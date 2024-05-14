# Wizard's Wardrobe Override

Dependencies:

[Wizard's Wardrobe](https://www.esoui.com/downloads/info3170-WizardsWardrobe.html)

[Wizard's Wardrobe Dungeons Extension](https://www.esoui.com/downloads/info3845-WizardsWardrobeDungeonsExtension.html)

## Removing icons

WizardsWardrobePreview.lua

    @@ function WWP.CreatePreviewWindow()

    line 201:
        --[[ -- ICON
            local iconBox = WINDOW_MANAGER:CreateControl(window:GetName() .. "Icon", preview, CT_CONTROL)
            iconBox:SetDimensions(270, 124)
            iconBox:SetAnchor(TOPLEFT, preview, TOPLEFT, 520, 50 + 102 + 10 + 60 + 10 + 346 + 10 + 2)
            local iconBoxBG = WINDOW_MANAGER:CreateControl(iconBox:GetName() .. "BG", iconBox, CT_BACKDROP)
            iconBoxBG:SetCenterColor(1, 1, 1, 0)
            iconBoxBG:SetEdgeColor(1, 1, 1, 1)
            iconBoxBG:SetEdgeTexture(nil, 1, 1, 1, 0)
            iconBoxBG:SetAnchorFill(iconBox)
            local icon = WINDOW_MANAGER:CreateControl(iconBox:GetName() .. "Icon", iconBox, CT_TEXTURE)
            icon:SetTexture("/WizardsWardrobe/assets/icon128.dds")
            icon:SetDimensions(80, 80)
            icon:SetAnchor(CENTER, iconBox, CENTER, 0, 0) ]]

WizardsWardrobeGui.lua

    @@ function WWG.SetSceneManagement()

    line 160:
        --[[ CALLBACK_MANAGER:RegisterCallback( "LAM-PanelControlsCreated", function( panel )
          if panel:GetName() ~= "WizardsWardrobeMenu" then return end
                local icon = WINDOW_MANAGER:CreateControl( "WizardsWardrobeMenuIcon", panel, CT_TEXTURE )
                icon:SetTexture( "/WizardsWardrobe/assets/icon64.dds" )
                icon:SetDimensions( 64, 64 )
                icon:SetAnchor( TOPRIGHT, panel, TOPRIGHT, -45, -25 )
            end ) ]]

WizardsWardrobe.xml

    line 10:
    <!-- <Texture name="$(parent)Icon" layer="CONTROLS" textureFile="/WizardsWardrobe/assets/icon64.dds" mouseEnabled="true">
    	<Dimensions x="46" y="46" />
    	<Anchor point="LEFT" relativeTo="$(parent)" relativePoint="LEFT" offsetX="10" />
    </Texture> -->
    <Label name="$(parent)TopLabel" font="ZoFontGameBold" verticalAlignment="TEXT_ALIGN_CENTER">
        <Anchor point="TOPLEFT" relativeTo="$(parent)" relativePoint="TOPLEFT" offsetX="10" offsetY="7" />
    </Label>
    <Label name="$(parent)MiddleLabel" font="ZoFontGameBold" verticalAlignment="TEXT_ALIGN_CENTER">
        <Anchor point="LEFT" relativeTo="$(parent)" relativePoint="LEFT" offsetX="10" />
    </Label>
    <Label name="$(parent)BottomLabel" font="ZoFontGameBold" verticalAlignment="TEXT_ALIGN_CENTER">
        <Anchor point="BOTTOMLEFT" relativeTo="$(parent)" relativePoint="BOTTOMLEFT" offsetX="10" offsetY="-7" />
    </Label>
