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
      pythonDependencies = with python311Packages; [
        (chardet.overrideAttrs(_: rec {
          nativeBuildInputs = [ python311Packages.setuptools ];
        }))
        scapy
      ];

      nativeCheckInputs = propagatedBuildInputs ++ [ python311Packages.unittestCheckHook ];
    }))
    zigpy-cli
  ];
}
