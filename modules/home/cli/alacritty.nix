{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      font = {
        size = 12.5;
      };

      font.normal = {
        family = "FiraCode Nerd Font";
        style = "Regular";
      };

      window = {
        opacity = 0.7;
      };

      window.padding = {
        x = 15;
        y = 15;
      };

      window.dimensions = {
        columns = 160;
        lines = 40;
      };

      selection = {
        save_to_clipboard = true;
      };
    };
  };
}
