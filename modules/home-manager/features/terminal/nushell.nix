{
  pkgs,
  ...
}:
{
  programs.nushell.enable = true;

  home.activation.setNuShellShell = ''
    NU_PATH=${pkgs.nushell}/bin/nu

    if [ "$SHELL" != "$NU_PATH" ]; then
      if ! grep -q "$NU_PATH" /etc/shells; then
        /usr/bin/sudo sh -c "echo $NU_PATH >> /etc/shells"
      fi
      /usr/bin/sudo /usr/bin/chsh -s "$NU_PATH" "$USER" || true
    fi
  '';
}