{ pkgs, conf, lib }:
with conf.config.neovim;
{
  tridactylrc = {
    target = "tridactyl/tridactylrc";
    text = ''
sanitize tridactyllocal tridactylsync

unbind <C-f>

bind / fillcmdline find
bind ? fillcmdline find -?
bind n findnext 1
bind N findnext -1
bind ,<Space> nohlsearch

set findcase smart

autocmd DocStart ^http(s?)://www.reddit.com js tri.excmds.urlmodify("-t", "www", "old")

" Orange site / Reddit / Lobste.rs specific hints to toggle comments
bind ;c hint -Jc [class*="expand"],[class="togg"],[class="comment_folder"]

set yankto both

blacklistadd netflix.com
    '';
  };
}
