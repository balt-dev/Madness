MADNESS.load_module "config"
MADNESS.load_module "menu"
MADNESS.load_module "overscoring"

if JokerDisplay then
    NFS.write(JokerDisplay.path .. '.lovelyignore', '')
    error("This mod doesn't work with JokerDisplay yet.\nJokerDisplay has been disabled, restart the game.")    
end
