{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      formulahendry.auto-close-tag
      biomejs.biome
      alefragnani.bookmarks
      formulahendry.code-runner
      twxs.cmake
      ms-vscode.cmake-tools
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
      # ms-python.python  miss
      ms-python.black-formatter
      ms-python.vscode-pylance

      # rust
      # rust-lang.rust-analyzer
      tamasfe.even-better-toml

      # nix
      jnoortheen.nix-ide
      brettm12345.nixfmt-vscode

      # other languages
      # nvarner.typst-lsp

      # astro-build.astro-vscode   miss

    ];
  };
}
