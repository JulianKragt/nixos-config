
def aclear [] {
    cd ~/projects/appreo/api
    php artisan cache:clear
    php artisan cache:clear applicationCache
}
def watch-appreo [] {
    print "Starting Desktop watcher..."
    sh -c "cd ~/projects/appreo/desktop && sencha app watch &"

    print "Starting App watcher on port 1843..."
    sh -c "cd ~/projects/appreo/app && sencha app watch --port=1843 &"
}
def sqlquery [query] {
    mysql -u root --password="" -D appreo_live -e $query
    | decode utf-8 |
    | from csv --separator "\t"
}
def sqlexplain [query] {
    mysql -u root --password="" -D appreo_live -e $"EXPLAIN ($query)"
    | decode utf-8 |
    | from csv --separator "\t"
}
def sqlprocess [] {
    mysql -u root -e "SHOW FULL PROCESSLIST;"
    | decode utf-8 |
    | from csv --separator "\t"
    | where Command in [ "Query" "Execute" ]
    | where Info != "SHOW FULL PROCESSLIST"
    | select Id Time State Info
    | each { |value|
        if $value.Info != null {
            $value | merge { Info: ($value.Info | sql-formatter -l mysql) }
        } else {
            $value | merge { Info: "" }
        }
    }
    | table
}

# Completion function for MySQL processes
def "nu-complete sql processes" [] {
    let processes = (
        mysql -u root -e "SHOW FULL PROCESSLIST;" 
        | from csv --separator "\t"
        | where Command in [ "Query" "Execute" ]
        | where Info != "SHOW FULL PROCESSLIST"
        | get Id
    )

    {
        options: {
            completion_algorithm: substring
            case_sensitive: false
            sort: false
        },
        completions: (
            $processes | each {|p| { value: ($p | into string) } }
        )
    }
}

def sqlkill [process: string@"nu-complete sql processes"] {
    mysql -u root -e $"KILL ($process);"
    print $"Killed process ($process)"
}

def "nu-complete git branches" [] {
  let branches = (
    git branch --all --format="%(refname:short)"
    | lines
    | where {|b| $b != "origin" }
  )

  let local = (
    $branches
    | where {|b| not ($b | str starts-with "origin/") }
  )

  let remote = (
    $branches
    | where {|b| $b | str starts-with "origin/" }
  )

  {
    options: {
      completion_algorithm: fuzzy
      case_sensitive: false
      sort: false
    }
    completions: (
      ($local | append $remote)
      | each {|b| { value: $b } }
    )
  }
}

export extern "git switch" [
  branch?: string@"nu-complete git branches"
  -c: string
  -C: string
  -f
]

