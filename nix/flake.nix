{
  description = "A Nix-flake-based Node.js development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: rec {
        nodejs = prev.nodejs;
        yarn = (prev.yarn.override { inherit nodejs; });
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              node2nix
              nodejs
              nodePackages.pnpm
              yarn-berry
            ];
          };
          export = pkgs.mkShell rec {
            buildInputs =
              with pkgs;
              [
                glib
                nss
                nspr
                dbus
                atk
                at-spi2-atk
                at-spi2-core
                expat
                udev
                alsa-lib
                libgbm
                libxkbcommon
              ]
              ++ (with pkgs.xorg; [
                libX11
                libXcomposite
                libXrandr
                libxcb
                libXdamage
                libXext
                libXfixes
              ]);
            packages = with pkgs; [
              node2nix
              nodejs
              nodePackages.pnpm
              yarn-berry

              # export
              playwright
            ];
            
            # If `yarn slidev export` fails,
            # manually run `patchelf --set-interpreter $(patchelf --print-interpreter $(which find)) <headless_shell_path>`
            shellHook = ''
              export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"
            '';
          };
        }
      );
    };
}
