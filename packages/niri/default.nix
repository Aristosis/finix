{
  niri,
  dbus,
  makeWrapper,
  symlinkJoin,
  lib
}:
symlinkJoin {
  name = "niri-wrapped";
  paths = [ niri ];
  nativeBuildInputs = [ makeWrapper ];
  passthru = niri.passthru;
  postBuild = ''
    cp -r ${./config} $out/config
    wrapProgram $out/bin/niri \
    --set NIRI_CONFIG "$out/config/config.kdl"

    rm "$out/share/wayland-sessions/niri.desktop"

    cat > "$out/share/wayland-sessions/niri.desktop" <<EOF
    [Desktop Entry]
    Encoding=UTF-8
    Name=Niri
    DesktopNames=Niri    Comment=Niri
    Exec=${lib.getExe' dbus "dbus-run-session"} -- $out/bin/niri --session
    Icon=niri
    Type=Application
    EOF
    '';
  meta.mainProgram = "niri";
}
