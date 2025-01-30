{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat # better cat
    bottom # cross-platform graphical process/system monitor for the terminal
    duf # A simple, fast and user-friendly alternative to du
    fastfetch # A simple, fast and user-friendly alternative to neofetch
    fd # A simple, fast and user-friendly alternative to find
    fzf # A command-line fuzzy finder
    lsd # A simple, fast and user-friendly alternative to ls
    jq # A lightweight and flexible command-line JSON processor
    ripgrep # recursively searches directories for a regex pattern
    tldr # Simplified and community-driven man pages
    tree # A directory listing program that makes use of a tree structure
    yq-go # yaml processor https://github.com/mikefarah/yq
  ];

  programs.thefuck = {
    enable = true;
    enableZshIntegration = true; # set alias for zsh
  };

  programs.zoxide = {
    enable= true;
  }
}
