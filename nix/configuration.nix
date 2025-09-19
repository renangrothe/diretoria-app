{ config, pkgs, ... }:

let
  source = import ./source-derivation.nix { inherit pkgs; }; # lamp configuration
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Whether to mount a tmpfs on /tmp during boot.
  boot.tmp.useTmpfs = true;

  networking.hostName = "servidorDiretoria"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  users.users.rego = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "rego";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  users.users.gru = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "gru";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  users.users.bibi = {
    isNormalUser = true;
    description = "bibi";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  environment.variables.EDITOR = "nvim";
  environment.variables.PATH = "${pkgs.clang-tools}/bin:$PATH";


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  security.sudo.enable = true;

  # Permitir (mais ou menos) a execução de binátios genéricos
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  git
  neovim
  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";

  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    randomizedDelaySec = "45min";
  };

  # LAMP CONFIG
  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = [ 80 443 ];
  };
  
  services.httpd = {
    enable = true;
    adminAddr = "felipetzne12@gmail.com";
    enablePHP = true;
    virtualHosts."example.org" = {
      documentRoot = source.source-code;
      # want ssl + a let's encrypt certificate? add `forceSSL = true;` right here
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialDatabases = [
      { name = "tabela";
        schema = pkgs.writeText "init.sql" ''
          CREATE TABLE entries (text TEXT);
        '';
      }
    ];
    ensureUsers = [
      { name = "rego";
        ensurePermissions = {
          "rego.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # hacky way to create our directory structure and index page
  systemd.tmpfiles.rules = [
    "d /var/www/mysite.com"
    "f /var/www/mysite.com/index.php - - - - <?php phpinfo();"
  ];

}

