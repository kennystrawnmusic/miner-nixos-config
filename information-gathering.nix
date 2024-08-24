# Tools for informtion gathering

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cloudbrute
    enumerepo
    holehe

    # Must use Python 3.11 for this to build properly
    (maigret.overrideAttrs(_: rec {
      python3 = python311;
    }))
    metabigor
    p0f
    sn0int
    socialscan
    theharvester
    urlhunter
  ];
}
