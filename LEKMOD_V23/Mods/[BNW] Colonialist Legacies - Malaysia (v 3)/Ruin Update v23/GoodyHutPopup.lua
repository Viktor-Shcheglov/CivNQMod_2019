-------------------------------------------------
-- Goody Hut Popup
-------------------------------------------------

local m_PopupInfo = nil;

-------------------------------------------------
-- On Display
-------------------------------------------------
function OnPopup( popupInfo )
	if( popupInfo.Type ~= ButtonPopupTypes.BUTTONPOPUP_GOODY_HUT_REWARD or popupInfo.Data4 ~= 1000000) then
		return;
	end
	
	m_PopupInfo = popupInfo;

    local iGoodyType = popupInfo.Data1;
    local pGoodyInfo;

	for row in DB.Query("SELECT Type, Description FROM AncientRuinsRewards WHERE ID = '" .. iGoodyType .. "'") do
		pGoodyInfo = row;
	end
	
	local strText = "";
	
	if (pGoodyInfo.Type == "GOODY_GOLD" or pGoodyInfo.Type == "GOODY_LOW_GOLD" or pGoodyInfo.Type == "GOODY_HIGH_GOLD") then
		local iGold = popupInfo.Data2;
		Controls.DescriptionLabel:SetText(Locale.ConvertTextKey(pGoodyInfo.Description, iGold));
	elseif (pGoodyInfo.Type == "GOODY_FAITH" or pGoodyInfo.Type == "GOODY_FOOD" or pGoodyInfo.Type == "GOODY_CULTURE" or pGoodyInfo.Type == "GOODY_PANTHEON_FAITH" or pGoodyInfo.Type == "GOODY_PROPHET_FAITH") then
		local iData = popupInfo.Data2;
		Controls.DescriptionLabel:SetText(Locale.ConvertTextKey(pGoodyInfo.Description, iData));
	elseif (pGoodyInfo.Type == "GOODY_SCIENCE" or pGoodyInfo.Type == "GOODY_PRODUCTION") then
		local iData = popupInfo.Data2;
		local iText = popupInfo.Text;
		Controls.DescriptionLabel:SetText(Locale.ConvertTextKey(pGoodyInfo.Description, iData, iText));
	else
		Controls.DescriptionLabel:SetText(Locale.ConvertTextKey(pGoodyInfo.Description));
	end
		
	UIManager:QueuePopup( ContextPtr, PopupPriority.GoodyHut );
end
Events.SerialEventGameMessagePopup.Add( OnPopup );


----------------------------------------------------------------        
-- Input processing
----------------------------------------------------------------        
function OnCloseButtonClicked ()
    UIManager:DequeuePopup( ContextPtr );
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnCloseButtonClicked );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN then
            OnCloseButtonClicked();
            return true;
        end
    end
end
ContextPtr:SetInputHandler( InputHandler );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function ShowHideHandler( bIsHide, bInitState )

    if( not bInitState ) then
        if( not bIsHide ) then
        	UI.incTurnTimerSemaphore();
        	Events.SerialEventGameMessagePopupShown(m_PopupInfo);
        else
            UI.decTurnTimerSemaphore();
            Events.SerialEventGameMessagePopupProcessed.CallImmediate(ButtonPopupTypes.BUTTONPOPUP_GOODY_HUT_REWARD, 0);
        end
    end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnCloseButtonClicked);
