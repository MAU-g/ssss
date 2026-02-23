-- Load UI Library Safely
local function getLibrary(url)
    local success, response = pcall(game.HttpGet, game, url)
    if not success then return warn("Failed to HttpGet:", response) end
    
    local func, loadErr = loadstring(response)
    if not func then return warn("Failed to Loadstring:", loadErr) end
    
    local execSuccess, result = pcall(func)
    if not execSuccess then return warn("Failed to Execute:", result) end
    
    return result
end

local library = getLibrary('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua')
if type(library) == "string" and library:match("404") then
    -- Fallback/Właściwy fork jeśli oryginalny repozytorium padło (a wally usunął swoje z githuba)
    library = getLibrary('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua')
    themeManager = getLibrary('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua')
    saveManager = getLibrary('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua')
else
    themeManager = getLibrary('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/ThemeManager.lua')
    saveManager = getLibrary('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/SaveManager.lua')
end

if not library then
    return warn("Executor Error: UI Library could not be loaded. Please ensure your executor fully supports HttpGet and Loadstring.")
end

local window = library:CreateWindow({
    Title = 'Unnamed Enhancements - discord.gg/enhancements',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local tabs = {
    Main = window:AddTab('main'),
    World = window:AddTab('world'),
    ESP = window:AddTab('esp'),
    Visuals = window:AddTab('visuals'),
    Character = window:AddTab('character'),
    Misc = window:AddTab('misc'),
    Settings = window:AddTab('settings')
}

-- ==========================================
-- MAIN TAB
-- ==========================================
local aimbotTabBox = tabs.Main:AddLeftTabbox()
local saTab = aimbotTabBox:AddTab('silent aim')
local aimTab = aimbotTabBox:AddTab('aimbot')

-- silent aim
saTab:AddToggle('sa_enabled', { Text = 'enabled' })
saTab:AddToggle('sa_manipulation', { Text = 'manipulation' })
saTab:AddToggle('sa_closest_part', { Text = 'closest part' })
saTab:AddToggle('sa_visualize', { Text = 'visualize' })
saTab:AddSlider('sa_radius', { Text = 'radius', Default = 100, Min = 0, Max = 500, Rounding = 0, Suffix = 'px' })
saTab:AddSlider('sa_hitchance', { Text = 'hit chance', Default = 100, Min = 0, Max = 100, Rounding = 0, Suffix = '%' })
Toggles.sa_enabled:AddKeyPicker('sa_key', { Default = 'None', SyncToggleState = true, Mode = 'Toggle', Text = 'silent aim' })

-- aimbot
aimTab:AddToggle('ab_enabled', { Text = 'enabled' })
aimTab:AddToggle('ab_closest_part', { Text = 'closest part' })
aimTab:AddToggle('ab_closest_position', { Text = 'closest position' })
aimTab:AddToggle('ab_delay_position', { Text = 'delay position' })
aimTab:AddSlider('ab_radius', { Text = 'radius', Default = 100, Min = 0, Max = 800, Rounding = 0, Suffix = 'px' })
aimTab:AddSlider('ab_smoothing', { Text = 'smoothing', Default = 100, Min = 0, Max = 100, Rounding = 0, Suffix = '%' })
Toggles.ab_enabled:AddKeyPicker('ab_key', { Default = 'None', SyncToggleState = true, Mode = 'Toggle', Text = 'aimbot' })


local targetingBox = tabs.Main:AddLeftGroupbox('targeting')
targetingBox:AddToggle('trg_vis', { Text = 'visible only' })
targetingBox:AddToggle('trg_ignore', { Text = 'ignore protected' })
targetingBox:AddToggle('trg_flash', { Text = 'disable on flash' })
targetingBox:AddToggle('trg_limit', { Text = 'limit distance' })
targetingBox:AddSlider('trg_react', { Text = 'reaction time', Default = 0, Min = 0, Max = 1000, Rounding = 0, Suffix = 'ms' })
targetingBox:AddSlider('trg_forget', { Text = 'forget time', Default = 1, Min = 0, Max = 5, Rounding = 1, Suffix = 's' })
targetingBox:AddDropdown('trg_part', { Values = { 'Head', 'Torso', 'Random' }, Default = 1, Multi = false, Text = 'target part' })
targetingBox:AddDropdown('trg_blacklist', { Values = { 'LeftHand', 'RightHand', 'LeftLowerArm', 'RightLowerArm', 'LeftLeg', 'RightLeg' }, Default = 1, Multi = true, Text = 'closest part blacklist' })

local triggerbotBox = tabs.Main:AddRightGroupbox('triggerbot')
triggerbotBox:AddToggle('tb_enabled', { Text = 'enabled' })
triggerbotBox:AddSlider('tb_react', { Text = 'reaction time', Default = 100, Min = 0, Max = 500, Rounding = 0, Suffix = 'ms' })
triggerbotBox:AddSlider('tb_react_offset', { Text = 'reaction time offset', Default = 0, Min = 0, Max = 500, Rounding = 0, Suffix = 'ms' })
triggerbotBox:AddSlider('tb_forget', { Text = 'forget time', Default = 0.5, Min = 0, Max = 5, Rounding = 1, Suffix = 's' })
triggerbotBox:AddSlider('tb_shoot', { Text = 'shoot delay', Default = 0, Min = 0, Max = 1000, Rounding = 0, Suffix = 'ms' })
triggerbotBox:AddSlider('tb_maxdist', { Text = 'max distance', Default = 100, Min = 0, Max = 2000, Rounding = 0, Suffix = 's' })
triggerbotBox:AddDropdown('tb_part_blacklist', { Values = { 'None' }, Default = 1, Multi = true, Text = 'part blacklist' })
triggerbotBox:AddDropdown('tb_settings', { Values = { 'anti katana' }, Default = 1, Multi = false, Text = 'settings' })
Toggles.tb_enabled:AddKeyPicker('tb_key', { Default = 'None', SyncToggleState = true, Mode = 'Toggle', Text = 'triggerbot' })

local weaponsBox = tabs.Main:AddRightGroupbox('weapons')
weaponsBox:AddToggle('wep_nospread', { Text = 'no spread' })
weaponsBox:AddToggle('wep_fullauto', { Text = 'full auto' })
weaponsBox:AddToggle('wep_always_backstab', { Text = 'always backstab' })
weaponsBox:AddSlider('wep_firerate', { Text = 'firerate', Default = 100, Min = 0, Max = 100, Rounding = 0, Suffix = '%' })

local rageTabBox = tabs.Main:AddRightTabbox()
local rageTab = rageTabBox:AddTab('ragebot')
local prioTab = rageTabBox:AddTab('priority')

rageTab:AddToggle('rgb_enabled', { Text = 'enabled' })
rageTab:AddToggle('rgb_void', { Text = 'void spam' })
rageTab:AddSlider('rgb_hide', { Text = 'hide', Default = 0.25, Min = 0, Max = 2, Rounding = 2, Suffix = 's' })
rageTab:AddSlider('rgb_attack', { Text = 'attack', Default = 0.1, Min = 0, Max = 2, Rounding = 2, Suffix = 's' })
rageTab:AddSlider('rgb_shoot_atmpt', { Text = 'shoot attempts', Default = 1, Min = 1, Max = 10, Rounding = 0, Suffix = 'x' })
rageTab:AddDropdown('rgb_atk_mode', { Values = { 'gun', 'melee' }, Default = 1, Multi = false, Text = 'attack mode' })
rageTab:AddDropdown('rgb_pref_wep', { Values = { 'primary', 'secondary', 'melee' }, Default = 1, Multi = false, Text = 'preferred weapon' })
rageTab:AddDropdown('rgb_settings', { Values = { 'default' }, Default = 1, Multi = false, Text = 'settings' })
Toggles.rgb_enabled:AddKeyPicker('rgb_key', { Default = 'None', SyncToggleState = true, Mode = 'Toggle', Text = 'ragebot' })


-- ==========================================
-- WORLD TAB
-- ==========================================
local colorTabBox = tabs.World:AddLeftTabbox()
local ccTab = colorTabBox:AddTab('color correction')
local atmoTab = colorTabBox:AddTab('atmosphere')

ccTab:AddToggle('cc_enabled', { Text = 'enabled' })
ccTab:AddSlider('cc_sat', { Text = 'saturation', Default = 0, Min = -10, Max = 10, Rounding = 1 })
ccTab:AddSlider('cc_con', { Text = 'contrast', Default = 0, Min = -10, Max = 10, Rounding = 1 })
ccTab:AddSlider('cc_bri', { Text = 'brightness', Default = 0, Min = -10, Max = 10, Rounding = 1 })
Toggles.cc_enabled:AddColorPicker('cc_color', { Default = Color3.new(1, 1, 1) })

local lightingBox = tabs.World:AddLeftGroupbox('lighting')
lightingBox:AddLabel('Ambient'):AddColorPicker('l_ambient', { Default = Color3.new(1, 1, 1) })
lightingBox:AddLabel('ColorShift_Bottom'):AddColorPicker('l_cs_bot', { Default = Color3.new(1, 1, 1) })
lightingBox:AddLabel('ColorShift_Top'):AddColorPicker('l_cs_top', { Default = Color3.new(1, 1, 1) })
lightingBox:AddLabel('FogColor'):AddColorPicker('l_fog_col', { Default = Color3.new(1, 1, 1) })

lightingBox:AddToggle('l_fog_end_t', { Text = 'FogEnd' })
lightingBox:AddSlider('l_fog_end', { Text = 'FogEnd', Default = 1000, Min = 0, Max = 10000, Rounding = 0, Suffix = 'studs' })
lightingBox:AddToggle('l_fog_start_t', { Text = 'FogStart' })
lightingBox:AddSlider('l_fog_start', { Text = 'FogStart', Default = 0, Min = 0, Max = 10000, Rounding = 0, Suffix = 'studs' })
lightingBox:AddToggle('l_exp_t', { Text = 'ExposureCompensation' })
lightingBox:AddSlider('l_exp', { Text = 'ExposureCompensation', Default = 0.0, Min = -5, Max = 5, Rounding = 1 })
lightingBox:AddToggle('l_bri_t', { Text = 'Brightness' })
lightingBox:AddSlider('l_bri', { Text = 'Brightness', Default = 3.0, Min = 0, Max = 10, Rounding = 1 })
lightingBox:AddToggle('l_clock_t', { Text = 'ClockTime' })
lightingBox:AddSlider('l_clock', { Text = 'ClockTime', Default = 12.0, Min = 0, Max = 24, Rounding = 1, Suffix = 'h' })
lightingBox:AddToggle('l_global_shad', { Text = 'GlobalShadows' })
lightingBox:AddDropdown('l_tech', { Values = { 'Future', 'ShadowMap', 'Voxel', 'Compatibility' }, Default = 1, Multi = false, Text = 'Technology' })

local skyWeatherTabBox = tabs.World:AddRightTabbox()
local skyboxTab = skyWeatherTabBox:AddTab('skybox')
local weatherTab = skyWeatherTabBox:AddTab('weather')
local ambTab = skyWeatherTabBox:AddTab('ambience')

skyboxTab:AddToggle('sky_enabled', { Text = 'enabled' })
skyboxTab:AddDropdown('sky_selected', { Values = { 'Afternoon', 'Morning', 'Night', 'Space' }, Default = 1, Multi = false, Text = 'selected' })

local bloomRaysTabBox = tabs.World:AddRightTabbox()
local bloomTab = bloomRaysTabBox:AddTab('bloom')
local raysTab = bloomRaysTabBox:AddTab('sun rays')

bloomTab:AddToggle('bloom_enabled', { Text = 'enable' })
bloomTab:AddSlider('bloom_int', { Text = 'intensity', Default = 0.6, Min = 0, Max = 5, Rounding = 2 })
bloomTab:AddSlider('bloom_size', { Text = 'size', Default = 26, Min = 0, Max = 100, Rounding = 0 })
bloomTab:AddSlider('bloom_thres', { Text = 'threshold', Default = 0.4, Min = 0, Max = 5, Rounding = 2 })

local cameraBox = tabs.World:AddRightGroupbox('camera')
cameraBox:AddToggle('cam_fov_on', { Text = 'fov changer' })
cameraBox:AddSlider('cam_fov', { Text = 'fov', Default = 80, Min = 10, Max = 120, Rounding = 0 })
cameraBox:AddToggle('cam_aspect_on', { Text = 'aspect ratio' })
cameraBox:AddSlider('cam_aspect_x', { Text = 'ratio x', Default = 1, Min = 0.1, Max = 5, Rounding = 2 })
cameraBox:AddSlider('cam_aspect_y', { Text = 'ratio y', Default = 1, Min = 0.1, Max = 5, Rounding = 2 })
cameraBox:AddSlider('cam_blur', { Text = 'blur', Default = 0, Min = 0, Max = 50, Rounding = 0, Suffix = 'x' })


-- ==========================================
-- ESP TAB
-- ==========================================
local pOptsBox = tabs.ESP:AddLeftGroupbox('player options')
pOptsBox:AddToggle('esp_p_box', { Text = 'box' })
    :AddColorPicker('esp_p_box_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('esp_p_box_c2', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('esp_p_box_c3', { Default = Color3.new(1, 1, 1) })
pOptsBox:AddToggle('esp_p_movrot', { Text = 'moving rotation' })
pOptsBox:AddSlider('esp_p_rot', { Text = 'rotation', Default = 0, Min = 0, Max = 360, Rounding = 0, Suffix = '°' })
pOptsBox:AddSlider('esp_p_rotspeed', { Text = 'speed', Default = 0.1, Min = 0, Max = 5, Rounding = 1, Suffix = 'rps' })
pOptsBox:AddToggle('esp_p_fill', { Text = 'fill' }):AddColorPicker('esp_p_fill_c', { Default = Color3.new(1, 1, 1) })
pOptsBox:AddToggle('esp_p_skel', { Text = 'skeleton' }):AddColorPicker('esp_p_skel_c', { Default = Color3.new(1, 1, 1) })
pOptsBox:AddToggle('esp_p_name', { Text = 'name' }):AddColorPicker('esp_p_name_c', { Default = Color3.new(1, 1, 1) })
pOptsBox:AddToggle('esp_p_wep', { Text = 'weapon' }):AddColorPicker('esp_p_wep_c', { Default = Color3.new(1, 1, 1) })
pOptsBox:AddToggle('esp_p_dist', { Text = 'distance' }):AddColorPicker('esp_p_dist_c', { Default = Color3.new(1, 1, 1) })

pOptsBox:AddToggle('esp_p_hp', { Text = 'healthbar' })
pOptsBox:AddColorPicker('esp_p_hp_g', { Default = Color3.new(0, 1, 0), Title = 'Health Full' })
pOptsBox:AddColorPicker('esp_p_hp_y', { Default = Color3.new(1, 1, 0), Title = 'Health Mid' })
pOptsBox:AddColorPicker('esp_p_hp_r', { Default = Color3.new(1, 0, 0), Title = 'Health Low' })
pOptsBox:AddToggle('esp_p_resize', { Text = 'resize outline' })
pOptsBox:AddToggle('esp_p_movhp', { Text = 'moving healthbar' })
pOptsBox:AddDropdown('esp_p_hptype', { Values = { 'gradient', 'solid' }, Default = 1, Multi = false, Text = 'healthbar type' })
pOptsBox:AddSlider('esp_p_slices', { Text = 'slices', Default = 1, Min = 1, Max = 10, Rounding = 0 })
pOptsBox:AddSlider('esp_p_hpspeed', { Text = 'speed', Default = 1, Min = 0.1, Max = 5, Rounding = 1 })
pOptsBox:AddSlider('esp_p_hplerp', { Text = 'health lerp', Default = 0.05, Min = 0.01, Max = 1, Rounding = 2 })

local wOptsBox = tabs.ESP:AddLeftGroupbox('world options')
wOptsBox:AddToggle('esp_w_name', { Text = 'name' }):AddColorPicker('esp_w_name_c', { Default = Color3.new(1, 1, 1) })
wOptsBox:AddToggle('esp_w_img', { Text = 'image' })
wOptsBox:AddToggle('esp_w_dist', { Text = 'distance' }):AddColorPicker('esp_w_dist_c', { Default = Color3.new(1, 1, 1) })
wOptsBox:AddSlider('esp_w_scale', { Text = 'object scale', Default = 100, Min = 10, Max = 200, Rounding = 0, Suffix = '%' })
wOptsBox:AddDropdown('esp_w_white', { Values = { 'Grenade', 'Molotov', 'Satchel' }, Default = 1, Multi = true, Text = 'whitelist' })
wOptsBox:AddDropdown('esp_w_font', { Values = { 'proggy clean', 'tahoma', 'verdana' }, Default = 1, Multi = false, Text = 'font' })

local overAppBox = tabs.ESP:AddRightGroupbox('override appearance')
overAppBox:AddToggle('esp_oa_on', { Text = 'enabled' })
overAppBox:AddToggle('esp_oa_mat', { Text = 'material' })
overAppBox:AddToggle('esp_oa_col', { Text = 'color' }):AddColorPicker('esp_oa_c', { Default = Color3.new(1, 1, 1) })
overAppBox:AddDropdown('esp_oa_dis', { Values = { 'None', 'Texture' }, Default = 1, Multi = true, Text = 'disable' })
overAppBox:AddSlider('esp_oa_trans', { Text = 'transparency', Default = 100, Min = 0, Max = 100, Rounding = 0, Suffix = '%' })

local highEffTabBox = tabs.ESP:AddRightTabbox()
local highTab = highEffTabBox:AddTab('highlight')
local effTab = highEffTabBox:AddTab('effects')

highTab:AddToggle('hl_enabled', { Text = 'enabled' })
    :AddColorPicker('hl_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('hl_c2', { Default = Color3.new(1, 1, 1) })
highTab:AddSlider('hl_f_trans', { Text = 'fill transparency', Default = 2, Min = 0, Max = 10, Rounding = 1 })
highTab:AddSlider('hl_o_trans', { Text = 'outline transparency', Default = 1, Min = 0, Max = 10, Rounding = 1 })
highTab:AddDropdown('hl_set', { Values = { 'default' }, Default = 1, Multi = false, Text = 'highlight settings' })

local custBox = tabs.ESP:AddRightGroupbox('customization')
custBox:AddToggle('esp_c_team', { Text = 'include teammates' })
custBox:AddDropdown('esp_c_bound', { Values = { 'fixed', 'dynamic' }, Default = 1, Multi = false, Text = 'bounding mode' })
custBox:AddSlider('esp_c_f_scale', { Text = 'fixed width scale', Default = 100, Min = 10, Max = 200, Rounding = 0, Suffix = '%' })
custBox:AddDropdown('esp_c_font', { Values = { 'proggy clean', 'tahoma', 'verdana' }, Default = 1, Multi = false, Text = 'font' })
custBox:AddDropdown('esp_c_ntype', { Values = { 'Name', 'DisplayName' }, Default = 1, Multi = false, Text = 'name type' })

-- ==========================================
-- VISUALS TAB
-- ==========================================
local vmItemTabBox = tabs.Visuals:AddLeftTabbox()
local vmTab = vmItemTabBox:AddTab('viewmodel')
local itemTab = vmItemTabBox:AddTab('item')

vmTab:AddDropdown('vis_vm_dis', { Values = { '...' }, Default = 1, Multi = false, Text = 'disable' })
vmTab:AddToggle('vis_vm_fps', { Text = 'override fps' })
vmTab:AddSlider('vis_vm_recoil', { Text = 'recoil percent', Default = 100, Min = 0, Max = 100, Rounding = 0, Suffix = '%' })
vmTab:AddToggle('vis_vm_chams', { Text = 'chams' })
    :AddColorPicker('vis_vm_chams_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_vm_chams_c2', { Default = Color3.new(1, 1, 1) })
vmTab:AddToggle('vis_vm_offset', { Text = 'offset' })
vmTab:AddToggle('vis_vm_cosm', { Text = 'show cosmetics changer' })

local custTracersTabBox = tabs.Visuals:AddLeftTabbox()
local ctTab = custTracersTabBox:AddTab('custom tracers')
local ssTab = custTracersTabBox:AddTab('shoot sound')

ctTab:AddToggle('vis_ct_on', { Text = 'enabled' })
    :AddColorPicker('vis_ct_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_ct_c2', { Default = Color3.new(1, 1, 1) })

local xhairBox = tabs.Visuals:AddLeftGroupbox('crosshair')
xhairBox:AddToggle('vis_xh_on', { Text = 'enabled' })
    :AddColorPicker('vis_xh_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_xh_c2', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_xh_c3', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_xh_c4', { Default = Color3.new(1, 1, 1) })
xhairBox:AddToggle('vis_xh_dis', { Text = 'disable game crosshair' })


local hitEffTabBox = tabs.Visuals:AddRightTabbox()
local heTab = hitEffTabBox:AddTab('hit effects')
local hsTab = hitEffTabBox:AddTab('hit sounds')

heTab:AddToggle('vis_he_on', { Text = 'enabled' })
    :AddColorPicker('vis_he_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_he_c2', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_he_c3', { Default = Color3.new(1, 1, 1) })
heTab:AddToggle('vis_he_nohit', { Text = 'disable hit marker' })
heTab:AddToggle('vis_he_nodmg', { Text = 'disable damage numbers' })

local indBox = tabs.Visuals:AddRightGroupbox('indicators')
indBox:AddToggle('vis_ind_manip', { Text = 'manipulated' })
    :AddColorPicker('vis_ind_manip_c', { Default = Color3.new(1, 1, 1) })
indBox:AddToggle('vis_ind_rb', { Text = 'ragebot' })
    :AddColorPicker('vis_ind_rb_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_ind_rb_c2', { Default = Color3.new(1, 1, 1) })
indBox:AddDropdown('vis_ind_rb_style', { Values = { 'text', 'status' }, Default = 1, Multi = true, Text = 'ragebot style' })
indBox:AddToggle('vis_ind_ammo', { Text = 'ammo' })
    :AddColorPicker('vis_ind_ammo_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_ind_ammo_c2', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_ind_ammo_c3', { Default = Color3.new(1, 1, 1) })
indBox:AddSlider('vis_ind_lerp', { Text = 'lerp', Default = 1, Min = 0.1, Max = 10, Rounding = 1, Suffix = 'x' })
indBox:AddSlider('vis_ind_offx', { Text = 'offset x', Default = 0, Min = -500, Max = 500, Rounding = 0, Suffix = 'px' })
indBox:AddSlider('vis_ind_offy', { Text = 'offset y', Default = 25, Min = -500, Max = 500, Rounding = 0, Suffix = 'px' })
indBox:AddDropdown('vis_ind_font', { Values = { 'proggy clean' }, Default = 1, Multi = false, Text = 'font' })
indBox:AddDropdown('vis_ind_style', { Values = { 'lower' }, Default = 1, Multi = false, Text = 'text style' })
indBox:AddDropdown('vis_ind_pos', { Values = { '...' }, Default = 1, Multi = false, Text = 'position' })

local tgtBox = tabs.Visuals:AddRightGroupbox('target')
tgtBox:AddToggle('vis_tgt_tracer', { Text = 'tracer' })
    :AddColorPicker('vis_tgt_tr_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_tgt_tr_c2', { Default = Color3.new(1, 1, 1) })
tgtBox:AddToggle('vis_tgt_high', { Text = 'highlight' })
    :AddColorPicker('vis_tgt_hl_c1', { Default = Color3.new(1, 1, 1) })
    :AddColorPicker('vis_tgt_hl_c2', { Default = Color3.new(1, 1, 1) })

-- ==========================================
-- CHARACTER TAB
-- ==========================================
local movBox = tabs.Character:AddLeftGroupbox('movement')
movBox:AddToggle('chr_mov_vel', { Text = 'velocity' }):AddKeyPicker('chr_mov_vel_k', { Default = 'None', Mode = 'Toggle', Text = 'velocity' })
movBox:AddSlider('chr_mov_velspd', { Text = 'velocity speed', Default = 50, Min = 10, Max = 200, Rounding = 0, Suffix = 's' })
movBox:AddToggle('chr_mov_slide', { Text = 'slide boost' })
movBox:AddSlider('chr_mov_slide_v', { Text = 'slide boost', Default = 1, Min = 1, Max = 5, Rounding = 1, Suffix = 'x' })
movBox:AddToggle('chr_mov_dj', { Text = 'double jump height' })
movBox:AddSlider('chr_mov_dj_v', { Text = 'double jump height', Default = 1, Min = 1, Max = 5, Rounding = 1, Suffix = 'x' })
movBox:AddToggle('chr_mov_idj', { Text = 'infinite double jump' })

local animBox = tabs.Character:AddLeftGroupbox('animation player')
animBox:AddToggle('chr_anim_on', { Text = 'enabled' }):AddKeyPicker('chr_anim_k', { Default = 'None', Mode = 'Toggle', Text = 'animation' })
animBox:AddDropdown('chr_anim_sel', { Values = { 'floss' }, Default = 1, Multi = false, Text = 'animation' })
animBox:AddInput('chr_anim_id', { Default = '', Numeric = true, Finished = false, Text = 'custom animation', Placeholder = 'id... (ex: 4049646104)' })
animBox:AddSlider('chr_anim_spd', { Text = 'speed', Default = 1, Min = 0.1, Max = 5, Rounding = 1 })
animBox:AddSlider('chr_anim_start', { Text = 'start', Default = 0, Min = 0, Max = 100, Rounding = 0, Suffix = '%' })
animBox:AddSlider('chr_anim_end', { Text = 'end', Default = 100, Min = 0, Max = 100, Rounding = 0, Suffix = '%' })

local chrBox = tabs.Character:AddRightGroupbox('character')
chrBox:AddToggle('chr_noc', { Text = 'noclip' }):AddKeyPicker('chr_noc_k', { Default = 'None', Mode = 'Toggle', Text = 'noclip' })
chrBox:AddToggle('chr_fly', { Text = 'fly' }):AddKeyPicker('chr_fly_k', { Default = 'None', Mode = 'Toggle', Text = 'fly' })
chrBox:AddSlider('chr_fly_spd', { Text = 'fly speed', Default = 50, Min = 10, Max = 200, Rounding = 0, Suffix = 's' })

local tpBox = tabs.Character:AddRightGroupbox('third person')
tpBox:AddToggle('chr_tp_on', { Text = 'enabled' }):AddKeyPicker('chr_tp_k', { Default = 'None', Mode = 'Toggle', Text = 'third person' })

local aaBox = tabs.Character:AddRightGroupbox('anti aim')
aaBox:AddToggle('chr_aa_on', { Text = 'enabled' })
aaBox:AddDropdown('chr_aa_pitch', { Values = { 'disabled' }, Default = 1, Multi = false, Text = 'pitch' })
aaBox:AddDropdown('chr_aa_yaw', { Values = { 'disabled' }, Default = 1, Multi = false, Text = 'yaw' })
aaBox:AddToggle('chr_aa_ug', { Text = 'underground' }):AddKeyPicker('chr_aa_ug_k', { Default = 'None', Mode = 'Toggle', Text = 'underground' })


-- ==========================================
-- MISC TAB
-- ==========================================
local autoloadBox = tabs.Misc:AddLeftGroupbox('auto load')
autoloadBox:AddToggle('msc_al_on', { Text = 'enabled' })
autoloadBox:AddToggle('msc_al_silent', { Text = 'silent mode' })

local loadoutBox = tabs.Misc:AddLeftGroupbox('loadout')
loadoutBox:AddToggle('msc_lo_unre', { Text = 'unrestricted' })
loadoutBox:AddToggle('msc_lo_auto', { Text = 'auto select' })
loadoutBox:AddDropdown('msc_lo_pri', { Values = { 'Assault Rifle' }, Default = 1, Multi = false, Text = 'primary' })
loadoutBox:AddDropdown('msc_lo_sec', { Values = { 'Handgun' }, Default = 1, Multi = false, Text = 'secondary' })
loadoutBox:AddDropdown('msc_lo_mel', { Values = { 'Fists' }, Default = 1, Multi = false, Text = 'melee' })
loadoutBox:AddDropdown('msc_lo_util', { Values = { 'Grenade' }, Default = 1, Multi = false, Text = 'utility' })

local chatBox = tabs.Misc:AddLeftGroupbox('chat spam')
chatBox:AddToggle('msc_cs_on', { Text = 'enabled' })
chatBox:AddToggle('msc_cs_inorder', { Text = 'in order' })
chatBox:AddDropdown('msc_cs_mode', { Values = { 'custom' }, Default = 1, Multi = false, Text = 'chat mode' })
chatBox:AddDropdown('msc_cs_rand', { Values = { '...' }, Default = 1, Multi = false, Text = 'random custom text' })
chatBox:AddInput('msc_cs_add', { Default = '', Finished = false, Text = 'add custom text', Placeholder = 'message...' })
chatBox:AddButton('refresh modes', function() end)

local queueBanTabBox = tabs.Misc:AddRightTabbox()
local qTab = queueBanTabBox:AddTab('auto queue')
local banTab = queueBanTabBox:AddTab('auto ban')

qTab:AddToggle('msc_q_on', { Text = 'enabled' })
qTab:AddDropdown('msc_q_mode', { Values = { '1v1' }, Default = 1, Multi = false, Text = 'Game Mode' })

local spoofTabBox = tabs.Misc:AddRightTabbox()
local spoofTab = spoofTabBox:AddTab('name spoofer')
local sDevTab = spoofTabBox:AddTab('spoof device')

spoofTab:AddToggle('msc_sp_on', { Text = 'enabled' })
spoofTab:AddInput('msc_sp_name', { Default = '', Finished = false, Text = 'name', Placeholder = 'nosniy...' })

local arcadeBox = tabs.Misc:AddRightGroupbox('arcade servers')
arcadeBox:AddToggle('msc_arc_grab', { Text = 'automatically grab drops' })

local notifyBox = tabs.Misc:AddRightGroupbox('notify hit')
notifyBox:AddToggle('msc_not_on', { Text = 'enabled' })
notifyBox:AddSlider('msc_not_dur', { Text = 'notify duration', Default = 1, Min = 0.1, Max = 10, Rounding = 1, Suffix = 's' })
notifyBox:AddDropdown('msc_not_rand', { Values = { 'Hit (NAME) for (DMG) in the' }, Default = 1, Multi = false, Text = 'random notify text' })
notifyBox:AddInput('msc_not_add', { Default = '', Finished = false, Text = 'add custom text', Placeholder = 'ex: (NAME), (DMG), (PART)' })
notifyBox:AddLabel('ALL FORMATTING:\n(NAME), (DMG), (PART), (WEAPON)')


-- ==========================================
-- FINISH
-- ==========================================

library:SetWatermarkPosition({
    Position = 'TopRight'
})

themeManager:SetLibrary(library)
saveManager:SetLibrary(library)

saveManager:IgnoreThemeSettings()
saveManager:SetIgnoreIndexes({ 'MenuKeybind' })

themeManager:SetFolder('UnnamedEnhancements')
saveManager:SetFolder('UnnamedEnhancements/Rivals')

saveManager:BuildConfigSection(tabs.Settings)
themeManager:ApplyToTab(tabs.Settings)

-- Add custom missing boxes to Settings
local commConfigBox = tabs.Settings:AddRightGroupbox('community configs')
commConfigBox:AddDropdown('st_comm_list', { Values = { "Rem\'s Legit Config" }, Default = 1, Multi = false, Text = 'config list' })
commConfigBox:AddButton('load config', function() end)

local stLuaBox = tabs.Settings:AddRightGroupbox('lua')
stLuaBox:AddLabel('in development', { Center = true })

-- ==========================================
-- SCRIPT LOGIC & ANTI-DETECTION
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- [ 1. UTILS & TARGETING ]
local function getTargetPartName()
    local val = Options.trg_part.Value
    if val == 'Random' then
        local parts = {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
        return parts[math.random(1, #parts)]
    end
    return val
end

local function getClosestPlayer(radius, visibleOnly)
    local closestDist = radius or math.huge
    local closestTarget = nil
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            
            -- Teammate check
            if not Toggles.esp_c_team.Value and player.Team == LocalPlayer.Team then continue end

            local targetPartName = getTargetPartName()
            local targetPart = player.Character:FindFirstChild(targetPartName) or player.Character:FindFirstChild("Head")
            
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if dist < closestDist then
                        if visibleOnly then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local rayResult = Workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 5000, rayParams)
                            if rayResult and rayResult.Instance and rayResult.Instance:IsDescendantOf(player.Character) then
                                closestDist = dist
                                closestTarget = player.Character
                            end
                        else
                            closestDist = dist
                            closestTarget = player.Character
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

-- [ 2. AIMBOT (Camera Manipulation) ]
RunService.RenderStepped:Connect(function()
    if Toggles.ab_enabled.Value and Options.ab_key:GetState() then
        local target = getClosestPlayer(Options.ab_radius.Value, Toggles.trg_vis.Value)
        if target then
            local targetPart = target:FindFirstChild(getTargetPartName()) or target:FindFirstChild("Head")
            if targetPart then
                local targetPos = targetPart.Position
                local smooth = Options.ab_smoothing.Value / 100
                local lookCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                if smooth < 1 and smooth > 0 then
                    Camera.CFrame = Camera.CFrame:Lerp(lookCFrame, (1 - smooth))
                else
                    Camera.CFrame = lookCFrame
                end
            end
        end
    end
end)

-- [ 3. ANTI-DETECTION & ADVANCED SILENT AIM (Remote Mapping & Hooking) ]
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() then
        -- 1. Raycast Hooking (Rivals / FastCast compatibility)
        if method == "Raycast" and Toggles.sa_enabled.Value and Options.sa_key:GetState() then
            local target = getClosestPlayer(Options.sa_radius.Value, Toggles.trg_vis.Value)
            if target then
                local targetPart = target:FindFirstChild(getTargetPartName()) or target:FindFirstChild("Head")
                if targetPart then
                    local origin = args[1]
                    local newDir = (targetPart.Position - origin).Unit * 5000
                    args[2] = newDir
                    -- Hit chance logic
                    if math.random(1, 100) <= Options.sa_hitchance.Value then
                        return oldNamecall(self, args[1], args[2], args[3])
                    end
                end
            end
        end
        
        -- 2. Full Remote Mapping & Argument Spoofing (HitPart/Positions)
        if (method == "FireServer" or method == "InvokeServer") and Toggles.sa_enabled.Value and Options.sa_key:GetState() then
            local target = getClosestPlayer(Options.sa_radius.Value, Toggles.trg_vis.Value)
            if target then
                local targetPartName = getTargetPartName()
                local targetPart = target:FindFirstChild(targetPartName) or target:FindFirstChild("Head")
                
                if targetPart then
                    local hitChance = Options.sa_hitchance.Value
                    if math.random(1, 100) <= hitChance then
                        local modified = false
                        for i, v in pairs(args) do
                            -- Wymiana obiektów (Part/Instance) w argumentach (np. HitPart = Wrog)
                            if typeof(v) == "Instance" and v:IsA("BasePart") and v:IsDescendantOf(Workspace) then
                                -- Sprawdzenie czy stara wartosc nalezy do jakiegos gracza
                                local isEnemyPart = false
                                for _, p in pairs(Players:GetPlayers()) do
                                    if p ~= LocalPlayer and p.Character and v:IsDescendantOf(p.Character) then
                                        isEnemyPart = true
                                        break
                                    end
                                end
                                
                                if isEnemyPart or tostring(v):match("Hit") or tostring(v):match("Part") then
                                    args[i] = targetPart
                                    modified = true
                                end
                            -- Wymiana wektorów (HitPosition/MouseLocation) do strzału broni w Rivals
                            elseif typeof(v) == "Vector3" then
                                local dist = (v - targetPart.Position).Magnitude
                                -- Tylko podmieniamy, jeśli pozycja wysyłana na serwer jest "bliżej" wycelowana we wroga lub celujemy w miare prosto.
                                -- Zwiększamy obszar przyciągania pakietu
                                if dist < 100 or tostring(self):lower():match("bullet") or tostring(self):lower():match("shoot") or tostring(self):lower():match("weapon") then
                                    args[i] = targetPart.Position
                                    modified = true
                                end
                            end
                        end
                        
                        if modified then
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
            end
        end

        -- 3. Block generic log remotes (Anti-Cheat Server-Side logging)
        if method == "FireServer" then
            local selfName = tostring(self):lower()
            if selfName:match("log") or selfName:match("ban") or selfName:match("kick") or selfName:match("report") or selfName:match("anticheat") then 
                return -- Zablokowanie wysyłania pakietów
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() then
        if tostring(self) == "Humanoid" then
            if key == "WalkSpeed" then return 16 end
            if key == "JumpPower" then return 50 end
        end
    end
    return oldIndex(self, key)
end)

-- [ 4. HIGHLIGHT ESP (Basic) ]
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Toggles.hl_enabled.Value then
                if player.Character then
                    local hl = player.Character:FindFirstChild("RivalsESP_HL")
                    if not hl then
                        hl = Instance.new("Highlight", player.Character)
                        hl.Name = "RivalsESP_HL"
                    end
                    hl.Enabled = Toggles.hl_enabled.Value
                    hl.FillColor = Options.hl_c1.Value
                    hl.OutlineColor = Options.hl_c2.Value
                    hl.FillTransparency = Options.hl_f_trans.Value / 10
                    hl.OutlineTransparency = Options.hl_o_trans.Value / 10
                end
            else
                if player.Character and player.Character:FindFirstChild("RivalsESP_HL") then
                    player.Character.RivalsESP_HL:Destroy()
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

-- [ 5. CHARACTER MOVEMENT & WORLD ]
RunService.Heartbeat:Connect(function()
    -- Character Loop
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        -- Velocity override
        if Toggles.chr_mov_vel.Value and Options.chr_mov_vel_k:GetState() and hum then
            hrp.Velocity = hum.MoveDirection * Options.chr_mov_velspd.Value + Vector3.new(0, hrp.Velocity.Y, 0)
        end
        
        -- Noclip Simulation
        if Toggles.chr_noc.Value and Options.chr_noc_k:GetState() then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
        
        -- Fly Simulation
        if Toggles.chr_fly.Value and Options.chr_fly_k:GetState() then
            hrp.Velocity = Camera.CFrame.LookVector * Options.chr_fly_spd.Value
        end
    end
    
    -- World Mod Loop
    if Toggles.l_exp_t.Value then Lighting.ExposureCompensation = Options.l_exp.Value end
    if Toggles.l_bri_t.Value then Lighting.Brightness = Options.l_bri.Value end
    if Toggles.l_clock_t.Value then Lighting.ClockTime = Options.l_clock.Value end
end)

-- [ 6. TRIGGERBOT ]
local tbDelayTick = tick()
RunService.RenderStepped:Connect(function()
    if Toggles.tb_enabled.Value and Options.tb_key:GetState() then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent then
            local enemyPlayer = Players:GetPlayerFromCharacter(target.Parent) or Players:GetPlayerFromCharacter(target.Parent.Parent)
            
            if enemyPlayer and enemyPlayer ~= LocalPlayer then
                if Toggles.esp_c_team.Value or enemyPlayer.Team ~= LocalPlayer.Team then
                    -- Sprawdzenie dystansu
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - enemyPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= Options.tb_maxdist.Value then
                        if enemyPlayer.Character and enemyPlayer.Character:FindFirstChild("Humanoid") and enemyPlayer.Character.Humanoid.Health > 0 then
                            if tick() - tbDelayTick >= (Options.tb_shoot.Value / 1000) then
                                tbDelayTick = tick()
                                mouse1click() -- Symulacja kliknięcia strzału
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- [ 7. RAGEBOT ]
local rageTick = tick()
RunService.Heartbeat:Connect(function()
    if Toggles.rgb_enabled.Value and Options.rgb_key:GetState() then
        if tick() - rageTick >= Options.rgb_attack.Value then
            rageTick = tick()
            -- Szukamy celu ze zignorowaniem scian i duzym zasiegiem (rage)
            local target = getClosestPlayer(math.huge, false) 
            if target then
                local targetPartName = getTargetPartName()
                local targetPart = target:FindFirstChild(targetPartName) or target:FindFirstChild("Head")
                if targetPart then
                    -- Gwałtowne machanie celownikiem na gracza (bez wygładzania na potrzeby Ragebota)
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                    
                    -- Natychmiastowe klikanie
                    for i = 1, Options.rgb_shoot_atmpt.Value do
                        mouse1click()
                    end
                end
            end
        end
    end
end)

-- [ 8. WEAPONS MODIFICATIONS ]
-- Modyfikuje statystyki używanej w danej chwili broni (Jeżeli gra opiera sie na konfiguracjach Tool'i w plecaku)
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            local settingsFolder = tool:FindFirstChild("Settings") or tool:FindFirstChild("Configuration") or tool:FindFirstChild("Stats")
            if settingsFolder then
                if Toggles.wep_fullauto.Value then
                    local auto = settingsFolder:FindFirstChild("Automatic") or settingsFolder:FindFirstChild("Auto")
                    if auto and (auto:IsA("BoolValue") or type(auto.Value) == "boolean") then
                        auto.Value = true
                    end
                end
                
                if Toggles.wep_nospread.Value then
                    local spread = settingsFolder:FindFirstChild("Spread") or settingsFolder:FindFirstChild("MinSpread") or settingsFolder:FindFirstChild("MaxSpread")
                    if spread and (spread:IsA("NumberValue") or type(spread.Value) == "number") then
                        spread.Value = 0
                    end
                end
                
                if Options.wep_firerate.Value > 0 then
                    local fr = settingsFolder:FindFirstChild("FireRate") or settingsFolder:FindFirstChild("RPM")
                    if fr and (fr:IsA("NumberValue") or type(fr.Value) == "number") then
                        -- Przepisanie RPM na podstawie ustalonego w GUI precentu (100% = max prędkość dopuszczalna przez serwer)
                        if fr.Name == "RPM" then
                            fr.Value = 1500 * (Options.wep_firerate.Value / 100)
                        else
                            fr.Value = 0.01 + (1 - (Options.wep_firerate.Value / 100))
                        end
                    end
                end
            end
        end
    end
end)

-- [ 9. MISC: CHAT SPAM ]
local chatSpamTick = tick()
RunService.Heartbeat:Connect(function()
    if Toggles.msc_cs_on.Value then
        if tick() - chatSpamTick >= 2 then -- Spam interval (aby uniknac kicka za flood)
            chatSpamTick = tick()
            
            local msg = "Unnamed Enhancements on top!"
            local customMode = Options.msc_cs_mode.Value
            
            if customMode == "custom" and Options.msc_cs_add.Value ~= "" then
                msg = Options.msc_cs_add.Value
            end
            
            local TextChatService = game:GetService("TextChatService")
            -- Zgodność z nowym TheTextChatService jak i starym systemem czatu gry
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if channel then channel:SendAsync(msg) end
            else
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local DefaultChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if DefaultChat and DefaultChat:FindFirstChild("SayMessageRequest") then
                    DefaultChat.SayMessageRequest:FireServer(msg, "All")
                end
            end
        end
    end
end)

saveManager:LoadAutoloadConfig()
