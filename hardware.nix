# Tools and libraries to access hardware

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cantoolz
    chipsec
    cmospwd
    esptool
    extrude
    gallia
    hachoir
    nrfutil
    teensy-loader-cli
    tytools
    python311Packages.angr
    python311Packages.angrop
    python311Packages.can
    python311Packages.pyi2cflash
    python311Packages.pyspiflash
    routersploit
  ];
}
