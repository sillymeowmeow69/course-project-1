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

    in {
 
      # nix run serve
      apps.${system} = {
        serve = {
          type = "app";
          program = "${serve}/bin/serve";
        };
      };

      # nix develop
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            serve
          ];
          shellHook = ''echo "meow"'';
        };
      };
    };
}
