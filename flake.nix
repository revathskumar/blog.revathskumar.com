{
  description = "Devshell with Ruby (from .ruby-version) and Node 24";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
    nixpkgs-ruby.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-ruby, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        rubyVersion = nixpkgs.lib.fileContents ./.ruby-version;
        ruby = nixpkgs-ruby.lib.mkRuby { inherit pkgs rubyVersion; };
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              ruby
              pkgs.nodejs_24
              pkgs.libwebp
            ];
            shellHook = ''
              ${ruby}/bin/ruby --version
              echo "Bundler"
              ${ruby}/bin/bundler --version
              echo "Node "
              ${pkgs.nodejs_24}/bin/node --version
              echo "Npm"
              ${pkgs.nodejs_24}/bin/npm --version
            '';
          };
        };
      }
    );
}
