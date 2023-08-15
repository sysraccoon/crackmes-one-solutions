{
  description = "Application packaged using poetry2nix";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication mkPoetryEnv;
        pkgs = nixpkgs.legacyPackages.${system};
        overrideBuildInputs = (app: app.overrideAttrs(old: {
              buildInputs = old.buildInputs ++ [
                app.python.pkgs.setuptools
                app.python.pkgs.z3
              ];
            }
        ));
      in
      {
        packages =
          let app = mkPoetryApplication {projectDir = ./.; }; in
          {
            solver = overrideBuildInputs app;
            default = self.packages.${system}.solver;
          };

        devShells.default =
          let env = mkPoetryEnv {
            projectDir = ./.;
            editablePackageSources = {
              solver = ./solver;
            };
          }; in
          overrideBuildInputs env;
      });
}
