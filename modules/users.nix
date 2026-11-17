{
  self,
  lib,
  hjem,
  ...
}:
let
  configDirPath = "${self}/config";
  scanConfigDir =
    lib.mapAttrs
      (name: _: {
        source = "${configDirPath}/${name}";
      })
      (
        lib.filterAttrs (name: type: type == "directory" && builtins.substring 0 1 name != "_") (
          builtins.readDir configDirPath
        )
      );
in
{
  imports = [
    hjem.finixModules.default
  ];

  hjem.users.ari = {
    user = "ari";
    xdg.config.files =
      let
        gtkrc = ''
          [Settings]
          gtk-application-prefer-dark-theme=true
        '';
      in
      scanConfigDir
      // {
        "gtk-3.0/settings.ini".text = gtkrc;
        "gtk-4.0/settings.ini".text = gtkrc;
        "user-dirs.dirs".text = ''
          XDG_DESKTOP_DIR="$HOME/media/hdd/Desktop"
          XDG_DOWNLOAD_DIR="$HOME/media/downloads"
          XDG_DOCUMENTS_DIR="$HOME/media/hdd/documents"
          XDG_MUSIC_DIR="$HOME/media/hdd/music"
          XDG_PICTURES_DIR="$HOME/media/hdd/pictures"
          XDG_VIDEOS_DIR="$HOME/media/hdd/videos"
          XDG_PROJECTS_DIR="$HOME/media/projects"
          XDG_TEMPLATES_DIR="/dev/null"
          XDG_PUBLICSHARE_DIR="/dev/null"
        '';
      };
  };
}
