{ pkgs ? import <nixpkgs> {} }:

with pkgs;

{
  source-code = stdenv.mkDerivation {
    name = "source-code-php";

    src = /home/rego/diretoria-app;

    phases = [ "installPhase" ];
    installPhase = ''
      cp -r $src $out
    '';
  };
}
