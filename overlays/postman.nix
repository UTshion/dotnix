final: prev: {
  postman = prev.postman.overrideAttrs (oldAttrs: rec {
    version = "11.47.1";
    
    src = prev.fetchurl {
      url = "https://dl.pstmn.io/download/version/${version}/linux${
        if prev.stdenv.hostPlatform.system == "aarch64-linux" then "arm64" else "64"
      }";
      sha256 = if prev.stdenv.hostPlatform.system == "aarch64-linux" 
        then "sha256-or4jru0kRL4AnRSuUIMhlBg20fXl2L6Mjra6rGIgjd8="  # ARM64用のハッシュ値（要更新）
        else "sha256-jOP4ya5n7g0+xB04Z10Qq25EifKBEnF5mNJEQWLNClU=";   # x86_64用のハッシュ値（要更新）
      name = "postman-${version}.tar.gz";
    };

    meta = oldAttrs.meta // {
      changelog = "https://www.postman.com/release-notes/postman-app/#${
        prev.lib.replaceStrings [ "." ] [ "-" ] version
      }";
    };
  });
}
