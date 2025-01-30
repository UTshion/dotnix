{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -a";
      nc = "ncat";
    };
    history.size = 10000;

    initExtra = ''
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      zstyle ':completion:*:default' menu select=2
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zmodload zsh/complist
      bindkey -M menuselect '^[[Z' reverse-menu-complete
    '';
  };
}
