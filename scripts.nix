{ pkgs, config, ... }: {

  home.file.".local/bin" = {
    source = ./scripts;
    # ./nvim-switch-config.sh;
    recursive = true;
    executable = true;
  };
}
