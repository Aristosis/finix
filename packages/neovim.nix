{
  neovim-unwrapped,
  fetchFromGitHub
}:
neovim-unwrapped.overrideAttrs (oldAttrs: {
  doCheck = false;
  doInstallCheck = false;
  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "0945d346eb1c5a0059955a6092ad859e53829713";
    hash = "sha256-H5bGHridavZknJqooTHRCiEh+6i48vsZAQWMceLbgsA=";
  };
})
