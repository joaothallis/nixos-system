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

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    initLua = ''
                      vim.opt.number = true

                      vim.opt.clipboard = "unnamedplus"

                      vim.opt.numberwidth = 1

      	        vim.keymap.set('n', '<leader>yp', function()
              	  local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
              	  local full = vim.fn.expand('%:p')
              	  local relative = full:sub(#root + 2)  -- +2 to remove the trailing slash
              	  vim.fn.setreg('+', relative)
              	  print("Yanked: " .. relative)
              	end, { desc = "Yank file path relative to project root" })
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
                                  			vim.lsp.enable('nixd')

          						vim.lsp.config('expert', {
          						  cmd = { '/home/joao/.local/bin/expert', '--stdio' },
          						  root_markers = { 'mix.exs', '.git' },
          						  filetypes = { 'elixir', 'eelixir', 'heex' },
          						})

          						vim.lsp.enable 'expert'

                      				vim.lsp.enable('copilot')
                                  			
                                  			vim.diagnostic.config({
                                  			  virtual_text = true,
                                  			})
                                  			
                                  			vim.api.nvim_create_autocmd('LspAttach', {
                                  			  desc = 'Enable inlay hints',
                                  			  callback = function(event)
                                  			    local id = vim.tbl_get(event, 'data', 'client_id')
                                  			    local client = id and vim.lsp.get_client_by_id(id)
                                  			    if client == nil or not client.supports_method('textDocument/inlayHint') then
                                  			      return
                                  			    end

                                  			    vim.lsp.inlay_hint.enable(true, {bufnr = event.buf})
                                  			  end,
                                  			})
        '';
      }
      {
        plugin = lsp-format-nvim;
        type = "lua";
        config = ''
          	require("lsp-format").setup {}

          	vim.api.nvim_create_autocmd('LspAttach', {
          	  callback = function(args)
          	    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          	    -- Skip formatting for ts_ls (use efm with prettierd instead)
          	    if client.name ~= 'ts_ls' then
          	      require("lsp-format").on_attach(client, args.buf)
          	    end
          	  end,
          	})
        '';
      }
      vim-illuminate
      {
        plugin = blink-cmp;
        type = "lua";
        config = ''
                      local blink = require("blink.cmp")
                      blink.setup({
          	       sources = {
          		      default = { "lsp", "path", "snippets", "buffer", "copilot" },
          		      providers = {
          			copilot = {
          			  name = "copilot",
          			  module = "blink-copilot",
          			  async = true,
          			},
          		      },
          		    },
          	    })
        '';
      }
      blink-copilot
      {
        plugin = fidget-nvim;
        type = "lua";
        config = ''
          require("fidget").setup { }
                      	      '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
      }
      vim-elixir
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = 'Telescope find files' })
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
                                  	  '';
      }
      {
        plugin = vim-test;
        config = ''
          nmap <silent> <leader>t :TestNearest<CR>
          nmap <silent> <leader>T :TestFile<CR>
          nmap <silent> <leader>a :TestSuite<CR>
          nmap <silent> <leader>l :TestLast<CR>
          nmap <silent> <leader>g :TestVisit<CR>
          	  '';
      }
      vim-fugitive
      {
        plugin = gitlinker-nvim;
        type = "lua";
        config = "require'gitlinker'.setup()";
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          	  require('gitsigns').setup{
          	    on_attach = function(bufnr)
              local gitsigns = require('gitsigns')

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- Navigation
              map('n', ']c', function()
                if vim.wo.diff then
                  vim.cmd.normal({']c', bang = true})
                else
                  gitsigns.nav_hunk('next')
                end
              end)

              map('n', '[c', function()
                if vim.wo.diff then
                  vim.cmd.normal({'[c', bang = true})
                else
                  gitsigns.nav_hunk('prev')
                end
              end)
            end
          	  }
          	  '';
      }

      file-line
    ];

  };

  programs.kitty.enable = true;

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
