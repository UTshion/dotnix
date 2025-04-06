# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  ...
}:

{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/system/apps.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipew ire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.satellite = {
    isNormalUser = true;
    description = "Nagayama Shion";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gccgo14
    rocmPackages_5.llvm.clang-unwrapped
    libgccjit
    cl
    clinfo
    hackgen-nf-font # Hackgen font
    neo4j # for bloodhound
    neovim
    nixd
    sbctl # secure boot requirement
    xbindkeys
    zig
    zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Enable tailscale
  services.tailscale.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # enable IME & setup fonts and dictionaries
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
    fcitx5.waylandFrontend = true;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.meslo-lg
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [
          "Fira Code Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # enable binaries to link libraries
  programs.nix-ld.enable = true;

  # Enable Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Configure firewall for Sunshine
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      47984
      47989
      47990
      48010
    ];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
  };

  # Enable hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # for global user
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # for zsh_completion
  environment.pathsToLink = [ "/share/zsh" ];

  # AMD GPU driver
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.enable = true; # Enable the X11 windowing system.
  services.xserver.videoDrivers = [ "amdgpu" ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # setting openvpn
  services.openvpn.servers = {
    htb = {
      autoStart = false;
      config = "config /home/satellite/Documents/lab_UTsatellite.ovpn";
    };
  };

  # Remove /etc/hosts file from nix's control,but initialize it.
  environment.etc."hosts".mode = "0644";

  # OpenCL support
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  # Setting NTP (Chrony)
  services.chrony = {
    enable = true;
    servers = [
      "ntp.nict.jp"
      "0.jp.pool.ntp.org"
      "1.jp.pool.ntp.org"
    ];
    extraConfig = ''
      rtcsync
      makestep 1.0 3
      local stratum 10
      driftfile /var/lib/chrony/drift
    '';
    enableRTCTrimming = false;
  };

  # ハードウェアクロックの設定
  time.hardwareClockInLocalTime = false;

  # Chronyサービスの起動順序調整
  systemd.services.chrony = {
    wantedBy = [ "sysinit.target" ];
    before = [ "time-sync.target" ];
    conflicts = [ "systemd-timesyncd.service" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "1s";
    };
  };

  # 修正版: 起動時の強制同期サービス
  systemd.services.chrony-sync-at-boot = {
    description = "Force time synchronization at boot";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network-online.target"
      "chrony.service"
    ];
    requires = [ "chrony.service" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "chrony-force-sync" ''
        sleep 3
        ${pkgs.chrony}/bin/chronyc makestep
      '';
    };
  };

  # 早期起動時のクロック修正
  boot = {
    initrd.systemd.enable = true;
    kernelParams = [
      "nowatchdog"
      "nmi_watchdog=0"
    ];
  };
}
