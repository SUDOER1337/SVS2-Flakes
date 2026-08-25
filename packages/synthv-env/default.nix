{
  lib,
  symlinkJoin,
  wineWow64Packages,
  winetricks,
}:
# === Packages ===
#   synthv-env  - Combined Wine + Winetricks environment for SynthV

symlinkJoin {
  name = "synthv-env-${wineWow64Packages.stable.version}";
  paths = [
    wineWow64Packages.stable
    winetricks
  ];

  meta = {
    description = "Wine + Winetricks environment for Synthesizer V Studio 2";
    homepage = "https://github.com/SUDOER1337/SVS2-Flakes";
    license = lib.licenses.lgpl21Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
