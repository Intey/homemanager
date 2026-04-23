{
  description = "Home Manager configuration of intey";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    github-packages.url = "path:./github-packages";

  };

  outputs = { nixpkgs, home-manager, github-packages, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ github-packages.overlays.default ];
      };
    in
    {
      homeConfigurations."intey" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home.nix ];

      };
    };
}
