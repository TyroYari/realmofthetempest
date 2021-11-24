/*=============================================================================
 * ROTT_UI_Scene_Game_Over
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene is displayed when the player loses a combat 
 * scenario.
 *===========================================================================*/

class ROTT_UI_Scene_Game_Over extends ROTT_UI_Scene;

var private ROTT_UI_Page gameOverPage;

/*=============================================================================
 * loadScene()
 *
 * Called when switching to this scene
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  // Camera setting
  gameInfo.tempestPawn.overrideCamera(overrideCamLoc, overrideCamRot);
  
  // UI
  gameOverPage = ROTT_UI_Page(findComp("Page_Game_Over"));
  pushPage(gameOverPage);
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Controls
  bAllowOverWorldControl=false
  
  // Camera
  overrideCamLoc=(x=97.90, y=-2055.0, z=559.50)
  overrideCamRot=(pitch=-4555, yaw=9363, roll=0))
  
  // Title Page
  begin object class=ROTT_UI_Page_Game_Over Name=Page_Game_Over
    tag="Page_Game_Over"
    bEnabled=true
  end object
  pageComponents.add(Page_Game_Over)
  
  
}









