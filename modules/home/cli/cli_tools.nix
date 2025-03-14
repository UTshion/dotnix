{ pkgs, ... }:

{
  home.packages = with pkgs; [
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    bat # better cat
    bottom # cross-platform graphical process/system monitor for the terminal
    duf # A simple, fast and user-friendly alternative to du
    exiftool # Tool to read, write and edit EXIF meta information
    fastfetch # A simple, fast and user-friendly alternative to neofetch
    fd # A simple, fast and user-friendly alternative to find
    fzf # A command-line fuzzy finder
    lsd # A simple, fast and user-friendly alternative to ls
    jq # A lightweight and flexible command-line JSON processor
    nix-tree # Interactively browse a Nix store paths dependencies
    ripgrep # recursively searches directories for a regex pattern
    tldr # Simplified and community-driven man pages
    tree # A directory listing program that makes use of a tree structure
    typst # New markup-based typesetting system that is powerful and easy to learn
    typstfmt # Formatter for the Typst language
    yq-go # yaml processor https://github.com/mikefarah/yq
    yt-dlp # Command-line tool to download videos from YouTube.com and other sites
  ];

  programs.thefuck = {
    enable = true;
    enableZshIntegration = true; # set alias for zsh
  };

  programs.zoxide = {
    enable = true;
  };
}
