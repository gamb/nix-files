{ config, lib, pkgs, ... }:

let
  emacsPkg = config.programs.emacs.finalPackage;
  emacsclient-app = pkgs.callPackage ../packages/emacsclient-app.nix {
    emacs = emacsPkg;
    # icon = ../assets/emacsclient.icns; # uncomment to use a custom icon
  };
in
{
  home.file."Applications/Emacs Client.app".source = emacsclient-app;

  # Launch the daemon from inside Emacs.app rather than bin/emacs, so its
  # NSBundle resolves to the app and GUI frames get the real Emacs icon
  # instead of the generic one. Home Manager wraps these args in a
  # wait4path guard itself, so pass them plain like the upstream module.
  launchd.agents.emacs.config.ProgramArguments = lib.mkForce [
    "${emacsPkg}/Applications/Emacs.app/Contents/MacOS/Emacs"
    "--fg-daemon"
  ];

  programs.emacs = {
    enable = true;
    package = (pkgs.emacsPackagesFor pkgs.emacs-unstable).emacsWithPackages (
      epkgs: with epkgs; [
        (epkgs.trivialBuild {
          pname = "eglot-hierarchy";
          version = "unstable";
          src = pkgs.fetchFromGitHub {
            owner = "dolmens";
            repo = "eglot-hierarchy";
            rev = "main";
            sha256 = "sha256-Eh+gglFAv7WPVTi5UP6otlulxxkRWzEPkbPw7EJZ7l4=";
          };
          packageRequires = with epkgs; [ eglot ];
        })
        agent-shell
        browse-kill-ring
        cape
        clojure-mode
        consult
        corfu
        embark-consult
        envrc
        exec-path-from-shell
        flymake
        focus
        fullframe
        gptel
        hide-mode-line
        highlight-symbol
        ibuffer-project
        j-mode
        jarchive
        justl
        ledger-mode
        magit
        marginalia
        markdown-mode
        minions
        modus-themes
        move-dup
        nim-mode
        nix-ts-mode
        ns-auto-titlebar
        ocaml-ts-mode
        orderless
        org-roam
        paredit
        reformatter
        rg
        slime
        symbol-overlay
        tempel
        tuareg
        uiua-mode
        use-package
        vertico
        vterm
        which-key
        whole-line-or-region
        xref
        (treesit-grammars.with-grammars (
          treesit-pkgs: with treesit-pkgs; [
            tree-sitter-typescript
            tree-sitter-ocaml
            tree-sitter-ruby
            tree-sitter-nix
            tree-sitter-tsx
            tree-sitter-json
            tree-sitter-javascript
          ]
        ))
      ]
    );
    extraConfig = builtins.readFile ../config.el;
  };

  services.emacs = {
    enable = true;
    startWithUserSession = true;

    client = {
      enable = true;
    };
  };

}
