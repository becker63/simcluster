{ config, lib, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_5_15;

  services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";   # Allow root login with a password
        PasswordAuthentication = true;  # Allow password authentication
      };
    };

    users.users.root = {
      password = "jidw";  # Set an empty password for root
    };

  system.stateVersion = "23.05";
}
