{ pkgs, ... }:

{
  home.packages = with pkgs; [
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    asciinema # Record and share terminal sessions
    awscli2 # AWS Command Line Interface v2
    bat # better cat
    biome # Toolchain of the web
    bitwarden-cli # Secure and free password manager for all of your devices
    blueman # 
    bottom # cross-platform graphical process/system monitor for the terminal
    claude-code # Anthropic cli coding-agent
    duf # A simple, fast and user-friendly alternative to du
    exiftool # Tool to read, write and edit EXIF meta information
    fastfetch # A simple, fast and user-friendly alternative to neofetch
    fd # A simple, fast and user-friendly alternative to find
    fzf # A command-line fuzzy finder
    git-graph # Graph visualization of a git repository's evolution in CLI
    google-cloud-sql-proxy # Google Cloud SQL Proxy
    google-cloud-sdk # gcloud
    gping # alternative ping
    hexyl
    httpie 
    infracost # Infrastructure as Code Cost Estimates
    jq # A lightweight and flexible command-line JSON processor
    lsd # A simple, fast and user-friendly alternative to ls
    nginx # HTTP server and reverse proxy
    nyancat # JOKE CAT
    nil # Nix LSP
    nix-tree # Interactively browse a Nix store paths dependencies
    ranger # Console file manager
    ripgrep # recursively searches directories for a regex patter
    spicetify-cli
    sqlite # sqlite3 db
    tenv # A tool for managing IaC tools (successor of tfenv)
    tldr # Simpler, more approachable complement to traditional man pages
    traefik # A Cloud Native Application Proxy
    tree # A directory listing program that makes use of a tree structure
    typst # New markup-based typesetting system that is powerful and easy to learn
    typstfmt # Formatter for the Typst language
    yq-go # yaml processor https://github.com/mikefarah/yq
    yt-dlp # Command-line tool to download videos from YouTube.com and other sites
  ];

  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true; # set alias for zsh
  };

  programs.zoxide = {
    enable = true;
  };
}
