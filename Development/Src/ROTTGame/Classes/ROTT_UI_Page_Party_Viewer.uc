/*=============================================================================
 * ROTT_UI_Page_Party_Viewer
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The party viewer shows info about a party selected through
 * the party manager scene.
 *===========================================================================*/
 
class ROTT_UI_Page_Party_Viewer extends ROTT_UI_Page;

enum MenuOptions {
  SET_ACTIVITY,
  TAKE_CONTROL
};

var privatewrite ROTT_UI_Scene_Party_Manager teamManagerScene;

// Internal references
var privatewrite ROTT_UI_Displayer_Team_Info teamInfo;
var privatewrite UI_Selector selector;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  teamManagerScene = ROTT_UI_Scene_Party_Manager(outer);
  
  // Internal references
  selector = UI_Selector(findComp("Selection_Box"));
  teamInfo = ROTT_UI_Displayer_Team_Info(findComp("Team_Info_Displayer"));
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  local ROTT_Party party;
  
  // Get party info
  party = teamManagerScene.getSelectedParty();
  
  // Team information
  teamInfo.attachDisplayer(party);
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  // Selector settings
  selector.resetSelection();
  selector.setActive(true);
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  switch (selector.getSelection()) {
    case SET_ACTIVITY:
      // Push activity scene
      teamManagerScene.shrineManagementPage.targetParty = teamManagerScene.getSelectedParty();
      teamManagerScene.pushPage(teamManagerScene.shrineManagementPage);
      
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case TAKE_CONTROL:
      // Set the party under active player control
      gameInfo.playerProfile.partySystem.setActiveParty(teamManagerScene.getSelectedParty().partyIndex);
      
      // Navigate back
      teamManagerScene.popPage();
      teamManagerScene.refresh();
      
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
  }
}

protected function navigationRoutineB() {
  teamManagerScene.popPage(tag);
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Culling
  cullTags.add("Party_Info_Container")
  
  // Relative draw position
  bDrawRelative=true
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
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
    labelText="This team awaits your command."
  end object
  componentList.add(Team_Viewer_Status_Description)
  
  // Button: "Shrine"
  begin object class=UI_Sprite Name=Button_Shrine_Sprite
    tag="Button_Shrine_Sprite"
    posX=852
    posY=544
    
    // Texture
    begin object class=UI_Texture_Info Name=Button_Shrine
      componentTextures.add(Texture2D'GUI.Button_Shrine')
    end object

    images(0)=Button_Shrine
  end object
  componentList.add(Button_Shrine_Sprite)
  
  // Button: "Control"
  begin object class=UI_Sprite Name=Button_Control_Sprite
    tag="Button_Control_Sprite"
    posX=852
    posY=624
    
    // Texture
    begin object class=UI_Texture_Info Name=Button_Control
      componentTextures.add(Texture2D'GUI.Button_Control')
    end object
    
    images(0)=Button_Control
  end object
  componentList.add(Button_Control_Sprite)
  
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
  
  // Selection Box
  begin object class=UI_Selector Name=Selection_Box
    tag="Selection_Box"
    bEnabled=true
    posX=864
    posY=552
    selectionOffset=(x=0,y=80)
    numberOfMenuOptions=2
    hoverCoords(0)=(xStart=863,yStart=554,xEnd=1301,yEnd=620)
    hoverCoords(1)=(xStart=863,yStart=624,xEnd=1301,yEnd=700)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Mgmt_Window_Selector')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Selection_Box)
  
}



