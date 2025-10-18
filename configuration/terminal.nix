# 💫 https://github.com/JaKooLit 💫 #
# Users - NOTE: Packages defined on this will be on current user only

{
  pkgs,
  ...
}:
{

  users.defaultUserShell = pkgs.zsh;

  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [
    lsd
    fzf
  ];

  programs.zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "agnoster";
      };

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      promptInit = ''
        	krabby random > /tmp/pkm_random.txt
                fastfetch -c $HOME/.config/fastfetch/config-v3.jsonc

                #pokemon colorscripts like. Make sure to install krabby package
                # krabby random --no-title -s; 

                # Set-up icons for files/directories in terminal using lsd
                alias ls='lsd'
                alias l='ls -l'
                alias la='ls -a'
                alias lla='ls -la'
                alias lt='ls --tree'

                source <(fzf --zsh);
                HISTFILE=~/.zsh_history;
                HISTSIZE=10000;
                SAVEHIST=10000;
                setopt appendhistory;
      '';
    };
  }
