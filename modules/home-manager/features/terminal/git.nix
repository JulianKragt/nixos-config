{
  config,
  ...
}:
{

  sops.secrets = {
    "git/username" = {};
    "git/email" = {};
  };

  programs.git = {
    enable = true;

    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    ignores = [
      ".vscode"
      ".idea"
      "*.swp"
      "*~"
      ".DS_Store"
    ];

    attributes = [
      "*.php diff=php"
      "*.py diff=python"
      "*.go diff=golang"
      "*.js diff=javascript"
      "*.ts diff=typescript"
      "*.cs diff=csharp"

      "*.html diff=html"
      "*.xml diff=html"
      "*.md diff=markdown"
      "*.css diff=css"

      "*.png binary"
      "*.jpg binary"
      "*.jpeg binary"
      "*.gif binary"
      "*.pdf binary"    ];

    includes = [
      {
        contents = {
          user = {
             name  = config.sops.secrets."git/username".path;
             email = config.sops.secrets."git/email".path;
          };
          alias = {
            co = "checkout";
            st = "status";
            ci = "commit";
            br = "branch";
            lg = "log --oneline --graph --decorate";
          };
          core = {
            editor = "nvim";
          };

          push.autoSetupRemote = true;
          pull.rebase = true;
        };
      }

      {
        condition = "gitdir:~/work/**";
        contents = {
          user = {
            # name  = config.sops.secrets."git/work/username".path;
            # email = config.sops.secrets."git/work/email".path;
          };
        };
      }
    ];
  };

}
