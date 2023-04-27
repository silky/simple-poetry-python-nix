{
  description = "python-poetry2nix-simple-starting";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        app-binary-name = "some-app";

        inherit (poetry2nix.legacyPackages.${system})
          mkPoetryApplication
          mkPoetryEnv
          ;

        pkgs = nixpkgs.legacyPackages.${system};

        some-app = mkPoetryApplication {
          projectDir = ./.;
          python     = pkgs.python311;
        };

        some-app-env = mkPoetryEnv {
          projectDir = ./.;
          python     = pkgs.python311;
          editablePackageSources = {
            some-app = ./some_app;
          };
        };

        dockerImage = pkgs.dockerTools.buildLayeredImage {
          name = "${app-binary-name}-image";
          config = { Cmd = [ "${some-app}/bin/${app-binary-name}" ]; };
        };

      in
      {
        packages = {
          default = some-app;
          docker  = dockerImage;
        };

        devShells.default = some-app-env.env.overrideAttrs (_: {
          buildInputs = [
            # Note: We _can't_ use poetry for commands such as `poetry run
            # ...`, as the Python version poetry uses is different, and lacks
            # the packages.
            pkgs.poetry
          ];

          POETRY_VIRTUALENVS_CREATE             = false;
          POETRY_EXPERIMENTAL_SYSTEM_GIT_CLIENT = true;
        });
      });
}
