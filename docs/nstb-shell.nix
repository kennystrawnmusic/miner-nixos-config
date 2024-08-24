{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
 nativeBuildInputs = [
    abootimg
    acltoolkit
    acquire
    adenum
    adidnsdump
    adreaper
    afflib
    afl
    aflplusplus
    aiodnsbrute
    aircrack-ng
    airgeddon
    ali
    amass
    amoco
    androguard
    anevicon
    apachetomcatscanner
    apkeep
    apkleaks
    apktool
    ares-rs
    arjun
    arp-scan
    arping
    arpoison
    atftp
    authoscope
    autobloody
    baboossh
    badchars
    bandwhich
    bettercap
    bind
    bingrep
    bloodhound-py
    bluewalker
    bluez
    bngblaster
    bomber-go
    boofuzz
    bore-cli
    braa
    brakeman
    breads-ad
    bruteforce-luks
    brutespray
    btop
    bully
    burpsuite
    cabextract
    cameradar
    cansina
    cantoolz
    cardpeek
    cargo-audit
    cariddi
    cassowary
    cdk-go
    cdncheck
    cero
    certi
    certipy
    certsync
    cfripper
    chain-bench
    chainsaw
    changetower
    checkip
    checkov
    checksec
    chipsec
    chisel
    chkrootkit
    chopchop
    chrony
    cifs-utils
    cirrusgo
    clair
    clairvoyance
    clamav
    cliam
    cloud-nuke
    cloudbrute
    cloudfox
    cloudlist
    cmospwd
    coercer
    commix
    conpass
    corkscrew
    cowpatty
    crackmapexec
    crackql
    credential-detector
    creds
    crlfsuite
    crunch
    curl
    cutecom
    cutter
    cyberchef
    dalfox
    das
    davtest
    dbmonster
    dcfldd
    ddosify
    ddrescue
    deepsecrets
    detect-secrets
    dex2jar
    dhcpdump
    dirstalk
    dislocker
    dismap
    dismember
    dive
    dnsenum
    dnsmon-go
    dnsmonster
    dnspeep
    dnsrecon
    dnstake
    dnstop
    dnstracer
    dnstwist
    dnsx
    dockle
    donpapi
    dontgo403
    doona
    dorkscout
    driftnet
    drill
    dsniff
    easyeasm
    ec2stepshell
    enum4linux
    enum4linux-ng
    enumerepo
    erosmb
    esptool
    eternal-terminal
    ettercap
    evil-winrm
    evillimiter
    exiflooter
    exiv2
    exploitdb
    ext4magic
    extrude
    extundelete
    feroxbuster
    ffuf
    fierce
    findomain
    flare-floss
    flashrom
    forbidden
    foremost
    fping
    freerdp
    freeze
    fwanalyzer
    galer
    galleta
    gallia
    garble
    gato
    gau
    gcp-scanner
    gdb
    gef
    genymotion
    ggshield
    ghauri
    ghidra-bin
    ghost
    ghunt
    girsh
    git-secret
    gitjacker
    gitleaks
    gitls
    go-exploitdb
    go365
    goblob
    gobuster
    gokart
    gomapenum
    goreplay
    gospider
    gotestwaf
    gowitness
    gping
    graphqlmaker
    graphqlmap
    graphw00f
    grype
    gtfocli
    gzrt
    h8mail
    hachoir
    hakrawler
    hans
    hashcat
    hashcat-utils
    hashdeep
    hekatomb
    hey
    hivex
    holehe
    honeytrap
    honggfuzz
    horst
    hping
    hstsparser
    httpie
    httptunnel
    httpx
    hurl
    iftop
    ike-scan
    imdshift
    inetutils
    inxi
    ioc-scan
    ioccheck
    iodine
    iotop
    ipcalc
    iperf2
    iproute
    iproute2
    ipscan
    iputils
    iw
    jaeles
    john
    joincap
    jsubfinder
    junkie
    jwt-cli
    jwt-hack
    katana
    kdigger
    keedump
    keepwn
    kepler
    kerbrute
    killerbee
    kismet
    kiterunner
    knockpy
    knowsmore
    kube-score
    kubeaudit
    kubescape
    kubestroyer
    laudanum
    ldapdomaindump
    ldapmonitor
    ldapnomnom
    ldeep
    legba
    legitify
    lftp
    libfreefare
    lil-pwny
    linux-exploit-suggester
    lmp
    log4j-detect
    log4j-scan
    log4j-sniffer
    log4j-vuln-scanner
    log4jcheck
    logmap
    lynis
    lynx
    macchanger

    # Must use Python 3.11 for this to build properly
    (maigret.overrideAttrs(_: rec {
       propagatedBuildInputs = with python311Packages; [
        aiodns
        aiohttp
        aiohttp-socks
        arabic-reshaper
        async-timeout
        attrs
        beautifulsoup4
        certifi
        chardet
        cloudscraper
        colorama
        future
        html5lib
        idna
        jinja2
        lxml
        markupsafe
        mock
        multidict
        networkx
        pycountry
        pypdf2
        pysocks
        python-bidi
        pyvis
        requests
        requests-futures
        six
        socid-extractor
        soupsieve
        stem
        torrequest
        tqdm
        typing-extensions
        webencodings
        xhtml2pdf
        xmind
        yarl
      ];
    }))
    mantra
    masscan
    massdns
    medusa
    metabigor
    metasploit
    mfcuk
    mfoc
    minicom
    mitm6
    mitmproxy
    mitmproxy2swagger
    mongoaudit
    monsoon
    mosh
    msldapdump
    mtr
    mubeng
    mx-takeover
    naabu
    nano
    nasty
    nbtscan
    nbtscanner
    nbutools
    ncftp
    ncrack
    net-snmp
    netcat-gnu
    netdiscover
    netexec
    netmask
    netscanner
    netsniff-ng
    nfs-utils
    ngrep
    nikto
    nload
    nmap
    nmap-formatter
    nodePackages.hyperpotamus
    nomore403
    noseyparker
    nosqli
    nrfutil
    ntfs3g
    ntfsprogs
    nth
    ntlmrecon
    ntp
    nuclei
    nuttcp
    nwipe
    offat
    offensive-azure
    oha
    onesixtyone
    openrisk
    openssh
    openvpn
    oshka
    ostinato
    osv-detector
    osv-scanner
    p0f
    p7zip
    packj
    pacu
    padre
    parted
    payload-dumper-go
    pev
    photon
    phrasendrescher
    picocom
    pingu
    pip-audit
    pixiewps
    pktgen
    plecost
    popeye
    poutine
    pre2k
    prowler
    proxify
    proxychains
    putty
    pwgen
    pwnat
    pwndbg
    pwntools
    pysqlrecon
    python310Packages.safety
    python311Packages.angr
    python311Packages.angrop
    python311Packages.binwalk
    python311Packages.bleak
    python311Packages.can
    python311Packages.emv
    python311Packages.karton-core
    python311Packages.lsassy
    python311Packages.malduck
    python311Packages.patator
    python311Packages.pyi2cflash
    python311Packages.pypykatz
    python311Packages.pyspiflash
    python311Packages.pytenable
    python311Packages.r2pipe
    python311Packages.scapy
    python311Packages.unicorn
    python311Packages.hakuin
    radamsa
    radare2
    radare2-cutter
    rdwatool
    reaverwps
    recoverjpeg
    redfang
    redsocks
    regexploit
    responder
    rizin
    ronin
    route-graph
    routersploit
    rshijack
    ruler
    rustcat
    rustscan
    safecopy
    safety-cli
    samba
    samba
    scout
    scraper
    scrcpy
    secrets-extractor
    secretscanner
    shellz
    siege
    silenthound
    simg2img
    sipp
    sipsak
    sipvicious
    sish
    skjold
    sleuthkit
    slowlorust
    smbmap
    smbscan
    sn0int
    snallygaster
    sngrep
    sniffglue
    snmpcheck
    snscrape
    socat
    socialscan
    sploitscan
    spyre
    sqlmap
    sr2t
    srm
    ssdeep
    ssh-audit
    ssh-mitm
    sshchecker
    sshping
    ssldump
    sslh
    sslscan
    sslsplit
    sslstrip
    stacs
    stegseek
    step-cli
    sttr
    stunnel
    subfinder
    subjs
    subprober
    subzerod
    swaggerhole
    swaks
    sx-go
    tcpdump
    tcpflow
    tcpreplay
    teensy-loader-cli
    teler
    tell-me-your-secrets
    termshark
    terrascan
    testdisk
    testssl
    tfsec
    thc-hydra
    theharvester
    #tightvnc
    tlsx
    tmux
    tracee
    traitor
    trivy
    troubadix
    truecrack
    trueseeing
    trufflehog
    trustymail
    tsung
    tunnelgraf
    tytools
    ubertooth
    uddup
    udptunnel
    udpx
    uncover
    unicorn
    unicorn-emu
    unrar
    unzip
    urlhunter
    utillinux
    vegeta
    volatility
    volatility3
    vulnix
    wad
    waf-tester
    wafw00f
    wavemon
    wbox
    webanalyze
    websecprobe
    wfuzz
    wget
    whatweb
    whispers
    whois
    wifite2
    wipe
    wireguard-go
    wireguard-tools
    wireshark
    wireshark-cli
    witness
    wprecon
    wpscan
    wsrepl
    wstunnel
    wtfis
    wuzz
    x3270
    xcrawl3r
    xeol
    xh
    xnlinkfinder
    xorex
    xortool
    xrdp
    xsubfind3r
    yara
    yatas
    yersinia
    zap
    zeek
    zellij
    zigpy-cli
    zkar
    zmap
    zydis
    zzuf
  ];
}
