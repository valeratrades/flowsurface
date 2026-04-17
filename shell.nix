{ pkgs ? import <nixpkgs> {} }:

let
  github = import /home/v/s/v_flakes/github {
    inherit pkgs;
    syncFork = true;
  };
in

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    # Wayland
    wayland
    wayland-protocols
    libxkbcommon

    # X11
    libx11
    libxcursor
    libxrandr
    libxi
    libxext

    # Graphics / wgpu
    vulkan-loader
    mesa
    libGL

    # Audio (rodio / alsa)
    alsa-lib

    # Fonts
    fontconfig
    freetype

    openssl
  ];

  LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
    wayland
    libxkbcommon
    libx11
    libxcursor
    libxrandr
    libxi
    libxext
    vulkan-loader
    mesa
    libGL
    alsa-lib
    fontconfig
    freetype
  ];

  shellHook = github.shellHook;
}
