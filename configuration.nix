# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, stdenv, fetchurl, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  nixpkgs.overlays = [

    (final: prev: {
      
      # Always spoof user agent to fix the problem of curl having a hard time
      # downloading certain files
      final.fetchurl = prev.fetchurl.overrideAttrs(_: {
        curlOptsList = [
          "-HUser-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
          "-L"
          "-sSf"
        ];

        mirrors.gnu = [
          # This one used to redirect to a (supposedly) nearby
          # and (supposedly) up-to-date mirror but no longer does
#           "https://ftpmirror.gnu.org/"

          "https://ftp.nluug.nl/pub/gnu/"
          "https://mirrors.kernel.org/gnu/"
          "https://mirror.ibcp.fr/pub/gnu/"
          "https://mirror.dogado.de/gnu/"
          "https://mirror.tochlab.net/pub/gnu/"

          # This one is the master repository, and thus it's always up-to-date
          "https://ftp.gnu.org/pub/gnu/"

          "ftp://ftp.funet.fi/pub/mirrors/ftp.gnu.org/gnu/"
        ];
      });

      # Force use of Python 3.11 to work around the problem of not having enough support for 3.12 among the pentest tools
      python3 = prev.python311;
    })
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Needed for ensuring desktop layout reproducibility
    (import "${home-manager}/nixos")

    # Pentest tools
    ./bluetooth.nix
    ./cloud.nix
    ./code.nix
    ./container.nix
    ./dns.nix
    ./exploits.nix
    ./forensics.nix
    ./fuzzers.nix
    ./generic.nix
    ./hardware.nix
    ./host.nix
    ./information-gathering.nix
    ./kubernetes.nix
    ./ldap.nix
    ./load-testing.nix
    ./malware.nix
    ./misc.nix
    ./mobile.nix
    ./network.nix
    ./packet-generators.nix
    ./password.nix
    ./port-scanners.nix
    ./proxies.nix
    ./services.nix
    ./smartcards.nix
    ./terminals.nix
    ./tls.nix
    ./traffic.nix
    ./tunneling.nix
    ./voip.nix
    ./web.nix
    ./windows.nix
    ./wireless.nix
  ];

  # Nix package manager settings
  nix.settings = {
    # Enable flakes permanently
    experimental-features = [ "nix-command" "flakes" ];

    # Some things just don't download if you don't push things
    download-attempts = 1000000;

    # Don't abort the entire system build because some obscure download failed
    keep-going = true;

    # Fetching from master Git branches is impossible otherwise
    require-sigs = false;

    # Any value higher than this will cause entire system to hang during QtWebEngine build
    build-cores = 6;
  };

  # Git configuration
  programs.git.config = {
    user = {
      name = "Kenny Strawn";
      email = "kstrawn0@saddleback.edu";
    };
    http = {
      postBuffer = 1048576000;
    };
    https = {
      postBuffer = 1048576000;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Clean /tmp on reboot
  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
    tmpfsSize = "300%";
  };

  # Plymouth
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # Temporary workaround for bcachefs problems
  boot.plymouth.enable = true;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "i915.fastboot=1"
    "i915.enable_psr=0"
    "i915.enable_fbc=0"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "vt.global_cursor_default=0"
    "sysrq_always_enabled=1"
    "usbcore.autosuspend=\"-1\""

    # Workaround until we can fix the display server hang problem
    # "modprobe.blacklist=amdgpu"

    # Default modesetting is too high and creates unreadable console text
    "video=HDMI-A-1:1360x768@60"
  ];

  # What to do in case of OOM condition
  systemd.oomd = {
    enableRootSlice = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "2s";
    };
  };

  # bcachefs
  boot.supportedFilesystems = [ "bcachefs" ];

  networking.hostName = "realkstrawn93-miner"; # Define your hostname.

  # Enable networking
  # NetworkManager already depends on wpa_supplicant, so no need to pull it in separately.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Absolute newest kernel possible
  boot.kernelPackages = pkgs.linuxPackages_testing;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # SDDM
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.settings = {
    Autologin = {
      User = "realkstrawn93";
      Session = "plasma.desktop";
    };
  };
  services.displayManager.sddm.autoLogin.relogin = true;

  # KDE Plasma
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PasswordAuthentication = true;
    };
  };

  # Enable sound with pipewire.
#   sound.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Needed for National Cyber League
  virtualisation.incus = {
    enable = true;
    socketActivation = true;
    preseed = {
      networks = [
        {
          config = {
            "ipv4.address" = "10.0.100.1/24";
            "ipv4.nat" = "true";
          };
          name = "incusbr0";
          type = "bridge";
        }
      ];
      profiles = [
        {
          devices = {
            eno1 = {
              name = "eno1";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              size = "35GiB";
              type = "disk";
            };
          };
          name = "default";
        }
      ];
      storage_pools = [
        {
          config = {
            source = "/var/lib/incus/storage-pools/default";
          };
          driver = "dir";
          name = "default";
        }
      ];
    };
  };

  # Annoying ads begone!
  services.adguardhome = {
    enable = true;
    allowDHCP = true;
    openFirewall = true;
    # Additional settings TBD
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "realkstrawn93";
  
  # Suppress annoying password prompts when running stuff that requires sudo
  security.sudo.extraRules = [
    {
      users = [ "realkstrawn93" ];
      commands = [
        {
          command = "ALL";
      	  options = [ "NOPASSWD" "SETENV" ];
        }
      ];
    }
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Essentials
    git
    gcc
    qemu
    file
    wget
    google-chrome

    # Force this package to not use the defunct ftpmirror.gnu.org download link
    (libunistring.overrideAttrs(_: rec {
      src = pkgs.fetchurl {
        url = "https://ftp.gnu.org/gnu/libunistring/libunistring-1.2.tar.gz";
        sha256 = "sha256-/W1WYvpwZIfEg0mnWLV7wUnOlOxsMGJOyf3Ec86rvI4=";
      };
    }))

    # KDE profile doesn't pull in Discover either
    discover

    # https://github.com/kennystrawnmusic/cryptos
    rustup
    rust-analyzer
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        rust-lang.rust-analyzer
        gruntfuggly.todo-tree
        github.copilot
        github.codespaces
        tamasfe.even-better-toml
        serayuzgur.crates
        bbenoist.nix
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.327.0";
          sha256 = "sha256-nx4g73fYTm5L/1s/IHMkiYBlt3v1PobAv6/0VUrlWis=";
        }
        {
          name = "copilot-chat";
          publisher = "GitHub";
          version = "0.12.2024013003";
          sha256 = "sha256-4ArWVFko2T6ze/i+HTdXAioWC7euWCycDsQxFTrEtUw=";
        }
      ];
    })

    # System Administration
    pv
    kwallet-pam
    kate
    konsole
    gwenview
    okular
    ark
    khelpcenter

    # Copy/paste from terminal
    wl-clipboard

    # For getting NixOS and Arch to play nicely together and vice versa
    arch-install-scripts

    # QtWebEngine is a major RAM hog
#    (
#      kdePackages.qtwebengine.overrideAttrs(new: old: rec {
#        new.cmakeFlags = old.cmakeFlags ++ [
#          "-DQT_FEATURE_webengine_jumbo_build=OFF"
#        ];
#      })
#    )

    # Needed for CS1A:15900
    eclipses.eclipse-cpp
    gnumake

    # Important personal stuff
    openssl
    nss.tools
    pciutils
    nvme-cli
    hw-probe
    usbutils
    spotify
    libreoffice-fresh

    # Surprisingly not pulled in by default
    kdePackages.plasma-browser-integration

    # Reproducibility
    nixos-install-tools

    # Runtime Dependencies of Python Pentest Tools
    gtk3
    (python311.withPackages(pypkgs: [
      pypkgs.binwalk
#       pypkgs.distorm3 # NixOS/nixpkgs#328346
      pypkgs.requests
      pypkgs.beautifulsoup4
      pypkgs.pygobject3
      pypkgs.scapy
      pypkgs.wasmer
    ]))

    # Custom packages, Part 1: PwnXSS
    (pkgs.stdenv.mkDerivation rec {
      pname = "pwnxss";
      version = "0.5.0";

      format = "pyproject";

      src = builtins.fetchGit {
        url = "https://github.com/Pwn0Sec/PwnXSS";
        ref = "master";
      };

      propagatedBuildInputs = [
        (python311.withPackages(pypkgs: [
          pypkgs.wrapPython
          pypkgs.beautifulsoup4
          pypkgs.requests
        ]))
      ];

      buildInputs = propagatedBuildInputs;
      nativeBuildInputs = propagatedBuildInputs;

      pythonPath = with python311Packages; [ beautifulsoup4 requests ];

      pwnxssExecutable = placeholder "out" + "/bin/pwnxss";

      installPhase = ''
        # Base directories
        install -dm755 $out/share/pwnxss
        install -dm755 $out/bin

        # Copy files
        cp -a --no-preserve=ownership * "$out/share/pwnxss"

        # Use wrapper script to allow execution from anywhere
        cat > $out/bin/pwnxss << EOF
        #!${pkgs.bash}/bin/bash
        cd $out/share/pwnxss
        python pwnxss.py \$@
        EOF

        chmod a+x $out/bin/pwnxss
      '';
    })

    # Custom packages, Part 2: CUPP
    (pkgs.stdenv.mkDerivation rec {
      pname = "cupp";
      version = "3.2.0-alpha";
      
      src = builtins.fetchGit {
        url = "https://github.com/Mebus/cupp";
        ref = "master";
      };
      
      installPhase = ''
        # Base directories
        install -dm755 $out/share/cupp
        install -dm755 $out/bin
        
        # Copy files
        cp -a --no-preserve=ownership * "$out/share/cupp"
        
        # Use wrapper script to allow execution from anywhere
        cat > $out/bin/cupp << EOF
        #!${pkgs.bash}/bin/bash
        cd $out/share/cupp
        python cupp.py \$@
        EOF

        chmod a+x $out/bin/cupp
      '';
    })
  ];

  # PAM configuration
  security.pam = {
    # KWallet auto-unlock
    services.sddm.enableKwallet = true;
    # NixOS doesn't pull from /etc/skel by default, so forcing it to
    makeHomeDir.skelDirectory = "/etc/skel";
  };

  # Flatpak
  services.flatpak.enable = true;

  # Get as close to Arch as possible with rolling updates
  nix.nixPath = lib.mkOverride 0 [
    "nixpkgs=https://github.com/NixOS/nixpkgs/archive/staging-next.tar.gz"
    "nixos=https://github.com/NixOS/nixpkgs/archive/staging-next.tar.gz"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  # Keep system up-to-date without intervention
  system.autoUpgrade = {
    enable = true;
    channel = "nixos";
    dates = "03:00";
    rebootWindow.lower = "01:00";
    rebootWindow.upper = "05:00";
    persistent = true;
  };

  # Memory compression
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 300;
  };

  # System-wide shell config
  environment.etc.bashrc.text = ''
    # Create /opt if it doesn't already exist and set proper permissions on it
    if [ ! -d /opt ]; then
      if [ $UID -eq 0 ]; then
        mkdir /opt
        chmod -R a+rw /opt
      else
        sudo mkdir /opt
        sudo chmod -R a+rw /opt
      fi
    fi

    # Ensure that Rust is installed in the correct (sysmtem-wide) location
    export CARGO_BUILD_JOBS=$(nproc)
    export RUSTUP_HOME=/opt/rust
    export CARGO_HOME=/opt/rust

    # Add Rust to $PATH if installed
    if [ -f /opt/rust/env ]; then
      source /opt/rust/env
    elif [ -d /opt/rust/bin ]; then
      export PATH=/opt/rust/bin:$PATH
    fi

    # Allow editing of files as root
    alias pkexec="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true"
  '';

  # Use the OOM killer to prevent splash hangs
#   systemd.services.displayOomKill = {
#     wantedBy = [ "multi-user.target" ];
#     before = [ "display-manager.service" ];
#     serviceConfig = {
#       Type = "oneshot";
#       ExecStart = ''${pkgs.bash}/bin/bash -c "echo f > /proc/sysrq-trigger"'';
#     };
#   };

  # OpenCL, Part 1
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  # OpenCL, Part 2
  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  # Keep USB mice and keyboards awake at all times
  services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
  ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{power/autosuspend}="0"
  ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend_delay_ms", ATTR{power/autosuspend_delay_ms}="0"
  '';

  # Desktop layout, part 1
  environment.etc."skel/.config/plasma-org.kde.plasma.desktop-appletsrc".text = lib.mkOverride 0 ''
    [ActionPlugins][0]
    RightButton;NoModifier=org.kde.contextmenu

    [ActionPlugins][1]
    RightButton;NoModifier=org.kde.contextmenu

    [Containments][1]
    ItemGeometries-1360x768=
    ItemGeometriesHorizontal=
    activityId=1a0267a4-a1e8-4b97-94da-2079fc2a9645
    formfactor=0
    immutability=1
    lastScreen=0
    location=0
    plugin=org.kde.plasma.folder
    wallpaperplugin=org.kde.image

    [Containments][1][General]
    ToolBoxButtonState=topcenter
    ToolBoxButtonX=342
    ToolBoxButtonY=36

    [Containments][2]
    activityId=
    formfactor=2
    immutability=1
    lastScreen=0
    location=4
    plugin=org.kde.panel
    wallpaperplugin=org.kde.image

    [Containments][2][Applets][5]
    immutability=1
    plugin=org.kde.plasma.icontasks

    [Containments][2][Applets][5][Configuration][ConfigDialog]
    DialogHeight=540
    DialogWidth=720

    [Containments][2][Applets][5][Configuration][General]
    fill=false
    launchers=applications:systemsettings.desktop,applications:org.kde.discover.desktop,preferred://browser,applications:org.kde.konsole.desktop,applications:spotify.desktop,applications:Eclipse.desktop,applications:code.desktop,org.kde.kate.desktop

    [Containments][2][Applets][53]
    immutability=1
    plugin=org.kde.plasma.kickerdash

    [Containments][2][Applets][53][Configuration]
    PreloadWeight=100
    popupHeight=510
    popupWidth=647

    [Containments][2][Applets][53][Configuration][General]
    favoritesPortedToKAstats=true

    [Containments][2][Applets][53][Configuration][Shortcuts]
    global=Alt+F1

    [Containments][2][Applets][53][Shortcuts]
    global=Alt+F1

    [Containments][2][Applets][6]
    immutability=1
    plugin=org.kde.plasma.marginsseparator

    [Containments][2][General]
    AppletOrder=53;5;6

    [Containments][27]
    activityId=
    formfactor=2
    immutability=1
    lastScreen=0
    location=3
    plugin=org.kde.panel
    wallpaperplugin=org.kde.image

    [Containments][27][Applets][28]
    immutability=1
    plugin=org.kde.plasma.appmenu

    [Containments][27][Applets][29]
    immutability=1
    plugin=org.kde.plasma.kickoff

    [Containments][27][Applets][29][Configuration]
    PreloadWeight=100
    popupHeight=510
    popupWidth=647

    [Containments][27][Applets][29][Configuration][General]
    favoritesPortedToKAstats=true

    [Containments][27][Applets][30]
    immutability=1
    plugin=org.kde.plasma.digitalclock

    [Containments][27][Applets][30][Configuration]
    PreloadWeight=95
    popupHeight=450
    popupWidth=560

    [Containments][27][Applets][30][Configuration][Appearance]
    showDate=false
    showSeconds=Always

    [Containments][27][Applets][30][Configuration][ConfigDialog]
    DialogHeight=540
    DialogWidth=720

    [Containments][27][Applets][33]
    immutability=1
    plugin=org.kde.plasma.panelspacer

    [Containments][27][Applets][34]
    immutability=1
    plugin=org.kde.plasma.panelspacer

    [Containments][27][Applets][35]
    immutability=1
    plugin=org.kde.plasma.systemtray

    [Containments][27][Applets][35][Configuration]
    PreloadWeight=75
    SystrayContainmentId=36

    [Containments][27][General]
    AppletOrder=29;28;34;30;33;35

    [Containments][36]
    activityId=
    formfactor=2
    immutability=1
    lastScreen=0
    location=3
    plugin=org.kde.plasma.private.systemtray
    popupHeight=432
    popupWidth=432
    wallpaperplugin=org.kde.image

    [Containments][36][Applets][37]
    immutability=1
    plugin=org.kde.plasma.clipboard

    [Containments][36][Applets][37][Configuration]
    PreloadWeight=55

    [Containments][36][Applets][38]
    immutability=1
    plugin=org.kde.plasma.devicenotifier

    [Containments][36][Applets][38][Configuration]
    PreloadWeight=60

    [Containments][36][Applets][39]
    immutability=1
    plugin=org.kde.plasma.manage-inputmethod

    [Containments][36][Applets][40]
    immutability=1
    plugin=org.kde.plasma.notifications

    [Containments][36][Applets][40][Configuration]
    PreloadWeight=55

    [Containments][36][Applets][41]
    immutability=1
    plugin=org.kde.plasma.keyboardindicator

    [Containments][36][Applets][42]
    immutability=1
    plugin=org.kde.plasma.printmanager

    [Containments][36][Applets][43]
    immutability=1
    plugin=org.kde.kscreen

    [Containments][36][Applets][44]
    immutability=1
    plugin=org.kde.plasma.keyboardlayout

    [Containments][36][Applets][45]
    immutability=1
    plugin=org.kde.plasma.volume

    [Containments][36][Applets][45][Configuration]
    PreloadWeight=90

    [Containments][36][Applets][45][Configuration][General]
    migrated=true

    [Containments][36][Applets][46]
    immutability=1
    plugin=org.kde.plasma.vault

    [Containments][36][Applets][47]
    immutability=1
    plugin=org.kde.kdeconnect

    [Containments][36][Applets][48]
    immutability=1
    plugin=org.kde.plasma.cameraindicator

    [Containments][36][Applets][49]
    immutability=1
    plugin=org.kde.plasma.brightness

    [Containments][36][Applets][49][Configuration]
    PreloadWeight=26

    [Containments][36][Applets][50]
    immutability=1
    plugin=org.kde.plasma.battery

    [Containments][36][Applets][50][Configuration]
    PreloadWeight=26

    [Containments][36][Applets][51]
    immutability=1
    plugin=org.kde.plasma.mediacontroller

    [Containments][36][Applets][51][Configuration]
    PreloadWeight=41

    [Containments][36][Applets][52]
    immutability=1
    plugin=org.kde.plasma.networkmanagement

    [Containments][36][Applets][52][Configuration]
    PreloadWeight=60

    [Containments][36][General]
    extraItems=org.kde.plasma.bluetooth,org.kde.plasma.battery,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.keyboardindicator,org.kde.plasma.printmanager,org.kde.kscreen,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.vault,org.kde.kdeconnect,org.kde.plasma.brightness,org.kde.plasma.cameraindicator
    knownItems=org.kde.plasma.bluetooth,org.kde.plasma.battery,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.keyboardindicator,org.kde.plasma.printmanager,org.kde.kscreen,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.vault,org.kde.kdeconnect,org.kde.plasma.brightness,org.kde.plasma.cameraindicator

    [Containments][8]
    activityId=
    formfactor=2
    immutability=1
    lastScreen=0
    location=4
    plugin=org.kde.plasma.private.systemtray
    popupHeight=432
    popupWidth=432
    wallpaperplugin=org.kde.image

    [Containments][8][Applets][10]
    immutability=1
    plugin=org.kde.plasma.devicenotifier

    [Containments][8][Applets][10][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][11]
    immutability=1
    plugin=org.kde.plasma.manage-inputmethod

    [Containments][8][Applets][11][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][12]
    immutability=1
    plugin=org.kde.plasma.notifications

    [Containments][8][Applets][12][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][13]
    immutability=1
    plugin=org.kde.plasma.keyboardindicator

    [Containments][8][Applets][13][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][14]
    immutability=1
    plugin=org.kde.plasma.printmanager

    [Containments][8][Applets][14][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][15]
    immutability=1
    plugin=org.kde.kscreen

    [Containments][8][Applets][15][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][16]
    immutability=1
    plugin=org.kde.plasma.keyboardlayout

    [Containments][8][Applets][16][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][17]
    immutability=1
    plugin=org.kde.plasma.volume

    [Containments][8][Applets][17][Configuration]
    PreloadWeight=72

    [Containments][8][Applets][17][Configuration][General]
    migrated=true

    [Containments][8][Applets][18]
    immutability=1
    plugin=org.kde.plasma.vault

    [Containments][8][Applets][18][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][19]
    immutability=1
    plugin=org.kde.kdeconnect

    [Containments][8][Applets][19][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][20]
    immutability=1
    plugin=org.kde.plasma.cameraindicator

    [Containments][8][Applets][20][Configuration]
    PreloadWeight=42

    [Containments][8][Applets][23]
    immutability=1
    plugin=org.kde.plasma.networkmanagement

    [Containments][8][Applets][23][Configuration]
    PreloadWeight=57

    [Containments][8][Applets][23][Configuration][General]
    currentDetailsTab=details

    [Containments][8][Applets][24]
    immutability=1
    plugin=org.kde.plasma.brightness

    [Containments][8][Applets][24][Configuration]
    PreloadWeight=26

    [Containments][8][Applets][25]
    immutability=1
    plugin=org.kde.plasma.battery

    [Containments][8][Applets][25][Configuration]
    PreloadWeight=26

    [Containments][8][Applets][26]
    immutability=1
    plugin=org.kde.plasma.mediacontroller

    [Containments][8][Applets][26][Configuration]
    PreloadWeight=26

    [Containments][8][Applets][9]
    immutability=1
    plugin=org.kde.plasma.clipboard

    [Containments][8][Applets][9][Configuration]
    PreloadWeight=42

    [Containments][8][Configuration]
    PreloadWeight=42

    [Containments][8][General]
    extraItems=org.kde.plasma.bluetooth,org.kde.plasma.battery,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.keyboardindicator,org.kde.plasma.printmanager,org.kde.kscreen,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.vault,org.kde.kdeconnect,org.kde.plasma.brightness,org.kde.plasma.cameraindicator
    knownItems=org.kde.plasma.bluetooth,org.kde.plasma.battery,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.keyboardindicator,org.kde.plasma.printmanager,org.kde.kscreen,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.vault,org.kde.kdeconnect,org.kde.plasma.brightness,org.kde.plasma.cameraindicator
  '';

  # Desktop layout, Part 2
  environment.etc."skel/.config/plasmashellrc".text = lib.mkOverride 0 ''
    [PlasmaViews][Panel 2]
    floating=1
    panelLengthMode=1
    panelOpacity=2

    [PlasmaViews][Panel 2][Defaults]
    thickness=32

    [PlasmaViews][Panel 27]
    floating=1

    [PlasmaViews][Panel 27][Defaults]
    thickness=20

    [Updates]
    performed=/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/containmentactions_middlebutton.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/digitalclock_migrate_font_settings.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/digitalclock_rename_timezonedisplay_key.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/folderview_fix_recursive_screenmapping.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/keyboardlayout_migrateiconsetting.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/keyboardlayout_remove_shortcut.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/klipper_clear_config.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/maintain_existing_desktop_icon_sizes.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/mediaframe_migrate_useBackground_setting.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/move_desktop_layout_config.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/no_middle_click_paste_on_panels.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/systemloadviewer_systemmonitor.js,/run/current-system/sw/share/plasma/shells/org.kde.plasma.desktop/contents/updates/unlock_widgets.js
  '';

  environment.etc."skel/.local/share/konsole/80x24.profile".text = ''
    [General]
    Name=80x24
    Parent=FALLBACK/
    TerminalColumns=80
    TerminalRows=24
  '';

  environment.etc."skel/.config/konsolerc".text = ''
    [Desktop Entry]
    DefaultProfile=80x24.profile

    [General]
    ConfigVersion=1

    [MainWindow]
    1360x768 screen: Height=456
    1360x768 screen: Width=669
    State=AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAvsAAAAiAFEAdQBpAGMAawBDAG8AbQBtAGEAbgBkAHMARABvAGMAawAAAAAA/////wAAAXIA////+wAAABwAUwBTAEgATQBhAG4AYQBnAGUAcgBEAG8AYwBrAAAAAAD/////AAABEQD///8AAAKdAAABmgAAAAQAAAAEAAAACAAAAAj8AAAAAQAAAAIAAAACAAAAFgBtAGEAaQBuAFQAbwBvAGwAQgBhAHIBAAAAAP////8AAAAAAAAAAAAAABwAcwBlAHMAcwBpAG8AbgBUAG8AbwBsAGIAYQByAQAAAOj/////AAAAAAAAAAA=
    ToolBarsMovable=Disabled

    [UiSettings]
    ColorScheme=
  '';

  environment.etc."skel/.config/powermanagementprofilesrc".text = ''
    [AC][Display]
    TurnOffDisplayWhenIdle=false

    [AC][SuspendAndShutdown]
    AutoSuspendAction=0

    [General]
    pausePlayersOnSuspend=false
  '';

  environment.etc."skel/.config/kscreenlockerrc".text = ''
    [Daemon]
    Autolock=false
    LockOnResume=false
  '';

  environment.etc."skel/.config/kwinoutputconfig.json".text = ''
    [
        {
            "data": [
                {
                    "autoRotation": "InTabletMode",
                    "brightness": 1,
                    "colorProfileSource": "sRGB",
                    "connectorName": "HDMI-A-1",
                    "edidHash": "05530ae9aa69747388f2317e65d2204d",
                    "edidIdentifier": "AMZ 0 0 1 2022 0",
                    "highDynamicRange": false,
                    "iccProfilePath": "",
                    "mode": {
                        "height": 768,
                        "refreshRate": 60015,
                        "width": 1360
                    },
                    "overscan": 0,
                    "rgbRange": "Full",
                    "scale": 0.9,
                    "sdrBrightness": 200,
                    "sdrGamutWideness": 0,
                    "transform": "Normal",
                    "vrrPolicy": "Automatic",
                    "wideColorGamut": false
                }
            ],
            "name": "outputs"
        },
        {
            "data": [
                {
                    "lidClosed": false,
                    "outputs": [
                        {
                            "enabled": true,
                            "outputIndex": 0,
                            "position": {
                                "x": 0,
                                "y": 0
                            },
                            "priority": 0
                        }
                    ]
                }
            ],
            "name": "setups"
        }
    ]
  '';

  # NixOS for Arch rescue/recovery, Part 1
  environment.etc."pacman.conf".text = ''
    #
    # /etc/pacman.conf
    #
    # See the pacman.conf(5) manpage for option and repository directives

    #
    # GENERAL OPTIONS
    #
    [options]
    # The following paths are commented out with their default values listed.
    # If you wish to use different paths, uncomment and update the paths.
    #RootDir     = /
    #DBPath      = /var/lib/pacman/
    #CacheDir    = /var/cache/pacman/pkg/
    #LogFile     = /var/log/pacman.log
    #GPGDir      = /etc/pacman.d/gnupg/
    #HookDir     = /etc/pacman.d/hooks/
    HoldPkg     = pacman glibc
    #XferCommand = /usr/bin/curl -L -C - -f -o %o %u
    #XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
    #CleanMethod = KeepInstalled
    Architecture = auto

    # Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
    #IgnorePkg   =
    #IgnoreGroup =

    #NoUpgrade   =
    #NoExtract   =

    # Misc options
    #UseSyslog
    #Color
    #NoProgressBar
    CheckSpace
    #VerbosePkgLists
    ParallelDownloads = 12

    # Pacstrap from NixOS to reinstall Arch fails without this
    # This doesn't get copied to the target system, which instead uses the default config
    # bundled with the pacman package
    SigLevel    = Never
    LocalFileSigLevel = Never
    #RemoteFileSigLevel = Required

    # NOTE: You must run `pacman-key --init` before first using pacman; the local
    # keyring can then be populated with the keys of all official Arch Linux
    # packagers with `pacman-key --populate archlinux`.

    #
    # REPOSITORIES
    #   - can be defined here or included from another file
    #   - pacman will search repositories in the order defined here
    #   - local/custom mirrors can be added here or in separate files
    #   - repositories listed first will take precedence when packages
    #     have identical names, regardless of version number
    #   - URLs will have $repo replaced by the name of the current repo
    #   - URLs will have $arch replaced by the name of the architecture
    #
    # Repository entries are of the format:
    #       [repo-name]
    #       Server = ServerName
    #       Include = IncludePath
    #
    # The header [repo-name] is crucial - it must be present and
    # uncommented to enable the repo.
    #

    # The testing repositories are disabled by default. To enable, uncomment the
    # repo name header and Include lines. You can add preferred servers immediately
    # after the header, and they will be used before the default mirrors.

    [kde-unstable]
    Include = /etc/pacman.d/mirrorlist

    [core-testing]
    Include = /etc/pacman.d/mirrorlist

    [core]
    Include = /etc/pacman.d/mirrorlist

    [extra-testing]
    Include = /etc/pacman.d/mirrorlist

    [extra]
    Include = /etc/pacman.d/mirrorlist

    # If you want to run 32 bit applications on your x86_64 system,
    # enable the multilib repositories as required here.

    [multilib-testing]
    Include = /etc/pacman.d/mirrorlist

    [multilib]
    Include = /etc/pacman.d/mirrorlist

    # An example of a custom package repository.  See the pacman manpage for
    # tips on creating your own repositories.
    #[custom]
    #SigLevel = Optional TrustAll
    #Server = file:///home/custompkgs
  '';

  # NixOS for Arch rescue/recovery, Part 2
  environment.etc."pacman.d/mirrorlist".text = ''
    ################################################################################
    ################# Arch Linux mirrorlist generated by Reflector #################
    ################################################################################

    # With:       reflector -c 'United States' --sort rate
    # When:       2024-07-03 06:22:19 UTC
    # From:       https://archlinux.org/mirrors/status/json/
    # Retrieved:  2024-07-03 06:22:19 UTC
    # Last Check: 2024-07-03 06:20:06 UTC

    Server = http://us.mirrors.cicku.me/archlinux/$repo/os/$arch
    Server = https://us.mirrors.cicku.me/archlinux/$repo/os/$arch
    Server = https://arch.hu.fo/archlinux/$repo/os/$arch
    Server = http://mirror.fcix.net/archlinux/$repo/os/$arch
    Server = https://mirrors.ocf.berkeley.edu/archlinux/$repo/os/$arch
    Server = https://ziply.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://mirrors.xtom.com/archlinux/$repo/os/$arch
    Server = http://arch.hu.fo/archlinux/$repo/os/$arch
    Server = https://mirror.lty.me/archlinux/$repo/os/$arch
    Server = http://mirrors.ocf.berkeley.edu/archlinux/$repo/os/$arch
    Server = https://codingflyboy.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://mirrors.xtom.com/archlinux/$repo/os/$arch
    Server = http://opencolo.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://mirrors.cat.pdx.edu/archlinux/$repo/os/$arch
    Server = http://dfw.mirror.rackspace.com/archlinux/$repo/os/$arch
    Server = https://opencolo.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://mirror.lty.me/archlinux/$repo/os/$arch
    Server = https://plug-mirror.rcac.purdue.edu/archlinux/$repo/os/$arch
    Server = https://southfront.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://repo.ialab.dsu.edu/archlinux/$repo/os/$arch
    Server = https://ridgewireless.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://mnvoip.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://mirror.fcix.net/archlinux/$repo/os/$arch
    Server = http://southfront.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://ziply.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://ridgewireless.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://uvermont.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://codingflyboy.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://coresite.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://nnenix.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://plug-mirror.rcac.purdue.edu/archlinux/$repo/os/$arch
    Server = http://mirrors.gigenet.com/archlinux/$repo/os/$arch
    Server = http://forksystems.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://ord.mirror.rackspace.com/archlinux/$repo/os/$arch
    Server = http://mirrors.mit.edu/archlinux/$repo/os/$arch
    Server = https://forksystems.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://iad.mirrors.misaka.one/archlinux/$repo/os/$arch
    Server = https://mirrors.rit.edu/archlinux/$repo/os/$arch
    Server = http://coresite.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://arch.mirror.constant.com/$repo/os/$arch
    Server = http://mirrors.rit.edu/archlinux/$repo/os/$arch
    Server = https://archmirror1.octyl.net/$repo/os/$arch
    Server = http://irltoolkit.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://ord.mirror.rackspace.com/archlinux/$repo/os/$arch
    Server = https://irltoolkit.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://mirrors.iu13.net/archlinux/$repo/os/$arch
    Server = https://volico.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://mirror.sfo12.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = https://iad.mirrors.misaka.one/archlinux/$repo/os/$arch
    Server = http://mirrors.bjg.at/arch/$repo/os/$arch
    Server = https://mnvoip.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://arch.mirror.constant.com/$repo/os/$arch
    Server = http://volico.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
    Server = https://mirror.pit.teraswitch.com/archlinux/$repo/os/$arch
    Server = rsync://mirrors.ocf.berkeley.edu/archlinux/$repo/os/$arch
    Server = http://mirrors.iu13.net/archlinux/$repo/os/$arch
    Server = rsync://opencolo.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://mirror.pit.teraswitch.com/archlinux/$repo/os/$arch
    Server = http://nnenix.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://uvermont.mm.fcix.net/archlinux/$repo/os/$arch
    Server = rsync://arch.hu.fo/archlinux/$repo/os/$arch
    Server = rsync://codingflyboy.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://repo.miserver.it.umich.edu/archlinux/$repo/os/$arch
    Server = http://ftp.osuosl.org/pub/archlinux/$repo/os/$arch
    Server = http://mirrors.sonic.net/archlinux/$repo/os/$arch
    Server = https://arlm.tyzoid.com/$repo/os/$arch
    Server = http://archmirror1.octyl.net/$repo/os/$arch
    Server = rsync://mirror.lty.me/archlinux/$repo/os/$arch
    Server = rsync://ridgewireless.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://mirrors.mit.edu/archlinux/$repo/os/$arch
    Server = rsync://ziply.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://mirrors.sonic.net/archlinux/$repo/os/$arch
    Server = https://america.mirror.pkgbuild.com/$repo/os/$arch
    Server = http://mirror.arizona.edu/archlinux/$repo/os/$arch
    Server = http://mirror.sfo12.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = rsync://mirrors.sonic.net/archlinux/$repo/os/$arch
    Server = rsync://mirror.arizona.edu/archlinux/$repo/os/$arch
    Server = rsync://coresite.mm.fcix.net/archlinux/$repo/os/$arch
    Server = rsync://mirror.dal10.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = rsync://forksystems.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://mirror.colonelhosting.com/archlinux/$repo/os/$arch
    Server = rsync://mirror.mia11.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = rsync://plug-mirror.rcac.purdue.edu/archlinux/$repo/os/$arch
    Server = rsync://arlm.tyzoid.com/archlinux/$repo/os/$arch
    Server = rsync://iad.mirrors.misaka.one/archlinux/$repo/os/$arch
    Server = rsync://volico.mm.fcix.net/archlinux/$repo/os/$arch
    Server = rsync://nnenix.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://mirror.mia11.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = rsync://mirror.sfo12.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = http://mirror.vtti.vt.edu/archlinux/$repo/os/$arch
    Server = rsync://arch.mirror.constant.com/archlinux/$repo/os/$arch
    Server = rsync://mirrors.iu13.net/archlinux/$repo/os/$arch
    Server = rsync://mirrors.bloomu.edu/archlinux/$repo/os/$arch
    Server = https://mirror.clarkson.edu/archlinux/$repo/os/$arch
    Server = rsync://mirror.pit.teraswitch.com/archlinux/$repo/os/$arch
    Server = rsync://mirrors.rit.edu/archlinux/$repo/os/$arch
    Server = http://mirrors.bloomu.edu/archlinux/$repo/os/$arch
    Server = rsync://zxcvfdsa.com/arch/$repo/os/$arch
    Server = https://mirror.dal10.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = rsync://distro.ibiblio.org/archlinux/$repo/os/$arch
    Server = https://mirror.mia11.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = http://mirror.clarkson.edu/archlinux/$repo/os/$arch
    Server = https://mirror.pilotfiber.com/archlinux/$repo/os/$arch
    Server = http://mirrors.acm.wpi.edu/archlinux/$repo/os/$arch
    Server = http://www.gtlib.gatech.edu/pub/archlinux/$repo/os/$arch
    Server = http://mirror.umd.edu/archlinux/$repo/os/$arch
    Server = https://mirror.umd.edu/archlinux/$repo/os/$arch
    Server = https://ftp.osuosl.org/pub/archlinux/$repo/os/$arch
    Server = rsync://ftp.osuosl.org/archlinux/$repo/os/$arch
    Server = http://mirrors.lug.mtu.edu/archlinux/$repo/os/$arch
    Server = https://mirrors.lug.mtu.edu/archlinux/$repo/os/$arch
    Server = rsync://mirrors.lug.mtu.edu/archlinux/$repo/os/$arch
    Server = http://mirrors.xmission.com/archlinux/$repo/os/$arch
    Server = http://mirrors.kernel.org/archlinux/$repo/os/$arch
    Server = rsync://mirrors.cat.pdx.edu/archlinux/$repo/os/$arch
    Server = http://mirrors.rutgers.edu/archlinux/$repo/os/$arch
    Server = http://mirror.dal10.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = http://mirror.wdc1.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = https://mirror.wdc1.us.leaseweb.net/archlinux/$repo/os/$arch
    Server = http://mirrors.liquidweb.com/archlinux/$repo/os/$arch
    Server = https://dfw.mirror.rackspace.com/archlinux/$repo/os/$arch
    Server = http://mirror.math.princeton.edu/pub/archlinux/$repo/os/$arch
    Server = http://distro.ibiblio.org/archlinux/$repo/os/$arch
    Server = http://mirror.siena.edu/archlinux/$repo/os/$arch
    Server = rsync://mirror.siena.edu/archlinux/$repo/os/$arch
    Server = http://repo.ialab.dsu.edu/archlinux/$repo/os/$arch
    Server = https://mirror.arizona.edu/archlinux/$repo/os/$arch
    Server = https://zxcvfdsa.com/arch/$repo/os/$arch
    Server = http://mirror.ette.biz/archlinux/$repo/os/$arch
    Server = https://mirror.ette.biz/archlinux/$repo/os/$arch
    Server = rsync://mirror.ette.biz/archlinux/$repo/os/$arch
    Server = https://mirror.tmmworkshop.com/archlinux/$repo/os/$arch
    Server = https://mirrors.bloomu.edu/archlinux/$repo/os/$arch
    Server = http://nocix.mm.fcix.net/archlinux/$repo/os/$arch
    Server = https://nocix.mm.fcix.net/archlinux/$repo/os/$arch
    Server = rsync://nocix.mm.fcix.net/archlinux/$repo/os/$arch
    Server = http://mirrors.vectair.net/archlinux/$repo/os/$arch
    Server = https://mirrors.vectair.net/archlinux/$repo/os/$arch
    Server = https://arch.mirror.k0.ae/$repo/os/$arch
    Server = https://mirror.zackmyers.io/archlinux/$repo/os/$arch
    Server = http://mirror.fossable.org/archlinux/$repo/os/$arch
    Server = rsync://mirror.fossable.org/mirror/archlinux/$repo/os/$arch
    Server = http://wcbmedia.io:8000/$repo/os/$arch
    Server = rsync://wcbmedia.io/mirror/$repo/os/$arch
    Server = http://mirror.adectra.com/archlinux/$repo/os/$arch
    Server = https://mirror.adectra.com/archlinux/$repo/os/$arch
    Server = rsync://mirror.adectra.com/archlinux/$repo/os/$arch
    Server = https://mirror.colonelhosting.com/archlinux/$repo/os/$arch
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  networking = {
      firewall = {
          enable = true;
          allowPing = false;
          allowedUDPPorts = [ 80 443 4822 57621 ];
          allowedTCPPorts = [ 22 80 443 4822 5353 ];
      };
      extraHosts = ''
        # Suspicious TLDs
        0.0.0.0 (^|\.)(cn|ir|zip|mov)$

        # Workarounds for Verizon constantly changing my public IP address (will add more to this)
        97.144.212.182 realkstrawn93-miner.foo
      '';
      nftables.enable = true;
  };

  users = {
    # Personal user account
    users.realkstrawn93 = {
      isNormalUser = true;
      description = "Kenny Strawn";
      extraGroups = [ "networkmanager" "wheel" "incus-admin" ];
      createHome = true;
    };
  };

  # Need to do this to ensure that all desktop layout files are properly copied
  home-manager = {
    backupFileExtension = "old";
    users.realkstrawn93 = {
      services.home-manager.autoUpgrade.enable = config.system.autoUpgrade.enable;
      services.home-manager.autoUpgrade.frequency = config.system.autoUpgrade.dates;

      home = {
        # Not created by default; so need to force this
        file.".config/plasma-org.kde.plasma.desktop-appletsrc".text = config.environment.etc."skel/.config/plasma-org.kde.plasma.desktop-appletsrc".text;

        # Same here
        file.".config/plasmashellrc".text = config.environment.etc."skel/.config/plasmashellrc".text;

        file.".config/konsolerc".text = config.environment.etc."skel/.config/konsolerc".text;
        file.".local/share/konsole/80x24.profile".text = config.environment.etc."skel/.local/share/konsole/80x24.profile".text;
        file.".config/powermanagementprofilesrc".text = config.environment.etc."skel/.config/powermanagementprofilesrc".text;
        file.".config/kscreenlockerrc".text = config.environment.etc."skel/.config/kscreenlockerrc".text;
        file.".config/kwinoutputconfig.json".text = config.environment.etc."skel/.config/kwinoutputconfig.json".text;

        stateVersion = config.system.stateVersion;
      };
    };
  };

  system.stateVersion = "24.05";
}
