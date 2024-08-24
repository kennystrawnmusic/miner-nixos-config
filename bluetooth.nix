# Bluetooth tools

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bluez
    bluewalker
    python311Packages.bleak
    redfang
    ubertooth
  ];
}
