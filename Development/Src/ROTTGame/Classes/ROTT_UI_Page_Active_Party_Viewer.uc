/*=============================================================================
 * ROTT_UI_Page_Active_Party_Viewer
 *    
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The party viewer shows info about a party selected through
 * the party manager scene.
 *===========================================================================*/
 
class ROTT_UI_Page_Active_Party_Viewer extends ROTT_UI_Page;

// Internal references
var privatewrite ROTT_UI_Displayer_Team_Info teamInfo;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  teamInfo = ROTT_UI_Displayer_Team_Info(findComp("Team_Info_Displayer"));
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  teamInfo.attachDisplayer(ROTT_UI_Scene_Party_Manager(outer).getSelectedParty());
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineB() {
  parentScene.popPage();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}


/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Culling
  cullTags.add("Party_Info_Container")
  
  /** ===== Input ===== **/  
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Team_Viewer_Background
    componentTextures.add(Texture2D'GUI.Party_Mgmt_Window')
  end object
  
  /** ===== UI Components ===== **/
  // Window
  begin object class=UI_Sprite Name=Team_Viewer_Window
    tag="Team_Viewer_Window"
    bEnabled=true
    posX=720
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Team_Viewer_Background
  end object
  componentList.add(Team_Viewer_Window)
  
  // Status description
  begin object class=UI_Label Name=Team_Viewer_Status_Description
    tag="Team_Viewer_Status_Description"
    posX=720
    posY=189
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="You are currently controlling this team."
  end object
  componentList.add(Team_Viewer_Status_Description)
  
  // Team Info Displayer
  begin object class=ROTT_UI_Displayer_Team_Info Name=Team_Info_Displayer
    tag="Team_Info_Displayer"
    bEnabled=true
    posX=0    
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
  end object
  componentList.add(Team_Info_Displayer)
  
}



