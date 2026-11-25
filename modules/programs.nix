{ quadra, pkgs, localPkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    localPkgs.fzf-wrapped
    ripgrep
    fd
    zoxide
    direnv
    btop
    nix-direnv
    p7zip
    gnutar
    curl

    # nix cli
    nix-du
    nix-diff
    nix-tree

    (obs-studio.override {
      cudaSupport = true;
    })
    heroic
    firefox
    obsidian
    syncthing
    mpv
    vesktop
    xournalpp
    pcsx2
    cmus
    quadra.packages.${pkgs.stdenv.hostPlatform.system}.quadra
  ];
}
