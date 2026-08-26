final: prev: {
  synthv-env = prev.callPackage ./synthv-env { };
  synthv-bootstrap = prev.callPackage ./synthv-bootstrap { };
  synthv-deps = prev.callPackage ./synthv-deps { };
  synthv-launcher = prev.callPackage ./synthv-launcher { };
}
