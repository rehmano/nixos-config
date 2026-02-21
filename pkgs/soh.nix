{
  pkgs,
  ...
}:

let
  version = "9.2.3";

  src = pkgs.fetchzip {
    url = "https://github.com/HarbourMasters/Shipwright/releases/download/${version}/SoH-Ackbar-Delta-Linux.zip";
    sha256 = "sha256-hlu5j8ZI+oml2xgnbQRh+a+lMC1hsZMyN4cExilIa7g=";
    stripRoot = false;
  };

  sohAppImage = pkgs.stdenv.mkDerivation {
    pname = "soh-appimage-raw";
    inherit version;
    src = src;
    installPhase = ''
      appimg=$(find $src -name "*.AppImage" -o -name "*.appimage" | head -n1)
      install -Dm755 "$appimg" $out/soh.AppImage
    '';
  };

  sohContents = pkgs.appimageTools.extract {
    pname = "soh-contents";
    inherit version;
    src = "${sohAppImage}/soh.AppImage";
  };

  sohDesktop = pkgs.makeDesktopItem {
    name = "soh";
    desktopName = "Ship of Harkinian";
    genericName = "Nintendo 64 Emulator / Port";
    comment = "A PC port of Ocarina of Time";
    exec = "soh %u";
    icon = "soh";
    categories = [ "Game" ];
    startupNotify = true;
  };

  # Outer launcher: copies the AppImage into a writable per-user data dir,
  # then runs it from there so SoH finds its ROM, saves, and mods next to it.
  sohLauncher = pkgs.writeShellApplication {
    name = "soh";
    runtimeInputs = [ pkgs.appimage-run ];
    text = ''
      SOH_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/soh"
      mkdir -p "$SOH_DIR"

      APPIMAGE_IN_STORE="${sohAppImage}/soh.AppImage"
      APPIMAGE_IN_DIR="$SOH_DIR/soh.AppImage"

      # Sync the AppImage into the data dir whenever the Nix store version changes.
      if [ ! -f "$APPIMAGE_IN_DIR" ] || \
         ! diff -q "$APPIMAGE_IN_STORE" "$APPIMAGE_IN_DIR" > /dev/null 2>&1; then
        echo "soh: updating AppImage in $SOH_DIR ..."
        cp "$APPIMAGE_IN_STORE" "$APPIMAGE_IN_DIR"
        chmod +x "$APPIMAGE_IN_DIR"
      fi

      # Run from inside $SOH_DIR so SoH treats it as its own directory.
      cd "$SOH_DIR"
      exec appimage-run "$APPIMAGE_IN_DIR" "$@"
    '';
  };

  sohIcon = pkgs.stdenv.mkDerivation {
    pname = "soh-icon";
    inherit version;
    dontUnpack = true;
    installPhase = ''
      # Prefer a high-res PNG from inside the AppImage if available,
      # falling back to .DirIcon at the root.
      icon=$(find ${sohContents}/usr/share/icons -name "*.png" \
               | sort -t'/' -k1 -V | tail -n1 2>/dev/null \
             || echo "${sohContents}/.DirIcon")

      ext="''${icon##*.}"
      install -Dm644 "$icon" \
        "$out/share/icons/hicolor/256x256/apps/soh.$ext"

      # Also drop a pixmap copy for environments that prefer share/pixmaps.
      install -Dm644 "$icon" \
        "$out/share/pixmaps/soh.$ext"
    '';
  };

in

pkgs.symlinkJoin {
  name = "soh-${version}";
  paths = [
    sohLauncher
    sohDesktop
    sohIcon
  ];
  meta = with pkgs.lib; {
    description = "Ship of Harkinian";
    homepage = "https://www.shipofharkinian.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "soh";
  };
}
