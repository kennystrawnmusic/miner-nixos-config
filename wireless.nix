# Wireless tools

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aircrack-ng
    airgeddon
    bully
    cowpatty
    dbmonster
    horst
    killerbee
    kismet
    netscanner
    pixiewps
    reaverwps
    wavemon
    (wifite2.overrideAttrs(_: rec {
      pythonDependencies = [
        python311Packages.chardet
        python311Packages.scapy
      ];

      nativeCheckInputs = propagatedBuildInputs ++ [ python311Packages.unittestCheckHook ];
    }))
    zigpy-cli
  ];
}
