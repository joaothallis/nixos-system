{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "joao";
  home.homeDirectory = "/home/joao";

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
  programs.bash.enable = true;
  programs.bash.shellAliases = {
    gs = "git status";
    gd = "git diff";
    gl = "git pull --prune";
    gp = "git push";
    glog = "git log --oneline";
    gc = "git commit --patch";
    gca = "git commit --patch --amend";
  };

  programs.chromium.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

