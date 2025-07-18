# flake.nix
{
  description = "ALU emulator + VHDL testbench (Zig, GHDL)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, zig-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              zigpkgs = zig-overlay.packages.${system};
            })
          ];
        };
        zig = pkgs.zigpkgs."0.14.1"; # or your preferred Zig version
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            zig
            pkgs.ghdl
            pkgs.gnumake
          ];
        };
      });
}

