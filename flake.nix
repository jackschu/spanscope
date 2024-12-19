# maintain with
# nix flake lock --update-input cargo2nix
# nix run github:cargo2nix/cargo2nix
{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    cargo2nix.url = "github:cargo2nix/cargo2nix";
  };

  outputs = {self, nixpkgs, flake-utils, cargo2nix, rust-overlay}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [cargo2nix.overlays.default];
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.75.0";
          packageFun = import ./Cargo.nix;
        };

      in rec {
        packages = {
          spanshot = (rustPkgs.workspace.spanshot {});
          default = packages.spanshot;
        };
      }
    );
}