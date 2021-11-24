/*=============================================================================
 * ROTT_UI_Scene_Character_Creation
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This screen is displayed when a new game is made, and when a
 * new character is unlocked, etc.
 *===========================================================================*/

class ROTT_UI_Scene_Character_Creation extends ROTT_UI_Scene;

var privatewrite ROTT_UI_Page_Character_Creation characterCreationPage;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  characterCreationPage = ROTT_UI_Page_Character_Creation(findComp("Character_Selection_Page"));
  
}

/*=============================================================================
 * loadScene()
 *
 * Called when switching to this scene
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  pushPage(characterCreationPage);
}

defaultProperties 
{
  bAllowOverWorldControl=false
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  // Title Page
  begin object class=ROTT_UI_Page_Character_Creation Name=Character_Selection_Page
    tag="Character_Selection_Page"
    bEnabled=true
  end object
  pageComponents.add(Character_Selection_Page)
  
}














