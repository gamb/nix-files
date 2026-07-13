{ configs, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (
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
