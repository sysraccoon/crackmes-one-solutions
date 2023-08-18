{
  description = "Wrapped hash program";

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
      hash = pkgs.stdenv.mkDerivation rec {
        name = "hash";
        buildInputs = with pkgs; [ autoPatchelfHook makeWrapper glib ];
        src = ./.;
        buildPhase = ":";
        installPhase = ''
          mkdir -p $out/bin
          mv hash $out/bin/hash
        '';
        postFixup = ''
          wrapProgram $out/bin/hash
        '';
      };
      default = self.packages.${system}.hash;
    };
  };
}
