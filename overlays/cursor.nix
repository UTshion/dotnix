self: super: {
  code-cursor = super.code-cursor.overrideAttrs (old: rec {
    version = "0.49.0";
    src = super.fetchurl {
      url = "https://download.cursor.com/cursor-0.49.0-x86_64.AppImage";
      hash = "sha256-WH4/Zw0VJmRGyRzMlkThkhZ4fGysMKBUSIPCTsyGS4w=";
    };
  });
}
