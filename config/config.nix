#  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
# ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
# ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
# ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
# ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
#  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
#           User configuration options

{ inputs, pkgs }: rec {
  ## Account information
  # Note: This can be overridden
  #   on a per-app basis inside
  #   config/programs/{program}

  # Used for user account, home directory
  name = "nouun";
  homeDir = "/home/${name}";
  # Generate with "nix-shell -p mkpasswd --run 'mkpasswd -m sha-512'"
  password =
    "$6$KaIMxFpIUCWjkkSF$y7G9/JdFgGAfTewFQdDX43cd2sr3IxO7Ze0rjx8InFFGO07YdXWVG9W6/jRh5s7Xx5rJoblJO3w5ic2ajRn4D/";

  # Used for Git
  email = "me@nouun.dev";

  firefox.enable = true;

  programs = {
    ## Configured Browsers
    # vieb
    # qutebrowser (TODO)
    #browser = pkgs.firefox;

    ## Configured Editors
    # neovim
    # kakoune (TODO)
    # emacs   (TODO)
    editor = {
      pkg = pkgs.neovim;
      # Override bin name because it's set
      # to "neovim" by default
      binName = "nvim";
    };

    ## Configured Terminals
    # kitty
    # wezterm
    # alacritty (TODO)
    # st        (TODO)
    terminal = pkgs.wezterm;

    # Configured Window Managers
    # X11
    #  i3-gaps    (TODO)
    #  bspwm      (TODO)
    #  herbstluft (TODO)
    # Wayland
    #  sway
    #  river   (TODO)
    windowManager = pkgs.awesome;

    ## Configured Launchers
    # X11
    #  rofi (TODO)
    # Wayland
    #  wofi (TODO)
    launcher = {
      pkg = pkgs.rofi;
      args = [ "--show" "run" ];
    };

    ## Configured Shells
    # Bash
    # Zsh     (TODO)
    # Elvish  (TODO)
    # Hilbish (TODO)
    shell = pkgs.bash;
  };

  # Only set this if using an X11 window manager
  xserver = {
    enable = true;

    defaultSession = "awesome";
  };

  unfreePredicate = [
    "postman"
    "displaylink"
  ];

  userPackages = with pkgs; [
    tridactyl-native

    shellcheck
    nixfmt
    codespell
    clojure-lsp
    rnix-lsp
    fnlfmt
  ] ++ (with nodePackages; [
    write-good
    fixjson
    markdownlint-cli
    eslint_d
    typescript-language-server
    bash-language-server
  ]);

  systemPackages = with pkgs; [
    postman
    sx
    #logo-ls

    apfs-fuse

    (discord-plugged.override {
      plugins = with inputs; [ who-reacted ];
      themes = with inputs; [ ];
    })

    # Screenshot
    imagemagick
    xclip
    slop
    (import ./pkgs/treeshot.nix { inherit pkgs; })
  ];
}
