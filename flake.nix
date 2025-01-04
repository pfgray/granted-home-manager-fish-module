{
  inputs = { };

  outputs = { self }: {
    homeManagerModules.default = import ./module.nix;
  };
}
