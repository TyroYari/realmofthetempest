/*=============================================================================
 * ROTT_UI_Scene_Service_Necromancy
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene manages the interface for the Merchant's bartering
 * service.  Items can be bought and sold here in exchange for gold and gems.
 *===========================================================================*/

class ROTT_UI_Scene_Service_Necromancy extends ROTT_UI_Scene;

// Pages
var privatewrite ROTT_UI_Page_Necromancy_Menu necromancyMenu;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal references
  necromancyMenu = ROTT_UI_Page_Necromancy_Menu(findComp("Page_Necromancy_Menu"));
  
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
  // Necromancy Instructions
  begin object class=ROTT_UI_Page_Necromancy_Instructions Name=Page_Necromancy_Instructions
    tag="Page_Necromancy_Instructions"
    bInitialPage=true
  end object
  pageComponents.add(Page_Necromancy_Instructions)
  
  // Necromancy Menu
  begin object class=ROTT_UI_Page_Necromancy_Menu Name=Page_Necromancy_Menu
    tag="Page_Necromancy_Menu"
  end object
  pageComponents.add(Page_Necromancy_Menu)
  
}









