final: prev: {
  maltego = prev.maltego.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      wrapProgram $out/bin/maltego \
        --set JAVA_HOME ${final.openjdk17} \
        --set NIX_JAVA_HOME ${final.openjdk17} \
        --add-flags "--jdkhome ${final.openjdk17}"
    '';
    
    buildInputs = oldAttrs.buildInputs or [] ++ [ final.makeWrapper ];
  });
}
