/*=============================================================================
 * ROTT_UI_Page_Information_Menu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The menu for using the Information service.
 *===========================================================================*/
 
class ROTT_UI_Page_Information_Menu extends ROTT_UI_Page;

// Internal references

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}
event onUnfocusMenu() {
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  
}

/*=============================================================================
 * refresh()
 *
 * Should be called when any changes occur to the UI.
 *===========================================================================*/
public function refresh() {
  
}

/*============================================================================*
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  
}

protected function navigationRoutineB() {
  // Navigate back to NPC
  parentScene.popPage();
  sceneManager.switchScene(SCENE_NPC_DIALOG);
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*============================================================================*
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft() {
  // Update display
  refresh();
}

public function onNavigateRight() {
  // Update display
  refresh();
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
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
  begin object class=UI_Texture_Info Name=Menu_Background
    componentTextures.add(Texture2D'GUI.Information_Background')
  end object
  
  /** ===== Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Information_Menu_Background
    tag="Information_Menu_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Menu_Background
  end object
  componentList.add(Information_Menu_Background)
  
  
}





