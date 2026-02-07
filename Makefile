.PHONY: all

all: home.nix flake.nix
	home-manager switch
