{ pkgs, ... }: {
  home = {
    # obsidian related. TODO: make module?
    file = {
      ".local/lib/plantuml.jar".source =
        "${pkgs.plantuml.out}/lib/plantuml.jar";
    };
    packages = (with pkgs; [ obsidian openjdk graphviz ]);
  };
}
