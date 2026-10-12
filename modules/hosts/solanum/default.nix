{ self, inputs, ... }: {

  flake.nixosConfigurations.solanum = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      self.nixosModules.solanum
    ];
  };

}
