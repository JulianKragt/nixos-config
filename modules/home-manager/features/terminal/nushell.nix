{
  pkgs,
  ...
}:
{
  programs.nushell.enable = true;

  home.activation.setNuShellShell = ''
        NU_PATH=${pkgs.nushell}/bin/nu

        # Add to /etc/shells if needed
        if ! grep -q "$NU_PATH" /etc/shells; then
          /usr/bin/sudo sh -c "echo $NU_PATH >> /etc/shells"
        fi

        # Set as login shell for current user
        /usr/bin/sudo /usr/bin/chsh -s "$NU_PATH" $USER || true
  '';
}