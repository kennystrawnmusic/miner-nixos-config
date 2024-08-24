# Tools to work with cloud environments

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cloud-nuke
    cloudfox
    ec2stepshell
    gato
    gcp-scanner
    (ggshield.overrideAttrs(_: rec {
      build-system = with python311Packages; [ setuptools ];

      dependencies = with python311Packages; [
        appdirs
        charset-normalizer
        click
        cryptography
        marshmallow
        marshmallow-dataclass
        oauthlib
        platformdirs
        pygitguardian
        pyjwt
        python-dotenv
        pyyaml
        requests
        rich
      ];

      nativeCheckInputs =
      [ git ]
      ++ (with python311Packages; [
        jsonschema
        pyfakefs
        pytest-mock
        pytest-voluptuous
        pytestCheckHook
        snapshottest
        wasmer
        vcrpy
      ]);
    }))
    goblob
    imdshift
    pacu
    poutine
    prowler
    yatas
  ];
}
