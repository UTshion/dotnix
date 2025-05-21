final: prev: {
  postman = prev.postman.overrideAttrs (oldAttrs: {
    version = "latest";
    src = prev.fetchurl {
      url = "https://dl.pstmn.io/download/latest/linux_64";
      # sha256はダウンロード後に正しい値に置き換える必要があります
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };
  });
}
