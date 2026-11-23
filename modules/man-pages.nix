{ pkgs, ... }:
{
  environment = {
    pathsToLink = [ "/share/man" ];
    systemPackages = with pkgs; [
      man
      man-pages
      man-pages-posix
      coreutils-full # man pages for coreutils
    ];
  };
}

