#
# Fish
#
{ pkgs, palette, palettes, ... }:

let
  p = palettes.${palette};

  hexDigit = c:
    if c == "a" then 10 else if c == "b" then 11 else
    if c == "c" then 12 else if c == "d" then 13 else
    if c == "e" then 14 else if c == "f" then 15 else
    builtins.fromJSON c;
  hexPairToInt = pair:
    hexDigit (builtins.substring 0 1 pair) * 16
    + hexDigit (builtins.substring 1 1 pair);
  brightness = color:
    let
      channel = offset:
        hexPairToInt (builtins.substring offset 2 color);
    in
      builtins.div
        (channel 1 * 299 + channel 3 * 587 + channel 5 * 114)
        1000;
  contrastOn = color: if brightness color >= 150 then p.black else p.white;

  starshipConf = ''
    "$schema" = 'https://starship.rs/config-schema.json'

    format = """
    [](color_user_bg)\
    $os\
    $username\
    [](fg:color_user_bg bg:color_directory_bg)\
    $directory\
    [](fg:color_directory_bg bg:color_git_bg)\
    $git_branch\
    $git_status\
    [](fg:color_git_bg bg:color_runtime_bg)\
    $c\
    $rust\
    $golang\
    $nodejs\
    $php\
    $java\
    $kotlin\
    $haskell\
    $python\
    [](fg:color_runtime_bg bg:color_context_bg)\
    $docker_context\
    $conda\
    [](fg:color_context_bg bg:color_time_bg)\
    $time\
    [ ](fg:color_time_bg)\
    $line_break$character"""

    palette = 'custom'

    # The prompt keeps its powerline hierarchy, but the current directory uses
    # the palette's primary accent instead of an unrelated yellow. Text on
    # colored segments is selected from the palette's light/dark extremes.
    [palettes.custom]
    color_fg0 = '${p.fg0}'
    color_fg = '${p.fg}'
    color_user_bg = '${p.bg2}'
    color_directory_bg = '${p.accent}'
    color_directory_fg = '${contrastOn p.accent}'
    color_git_bg = '${p.accent2}'
    color_git_fg = '${contrastOn p.accent2}'
    color_runtime_bg = '${p.blue}'
    color_runtime_fg = '${contrastOn p.blue}'
    color_context_bg = '${p.bg2}'
    color_time_bg = '${p.bg1}'
    color_green = '${p.green}'
    color_orange = '${p.accent}'
    color_purple = '${p.magenta}'
    color_red = '${p.red}'
    color_yellow = '${p.yellow}'

    [os]
    disabled = false
    style = "bg:color_user_bg fg:color_orange"

    [os.symbols]
    Windows = "󰍲"
    Ubuntu = "󰕈"
    SUSE = ""
    Raspbian = "󰐿"
    Mint = "󰣭"
    Macos = "󰀵"
    Manjaro = ""
    Linux = "󰌽"
    Gentoo = "󰣨"
    Fedora = "󰣛"
    Alpine = ""
    Amazon = ""
    Android = ""
    Arch = "󰣇"
    Artix = "󰣇"
    EndeavourOS = ""
    CentOS = ""
    Debian = "󰣚"
    Redhat = "󱄛"
    RedHatEnterprise = "󱄛"
    NixOS = ""

    [username]
    show_always = true
    style_user = "bg:color_user_bg fg:color_fg0"
    style_root = "bg:color_user_bg fg:color_fg0"
    format = '[ $user ]($style)'

    [directory]
    style = "fg:color_directory_fg bg:color_directory_bg"
    format = "[ $path ]($style)"
    truncation_length = 3
    truncation_symbol = "…/"

    [directory.substitutions]
    "Documents" = "󰈙 "
    "Downloads" = " "
    "Music" = "󰝚 "
    "Pictures" = " "
    "Developer" = "󰲋 "

    [git_branch]
    symbol = ""
    style = "bg:color_git_bg"
    format = '[[ $symbol $branch ](fg:color_git_fg bg:color_git_bg)]($style)'

    [git_status]
    style = "bg:color_git_bg"
    format = '[[($all_status$ahead_behind )](fg:color_git_fg bg:color_git_bg)]($style)'

    [nodejs]
    symbol = ""
    style = "bg:color_runtime_bg"
    format = '[[ $symbol( $version) ](fg:color_runtime_fg bg:color_runtime_bg)]($style)'

    [c]
    symbol = " "
    style = "bg:color_runtime_bg"
    format = '[[ $symbol( $version) ](fg:color_runtime_fg bg:color_runtime_bg)]($style)'

    [rust]
    symbol = ""
    style = "bg:color_runtime_bg"
    format = '[[ $symbol( $version) ](fg:color_runtime_fg bg:color_runtime_bg)]($style)'

    [golang]
    symbol = ""
    style = "bg:color_runtime_bg"
    format = '[[ $symbol( $version) ](fg:color_runtime_fg bg:color_runtime_bg)]($style)'

    [php]
    symbol = ""
    style = "bg:color_runtime_bg"
    format = '[[ $symbol( $version) ](fg:color_runtime_fg bg:color_runtime_bg)]($style)'

    [java]
    symbol = " "
    style = "bg:color_runtime_bg"
    format = '[[ $symbol( $version) ](fg:color_runtime_fg bg:color_runtime_bg)]($style)'

    [kotlin]
    symbol = ""
    style = "bg:color_runtime_bg"
    format = '[[ $symbol( $version) ](fg:color_runtime_fg bg:color_runtime_bg)]($style)'

    [haskell]
    symbol = ""
    style = "bg:color_runtime_bg"
    format = '[[ $symbol( $version) ](fg:color_runtime_fg bg:color_runtime_bg)]($style)'

    [python]
    symbol = ""
    style = "bg:color_runtime_bg"
    format = '[[ $symbol( $version) ](fg:color_runtime_fg bg:color_runtime_bg)]($style)'

    [docker_context]
    symbol = ""
    style = "bg:color_context_bg"
    format = '[[ $symbol( $context) ](fg:color_fg bg:color_context_bg)]($style)'

    [conda]
    style = "bg:color_context_bg"
    format = '[[ $symbol( $environment) ](fg:color_fg bg:color_context_bg)]($style)'

    [time]
    disabled = true
    time_format = "%R"
    style = "bg:color_time_bg"
    format = '[[  $time ](fg:color_fg0 bg:color_time_bg)]($style)'

    [line_break]
    disabled = true

    [character]
    disabled = true
    success_symbol = '(bold fg:color_green)'
    error_symbol = '[](bold fg:color_red)'
    vimcmd_symbol = '[](bold fg:color_green)'
    vimcmd_replace_one_symbol = '[](bold fg:color_purple)'
    vimcmd_replace_symbol = '[](bold fg:color_purple)'
    vimcmd_visual_symbol = '[](bold fg:color_yellow)'
  '';
in
{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        starship init fish | source
        zoxide init fish | source
        fastfetch # Show system info on opening an interactive shell
      '';

      # Modern CLI replacements.
      shellAliases = {
        ls = "eza";
        ll = "eza -la";
        cat = "bat";
        find = "fd";
      };

      functions = {
        # Optional fzf directory picker; excludes internal Git directories.
        cf = ''
          if test (count $argv) -eq 1
            set dir (fd --type d --hidden --exclude .git 2>/dev/null | fzf --query "$argv[1]" --preview 'eza -T --level=1 {}' --preview-window right:45%)
          else
            set dir (fd --type d --hidden --exclude .git 2>/dev/null | fzf --preview 'eza -T --level=1 {}' --preview-window right:45%)
          end
          if test -n "$dir"
            cd "$dir"
          end
        '';
      };
    };
  };

  home.packages = with pkgs; [
    starship
    fastfetch
  ];

  xdg.configFile."starship.toml".text = starshipConf;
}
