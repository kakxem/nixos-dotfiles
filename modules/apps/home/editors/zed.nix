#
# Zed
#

{
  pkgs,
  palette,
  palettes,
  ...
}:

let
  p = palettes.${palette};
  zedTheme =
  let
    p = palettes.${palette};
    transparent = "#00000000";
    alpha = color: opacity: "${color}${opacity}";
    syntaxColor = color: { inherit color; };
  in
  builtins.toJSON {
    "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
    name = "Custom Theme";
    author = "Generated from the Nix palette";
    themes = [
      {
        name = "Custom Theme";
        appearance = "dark";
        style = {
          border = p.bg2;
          "border.variant" = p.bg1;
          "border.focused" = p.accent;
          "border.selected" = p.accent;
          "border.transparent" = transparent;
          "border.disabled" = p.bg1;
          "background.appearance" = "opaque";

          "elevated_surface.background" = p.bg1;
          "surface.background" = p.bg1;
          background = p.bg;
          "element.background" = p.bg1;
          "element.hover" = p.bg2;
          "element.active" = alpha p.accent "26";
          "element.selected" = alpha p.accent "33";
          "element.selection_background" = alpha p.accent "33";
          "element.disabled" = p.bg1;
          "drop_target.background" = alpha p.accent "66";
          "drop_target.border" = p.accent;
          "ghost_element.background" = transparent;
          "ghost_element.hover" = p.bg2;
          "ghost_element.active" = alpha p.accent "26";
          "ghost_element.selected" = alpha p.accent "33";
          "ghost_element.disabled" = p.bg1;

          text = p.fg;
          "text.muted" = p.fg_idle;
          "text.placeholder" = p.comment;
          "text.disabled" = p.comment;
          "text.accent" = p.accent;
          icon = p.fg;
          "icon.muted" = p.fg_idle;
          "icon.disabled" = p.comment;
          "icon.placeholder" = p.comment;
          "icon.accent" = p.accent;

          "status_bar.background" = p.bg;
          "title_bar.background" = p.bg;
          "title_bar.inactive_background" = p.bg;
          "toolbar.background" = p.bg;
          "tab_bar.background" = p.bg;
          "tab.inactive_background" = p.bg;
          "tab.active_background" = p.bg;
          selection = alpha p.accent "4d";
          "search.match_background" = alpha p.accent "4d";
          "search.active_match_background" = alpha p.yellow "66";
          # Keep persistent side panels visually attached to the editor.
          "panel.background" = p.bg;
          "panel.focused_border" = p.accent;
          "panel.indent_guide" = alpha p.fg_idle "26";
          "panel.indent_guide_hover" = alpha p.fg_idle "66";
          "panel.indent_guide_active" = alpha p.accent "99";
          "panel.overlay_background" = alpha p.bg1 "f2";
          "panel.overlay_hover" = alpha p.accent "26";
          "pane.focused_border" = p.accent;
          "pane_group.border" = p.bg2;
          "scrollbar.thumb.background" = alpha p.fg_idle "66";
          "scrollbar.thumb.hover_background" = alpha p.fg_idle "99";
          "scrollbar.thumb.active_background" = alpha p.fg_idle "cc";
          "scrollbar.thumb.border" = transparent;
          "scrollbar.track.background" = transparent;
          "scrollbar.track.border" = transparent;
          "minimap.thumb.background" = alpha p.fg_idle "4d";
          "minimap.thumb.hover_background" = alpha p.fg_idle "80";
          "minimap.thumb.active_background" = alpha p.accent "99";
          "minimap.thumb.border" = transparent;

          "editor.foreground" = p.fg;
          "editor.background" = p.bg;
          "editor.gutter.background" = p.bg;
          "editor.subheader.background" = p.bg1;
          "editor.active_line.background" = alpha p.bg2 "b3";
          "editor.highlighted_line.background" = p.bg1;
          "editor.line_number" = p.comment;
          "editor.active_line_number" = p.fg0;
          "editor.hover_line_number" = p.fg;
          "editor.invisible" = p.comment;
          "editor.wrap_guide" = alpha p.fg_idle "26";
          "editor.active_wrap_guide" = alpha p.fg_idle "4d";
          "editor.indent_guide" = alpha p.fg_idle "26";
          "editor.indent_guide_active" = alpha p.accent "66";
          "editor.document_highlight.read_background" = alpha p.accent "26";
          "editor.document_highlight.write_background" = alpha p.accent2 "33";
          "editor.document_highlight.bracket_background" = alpha p.accent "33";
          "debugger.accent" = p.red;
          "editor.debugger_active_line.background" = alpha p.accent2 "1f";
          "editor.diff_hunk.added.background" = alpha p.green "26";
          "editor.diff_hunk.added.hollow_background" = alpha p.green "14";
          "editor.diff_hunk.added.hollow_border" = alpha p.green "80";
          "editor.diff_hunk.deleted.background" = alpha p.red "26";
          "editor.diff_hunk.deleted.hollow_background" = alpha p.red "14";
          "editor.diff_hunk.deleted.hollow_border" = alpha p.red "80";

          "terminal.background" = p.bg;
          "terminal.foreground" = p.fg;
          "terminal.bright_foreground" = p.fg0;
          "terminal.dim_foreground" = p.fg_idle;
          "terminal.ansi.background" = p.bg;
          "terminal.ansi.black" = p.black;
          "terminal.ansi.bright_black" = p.comment;
          "terminal.ansi.dim_black" = p.bg2;
          "terminal.ansi.red" = p.red;
          "terminal.ansi.bright_red" = p.red;
          "terminal.ansi.dim_red" = alpha p.red "b3";
          "terminal.ansi.green" = p.green;
          "terminal.ansi.bright_green" = p.green;
          "terminal.ansi.dim_green" = alpha p.green "b3";
          "terminal.ansi.yellow" = p.yellow;
          "terminal.ansi.bright_yellow" = p.yellow;
          "terminal.ansi.dim_yellow" = alpha p.yellow "b3";
          "terminal.ansi.blue" = p.blue;
          "terminal.ansi.bright_blue" = p.blue;
          "terminal.ansi.dim_blue" = alpha p.blue "b3";
          "terminal.ansi.magenta" = p.magenta;
          "terminal.ansi.bright_magenta" = p.magenta;
          "terminal.ansi.dim_magenta" = alpha p.magenta "b3";
          "terminal.ansi.cyan" = p.cyan;
          "terminal.ansi.bright_cyan" = p.cyan;
          "terminal.ansi.dim_cyan" = alpha p.cyan "b3";
          "terminal.ansi.white" = p.fg;
          "terminal.ansi.bright_white" = p.white;
          "terminal.ansi.dim_white" = p.fg_idle;

          "link_text.hover" = p.accent;
          "version_control.added" = p.green;
          "version_control.modified" = p.yellow;
          "version_control.renamed" = p.blue;
          "version_control.conflict" = p.yellow;
          "version_control.ignored" = alpha p.fg_idle "80";
          "version_control.word_added" = alpha p.green "59";
          "version_control.word_deleted" = alpha p.red "59";
          "version_control.deleted" = p.red;
          "version_control.conflict_marker.ours" = alpha p.green "33";
          "version_control.conflict_marker.theirs" = alpha p.blue "33";
          conflict = p.yellow;
          "conflict.background" = alpha p.yellow "1a";
          "conflict.border" = alpha p.yellow "80";
          created = p.green;
          "created.background" = alpha p.green "1a";
          "created.border" = alpha p.green "80";
          deleted = p.red;
          "deleted.background" = alpha p.red "1a";
          "deleted.border" = alpha p.red "80";
          error = p.red;
          "error.background" = alpha p.red "1a";
          "error.border" = alpha p.red "80";
          hidden = p.fg_idle;
          "hidden.background" = alpha p.fg_idle "1a";
          "hidden.border" = alpha p.fg_idle "4d";
          hint = p.cyan;
          "hint.background" = alpha p.cyan "1a";
          "hint.border" = alpha p.cyan "80";
          ignored = alpha p.fg_idle "80";
          "ignored.background" = alpha p.fg_idle "1a";
          "ignored.border" = alpha p.fg_idle "4d";
          info = p.blue;
          "info.background" = alpha p.blue "1a";
          "info.border" = alpha p.blue "80";
          modified = p.yellow;
          "modified.background" = alpha p.yellow "1a";
          "modified.border" = alpha p.yellow "80";
          predictive = p.fg_idle;
          "predictive.background" = alpha p.fg_idle "1a";
          "predictive.border" = alpha p.fg_idle "4d";
          renamed = p.blue;
          "renamed.background" = alpha p.blue "1a";
          "renamed.border" = alpha p.blue "80";
          success = p.green;
          "success.background" = alpha p.green "1a";
          "success.border" = alpha p.green "80";
          unreachable = p.comment;
          "unreachable.background" = alpha p.comment "1a";
          "unreachable.border" = alpha p.comment "4d";
          warning = p.yellow;
          "warning.background" = alpha p.yellow "1a";
          "warning.border" = alpha p.yellow "80";

          accents = [
            p.accent
            p.red
            p.yellow
            p.magenta
            p.cyan
            p.blue
            p.green
            p.accent2
          ];

          players = map (color: {
            cursor = color;
            background = color;
            selection = alpha color "3d";
          }) [ p.accent p.red p.yellow p.magenta p.cyan p.blue p.green p.accent2 ];

          # Theme modal editing indicators explicitly.
          "vim.mode.text" = p.bg;
          "vim.normal.foreground" = p.bg;
          "vim.normal.background" = p.accent;
          "vim.helix_normal.foreground" = p.bg;
          "vim.helix_normal.background" = p.accent;
          "vim.insert.foreground" = p.bg;
          "vim.insert.background" = p.green;
          "vim.visual.foreground" = p.bg;
          "vim.visual.background" = p.blue;
          "vim.visual_line.foreground" = p.bg;
          "vim.visual_line.background" = p.blue;
          "vim.visual_block.foreground" = p.bg;
          "vim.visual_block.background" = p.magenta;
          "vim.helix_select.foreground" = p.bg;
          "vim.helix_select.background" = p.blue;
          "vim.replace.foreground" = p.bg;
          "vim.replace.background" = p.red;
          "vim.helix_jump_label.foreground" = p.accent2;
          "vim.yank.background" = alpha p.yellow "66";

          syntax = {
            attribute = syntaxColor p.blue;
            boolean = syntaxColor p.magenta;
            character = syntaxColor p.cyan;
            "character.special" = syntaxColor p.yellow;
            comment = syntaxColor p.comment;
            "comment.doc" = syntaxColor p.fg_idle;
            "comment.documentation" = syntaxColor p.fg_idle;
            "comment.error" = syntaxColor p.red;
            "comment.hint" = syntaxColor p.cyan;
            "comment.info" = syntaxColor p.blue;
            "comment.note" = syntaxColor p.magenta;
            "comment.todo" = syntaxColor p.yellow;
            "comment.warn" = syntaxColor p.yellow;
            "comment.warning" = syntaxColor p.yellow;
            concept = syntaxColor p.cyan;
            constant = syntaxColor p.magenta;
            "constant.builtin" = syntaxColor p.magenta;
            "constant.macro" = syntaxColor p.magenta;
            constructor = syntaxColor p.blue;
            embedded = syntaxColor p.fg;
            emphasis = syntaxColor p.blue;
            "emphasis.strong" = (syntaxColor p.blue) // { font_weight = 700; };
            enum = syntaxColor p.accent2;
            field = syntaxColor p.blue;
            float = syntaxColor p.magenta;
            function = syntaxColor p.accent;
            "function.builtin" = syntaxColor p.accent;
            "function.call" = syntaxColor p.accent;
            "function.decorator" = syntaxColor p.yellow;
            "function.macro" = syntaxColor p.accent;
            "function.method" = syntaxColor p.accent;
            "function.method.call" = syntaxColor p.accent;
            hint = syntaxColor p.fg_idle;
            keyword = syntaxColor p.accent2;
            "keyword.conditional" = syntaxColor p.accent2;
            "keyword.conditional.ternary" = syntaxColor p.accent2;
            "keyword.coroutine" = syntaxColor p.accent2;
            "keyword.debug" = syntaxColor p.accent2;
            "keyword.directive" = syntaxColor p.accent2;
            "keyword.directive.define" = syntaxColor p.accent2;
            "keyword.exception" = syntaxColor p.accent2;
            "keyword.export" = syntaxColor p.accent2;
            "keyword.function" = syntaxColor p.accent2;
            "keyword.import" = syntaxColor p.accent2;
            "keyword.modifier" = syntaxColor p.accent2;
            "keyword.operator" = syntaxColor p.accent2;
            "keyword.repeat" = syntaxColor p.accent2;
            "keyword.return" = syntaxColor p.accent2;
            "keyword.type" = syntaxColor p.accent2;
            label = syntaxColor p.blue;
            link_text = (syntaxColor p.accent2) // { font_style = "italic"; };
            link_uri = syntaxColor p.green;
            module = syntaxColor p.fg;
            namespace = syntaxColor p.fg;
            number = syntaxColor p.magenta;
            "number.float" = syntaxColor p.magenta;
            operator = syntaxColor p.accent2;
            parameter = syntaxColor p.magenta;
            parent = syntaxColor p.fg;
            predictive = (syntaxColor p.comment) // { font_style = "italic"; };
            predoc = syntaxColor p.fg_idle;
            preproc = syntaxColor p.accent2;
            primary = syntaxColor p.fg;
            property = syntaxColor p.blue;
            punctuation = syntaxColor p.fg;
            "punctuation.bracket" = syntaxColor p.fg0;
            "punctuation.delimiter" = syntaxColor p.fg0;
            "punctuation.list_marker" = syntaxColor p.fg;
            "punctuation.markup" = syntaxColor p.fg;
            "punctuation.special" = syntaxColor p.magenta;
            "punctuation.special.symbol" = syntaxColor p.magenta;
            selector = syntaxColor p.magenta;
            "selector.pseudo" = syntaxColor p.blue;
            string = syntaxColor p.cyan;
            "string.doc" = syntaxColor p.cyan;
            "string.documentation" = syntaxColor p.cyan;
            "string.escape" = syntaxColor p.fg_idle;
            "string.regex" = syntaxColor p.cyan;
            "string.regexp" = syntaxColor p.cyan;
            "string.special" = syntaxColor p.yellow;
            "string.special.path" = syntaxColor p.yellow;
            "string.special.url" = syntaxColor p.cyan;
            "string.special.symbol" = syntaxColor p.accent2;
            symbol = syntaxColor p.accent2;
            tag = syntaxColor p.blue;
            "tag.attribute" = syntaxColor p.blue;
            "tag.delimiter" = syntaxColor p.fg;
            "tag.doctype" = syntaxColor p.magenta;
            text = syntaxColor p.fg;
            "text.literal" = syntaxColor p.accent2;
            title = (syntaxColor p.fg) // { font_weight = 700; };
            type = syntaxColor p.blue;
            "type.builtin" = syntaxColor p.blue;
            "type.class.definition" = syntaxColor p.blue;
            "type.definition" = syntaxColor p.blue;
            "type.interface" = syntaxColor p.blue;
            "type.super" = syntaxColor p.blue;
            variable = syntaxColor p.blue;
            "variable.builtin" = syntaxColor p.magenta;
            "variable.member" = syntaxColor p.blue;
            "variable.parameter" = syntaxColor p.magenta;
            "variable.special" = syntaxColor p.magenta;
            variant = syntaxColor p.blue;
            "diff.plus" = syntaxColor p.green;
            "diff.minus" = syntaxColor p.red;
          };
        };
      }
    ];
  };
in
{
  home.packages = with pkgs; [
    nil # Nix LSP
    nixd # Nix LSP
  ];

  programs = {
    zed-editor = {
      enable = true;
      package = pkgs.zed-editor;
      extensions = [ "nix" ];
      userSettings = {
        autosave = "on_focus_change";
        bottom_dock_layout = "full";

        ui_font_family = "CaskaydiaCove Nerd Font";
        buffer_font_family = "CaskaydiaCove Nerd Font";
        ui_font_size = 21;
        buffer_font_size = 21;

        terminal = {
          font_family = "FiraCode Nerd Font";
        };

        icon_theme = "Material Icon Theme";
        theme = "Custom Theme";
        accent_color = p.accent;

        tabs = {
          show_close_button = "hidden";
          file_icons = true;
          git_status = true;
        };

        sticky_scroll = {
          enabled = true;
        };

        inlay_hints = {
          enabled = true;
          show_background = true;
        };

        prettier = {
          allowed = false; # Nix files doesn't work with this... I'll investigate later
        };

        agent = {
          use_modifier_to_send = true;
          play_sound_when_agent_done = true;
          always_allow_tool_actions = true;
          default_profile = "write";
          default_model = {
            provider = "openrouter";
            model = "openai/gpt-5.1";
          };
          model_parameters = [ ];
        };
      };
    };
  };

  xdg.configFile."zed/themes/custom-theme.json".text = zedTheme;
}
