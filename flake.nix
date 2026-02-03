{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
  };
  outputs =
    inputs@{ self, nixpkgs, codex-cli-nix, ... }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          {
            nix = {
              settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
            };
          }
        ];
      };
    };
}
