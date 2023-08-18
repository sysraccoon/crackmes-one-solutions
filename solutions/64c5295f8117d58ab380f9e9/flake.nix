{
  description = "simple crackme from crackmes.one";

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
      angry-file = pkgs.stdenv.mkDerivation rec {
        name = "angry-file";
        buildInputs = with pkgs; [ autoPatchelfHook makeWrapper ];
        src = ./.;
        buildPhase = ":";
        installPhase = ''
          mkdir -p $out/bin
          mv ./angry-file $out/bin/angry-file
        '';
        postFixup = ''
          wrapProgram $out/bin/angry-file
        '';
      };
      default = self.packages.${system}.angry-file;
    };
  };
}
