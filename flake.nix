{
  description = "Nix flake for PandoraLauncher";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      packages."x86_64-linux".default = pkgs.stdenv.mkDerivation {
        pname = "PandoraLauncher";
        version = "2.4.1";

        src = pkgs.fetchurl {
          url = "https://github.com/Moulberry/PandoraLauncher/releases/download/v2.4.1/PandoraLauncher-Linux-2.4.1-x86_64";
          sha256 = "sha256-3yYpgVQLpWCTtNqKi+0ecsibPZSMcKtcbTbTDbIP83s=";
          postFetch = "chmod +x $out";
        };
        dontUnpack = true;

        buildInputs = (with pkgs; [
          makeWrapper
          autoPatchelfHook

          libgcc
          openssl
          libxkbcommon
          libxcb
        ]);
        installPhase = ''
          runHook preInstall

          mkdir -p $out/libexec
          install $src $out/libexec/PandoraLauncher

          runHook postInstall

          makeWrapper $out/libexec/PandoraLauncher $out/bin/PandoraLauncher \
            --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath (with pkgs; [
              wayland
              vulkan-loader

              # FIXME: Any of these should allow use to open URLs, but they don't.
              # https://github.com/zed-industries/zed/blob/d7bce5468521791c40b2f4641c23c3ce878bfd70/crates/gpui/src/platform/linux/wayland/client.rs#L789
              # There's a demo of `ashpd` & using the "Open URI" demo literally just doesn't work.
              # Even with the below packages it just doesn't work.
              # xgd-open does work for me (Which the `open` crate uses, but in the linked code it literally just doesn't get to execute it.)
              # NOTE: I have resorted to just building PandoraLauncher & just insert a println! with the login URL:
              # PandoraLauncher/crates/backend/src/backend.rs#L410
              dbus
              xdg-utils
              xdg-desktop-portal

              jdk17
              jdk21
              zulu17
              zulu21
              graalvmPackages.graalvm-ce
              semeru-bin-17
              semeru-bin # 21
            ])}

            mkdir -p $out/share/applications
            cp ${./PandoraLauncher.desktop} $out/share/applications/PandoraLauncher.desktop
            mkdir -p $out/share/icons/hicolor/scalable/apps
            cp ${./PandoraLauncher.svg} $out/share/icons/hicolor/scalable/apps/PandoraLauncher.svg
        '';

        meta = {
          name = "PandoraLauncher-2.4.1";
          description = "Pandora is a modern Minecraft launcher that balances ease-of-use with powerful instance management features";
          homepage = "https://pandora.moulberry.com/";
          license = pkgs.lib.licenses.mit;
          mainProgram = "PandoraLauncher";
          platforms = [ "x86_64-linux" ];
        };
      };
    };
}
