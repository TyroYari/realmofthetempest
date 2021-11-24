/*=============================================================================
 * ROTT_UI_Party_Manager_Container
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This container displays info and status about a given party.
 *===========================================================================*/
 
class ROTT_UI_Party_Manager_Container extends UI_Container;

// Internal references
var private ROTT_UI_Party_Info_Panel infoContainer;
var private ROTT_UI_Party_Display partyDisplay;
var private UI_Sprite partyBackdrop;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Party Display
  partyDisplay = ROTT_UI_Party_Display(findComp("Party_Displayer"));

  // Party Display Backdrop
  partyBackdrop = findSprite("Party_Backdrop");
  
  // Party info panel
  infoContainer = ROTT_UI_Party_Info_Panel(findComp("Party_Info_Container"));
}

/*=============================================================================
 * renderPartyInfo()
 *
 * Takes a party as a paramter, and displays that party's status & info
 *===========================================================================*/
public function renderPartyInfo(ROTT_Party party) {
  // Visibility settings
  if (party == none) {
    setEnabled(false);
    return;
  }
  setEnabled(true);
  
  // Set party portrait displays
  partyDisplay.renderParty(party);
  
  // Set panel display info
  infoContainer.renderPartyInfo(party);
}

/*=============================================================================
 * renderSaveFile()
 *
 * Takes a party as a paramter, and displays save file information
 *===========================================================================*/
public function renderSaveFile(ROTT_Game_Player_Profile profile, optional int saveIndex = -1) {
  // Visibility settings
  if (profile == none) {
    setEnabled(false);
    return;
  }
  setEnabled(true);
  
  // Set party portrait displays
  partyDisplay.renderParty(profile.getActiveParty());
  
  // Set panel display info
  infoContainer.renderSaveInfo(profile, saveIndex);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Container draw settings
  bDrawRelative=true
  
  /** ===== Textures ===== **/
  // Party backdrop
  begin object class=UI_Texture_Info Name=Party_Member_Backdrops
    componentTextures.add(Texture2D'GUI.Party_Manager_Party_Member_Backdrops')
  end object
  
  /** ===== Components ===== **/
  // Backdrops
  begin object class=UI_Sprite Name=Party_Backdrop
    tag="Party_Backdrop"
    posX=-705
    posY=3
    images(0)=Party_Member_Backdrops
  end object
  componentList.add(Party_Backdrop)
  
  // Party Portraits Displayer
  begin object class=ROTT_UI_Party_Display Name=Party_Displayer
    tag="Party_Displayer" 
    xOffset=204
    posX=-701
    posY=3
    displayMode=MANAGER_PORTRAITS
  end object
  componentList.add(Party_Displayer)
  
  // Party Info Panel
  begin object class=ROTT_UI_Party_Info_Panel Name=Party_Info_Container
    tag="Party_Info_Container" 
  end object
  componentList.add(Party_Info_Container)
  
}
  