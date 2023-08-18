{
  description = "Wrapped crackme program";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages.${system} = {
      crackme = pkgs.stdenv.mkDerivation rec {
        name = "crackme";
        buildInputs = with pkgs; [ autoPatchelfHook makeWrapper glib ];
        src = ./.;
        buildPhase = ":";
        installPhase = ''
          mkdir -p $out/bin
          mv crackme $out/bin/crackme
        '';
        postFixup = ''
          wrapProgram $out/bin/crackme
        '';
      };
      default = self.packages.${system}.crackme;
    };
  };
}
