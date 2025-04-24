{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "UTshion";
    userEmail = "yannbarushion@gmail.com";
    extraConfig = {
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      safe.directory = [
        "/opt/exploitdb"
        "/opt/exploitdb-papers"
      ];
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };
}
