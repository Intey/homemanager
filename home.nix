{ config
, pkgs
, inputs
, ...
}@ins:
{
  targets.genericLinux.enable = true;
  imports = [
    # inputs.LazyVim.homeManagerModules.default
    #./nvim
    ./obsidian.nix
    ./scripts.nix
  ];

  home = {
    language.base = "en_US.UTF8";
    username = "intey";
    homeDirectory = "/home/intey";
    stateVersion = "25.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/projects/work/.local/bin"
    ];
    packages = (
      with pkgs;
      [
        #python314
        #aider-chat
        #silver-searcher
        #gnumake
        #clang
        # no visible table
        #(config.lib.nixGL.wrap prusa-slicer)
        #(config.lib.nixGL.wrap blender)
        #(config.lib.nixGL.wrapOffload pkgs.freecad)
        #cookiecutter
        plantuml
        inotify-tools
        nickel
        #asciinema
        #agg # not found binary.
        #picat
        #gleam
        # (pkgs.python314.withPackages (ppkgs: [
        #   ppkgs.ipython

        # ]))
      ]
    );
    shellAliases = { };
  };

  programs = {
    home-manager.enable = true;
    autojump.enable = true;
    autojump.enableZshIntegration = true;
    jq.enable = true;
    uv.enable = true;
    fzf.enable = true;
    lazygit.enable = true;
    #alacritty.enable = true;
    git = {
      enable = true;
      aliases = {
        s = "status";
        d = "diff";
        dc = "diff --cached";
        ls = "log --oneline --decorate --graph";
        u = "add -u";
        cm = "commit -m";
        poh = "push origin HEAD";
        last = "commit --amend --no-edit";
        retry = "git last && git poh -f";
        c = "checkout";
        sw = "switch";
        shift = "!git stash --keep-index && git stash && git switch $1 && git commit && git";
      };
    };
    # aider.enable = true;
    # run github actions locally
    #act.enable = true;
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "blinks";
        plugins = [
          "git"
          "sudo"
          "git-extras"
          "gitfast"
          "autojump"
          "command-not-found"
          "direnv"
          #"nix-shell"
        ];
      };
      initContent = ''
        [[ -s "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        [[ -s ~/.config/aliases.sh ]] && source ~/.config/aliases.sh
        function kbpinky() {
            source ~/.keyboard.pinky
        }
        [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
        export HYGEN_TMPLS=~/.hygen.tmpl
        export SSH_AUTH_SOCK=/run/user/1000/ssh-agent.socket
        qse() {
            RG_PREFIX="rg --files-with-matches"
            local file
            file="$(        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
                fzf \
                --preview="[[ ! -z {} ]] && rg --pretty --context 5 {q} {}" \
                --disabled --query "$1" \
                --bind "change:reload:sleep 0.1; $RG_PREFIX {q}" \
                --bind "f3:execute(bat --paging=always --pager=less --color=always {} < /dev/tty > /dev/tty)" \
                --bind "f4:execute(v {})" \
                --preview-window="70%:wrap"     )" &&       echo "$file"
            }

        gswt() {
          cd $(git worktree list | cut -d' ' -f 1 | fzf)
          }
        git_user_intey() {
            git config user.email "ziexe0@gmail.com"
            git config user.name "intey"
        }

        git_user_sber() {
            git config user.email "drchurin@sberbank.ru"
            git config user.name "DRChurin"
        }
        run_on() {
            file=$1
            shift
            event=$1
            shift
            while ! inotifywait -q -e $event $file; do $@; done
        }

        mcd() {
            mkdir -p $1
            cd $1
        }

        export EDITOR=nvim
        source ~/.ghcup/env
        eval $(nickel gen-completions zsh)

      '';
      #eval "$(/usr/bin/mise activate zsh)"
    };
  };

  #fonts.fontConfig.defaultFonts = {
  #  monospace = { };
  #};

  xsession.windowManager.awesome.enable = true;
  # have issue with fonts - show rects with numbers
  # services.dropbox.enable = true;
  # nix.settings = {
  #   extra-experimental-features = [ "nix-command" "flakes" ];
  # };
  nixpkgs.config = {
    allowUnfree = true;
  };

  # programs.lazyvim = {
  #   enable = true;
  # };
  programs.starship = {
    enable = true;
    settings = {
      gcloud = {
        disabled = true;
      };
      add_newline = false;
      # format = ins.lib.concatStrings [
      #   "$line_break"
      #   "$package"
      #   "$line_break"
      #   "$character"
      # ];
      git_metrics.disabled = false;
      format = ins.lib.concatStrings [
        "[┏](bold green)$nix_shell$cpp$haskell$python"
        "$line_break"
        "[┃](bold green)$directory$package"
        "$line_break"
        "[┃](bold green)\\[$git_branch($git_state)\\]$git_status$git_metrics"
        "$line_break"
        "[┗》](bold green)"
      ];
      scan_timeout = 10;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };
  home.shell.enableZshIntegration = true;
  # programs.fish.enable = true;
  # home.shell.enableFishIntegration = true;

}
