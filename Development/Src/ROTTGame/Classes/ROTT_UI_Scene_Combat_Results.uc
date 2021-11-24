/*=============================================================================
 * ROTT_UI_Scene_Combat_Results
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene displays the results from a combat scenario.
 *===========================================================================*/

class ROTT_UI_Scene_Combat_Results extends ROTT_UI_Scene;

// Page references
var privatewrite ROTT_UI_Page_Combat_Victory pageCombatVictory;
var privatewrite ROTT_UI_Page_Combat_Analysis pageCombatAnalysis;

// Page transfering mechanics
var public bool bLevelUpTransfer;
var public bool bLootPending;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal menu references
  pageCombatVictory = ROTT_UI_Page_Combat_Victory(findComp("Page_Combat_Victory"));
  pageCombatAnalysis = ROTT_UI_Page_Combat_Analysis(findComp("Page_Combat_Analysis"));
  
  pushPage(pageCombatVictory);
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  // Clear the stack
  while (pageStack.length != 0) {
    popPage();
  }
  
  // Transition into victory page
  pushPage(pageCombatVictory);
}

/*=============================================================================
 * transitionToHeroStats()
 *
 * Called to transition out from combat analysis to game menu hero stats
 * after level up.
 *===========================================================================*/
event transitionToHeroStats() {
  // Transition to level up stats
  gameInfo.sceneManager.transitioner.setTransition(
    TRANSITION_OUT,                              // Transition direction
    RIGHT_SWEEP_TRANSITION_OUT,                  // Sorting config
    ,                                            // Pattern reversal
    SCENE_GAME_MENU,                             // Destination scene
    ,                                            // Destination page
    ,                                            // Destination world
    ,                                            // Color
    ,                                            // Tile speed
    0.2f,                                        // Delay
    true,                                        // Input consumption
    ""
  );
  
  // Make menu navigate to hero
  gameInfo.sceneManager.sceneGameMenu.transitionToHeroStats();
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  // Victory Page
  begin object class=ROTT_UI_Page_Combat_Victory Name=Page_Combat_Victory
    tag="Page_Combat_Victory"
  end object
  pageComponents.add(Page_Combat_Victory)
  
  // Analysis Page
  begin object class=ROTT_UI_Page_Combat_Analysis Name=Page_Combat_Analysis
    tag="Page_Combat_Analysis"
  end object
  pageComponents.add(Page_Combat_Analysis)
  
}













