# Tools for informtion gathering

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cloudbrute
    enumerepo
    holehe

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
    metabigor
    p0f
    sn0int
    socialscan
    theharvester
    urlhunter
  ];
}
