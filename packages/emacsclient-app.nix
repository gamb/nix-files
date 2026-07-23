{
  lib,
  stdenvNoCC,
  emacs,
  # Display name of the bundle (also the .app file name in Finder).
  name ? "Emacs Client",
  bundleId ? "org.gnu.EmacsClient",
  # Path to a custom .icns file. Null reuses the icon from Emacs.app.
  icon ? null,
  # Args passed to emacsclient. Create a new GUI frame, return immediately,
  # and start the daemon if it isn't already running.
  emacsclientArgs ? [
    "-c"
    "-n"
    "--alternate-editor="
  ],
}:

let
  iconSrc =
    if icon != null then icon else "${emacs}/Applications/Emacs.app/Contents/Resources/Emacs.icns";
  version = emacs.version or (lib.getVersion emacs);
in
stdenvNoCC.mkDerivation {
  pname = "emacsclient-app";
  inherit version;

  dontUnpack = true;

  # $out is the .app bundle itself, so home.file can point straight at it.
  buildPhase = ''
    runHook preBuild

    contents="$out/Contents"
    mkdir -p "$contents/MacOS" "$contents/Resources"

    cp ${iconSrc} "$contents/Resources/icon.icns"

    cat > "$contents/Info.plist" <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleExecutable</key><string>emacsclient-launcher</string>
      <key>CFBundleIconFile</key><string>icon</string>
      <key>CFBundleIdentifier</key><string>${bundleId}</string>
      <key>CFBundleName</key><string>${name}</string>
      <key>CFBundlePackageType</key><string>APPL</string>
      <key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
      <key>CFBundleShortVersionString</key><string>${version}</string>
      <key>NSHighResolutionCapable</key><true/>
    </dict>
    </plist>
    EOF

    launcher="$contents/MacOS/emacsclient-launcher"
    cat > "$launcher" <<EOF
    #!/bin/sh
    exec ${emacs}/bin/emacsclient ${lib.escapeShellArgs emacsclientArgs} "\$@"
    EOF
    chmod +x "$launcher"

    runHook postBuild
  '';

  dontInstall = true;

  meta = {
    description = "macOS .app bundle wrapper around emacsclient with a proper icon";
    platforms = lib.platforms.darwin;
  };
}
