{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
          lua << EOF
            ${builtins.readFile ../../customisation/nvim/init.lua}
            ${builtins.readFile ../../customisation/nvim/lua/config/lazy.lua}
            ${builtins.readFile ../../customisation/nvim/lua/config/keymaps.lua}
            ${builtins.readFile ../../customisation/nvim/lua/config/autocmds.lua}
	    ${builtins.readFile ../../customisation/nvim/lua/config/options.lua}
          EOF
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ 
	  LazyVim	  	  
	];
      };
    };
  };
}
