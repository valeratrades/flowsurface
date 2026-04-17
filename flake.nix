{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    v_flakes.url = "github:valeratrades/v_flakes/v1.6.1";
  };

  outputs = { self, nixpkgs, flake-utils, v_flakes }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        github = v_flakes.github {
          inherit pkgs;
          syncFork = true;
        };
      in
      {
        devShells.default = with pkgs; mkShell {
          nativeBuildInputs = [ pkg-config ];

          buildInputs = [
            wayland
            wayland-protocols
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
            openssl
          ];

          env.LD_LIBRARY_PATH = lib.makeLibraryPath [
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

          shellHook = github.shellHook + ''
            grep -qxF '.direnv/' .gitignore 2>/dev/null || printf '\n.direnv/\n' >> .gitignore
          '';
        };
      }
    );
}
