{ pkgs, localPkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    localPkgs.fzf-wrapped
    ripgrep
    fd
    zoxide
    direnv
    nix-direnv
    p7zip
    gnutar

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
  ];
}
