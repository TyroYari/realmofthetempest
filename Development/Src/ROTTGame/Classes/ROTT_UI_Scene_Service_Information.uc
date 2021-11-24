/*=============================================================================
 * ROTT_UI_Scene_Service_Information
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene manages the interface for the Merchant's bartering
 * service.  Items can be bought and sold here in exchange for gold and gems.
 *===========================================================================*/

class ROTT_UI_Scene_Service_Information extends ROTT_UI_Scene;

// Pages

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal references
  
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
}

/*=============================================================================
 * unloadScene()
 * 
 * Called when this scene will no longer be rendered.  Each page receives
 * a call for the onSceneDeactivation() event
 *===========================================================================*/
event unloadScene() {
  super.unloadScene();
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties 
{
  bResetOnLoad=true
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  /** ===== Pages ===== **/
  // Scene Background Page
  begin object class=ROTT_UI_Page_Information_Menu Name=Page_Information_Menu
    tag="Page_Information_Menu"
    bInitialPage=true
  end object
  pageComponents.add(Page_Information_Menu)
  
}









