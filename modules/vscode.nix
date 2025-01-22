{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      formulahendry.code-runner
      ms-vscode.cpptools-extension-pack
      vadimcn.vscode-lldb
      fill-labs.dependi

      # git-extensions
      donjayamanne.githistory
      eamodio.gitlens
      waderyan.gitblame
      mhutchie.git-graph
      codezombiech.gitignore

      ms-vsliveshare.vsliveshare
      unifiedjs.vscode-mdx
      christian-kohler.path-intellisense
      esbenp.prettier-vscode

      # python
      ms-python.python
      ms-python.black-formatter
      ms-python.vscode-pylance

      # rust
      rust-lang.rust-analyzer
      tamasfe.even-better-toml

      # nix
      jnoortheen.nix-ide
      brettm12345.nixfmt-vscode

      # other languages
      nvarner.typst-lsp

      astro-build.astro-vscode

      # themes
      equinusocio.vsc-material-theme-icons
    ];
  };
}
