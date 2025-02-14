global function InitCharactersPanel

const int MAX_ROWS = 4
const int MAX_COLUMNS = 5

struct
{
	var                    	panel
	var                    	characterSelectInfoRui
	var					   	lobbyClassPerkInfoRui
	array<var>             	buttons
	var						topLegendRowAnchor
	var						botLegendRowAnchor
	var		   				assaultShelf
	var		   				reconShelf
	var		   				supportShelf
	var		   				controllerShelf
	var		   				assaultShelfRUI
	var		   				reconShelfRUI
	var		   				supportShelfRUI
	var		   				controllerShelfRUI
	array<var>             	roleButtons_Assault
	array<var>             	roleButtons_Recon
	array<var>             	roleButtons_Defense
	array<var>             	roleButtons_Support
	table<var, ItemFlavor> 	buttonToCharacter
	ItemFlavor ornull	   	presentedCharacter
	int						filterTabIndex
	var					   actionLabel
} file

void function InitCharactersPanel( var panel )
{
	file.panel = panel

	//file.characterSelectInfoRui = Hud_GetRui( Hud_GetChild( file.panel, "LobbyClassLegendInfo" ) )
	file.characterSelectInfoRui = Hud_GetRui( Hud_GetChild( file.panel, "CharacterSelectInfo" ) )
	file.lobbyClassPerkInfoRui = Hud_GetRui( Hud_GetChild( file.panel, "LobbyClassPerkInfo" ) )
	//file.assaultShelfRUI = Hud_GetRui(Hud_GetChild( file.panel, "assaultShelf" ))
	//file.reconShelfRUI = Hud_GetRui(Hud_GetChild( file.panel, "reconShelf" ))
	//file.supportShelfRUI = Hud_GetRui(Hud_GetChild( file.panel, "supportShelf" ))
	//file.controllerShelfRUI = Hud_GetRui(Hud_GetChild( file.panel, "controllerShelf" ))
     
                                                                                              
      
	file.buttons = GetPanelElementsByClassname( panel, "CharacterButtonClass" )
	file.roleButtons_Assault = GetPanelElementsByClassname( panel, "AssaultCharacterRoleButtonClass" )
	file.roleButtons_Recon = GetPanelElementsByClassname( panel, "ReconCharacterRoleButtonClass" )
	file.roleButtons_Defense = GetPanelElementsByClassname( panel, "DefenseCharacterRoleButtonClass" )
	file.roleButtons_Support = GetPanelElementsByClassname( panel, "SupportCharacterRoleButtonClass" )
	file.topLegendRowAnchor = Hud_GetChild( panel, "Top_List_Anchor" )
	file.botLegendRowAnchor = Hud_GetChild( panel, "Bot_List_Anchor" )
	file.assaultShelf = Hud_GetChild( file.panel, "assaultShelf" )
	file.reconShelf = Hud_GetChild( file.panel, "reconShelf" )
	file.supportShelf = Hud_GetChild( file.panel, "supportShelf" )
	file.controllerShelf = Hud_GetChild( file.panel, "controllerShelf" )

	file.buttons = GetPanelElementsByClassname( panel, "CharacterButtonClass" )

	SetPanelTabTitle( panel, "#LEGENDS" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharactersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharactersPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CharactersPanel_OnFocusChanged )

	foreach ( button in file.buttons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	foreach ( button in file.roleButtons_Assault )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	foreach ( button in file.roleButtons_Recon )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	foreach ( button in file.roleButtons_Defense )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	foreach ( button in file.roleButtons_Support )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	//AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#BUTTON_MARK_ALL_AS_SEEN_GAMEPAD", "#BUTTON_MARK_ALL_AS_SEEN_MOUSE", MarkAllCharacterItemsAsViewed, CharacterButtonNotFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, IsCharacterButtonFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_TOGGLE_LOADOUT", "#X_BUTTON_TOGGLE_LOADOUT", OpenFocusedCharacterSkillsDialog, IsCharacterButtonFocused )
	//AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_UNLOCK", "#Y_BUTTON_UNLOCK", OpenPurchaseCharacterDialogFromFocus, IsReadyAndFocusedCharacterLocked )
	AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_SET_FEATURED", "#Y_BUTTON_SET_FEATURED", SetFeaturedCharacterFromFocus, IsReadyAndNonfeaturedCharacterButtonFocused )

	//file.actionButton = Hud_GetChild( panel, "ActionButton" )
	//HudElem_SetRuiArg( file.actionButton, "bigText", "" )
	//HudElem_SetRuiArg( file.actionButton, "buttonText", "" )
	//HudElem_SetRuiArg( file.actionButton, "descText", "" )
	//HudElem_SetRuiArg( file.actionButton, "centerText", "#X_BUTTON_TOGGLE_LOADOUT" )
	//Hud_AddEventHandler( file.actionButton, UIE_CLICK, OpenFocusedCharacterSkillsDialog )

	file.actionLabel = Hud_GetChild( panel, "ActionLabel" )
	Hud_SetText( file.actionLabel, "#X_BUTTON_TOGGLE_LOADOUT" )
}

bool function CharacterButtonNotFocused()
{
	return !IsCharacterButtonFocused()
}


bool function IsReadyAndFocusedCharacterLocked()
{
	if ( !GRX_IsInventoryReady() )
		return false

	var focus = GetFocus()

	if ( focus in file.buttonToCharacter )
		return !GRX_IsItemOwnedByPlayer( file.buttonToCharacter[focus] )

	return false
}


bool function IsReadyAndNonfeaturedCharacterButtonFocused()
{
	if ( !GRX_IsInventoryReady() )
		return false

	var focus = GetFocus()

	if ( focus in file.buttonToCharacter )
		return file.buttonToCharacter[focus] != LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() )

	return false
}


bool function IsCharacterButtonFocused()
{
	if ( file.buttons.contains( GetFocus() ) )
		return true

	return false
}


void function SetFeaturedCharacter( ItemFlavor character )
{
	if ( !GRX_IsItemOwnedByPlayer( character ) )
		return

	foreach ( button in file.buttons )
	{
		if ( button in file.buttonToCharacter )
			Hud_SetSelected( button, file.buttonToCharacter[button] == character )
	}

	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character )

	EmitUISound( "UI_Menu_Legend_SetFeatured" )
}


void function JumpToStoreCharacterFromFocus( var button )
{
	var focus = GetFocus()

	JumpToStoreCharacterFromButton( focus )
}

void function JumpToStoreCharacterFromButton( var button )
{
	if ( button in file.buttonToCharacter )
		JumpToStoreCharacter( file.buttonToCharacter[button] )

	EmitUISound( "menu_accept" )
}

void function SetFeaturedCharacterFromButton( var button )
{
	if ( button in file.buttonToCharacter )
		SetFeaturedCharacter( file.buttonToCharacter[button] )
}

void function SetFeaturedCharacterFromFocus( var button )
{
	var focus = GetFocus()

	SetFeaturedCharacterFromButton( focus )
}


void function OpenFocusedCharacterSkillsDialog( var button )
{
	var focus = GetFocus()

	if ( file.buttons.contains( focus ) )
		OpenCharacterSkillsDialog( file.buttonToCharacter[focus] )
}


void function InitCharacterButtons()
{
	file.buttonToCharacter.clear()

	foreach ( button in file.buttons )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Assault )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Recon )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Defense )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Support )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	array<ItemFlavor> characters
	foreach ( ItemFlavor itemFlav in GetAllCharacters() )
	{
		bool isAvailable = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), itemFlav )
		if ( !isAvailable )
		{
			if ( !ItemFlavor_ShouldBeVisible( itemFlav, GetLocalClientPlayer() ) )
				continue
		}

		characters.append( itemFlav )
	}

	array<ItemFlavor> orderedCharacters = GetCharacterButtonOrder( characters, file.buttons.len() )
	array<var> characterButtons

                   
	int listGap = 90
	int buttonGap = 6
	int buttonWidth = 117

	UISize screenSize = GetScreenSize()

	float screenSizeXFrac =  screenSize.width / 1920.0
	float screenSizeYFrac =  screenSize.height / 1080.0

	float scaleFrac = min(screenSizeXFrac, screenSizeYFrac)

	int assaultLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.OFFENSE ).len()
	int reconLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.RECON ).len()
	int supportLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.SUPPORT ).len()
	int defenderLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.DEFENSE ).len()

	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.OFFENSE ) )
	{
		var button = file.roleButtons_Assault[index]
		CharacterClassButton_Init( button, character )
		int offset = (buttonWidth * index) + (buttonGap * index)
		Hud_SetX( button, offset * scaleFrac)
	}

	int topListOffset1 = (assaultLegendsAmount * buttonWidth) + ( (assaultLegendsAmount - 1) * buttonGap) + listGap

	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.RECON ) )
	{
		var button = file.roleButtons_Recon[index]
		CharacterClassButton_Init( button, character )
		int offset = topListOffset1 + (buttonWidth * index) + (buttonGap * index)
		Hud_SetX( button, offset * scaleFrac)
	}

	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.SUPPORT ) )
	{
		var button = file.roleButtons_Support[index]
		CharacterClassButton_Init( button, character )
		int offset = (buttonWidth * index) + (buttonGap * index)
		Hud_SetX( button, offset * scaleFrac)
	}

	int botListOffset1 = (supportLegendsAmount * buttonWidth) + ( (supportLegendsAmount - 1) * buttonGap) + listGap

	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.DEFENSE ) )
	{
		var button = file.roleButtons_Defense[index]
		CharacterClassButton_Init( button, character )
		int offset = botListOffset1 + (buttonWidth * index) + (buttonGap * index)
		Hud_SetX( button, offset * scaleFrac)
	}

	int topListFullWidth = (assaultLegendsAmount * buttonWidth) + ( (assaultLegendsAmount - 1) * buttonGap) + listGap + (reconLegendsAmount * buttonWidth) + ( (reconLegendsAmount - 1) * buttonGap)
	int botListFullWidth = botListOffset1 + (defenderLegendsAmount * buttonWidth) + ( (defenderLegendsAmount - 1) * buttonGap)

	Hud_SetX( file.topLegendRowAnchor, -(topListFullWidth/2) * scaleFrac)
	Hud_SetX( file.botLegendRowAnchor, -(botListFullWidth/2) * scaleFrac)

	//RuiSetFloat( file.assaultShelfRUI, "shelfWidth", float((assaultLegendsAmount * buttonWidth) + ( (assaultLegendsAmount - 1) * buttonGap)))
	//RuiSetColorAlpha( file.assaultShelfRUI, "shelfColor", SrgbToLinear(CharacterClass_GetRoleColor(1)), 1.0)
	//RuiSetString( file.assaultShelfRUI, "roleString", "#ROLE_ASSAULT" )
	//RuiSetImage( file.assaultShelfRUI, "roleIcon", $"rui/menu/character_select/utility/role_offense" )

	//RuiSetFloat( file.reconShelfRUI, "shelfWidth", float((reconLegendsAmount * buttonWidth) + ( (reconLegendsAmount - 1) * buttonGap)))
	//RuiSetColorAlpha( file.reconShelfRUI, "shelfColor", SrgbToLinear(CharacterClass_GetRoleColor(3)), 1.0)
	//RuiSetString( file.reconShelfRUI, "roleString", "#ROLE_RECON" )
	//RuiSetImage( file.reconShelfRUI, "roleIcon", $"rui/menu/character_select/utility/role_recon" )

	//RuiSetFloat( file.supportShelfRUI, "shelfWidth", float((supportLegendsAmount * buttonWidth) + ( (supportLegendsAmount - 1) * buttonGap)))
	//RuiSetColorAlpha( file.supportShelfRUI, "shelfColor", SrgbToLinear(CharacterClass_GetRoleColor(5)), 1.0)
	//RuiSetString( file.supportShelfRUI, "roleString", "#ROLE_SUPPORT" )
	//RuiSetImage( file.supportShelfRUI, "roleIcon", $"rui/menu/character_select/utility/role_support" )

	//RuiSetFloat( file.controllerShelfRUI, "shelfWidth", float((defenderLegendsAmount * buttonWidth) + ( (defenderLegendsAmount - 1) * buttonGap)))
	//RuiSetColorAlpha( file.controllerShelfRUI, "shelfColor", SrgbToLinear(CharacterClass_GetRoleColor(4)), 1.0)
	//RuiSetString( file.controllerShelfRUI, "roleString", "#ROLE_CONTROLLER" )
	//RuiSetImage( file.controllerShelfRUI, "roleIcon", $"rui/menu/character_select/utility/role_defense" )

	Hud_SetX( file.assaultShelf, (-buttonWidth/2) * scaleFrac)
	Hud_SetX( file.reconShelf, (-buttonWidth/2) * scaleFrac)
	Hud_SetX( file.supportShelf, (botListOffset1 -buttonWidth/2) * scaleFrac)
	Hud_SetX( file.controllerShelf, (botListOffset1 -buttonWidth/2) * scaleFrac)

	SetPerkLayoutNav ( orderedCharacters )
}

void function SetPerkLayoutNav (array<ItemFlavor> orderedCharacters)
{
	int assaultLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.OFFENSE ).len()
	int reconLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.RECON ).len()
	int supportLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.SUPPORT ).len()
	int defenderLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.DEFENSE ).len()
	                                   
	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.OFFENSE ) )
	{
		var button = file.roleButtons_Assault[index]

		            
		if (index < assaultLegendsAmount -1)
			Hud_SetNavRight(button, file.roleButtons_Assault[index + 1])
		else
			Hud_SetNavRight(button, file.roleButtons_Recon[0])

		           
		if (index != 0)
			Hud_SetNavLeft(button, file.roleButtons_Assault[index - 1])

		          
		if ( index <= supportLegendsAmount - 1 )
			Hud_SetNavDown(button, file.roleButtons_Support[0])
		else
			Hud_SetNavDown(button, file.roleButtons_Defense[0])
	}

	                                      
	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.RECON ) )
	{
		var button = file.roleButtons_Recon[index]

		            
		if (index < reconLegendsAmount -1)
			Hud_SetNavRight(button, file.roleButtons_Recon[index + 1])

		           
		if (index != 0)
			Hud_SetNavLeft(button, file.roleButtons_Recon[index - 1])
		else
			Hud_SetNavLeft(button, file.roleButtons_Assault[assaultLegendsAmount -1])

		          
		if ( index >= reconLegendsAmount - defenderLegendsAmount )
			Hud_SetNavDown(button, file.roleButtons_Defense[0])
		else
			Hud_SetNavDown(button, file.roleButtons_Support[supportLegendsAmount - 1])
	}

	                                   
	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.SUPPORT ) )
	{
		var button = file.roleButtons_Support[index]
		        
		if (index <= (supportLegendsAmount-1)/2)
			Hud_SetNavUp(button, file.roleButtons_Assault[assaultLegendsAmount -1])
		else
			Hud_SetNavUp(button, file.roleButtons_Assault[0])

		            
		if (index < supportLegendsAmount -1)
			Hud_SetNavRight(button, file.roleButtons_Support[index + 1])
		else
			Hud_SetNavRight(button, file.roleButtons_Defense[0])

		           
		if (index != 0)
			Hud_SetNavLeft(button, file.roleButtons_Support[index - 1])
		else
			Hud_SetNavLeft(button, file.roleButtons_Recon[reconLegendsAmount -1])
	}

	                                     
	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.DEFENSE ) )
	{
		var button = file.roleButtons_Defense[index]
		         
		if (defenderLegendsAmount <= reconLegendsAmount)
			Hud_SetNavUp(button, file.roleButtons_Recon[reconLegendsAmount - 1])
		else
			Hud_SetNavUp(button, file.roleButtons_Recon[0])

		            
		if (index < defenderLegendsAmount -1)
			Hud_SetNavRight(button, file.roleButtons_Defense[index + 1])

		           
		if (index != 0)
			Hud_SetNavLeft(button, file.roleButtons_Defense[index - 1])
		else
			Hud_SetNavLeft(button, file.roleButtons_Support[supportLegendsAmount -1])
	}
}


void function CharacterButton_Init( var button, ItemFlavor character )
{
	file.buttonToCharacter[button] <- character

	bool isLocked   = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character )
	bool isSelected = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() ) == character

	Hud_SetVisible( button, true )
	Hud_SetLocked( button, !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character ) )
	Hud_SetSelected( button, isSelected )

	RuiSetColorAlpha( Hud_GetRui( button ), "seasonColor", SrgbToLinear( <1.0, 1.0, 1.0> ), 1.0 )
	RuiSetString( Hud_GetRui( button ), "buttonText", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetImage( Hud_GetRui( button ), "buttonImage", CharacterClass_GetGalleryPortraitBackground( character ) )
	RuiSetImage( Hud_GetRui( button ), "bgImage", CharacterClass_GetGalleryPortraitBackground( character ) )
	RuiSetImage( Hud_GetRui( button ), "roleImage", CharacterClass_GetCharacterRoleImage( character ) )

	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )
}

void function CharacterClassButton_Init( var button, ItemFlavor character, bool addNewness = true)
{
	Hud_SetVisible( button, true )
	file.buttonToCharacter[button] <- character

	bool isSelected = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() ) == character

	Hud_SetVisible( button, true )
	Hud_SetLocked( button, !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character ) )
	Hud_SetSelected( button, isSelected )

	                              
	var buttonRui = Hud_GetRui( button )
	RuiSetImage( buttonRui, "portraitImage", CharacterClass_GetGalleryPortrait( character ) )
	RuiSetImage( buttonRui, "portraitBackground", CharacterClass_GetGalleryPortraitBackground( character ) )
	RuiSetString( buttonRui, "portraitName", Localize( ItemFlavor_GetLongName( character ) ) )
	RuiSetImage( buttonRui, "roleImage", CharacterClass_GetCharacterRoleImage( character ) )

	if( addNewness )
		Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )
}


void function CharactersPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_SELECT )

	ItemFlavor character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() )
	SetTopLevelCustomizeContext( character )
	PresentCharacter( character )

	InitCharacterButtons()
}


void function CharactersPanel_OnHide( var panel )
{
	if ( NEWNESS_QUERIES.isValid )
		foreach ( var button, ItemFlavor character in file.buttonToCharacter )
			if ( character in NEWNESS_QUERIES.CharacterButton ) // todo(dw): aaarggggghhhhh
				Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )

	SetTopLevelCustomizeContext( null )
	RunMenuClientFunction( "ClearAllCharacterPreview" )

	file.buttonToCharacter.clear()
}


void function CharactersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return

	if ( !newFocus || GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	ItemFlavor character
	if ( file.buttons.contains( newFocus )
			||file.roleButtons_Assault.contains( GetFocus() )
			|| file.roleButtons_Recon.contains( GetFocus() )
			|| file.roleButtons_Defense.contains( GetFocus() )
			|| file.roleButtons_Support.contains( GetFocus() ) )
	{
		character = file.buttonToCharacter[newFocus]
		if (newFocus != null)
		{	
			Hud_ScaleOverTime( newFocus, 1.15, 1.15,0.1, INTERPOLATOR_DEACCEL )
		}
	}
	else
		character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() )

	if ( file.buttons.contains( oldFocus )
			||file.roleButtons_Assault.contains( oldFocus )
			|| file.roleButtons_Recon.contains( oldFocus )
			|| file.roleButtons_Defense.contains( oldFocus )
			|| file.roleButtons_Support.contains( oldFocus ) )
	{
		if (oldFocus != null)
		{
			Hud_ReturnToBaseScaleOverTime( oldFocus, 0.1, INTERPOLATOR_DEACCEL )
		}
	}

	printt( ItemFlavor_GetHumanReadableRef( character ) )
	PresentCharacter( character )
}


void function CharacterButton_OnActivate( var button )
{
	ItemFlavor character = file.buttonToCharacter[button]
	SetTopLevelCustomizeContext( character )
	CustomizeCharacterMenu_SetCharacter( character )
	if ( GRX_IsItemOwnedByPlayer( character ) )
		RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character ) // TEMP, Some menu state is broken without this. Need Declan to look at why RefreshLoadoutSlotInternal doesn't run when editing a loadout that isn't the featured one before removing this.
	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	EmitUISound( "UI_Menu_Legend_Select" )
	AdvanceMenu( GetMenu( "CustomizeCharacterMenu" ) )
}


void function CharacterButton_OnRightClick( var button )
{
	OpenCharacterSkillsDialog( file.buttonToCharacter[button] )
}


void function CharacterButton_OnMiddleClick( var button )
{
	if ( Hud_IsLocked( button ) )
		JumpToStoreCharacterFromButton( button )
	else
		SetFeaturedCharacterFromButton( button )
}


void function PresentCharacter( ItemFlavor character )
{
	if ( file.presentedCharacter == character )
		return

	RuiSetString( file.characterSelectInfoRui, "nameText", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetString( file.characterSelectInfoRui, "subtitleText", Localize( CharacterClass_GetCharacterSelectSubtitle( character ) ) )
	RuiSetGameTime( file.characterSelectInfoRui, "initTime", Time() )

	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( character ) )
	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex_DEPRECATED( characterSkin ), ItemFlavor_GetNetworkIndex_DEPRECATED( character ) )

	file.presentedCharacter = character
}