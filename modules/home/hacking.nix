{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gobuster
    dirbuster
    exploitdb
    ffuf
    ghidra-bin
    hashcat
    john
    metasploit
    nmap
  ];
}
