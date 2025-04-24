# /etc/nixos/security/certificates.nix
{
  config,
  pkgs,
  lib,
  ...
}:

let
  certDir = "/var/lib/ssl-certs";
  domains = [ "nixos.tail1130da.ts.net" ];
in
{
  # モジュールのオプションを定義
  options.security.certificates = {
    directory = lib.mkOption {
      type = lib.types.str;
      default = certDir;
      description = "Directory to store SSL certificates";
    };
  };

  config = {
    # 証明書ディレクトリを作成
    systemd.tmpfiles.rules = [
      "d ${certDir} 0750 nginx nginx -"
    ];

    # 証明書生成・更新を1つのサービスにまとめる
    systemd.services = {
      "certificates-init" = {
        description = "Initialize SSL certificates";
        wantedBy = [ "multi-user.target" ];
        before = [ "nginx.service" ];
        path = [ pkgs.openssl ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = lib.concatMapStrings (
          domain:
          let
            certName = lib.replaceStrings [ "." ] [ "-" ] domain;
          in
          ''
            # 証明書が存在しない場合のみ生成
            if [ ! -f "${certDir}/${certName}.key" ]; then
              echo "Generating new self-signed certificate for ${domain}"
              
              # プライベートキーを生成
              openssl genrsa -out "${certDir}/${certName}.key" 4096
              chmod 400 "${certDir}/${certName}.key"
              
              # CSRを生成
              openssl req -new -key "${certDir}/${certName}.key" \
                -out "${certDir}/${certName}.csr" \
                -subj "/CN=${domain}"
                
              # 自己署名証明書を生成
              openssl x509 -req -days 3650 \
                -in "${certDir}/${certName}.csr" \
                -signkey "${certDir}/${certName}.key" \
                -out "${certDir}/${certName}.crt"
              chmod 444 "${certDir}/${certName}.crt"
              
              # 所有権を設定
              chown nginx:nginx "${certDir}/${certName}.key" "${certDir}/${certName}.crt"
            else
              echo "Certificate for ${domain} already exists, skipping generation"
            fi
          ''
        ) domains;
      };

      "certificates-renew" = {
        description = "Renew all self-signed certificates";
        serviceConfig = {
          Type = "oneshot";
        };

        script =
          lib.concatMapStrings (
            domain:
            let
              certName = lib.replaceStrings [ "." ] [ "-" ] domain;
            in
            ''
              # ${domain}の証明書の有効期限を確認
              EXPIRY=$(openssl x509 -enddate -noout -in "${certDir}/${certName}.crt" | cut -d= -f2)
              EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s)
              NOW_EPOCH=$(date +%s)

              # 有効期限まで90日未満ならば更新
              if [ $(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 )) -lt 90 ]; then
                echo "Certificate for ${domain} expires in less than 90 days, renewing..."
                
                # 証明書を更新
                openssl x509 -req -days 3650 \
                  -in "${certDir}/${certName}.csr" \
                  -signkey "${certDir}/${certName}.key" \
                  -out "${certDir}/${certName}.crt"
                  
                chmod 444 "${certDir}/${certName}.crt"
                chown nginx:nginx "${certDir}/${certName}.crt"
                
                NEED_NGINX_RESTART=1
              else
                echo "Certificate for ${domain} is still valid for more than 90 days, skipping renewal"
              fi
            ''
          ) domains
          + ''
            # 必要であればNginxを再起動
            if [ "$NEED_NGINX_RESTART" = "1" ]; then
              echo "Restarting Nginx to apply new certificates..."
              systemctl restart nginx.service
            fi
          '';

        path = [
          pkgs.openssl
          pkgs.coreutils
          pkgs.systemd
        ];
      };
    };

    # 定期的な証明書更新用タイマー
    systemd.timers."certificates-renew" = {
      description = "Timer for certificate renewal";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-01 02:00:00";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };
  };
}
