{
  description = "My project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

      serve = pkgs.writeShellApplication {
        name = "serve";
        runtimeInputs = [ pkgs.python3 ];
        text = builtins.readFile ./scripts/serve.sh;
      };

      build = pkgs.writeShellApplication {
        name = "build";
        text = builtins.readFile ./scripts/build.sh;
      };

    in {
      apps.${system} = {
        # nix run .#serve
        serve = {
          type = "app";
          program = "${serve}/bin/serve";
        };

        # nix run .#build
        build = {
          type = "app";
          program = "${build}/bin/build";
        };
      };

      # nix develop
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            serve
            build
          ];
          shellHook = ''echo "meow"'';
        };
      };
    };
}
