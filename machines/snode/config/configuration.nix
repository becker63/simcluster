{
  imports = [ ./hardware-configuration.nix # TODO: This should be a global var
  ../../../node-config/configuration.nix ];
  system.stateVersion = "23.11";
}
