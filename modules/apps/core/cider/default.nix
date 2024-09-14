{ pkgs, lib, ... }:

let 
  pname = "cider";
  version = "2.5.0";
  src = ./Cider-linux-appimage-x64.AppImage;
in
{
  environment.systemPackages = with pkgs; [
    (appimageTools.wrapType2
      {
        inherit pname version src;
        extraInstallCommands = ''
          source "${makeWrapper}/nix-support/setup-hook"
          wrapProgram $out/bin/${pname}
          install -m 444 -D ${src} -t $out/bin

          mkdir -p $out/share/applications
          cat > $out/share/applications/cider.desktop <<EOF
          [Desktop Entry]
          Type=Application
          Name=Cider
          Icon=cider
          Exec=cider %F
          Categories=Graphics;
          EOF
        '';

        meta = with lib; {
          description = "New look into listening and enjoying Apple Music in style and performance";
          homepage = "https://github.com/ciderapp/Cider";
          license = licenses.agpl3Only;
          mainProgram = "cider";
          maintainers = [ maintainers.cigrainger ];
          platforms = [ "x86_64-linux" ];
        };
      }
    )
  ];
}