{ pkgs, ... }: let
  pname = "sunsama";
  version = "1.0.5"; # Replace with the actual version if known

  # Fetch the Sunsama AppImage
  src = pkgs.fetchurl {
    url = "https://desktop.sunsama.com/linux/appImage/x64";
    sha256 = "UPAwaPsrx9VSrRkBrvU9DBKc1MDTpSJAiAtGWQZVlKs="; # Replace with actual hash
  };

  # Fetch the Sunsama icon
  icon = pkgs.fetchurl {
    url = "https://store-images.s-microsoft.com/image/apps.57418.b46a3a5c-41f7-4861-b6e0-a73b2a5c941e.52d998ae-94fc-4155-8533-3881d2a7cc0d.db229874-0e31-4fd6-914b-b1387f6adb70.png";
    sha256 = "SuARjse443Npm64KYj+ye8+HAbFCTszhxIfj7m69Cyw="; # Replace with actual hash
  };

  # Extract the AppImage contents
  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;
  pkgs = pkgs;

  extraInstallCommands = ''
    # Install the .desktop file
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop

    # Modify the Exec line in the .desktop file
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    # Install the icon
    install -m 444 -D ${icon} $out/share/icons/hicolor/256x256/apps/${pname}.png

    # Create a symlink for the executable
    # ln -s $out/bin/${pname}-${version} $out/bin/${pname}
  '';

  extraBwrapArgs = [
    "--bind-try /etc/nixos /etc/nixos"
  ];

  dieWithParent = false;

  extraPkgs = pkgs: with pkgs; [
    fuse
  ];
}
