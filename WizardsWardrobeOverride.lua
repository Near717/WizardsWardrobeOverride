WizardsWardrobeOverride = {
    name = "WizardsWardrobeOverride"
}

local WWNS = WizardsWardrobeOverride

local WW = WizardsWardrobe
local WWG = WW.gui

local function overrideFuncs()

    function WW.LoadSetupSubstitute( index )
        if not WW.zones[ "SUB" ] or not WW.pages[ "SUB" ] then return end

        local isTrial = false
        for _, value in pairs(WW.zones) do
            if value.id == WW.currentZoneId and value.trial == true then
                isTrial = true
                WW.LoadSetup( WW.zones[ "SUB" ], WW.pages[ "SUB" ][ 0 ].selected, index, true )
                break
            end
        end

        if isTrial == false and WW.settings.substitute.dungeons == true then
            if not WW.zones[ "DG" ] or not WW.pages[ "DG" ] then return end
            WW.LoadSetup( WW.zones[ "DG" ], WW.pages[ "DG" ][ 0 ].selected, index, true )
        end
    end

    function WWG.OnZoneSelect( zone )
        PlaySound( SOUNDS.TABLET_PAGE_TURN )

        if not WW.pages[ zone.tag ] then
            WWG.CreatePage( zone, true )
        end

        WW.selection.zone = zone
        WW.selection.pageId = WW.pages[ zone.tag ][ 0 ].selected

        WWG.BuildPage( WW.selection.zone, WW.selection.pageId )

        WWG.zoneSelection:SetLabel( zone.name )

        local isSubstitute = zone.tag == "SUB"
        if not isSubstitute then
            isSubstitute = zone.tag == "DG"
        end
        WWG.substituteExplain:SetHidden( not isSubstitute )
        WWG.addSetupButton:SetHidden( isSubstitute )

        if zone.tag == "GEN"
            or zone.tag == "SUB"
            or zone.tag == "DG"
            or zone.tag == "PVP" then
            WizardsWardrobeWindowTopMenuTeleportTrial:SetHidden( true )
            WizardsWardrobeWindowTopMenuTeleportHouse:SetHidden( false )
        else
            WizardsWardrobeWindowTopMenuTeleportTrial:SetHidden( false )
            WizardsWardrobeWindowTopMenuTeleportHouse:SetHidden( true )
        end

        WizardsWardrobeWindowTopMenuTeleportTrial:SetEnabled( not IsInAvAZone() )
        WizardsWardrobeWindowTopMenuTeleportTrial:SetDesaturation( IsInAvAZone() and 1 or 0 )
        WizardsWardrobeWindowTopMenuTeleportHouse:SetEnabled( not IsInAvAZone() )
    end

    function WWG.AquireSetupControl( setup )
        local setupControl, key = WWG.setupPool:AcquireObject()
        table.insert( WWG.setupTable, key )
        local index = #WWG.setupTable

        setupControl:SetHidden( false )
        setupControl.i = index

        setupControl.name:SetHandler( "OnMouseEnter", function( self )
            setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )
            ZO_Tooltips_ShowTextTooltip( self, TOP, GetString( WW_BUTTON_LABEL ) )
            if not setup:IsDisabled() then
                self:SetColor( 1, 0.5, 0.5, 1 )
            end
        end )
        setupControl.name:SetHandler( "OnMouseExit", function( self )
            setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )
            ZO_Tooltips_HideTextTooltip()
            local color = 1
            if setup:IsDisabled() then
                color = 0.3
            end
            self:SetColor( color, color, color, 1 )
        end )
        setupControl.name:SetHandler( "OnMouseDown", function( self )
            self:SetColor( 0.8, 0.4, 0.4, 1 )
        end )
        setupControl.name:SetHandler( "OnMouseUp", function( self, mouseButton )
            if not MouseIsOver( self, 0, 0, 0, 0 ) then return end
            if mouseButton == MOUSE_BUTTON_INDEX_LEFT then
                WW.LoadSetupCurrent( index, false )
            end
        end )

        setupControl.dropdown:SetHandler( "OnClicked", function( self, mouseButton )
            if mouseButton == MOUSE_BUTTON_INDEX_LEFT then
                if IsMenuVisible() then
                    ClearMenu()
                else
                    WWG.ShowSetupContextMenu( setupControl.name, index )
                end
            end
        end )
        setupControl.modify:SetEnabled( not (WW.selection.zone.tag == "SUB") and not (WW.selection.zone.tag == "DG") )
        setupControl.modify:SetHandler( "OnClicked", function( self )
            WWG.ShowModifyDialog( setupControl, index )
        end )
        setupControl.save:SetHandler( "OnClicked", function( self )
            WW.SaveSetup( WW.selection.zone, WW.selection.pageId, index )
            setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )
            WWG.RefreshSetup( setupControl, setup )
        end )
        setupControl.preview:SetHandler( "OnClicked", function( self )
            WW.preview.ShowPreviewFromSetup( setup, WW.selection.zone.name )
        end )
        setupControl.banking:SetHandler( "OnClicked", function( self )
            if IsShiftKeyDown() then
                WW.banking.DepositSetup( WW.selection.zone, WW.selection.pageId, index )
            else
                WW.banking.WithdrawSetup( WW.selection.zone, WW.selection.pageId, index )
            end
        end )

        for hotbarCategory = 0, 1 do
            for slotIndex = 3, 8 do
                local skillControl = setupControl.skills[ hotbarCategory ][ slotIndex ]
                local function OnSkillDragStart( self )
                    if IsUnitInCombat( "player" ) then return end -- would fail at protected call anyway
                    if GetCursorContentType() ~= MOUSE_CONTENT_EMPTY then return end

                    setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )

                    local abilityId = setup:GetSkills()[ hotbarCategory ][ slotIndex ]
                    if not abilityId then return end

                    local baseAbilityId = WW.GetBaseAbilityId( abilityId )
                    if not baseAbilityId then return end

                    local skillType, skillLine, skillIndex = GetSpecificSkillAbilityKeysByAbilityId( baseAbilityId )
                    if CallSecureProtected( skillIndex, skillType, skillLine, "PickupAbilityBySkillLine" ) then
                        setup:SetSkill( hotbarCategory, slotIndex, 0 )
                        setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )
                        self:GetHandler( "OnMouseExit" )()
                        WWG.RefreshSetup( setupControl, setup )
                    end
                end
                local function OnSkillDragReceive( self )
                    if GetCursorContentType() ~= MOUSE_CONTENT_ACTION then return end
                    local abilityId = GetCursorAbilityId()

                    local progression = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId( abilityId )
                    if not progression then return end

                    if progression:IsUltimate() and slotIndex < 8 or
                        not progression:IsUltimate() and slotIndex > 7 then
                        -- Prevent ult on normal slot and vice versa
                        return
                    end

                    if progression:IsChainingAbility() then
                        abilityId = GetEffectiveAbilityIdForAbilityOnHotbar( abilityId, hotbarCategory )
                    end

                    ClearCursor()

                    setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )

                    local previousAbilityId = setup:GetSkills()[ hotbarCategory ][ slotIndex ]
                    setup:SetSkill( hotbarCategory, slotIndex, abilityId )
                    setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )

                    self:GetHandler( "OnMouseExit" )()
                    WWG.RefreshSetup( setupControl, setup )

                    if previousAbilityId and previousAbilityId > 0 then
                        local baseAbilityId = WW.GetBaseAbilityId( previousAbilityId )
                        local skillType, skillLine, skillIndex = GetSpecificSkillAbilityKeysByAbilityId( baseAbilityId )
                        CallSecureProtected( "PickupAbilityBySkillLine", skillType, skillLine, skillIndex )
                    end
                end
                skillControl:SetHandler( "OnReceiveDrag", OnSkillDragReceive )
                skillControl:SetHandler( "OnMouseUp", function( self )
                    if MouseIsOver( self, 0, 0, 0, 0 ) then
                        OnSkillDragReceive( self )
                    end
                end )
                skillControl:SetHandler( "OnDragStart", OnSkillDragStart )
            end
        end

        local function OnFoodDrag( self )
            local cursorContentType = GetCursorContentType()
            if cursorContentType ~= MOUSE_CONTENT_INVENTORY_ITEM then return false end

            local bagId = GetCursorBagId()
            local slotIndex = GetCursorSlotIndex()

            local foodLink = GetItemLink( bagId, slotIndex, LINK_STYLE_DEFAULT )
            local foodId = GetItemLinkItemId( foodLink )

            if not WW.BUFFFOOD[ foodId ] then
                WW.Log( GetString( WW_MSG_NOTFOOD ), WW.LOGTYPES.ERROR )
                return false
            end

            setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )

            WW.SaveFood( setup, slotIndex )
            setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )

            self:GetHandler( "OnMouseExit" )()
            WWG.RefreshSetup( setupControl, setup )
            self:GetHandler( "OnMouseEnter" )()

            ClearCursor()
            return true
        end
        setupControl.food:SetHandler( "OnReceiveDrag", OnFoodDrag )
        setupControl.food:SetHandler( "OnClicked", function( self, mouseButton )
            setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )
            if OnFoodDrag( self ) then return end
            if mouseButton == MOUSE_BUTTON_INDEX_LEFT then
                if IsShiftKeyDown() then
                    WW.SaveFood( setup )
                    setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )
                    self:GetHandler( "OnMouseExit" )()
                    WWG.RefreshSetup( setupControl, setup )
                    self:GetHandler( "OnMouseEnter" )()
                elseif IsControlKeyDown() or IsCommandKeyDown() then
                    setup:SetFood( {} )
                    setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )
                    ZO_Tooltips_HideTextTooltip()
                    self:GetHandler( "OnMouseExit" )()
                    WWG.RefreshSetup( setupControl, setup )
                    self:GetHandler( "OnMouseEnter" )()
                else
                    WW.EatFood( setup )
                end
            end
        end )

        local function OnGearDrag( self )
            local cursorContentType = GetCursorContentType()
            if cursorContentType ~= MOUSE_CONTENT_INVENTORY_ITEM and
                cursorContentType ~= MOUSE_CONTENT_EQUIPPED_ITEM then
                return false
            end

            local bagId = GetCursorBagId()
            local slotIndex = GetCursorSlotIndex()

            local itemLink = GetItemLink( bagId, slotIndex, LINK_STYLE_DEFAULT )
            local equipType = GetItemLinkEquipType( itemLink )

            if not WW.GEARTYPE[ equipType ] then return false end
            local gearSlot = WW.GEARTYPE[ equipType ]

            if IsShiftKeyDown() then
                if gearSlot == EQUIP_SLOT_MAIN_HAND then
                    gearSlot = EQUIP_SLOT_BACKUP_MAIN
                elseif gearSlot == EQUIP_SLOT_RING1 then
                    gearSlot = EQUIP_SLOT_RING2
                elseif gearSlot == EQUIP_SLOT_POISON then
                    gearSlot = EQUIP_SLOT_BACKUP_POISON
                end
            end

            setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )

            local gearTable = setup:GetGear()

            if gearTable.mythic then
                local isMythic = WW.IsMythic( bagId, slotIndex )
                if isMythic and gearSlot ~= gearTable.mythic then
                    gearTable[ gearTable.mythic ] = {
                        [ "link" ] = "",
                        [ "id" ] = "0",
                    }
                    gearTable.mythic = gearSlot
                elseif not isMythic and gearSlot == gearTable.mythic then
                    gearTable[ gearTable.mythic ] = {
                        [ "link" ] = "",
                        [ "id" ] = "0",
                    }
                    gearTable.mythic = nil
                end
            end

            if gearSlot == EQUIP_SLOT_MAIN_HAND then
                gearTable[ EQUIP_SLOT_OFF_HAND ] = {
                    [ "link" ] = "",
                    [ "id" ] = "0",
                }
            elseif gearSlot == EQUIP_SLOT_BACKUP_MAIN then
                gearTable[ EQUIP_SLOT_BACKUP_OFF ] = {
                    [ "link" ] = "",
                    [ "id" ] = "0",
                }
            end

            gearTable[ gearSlot ] = {
                id = Id64ToString( GetItemUniqueId( bagId, slotIndex ) ),
                link = GetItemLink( bagId, slotIndex, LINK_STYLE_DEFAULT ),
            }

            if GetItemLinkItemType( gearTable[ gearSlot ].link ) == ITEMTYPE_TABARD then
                gearTable[ gearSlot ].creator = GetItemCreatorName( bagId, slotIndex )
            end

            setup:SetGear( gearTable )
            setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )

            self:GetHandler( "OnMouseExit" )()
            WWG.RefreshSetup( setupControl, setup )
            self:GetHandler( "OnMouseEnter" )()

            ClearCursor()
            return true
        end
        setupControl.gear:SetHandler( "OnReceiveDrag", OnGearDrag )
        setupControl.gear:SetHandler( "OnClicked", function( self, mouseButton )
            setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )
            if OnGearDrag( self ) then return end
            if mouseButton == MOUSE_BUTTON_INDEX_LEFT then
                if IsShiftKeyDown() then
                    WW.SaveGear( setup )
                    setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )
                    local tooltip = setup:GetGearText()
                    if tooltip and tooltip ~= "" then
                        ZO_Tooltips_ShowTextTooltip( self, RIGHT, tostring( tooltip ) )
                    end
                    WWG.RefreshSetup( setupControl, setup )
                elseif IsControlKeyDown() or IsCommandKeyDown() then
                    setup:SetGear( { mythic = nil } )
                    setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )
                    ZO_Tooltips_HideTextTooltip()
                    WWG.RefreshSetup( setupControl, setup )
                else
                    WW.LoadGear( setup )
                end
            end
        end )

        setupControl.skill:SetHandler( "OnClicked", function( self, mouseButton )
            setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )
            if mouseButton == MOUSE_BUTTON_INDEX_LEFT then
                if IsShiftKeyDown() then
                    WW.SaveSkills( setup )
                    setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )
                    local tooltip = setup:GetSkillsText()
                    if tooltip and tooltip ~= "" then
                        ZO_Tooltips_ShowTextTooltip( self, RIGHT, tostring( tooltip ) )
                    end
                    WWG.RefreshSetup( setupControl, setup )
                elseif IsControlKeyDown() or IsCommandKeyDown() then
                    setup:SetSkills( { [ 0 ] = {}, [ 1 ] = {} } )
                    setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )
                    ZO_Tooltips_HideTextTooltip()
                    WWG.RefreshSetup( setupControl, setup )
                else
                    WW.LoadSkills( setup )
                end
            end
        end )

        setupControl.cp:SetHandler( "OnClicked", function( self, mouseButton )
            setup = Setup:FromStorage( WW.selection.zone.tag, WW.selection.pageId, index )
            if mouseButton == MOUSE_BUTTON_INDEX_LEFT then
                if IsShiftKeyDown() then
                    WW.SaveCP( setup )
                    setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )
                    local tooltip = setup:GetCPText()
                    if tooltip and tooltip ~= "" then
                        ZO_Tooltips_ShowTextTooltip( self, RIGHT, tostring( tooltip ) )
                    end
                    WWG.RefreshSetup( setupControl, setup )
                elseif IsControlKeyDown() or IsCommandKeyDown() then
                    setup:SetCP( {} )
                    setup:ToStorage( WW.selection.zone.tag, WW.selection.pageId, index )
                    ZO_Tooltips_HideTextTooltip()
                    WWG.RefreshSetup( setupControl, setup )
                else
                    WW.LoadCP( setup )
                end
            end
        end )

        return setupControl
    end

    function WWG.BuildPage( zone, pageId, scroll )
        WWG.ClearPage()
        for entry in WW.PageIterator( zone, pageId ) do
            local setup = Setup:FromStorage( zone.tag, pageId, entry.index )
            local control = WWG.AquireSetupControl( setup )
        end
        if (zone.tag == "SUB" or zone.tag == "DG") and #WWG.setupTable == 0 then
            WWG.CreateDefaultSetups( zone, pageId )
            WWG.BuildPage( zone, pageId )
            return
        end
        WWG.RefreshPage()
        WWG.OnWindowResize( "stop" )
        WW.conditions.LoadConditions()
        if scroll then
            ZO_Scroll_ResetToTop( WizardsWardrobeWindowSetupList )
        end
    end

    function WWG.ShowPageContextMenu( control )
        local zone = WW.selection.zone
        local pageId = WW.selection.pageId

        ClearMenu()

        AddMenuItem( GetString( WW_BUTTON_RENAME ), function() WWG.RenamePage() end, MENU_ADD_OPTION_LABEL )

        if WW.selection.zone.tag ~= "SUB" and WW.selection.zone.tag ~= "DG" then
            AddMenuItem( GetString( WW_BUTTON_REARRANGE ), function() WWG.ShowArrangeDialog( zone, pageId ) end,
                MENU_ADD_OPTION_LABEL )
        end

        AddMenuItem( GetString( WW_DUPLICATE ), function() WWG.DuplicatePage() end, MENU_ADD_OPTION_LABEL )

        local deleteColor = #WW.pages[ zone.tag ] > 1 and ZO_ColorDef:New( 1, 0, 0, 1 ) or ZO_ColorDef:New( 0.35, 0.35, 0.35, 1 )
        AddMenuItem( GetString( WW_DELETE ):upper(), function()
                         if #WW.pages[ zone.tag ] > 1 then
                             local pageName = WW.pages[ zone.tag ][ pageId ].name
                             WWG.ShowConfirmationDialog( "DeletePageConfirmation",
                                                         string.format( GetString( WW_DELETEPAGE_WARNING ), pageName ),
                                                         function()
                                                             WWG.DeletePage()
                                                         end )
                         end
                     end, MENU_ADD_OPTION_LABEL, "ZoFontGameBold", deleteColor, deleteColor )

        -- lets fix some ZOS bugs(?)
        if control:GetWidth() >= ZO_Menu.width then
            ZO_Menu.width = control:GetWidth() - 10
        end

        ShowMenu( control, 2, MENU_TYPE_COMBO_BOX )
        SetMenuPad( 100 )
        AnchorMenu( control, 0 )
    end

    function WWG.ShowSetupContextMenu( control, index )
        local zone = WW.selection.zone
        local pageId = WW.selection.pageId

        ClearMenu()

        -- LINK TO CHAT
        AddMenuItem( GetString( SI_ITEM_ACTION_LINK_TO_CHAT ), function()
                         WW.preview.PrintPreviewString( zone, pageId, index )
                     end, MENU_ADD_OPTION_LABEL )

        -- CUSTOM CODE
        AddMenuItem( GetString( WW_CUSTOMCODE ), function() WW.code.ShowCodeDialog( zone, pageId, index ) end,
            MENU_ADD_OPTION_LABEL )

        -- IMPORT / EXPORT
        AddMenuItem( GetString( WW_IMPORT ), function() WW.transfer.ShowImportDialog( zone, pageId, index ) end,
            MENU_ADD_OPTION_LABEL )
        AddMenuItem( GetString( WW_EXPORT ), function() WW.transfer.ShowExportDialog( zone, pageId, index ) end,
            MENU_ADD_OPTION_LABEL )

        -- ENABLE / DISABLE
        --if setup:IsDisabled() then
        --	AddMenuItem(GetString(WW_ENABLE), function() WWG.SetSetupDisabled(zone, pageId, index, false) end, MENU_ADD_OPTION_LABEL)
        --else
        --	AddMenuItem(GetString(WW_DISABLE), function() WWG.SetSetupDisabled(zone, pageId, index, true) end, MENU_ADD_OPTION_LABEL)
        --end

        -- DELETE
        AddMenuItem( GetString( WW_DELETE ):upper(), function()
                         PlaySound( SOUNDS.DEFER_NOTIFICATION )
                         if WW.selection.zone.tag == "SUB" or WW.selection.zone.tag == "DG" then
                             WW.ClearSetup( zone, pageId, index )
                         else
                             WW.DeleteSetup( zone, pageId, index )
                         end
                     end, MENU_ADD_OPTION_LABEL, "ZoFontGameBold", ZO_ColorDef:New( 1, 0, 0, 1 ), ZO_ColorDef:New( 1, 0, 0, 1 ) )

        -- lets fix some ZOS bugs(?)
        if control:GetWidth() >= ZO_Menu.width then
            ZO_Menu.width = control:GetWidth() - 10
        end

        ShowMenu( control, 2, MENU_TYPE_COMBO_BOX )
        SetMenuPad( 100 )
        AnchorMenu( control, 0 )
    end
end

local function overrideConst()
    WW.BUFFFOOD = {
        [64711] = 68411,	-- Crown Fortifying Meal
        [64712] = 68416,	-- Crown Refreshing Drink
        [68233] = 61259,	-- Garlic-and-Pepper Venison Steak
        [68234] = 61259,	-- Millet and Beef Stuffed Peppers
        [68235] = 61259,	-- Lilmoth Garlic Hagfish
        [68236] = 61260,	-- Firsthold Fruit and Cheese Plate
        [68237] = 61260,	-- Thrice-Baked Gorapple Pie
        [68238] = 61260,	-- Tomato Garlic Chutney
        [68239] = 61261,	-- Hearty Garlic Corn Chowder
        [68240] = 61261,	-- Bravil's Best Beet Risotto
        [68241] = 61261,	-- Tenmar Millet-Carrot Couscous
        [68242] = 61257,	-- Mistral Banana-Bunny Hash
        [68243] = 61257,	-- Melon-Baked Parmesan Pork
        [68244] = 61257,	-- Solitude Salmon-Millet Soup
        [68245] = 61255,	-- Sticky Pork and Radish Noodles
        [68246] = 61255,	-- Garlic Cod with Potato Crust
        [68247] = 61255,	-- Braised Rabbit with Spring Vegetables
        [68248] = 61294,	-- Chevre-Radish Salad with Pumpkin Seeds
        [68249] = 61294,	-- Grapes and Ash Yam Falafel
        [68250] = 61294,	-- Late Hearthfire Vegetable Tart
        [68251] = 61218,	-- Capon Tomato-Beet Casserole
        [68252] = 61218,	-- Jugged Rabbit in Preserves
        [68253] = 61218,	-- Longfin Pasty with Melon Sauce
        [68254] = 61218,	-- Withered Tree Inn Venison Pot Roast
        [68255] = 61322,	-- Kragenmoor Zinger Mazte
        [68256] = 61322,	-- Colovian Ginger Beer
        [68257] = 61322,	-- Markarth Mead
        [68258] = 61325,	-- Heart's Day Rose Tea
        [68259] = 61325,	-- Soothing Bard's-Throat Tea
        [68260] = 61325,	-- Muthsera's Remorse
        [68261] = 61328,	-- Fredas Night Infusion
        [68262] = 61328,	-- Old Hegathe Lemon Kaveh
        [68263] = 61328,	-- Hagraven's Tonic
        [68264] = 61335,	-- Port Hunding Pinot Noir
        [68265] = 61335,	-- Dragontail Blended Whisky
        [68266] = 61335,	-- Bravil Bitter Barley Beer
        [68267] = 61340,	-- Wide-Eye Double Rye
        [68268] = 61340,	-- Camlorn Sweet Brown Ale
        [68269] = 61340,	-- Flowing Bowl Green Port
        [68270] = 61345,	-- Honest Lassie Honey Tea
        [68271] = 61345,	-- Rosy Disposition Tonic
        [68272] = 61345,	-- Cloudrest Clarified Coffee
        [68273] = 61350,	-- Senche-Tiger Single Malt
        [68274] = 61350,	-- Velothi View Vintage Malbec
        [68275] = 61350,	-- Orcrest Agony Pale Ale
        [68276] = 61350,	-- Lusty Argonian Maid Mazte
        [71056] = 72816,	-- Orzorga's Red Frothgar
        [71057] = 72819,	-- Orzorga's Tripe Trifle Pocket
        [71058] = 72822,	-- Orzorga's Blood Price Pie
        [71059] = 72824,	-- Orzorga's Smoked Bear Haunch
        [87685] = 84678,	-- Sweet Sanguine Apples
        [87686] = 84681,	-- Crisp and Crunchy Pumpkin Snack Skewer
        [87687] = 84700,	-- Bowl of "Peeled Eyeballs"
        [87690] = 84704,	-- Witchmother's Party Punch
        [87691] = 84709,	-- Crunchy Spider Skewer
        [87695] = 84720,	-- Ghastly Eye Bowl
        [87696] = 84725,	-- Frosted Brains
        [87697] = 84731,	-- Witchmother's Potent Brew
        [87699] = 84735,	-- Purifying Bloody Mara
        [94437] = 85484,	-- Crown Crate Fortifying Meal
        [94438] = 85497,	-- Crown Crate Refreshing Drink
        [101879] = 86559,	-- Hissmir Fish-Eye Rye
        [112425] = 86673,	-- Lava Foot Soup-and-Saltrice
        [112426] = 86677,	-- Bergama Warning Fire
        [112433] = 86746,	-- Betnikh Twice-Spiked Ale
        [112434] = 86749,	-- Jagga-Drenched "Mud Ball"
        [112435] = 84678,	-- Old Aldmeri Orphan Gruel
        [112438] = 86787,	-- Rajhin's Sugar Claws
        [112439] = 86789,	-- Alcaire Festival Sword-Pie
        [112440] = 86791,	-- Snow Bear Glow-Wine
        [120436] = 84678,	-- Princess's Delight
        [120762] = 89955,	-- Candied Jester's Coins
        [120763] = 89957,	-- Dubious Camoran Throne
        [120764] = 89971,	-- Jewels of Misrule
        [133554] = 100502,	-- Deregulated Mushroom Stew
        [133555] = 100488,	-- Spring-Loaded Infusion
        [133556] = 100498,	-- Clockwork Citrus Filet
        [139016] = 107748,	-- Artaeum Pickled Fish Bowl
        [139018] = 107789,	-- Artaeum Takeaway Broth
        [153625] = 127531,	-- Corrupting Bloody Mara
        [153627] = 127572,	-- Pack Leader's Bone Broth
        [153629] = 127596,	-- Bewitched Sugar Skulls
        [171322] = 148633,	-- Sparkling Mudcrab Apple Cider
    }
end

local function Init()
    if WW == nil then return end
    overrideFuncs()
    overrideConst()
end

local function OnAddOnLoaded(_, addonName)
	if addonName ~= WWNS.name then return end
    EVENT_MANAGER:UnregisterForEvent(WWNS.name, EVENT_ADD_ON_LOADED)
    Init()
end

EVENT_MANAGER:RegisterForEvent(WWNS.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)