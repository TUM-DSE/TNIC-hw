{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    gcc
    gnumake
    cmake
    boost
    fmt
  ];
}
