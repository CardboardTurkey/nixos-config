{ osConfig, ... }:
{
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        # features = "side-by-side line-numbers decorations zebra-dark";
        whitespace-error-style = "22 reverse";
        navigate = true;
        conflictstyle = "diff3";
        colorMoved = "default";
        side-by-side = true;
        hyperlinks = true;
      };
    };
    git = {
      enable = true;
      settings = {
        core.editor = "hx";
        pull.rebase = "true";
        alias = {
          co = "checkout";
          sw = "switch";
          ci = "commit";
          st = "status";
          br = "branch";
          hist = "log --graph --abbrev-commit --oneline";
          type = "cat-file -t";
          dump = "cat-file -p";
          last = "log -1";
        };
        global.basedir = "/home/kiran/git/";
        format.signOff = true;
        user = {
          email = "kiran@ostrolenk.co.uk";
          name = "Kiran Ostrolenk";
        };
      };
      lfs.enable = true;
      ignores = [
        "target"
        ".direnv"
        ".vscode"
      ];
      signing.key = "${osConfig.pgp_sign}";
      includes = [
        {
          contents.user.email = "kiran@ostrolenk.co.uk";
          condition = "gitdir:~/git/**";
        }
        {
          contents.user.email = "kiran.ostrolenk@codethink.co.uk";
          condition = "gitdir:~/git/CodethinkLabs/**";
        }
        {
          contents.user.email = "kiran@ostrolenk.co.uk";
          condition = "gitdir:~/github/**";
        }
      ];
    };
  };
}
