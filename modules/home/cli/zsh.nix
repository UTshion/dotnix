{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      bat = "bat --paging=never";
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -a";
      nc = "ncat";
      asobi-db = "cloud-sql-proxy --auto-iam-authn workschool-production-va8s4yue:asia-northeast1:workschool --port 54321";
      v3-db = "cloud-sql-proxy --auto-iam-authn trunk-work-school:asia-northeast1:workschool --port 65432";
      ".." = "cd ..";
    };

    history.size = 10000;

    initExtra = ''
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      zstyle ':completion:*:default' menu select=2
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zmodload zsh/complist
      bindkey -M menuselect '^[[Z' reverse-menu-complete

      autoload -U history-search-end
      zle -N history-beginning-search-backward history-search-end
      zle -N history-beginning-search-forward history-search-end
      bindkey "^p" history-beginning-search-backward
      bindkey "^n" history-beginning-search-forward

      zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

      export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>'
    '';
  };
}
