final: prev: {
  synthv-env = prev.callPackage ./synthv-env { };
  synthv-bootstrap = prev.callPackage ./synthv-bootstrap { };
  synthv-launcher = prev.callPackage ./synthv-launcher { };
}
