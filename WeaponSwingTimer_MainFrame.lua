LHGWSTMain = {}

local function MainFrame_OnDragStart()
    if not LHG_WeapSwingTimer_Settings.is_locked then
        LHGWSTMain.main_frame:StartMoving()
    end
end

local function MainFrame_OnDragStop()
    LHGWSTMain.main_frame:StopMovingOrSizing()
    _, _, rel_point, x_pos, y_pos = LHGWSTMain.main_frame:GetPoint()
    LHG_WeapSwingTimer_Settings.rel_point = rel_point
    LHG_WeapSwingTimer_Settings.x_pos = x_pos
    LHG_WeapSwingTimer_Settings.y_pos = y_pos
    LHGWSTConfig.UpdateConfigFrameValues()
end

LHGWSTMain.UpdateSwingFrames = function(play_weap_speed, play_swing_time, tar_weap_speed, tar_swing_time)
    -- Update the alpha
    local main_frame = LHGWSTMain.main_frame
    if LHG_WeapSwingTimer_Settings.in_combat then
        main_frame:SetAlpha(LHG_WeapSwingTimer_Settings.in_combat_alpha)
    else
        main_frame:SetAlpha(LHG_WeapSwingTimer_Settings.ooc_alpha)
    end
    -- Update the player swing frame
    local player_swing_frame = LHGWSTMain.main_frame.player_swing_frame
    player_percent = 1 - (play_swing_time / play_weap_speed)
    player_swing_frame:SetWidth((main_frame:GetWidth() - 2) * player_percent)
    -- Update the target swing frame
    local target_swing_frame = LHGWSTMain.main_frame.target_swing_frame
    target_percent = 1 - (tar_swing_time / tar_weap_speed)
    target_swing_frame:SetWidth((main_frame:GetWidth() - 2) * target_percent)
end

LHGWSTMain.UpdateVisuals = function()
    local main_frame = LHGWSTMain.main_frame
    main_frame:SetWidth(LHG_WeapSwingTimer_Settings.width)
    main_frame:SetHeight(LHG_WeapSwingTimer_Settings.height)
    main_frame:SetPoint(LHG_WeapSwingTimer_Settings.rel_point, LHG_WeapSwingTimer_Settings.x_pos, LHG_WeapSwingTimer_Settings.y_pos)
    main_frame:SetScale(LHG_WeapSwingTimer_Settings.scale)
    main_frame.main_texture:SetColorTexture(0,0,0,LHG_WeapSwingTimer_Settings.backplane_alpha)
    main_frame.player_swing_frame:SetWidth(main_frame:GetWidth() - 2)
    main_frame.player_swing_frame:SetHeight((main_frame:GetHeight() / 2) - 2)
    main_frame.player_swing_frame:SetPoint("TOPLEFT", 1, -1)
    main_frame.target_swing_frame:SetWidth(main_frame:GetWidth() - 2)
    main_frame.target_swing_frame:SetHeight((main_frame:GetHeight() / 2) - 2)
    main_frame.target_swing_frame:SetPoint("BOTTOMLEFT", 1, 1)
    LHGWSTMain.UpdateSwingFrames(1, 1, 1, 1)
end

LHGWSTMain.CreateLHGWSTMainFrame = function()
    -- Setup the main frame appearance
    LHGWSTMain.main_frame = CreateFrame("Frame", "WSTMainFrame", UIParent)
    local main_frame = LHGWSTMain.main_frame
    main_frame.main_texture = main_frame:CreateTexture(nil,"ARTWORK")
    main_frame.main_texture:SetColorTexture(0,0,0,LHG_WeapSwingTimer_Settings.backplane_alpha)
    main_frame.main_texture:SetAllPoints(main_frame)
    main_frame.texture = main_frame.main_texture
    main_frame:Show()
    -- Setup the player's swing image appearance
    main_frame.player_swing_frame = CreateFrame("Frame", "WSTPlayerSwingFrame", main_frame)
    local player_texture = main_frame.player_swing_frame:CreateTexture(nil,"ARTWORK")
    player_texture:SetColorTexture(0.8,1,0.8,1)
    player_texture:SetAllPoints(main_frame.player_swing_frame)
    main_frame.player_swing_frame.texture = player_texture
    -- Setup the target's swing image appearance
    main_frame.target_swing_frame = CreateFrame("Frame", "WSTTargetSwingFrame", main_frame)
    local target_texture = main_frame.target_swing_frame:CreateTexture(nil,"ARTWORK")
    target_texture:SetColorTexture(1,0.8,0.8,1)
    target_texture:SetAllPoints(main_frame.target_swing_frame)
    main_frame.target_swing_frame.texture = target_texture
    -- Set the scripts that control the main_frame
    main_frame:SetMovable(true)
    main_frame:EnableMouse(true)
    main_frame:RegisterForDrag("LeftButton")
    main_frame:SetScript("OnDragStart", MainFrame_OnDragStart)
    main_frame:SetScript("OnDragStop", MainFrame_OnDragStop)
    -- Update the visuals
    LHGWSTMain.UpdateVisuals()
    -- return the main_frame
    return main_frame
end
