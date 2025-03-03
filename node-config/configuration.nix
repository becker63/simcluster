{ pkgs, lib, ... }:

with lib;

{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  config = {
    # Yeah bro IDC, this is a test vm
    services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";   # Allow root login with a password
          PasswordAuthentication = true;  # Allow password authentication
          PermitEmptyPasswords = true;    # Allow login without a password
        };
      };

      users.users.root = {
        password = "";  # Set an empty password for root
      };

  };
}
