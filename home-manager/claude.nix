{ lib, mattpocock-skills, ... }:

{
  # The instructions are inlined rather than kept in a repo-root CLAUDE.md, so
  # Claude Code does not also read them as project instructions for this repo.
  home.file = {
    "CLAUDE.md".text = ''
      Write all responses in ASD-STE100 Simplified Technical English.
    '';
  }
  // lib.listToAttrs (
    map (p: {
      name = ".claude/skills/${baseNameOf p}";
      value.source = "${mattpocock-skills}/${lib.removePrefix "./" p}";
    }) (builtins.fromJSON (builtins.readFile "${mattpocock-skills}/.claude-plugin/plugin.json")).skills
  );
}
