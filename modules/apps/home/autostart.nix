{ ... }:

{
  xdg.configFile = {
    "autostart/brave-browser.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Brave Web Browser
      Exec=brave %U
      Terminal=false
      Categories=Network;WebBrowser;
    '';

    "autostart/org.telegram.desktop.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Telegram
      Exec=Telegram -- %U
      Terminal=false
      Categories=Chat;Network;InstantMessaging;Qt;
    '';

    "autostart/proton.vpn.app.gtk.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Proton VPN
      Exec=protonvpn-app
      Terminal=false
      Categories=Network;
    '';

    "autostart/discord.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Discord
      Exec=discord
      Terminal=false
      Categories=Network;InstantMessaging;Chat;
    '';
  };
}
