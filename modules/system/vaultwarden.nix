# /etc/nixos/services/vaultwarden.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  domain = "nixos.tail1130da.ts.net";
  certDir = config.security.certificates.directory;
  certName = lib.replaceStrings [ "." ] [ "-" ] domain;
in
{
  # vaultwardenサービスの設定
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_PORT = 8001;
      ROCKET_ADDRESS = "127.0.0.1";
      DOMAIN = "https://${domain}";
      WEB_VAULT_ENABLED = true;
      SIGNUPS_ALLOWED = true;
      INVITATIONS_ALLOWED = false;
      PASSWORD_HINTS_ALLOWED = false;
      SHOW_PASSWORD_HINT = false;
    };
    backupDir = "/var/backup/vaultwarden";
  };

  # Nginxの設定
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    virtualHosts."${domain}" = {
      forceSSL = true;
      sslCertificate = "${certDir}/${certName}.crt";
      sslCertificateKey = "${certDir}/${certName}.key";
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8001";
          proxyWebsockets = true;
        };
        "/admin" = {
          proxyPass = "http://127.0.0.1:8001/admin";
          proxyWebsockets = true;
          # Tailscaleネットワーク全体からのアクセスを許可
          extraConfig = ''
            allow 100.64.0.0/10;  # Tailscaleが使用するCGNAT範囲
            deny all;
          '';
        };
      };
      # セキュリティヘッダー
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-XSS-Protection "1; mode=block";
        add_header Content-Security-Policy "default-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; script-src 'self'; connect-src 'self' wss://${domain};";
      '';
    };
  };

  # バックアップディレクトリの作成
  systemd.tmpfiles.rules = [
    "d /var/backup/vaultwarden 0750 vaultwarden vaultwarden -"
  ];

  # vaultwardenのバックアップサービス
  systemd.services."vaultwarden-backup"= lib.mkIf config.services.vaultwarden.enable {
    description = "Backup vaultwarden database";
    after = [ "vaultwarden.service" ];
    requires = [ "vaultwarden.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "vaultwarden";
      Group = "vaultwarden";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.sqlite}/bin/sqlite3 /var/lib/vaultwarden/db.sqlite3 \".backup /var/backup/vaultwarden/db-$(date +%F).sqlite3\"'";
      # 権限とセキュリティの設定
      PrivateTmp = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ "/var/backup/vaultwarden" ];
      ReadOnlyPaths = [ "/var/lib/vaultwarden" ];
    };
  };

  # 古いバックアップの自動削除
  systemd.services."vaultwarden-cleanup" = lib.mkIf config.services.vaultwarden.enable {
    description = "Clean up old vaultwarden backups";
    serviceConfig = {
      Type = "oneshot";
      User = "vaultwarden";
      Group = "vaultwarden";
      ExecStart = "${pkgs.findutils}/bin/find /var/backup/vaultwarden -name 'db-*.sqlite3' -type f -mtime +30 -delete";
      # 権限とセキュリティの設定
      PrivateTmp = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ "/var/backup/vaultwarden" ];
    };
  };

  # タイマー設定
  systemd.timers."vaultwarden-backup" = lib.mkIf config.services.vaultwarden.enable {
    description = "Timer for vaultwarden database backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.timers."vaultwarden-cleanup" = lib.mkIf config.services.vaultwarden.enable {
    description = "Timer for vaultwarden backup cleanup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}