{
  description = "Home Manager configuration of adamgamble";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    llm-agents.url = "github:numtide/llm-agents.nix";
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, emacs-overlay, llm-agents, mattpocock-skills, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          emacs-overlay.overlays.default
          # Use llm-agents' prebuilt packages (built against its own newer
          # nixpkgs) rather than shared-nixpkgs, which rebuilds the npm
          # packages against our nixpkgs and fails the npmDepsHash check on our
          # pinned nixpkgs. See https://github.com/numtide/llm-agents.nix/issues/4320.
          (_final: _prev: { llm-agents = llm-agents.packages.${system}; })
        ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.just
          home-manager.packages.${system}.home-manager
        ];
      };

      homeConfigurations."macbook" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home-manager/macbook.nix ];

        extraSpecialArgs = { inherit mattpocock-skills; };
      };
    };
}
