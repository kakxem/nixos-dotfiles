{
  pkgs,
  inputs,
  config,
  ...
}:

let
  camofoxUrl = "http://127.0.0.1:9377";
  docker = "${pkgs.docker}/bin/docker";
  camofoxImage = "camofox-browser:135.0.1-x86_64";
  hermes = inputs.llm-agents.packages.${pkgs.system}.hermes-agent;
in
{
  # No module: Hermes manages its own config interactively in ~/.hermes/.
  home.packages = [ hermes ];

  home.sessionVariables = {
    CAMOFOX_URL = camofoxUrl;
    HERMES_HOME = "${config.home.homeDirectory}/.hermes";
  };

  systemd.user.services.hermes-agent = {
    Unit = {
      Description = "Hermes Agent Gateway";
      After = [ "default.target" ];
      ConditionPathExists = "%h/.hermes/config.yaml";
    };

    Service = {
      Type = "simple";
      Environment = "HERMES_HOME=%h/.hermes";
      ExecStart = "${hermes}/bin/hermes gateway run";
      WorkingDirectory = "%h/.hermes";
      Restart = "always";
      RestartSec = 5;
      RestartForceExitStatus = [ 75 ];
      TimeoutStopSec = 210;
      KillMode = "mixed";
      KillSignal = "SIGTERM";
      StandardOutput = "journal";
      StandardError = "journal";
    };

    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.camofox-browser = {
    Unit = {
      Description = "Camofox anti-detection browser server";
      After = [ "default.target" ];
      Wants = [ "default.target" ];
      # Only start when the Docker daemon is available.
      ConditionPathExists = [ "/run/docker.sock" ];
    };

    Service = {
      Type = "simple";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/camofox"
        "-${docker} rm -f camofox-browser"
      ];
      ExecStart = "${docker} run --rm --name camofox-browser --shm-size=2g --add-host=host.docker.internal:host-gateway -p 127.0.0.1:9377:9377 -p 127.0.0.1:6080:6080 -p 127.0.0.1:5901:5900 -e CAMOFOX_PORT=9377 -e CAMOFOX_BIND_HOST=0.0.0.0 -e CAMOFOX_CRASH_REPORT_ENABLED=false -e ENABLE_VNC=1 -e VNC_BIND=0.0.0.0 -e VNC_RESOLUTION=1920x1080 -e MAX_OLD_SPACE_SIZE=2048 -v %h/.local/share/camofox:/root/.camofox ${camofoxImage}";
      ExecStop = "${docker} stop --time 30 camofox-browser";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 45;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
