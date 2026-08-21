{ pkgs, ... }:

{
  imports = [
    ./claude.nix
    ./emacs.nix
    ./fonts.nix
  ];

  home.username = "adamgamble";
  home.homeDirectory = "/Users/adamgamble";

  home.stateVersion = "25.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

  home.packages = [
    (pkgs.aspellWithDicts (dicts: with dicts; [ en ]))
    pkgs.bun
    pkgs.llm-agents.claude-agent-acp
    pkgs.llm-agents.codex-acp
    pkgs.coreutils-prefixed
    pkgs.entr
    pkgs.fd
    pkgs.fish
    pkgs.git-absorb
    pkgs.jq
    pkgs.just
    pkgs.ledger
    pkgs.nixfmt-rfc-style
    pkgs.nodePackages.prettier
    pkgs.ripgrep
    pkgs.sqlite
    pkgs.texlive.combined.scheme-basic
    pkgs.tree
    pkgs.uiua
    pkgs.unzip
  ];

  programs.fish = {
    enable = true;
  };

  programs.git = {
    enable = true;
    ignores = [ ".direnv/" ];
    settings = {
      user = {
        name = "Adam Gamble";
        email = "adam.gamble@hey.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "emacsclient";
  };
}
