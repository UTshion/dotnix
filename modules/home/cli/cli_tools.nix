{ pkgs, ... }:

{
  home.packages = with pkgs; [
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    awscli2 # AWS Command Line Interface v2
    bat # better cat
    biome # Toolchain of the web
    bitwarden-cli # Secure and free password manager for all of your devices
    bottom # cross-platform graphical process/system monitor for the terminal
    duf # A simple, fast and user-friendly alternative to du
    exiftool # Tool to read, write and edit EXIF meta information
    fastfetch # A simple, fast and user-friendly alternative to neofetch
    fd # A simple, fast and user-friendly alternative to find
    fzf # A command-line fuzzy finder
    google-cloud-sql-proxy # Google Cloud SQL Proxy
    google-cloud-sdk # gcloud
    hexyl
    jq # A lightweight and flexible command-line JSON processor
    lsd # A simple, fast and user-friendly alternative to ls
    nyancat # JOKE CAT
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
