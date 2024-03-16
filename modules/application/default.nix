{lib, ...}:

with lib;
{
  imports = [
    ./bat.nix 
    ./bind.nix
    ./binutils.nix
    ./coreutils.nix
    ./curl.nix
    ./dhcpcd.nix
    ./dust.nix
    ./e2fsprogs.nix
    ./fzf.nix
    ./git.nix
    ./glow.nix
    ./gpm.nix
    ./htop.nix
    ./iftop.nix
    ./iotop.nix
    ./less.nix
    ./lsof.nix
    ./pciutils.nix
    ./rsync.nix
    ./tree.nix
    ./tmux.nix
    ./vim.nix
    ./wget.nix
    ./zsh
  ];
}
