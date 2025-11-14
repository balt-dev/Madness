MADNESS = SMODS.current_mod
assert(SMODS.current_mod.lovely, "Lovely patches were not loaded! Make sure your mod is in the right place.")

MADNESS.mod_path = SMODS.current_mod.path .. ""

local function load_file(path, ...)
	local f, err = SMODS.load_file(path)
	if err then error(err) end
	return f(...)
end

function MADNESS.load_module(mod)
	local f, err, path_prefix
	if MADNESS.current_module == nil then
		path_prefix = ""
	else
		path_prefix = MADNESS.current_module .. "/"
	end
	if NFS.getInfo(MADNESS.mod_path .. "/" .. path_prefix .. mod .. "/mod.lua") ~= nil then
		print("[MADNESS] Loading module " .. path_prefix .. mod .. "/mod.lua...")
		f, err = SMODS.load_file(path_prefix .. mod .. "/mod.lua")
	else
		print("[MADNESS] Loading module " .. path_prefix .. mod .. ".lua...")
		f, err = SMODS.load_file(path_prefix .. mod .. ".lua")
	end
	if err then error(err) end
	local old_mod = MADNESS.current_module
	MADNESS.current_module = path_prefix .. mod
	local res = f()
	MADNESS.current_module = old_mod
	print("[] Loaded module " .. path_prefix .. mod)
	return res
end

MADNESS.current_module = nil

MADNESS.load_module "src"
