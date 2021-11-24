/*=============================================================================
 * ROTT_UI_Scene_Service_Bestiary
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene manages the enchantment minigame from the Dragon
 *  Tamer
 *===========================================================================*/

class ROTT_UI_Scene_Service_Bestiary extends ROTT_UI_Scene;

// Monster selection
var public ROTT_Combat_Enemy enemyList[6];
var private array<int> levelAmps;

// Pages
var privatewrite ROTT_UI_Page_Bestiary_Menu bestiaryMenu;

// Store bestiary content
var privatewrite ROTT_Resource_Bestiary_Seed bestiaryContent;
var privatewrite bool bestiaryLoaded;
var privatewrite bool bPendingReload;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal references
  bestiaryMenu = ROTT_UI_Page_Bestiary_Menu(findComp("Page_Bestiary_Menu"));
  
  // Game reference
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  // Reload after use of service
  if (bPendingReload) {
    reloadBestiary();
    bPendingReload = false;
  }
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
 * reloadBestiary()
 * 
 * Reloads the monster list using stored bestiary info
 *===========================================================================*/
public function reloadBestiary() {
  local SpawnerInfo spawnerStats;
  local array<int> bestiaryIndices;
  local int randomIndex;
  local int i;
  
  if (bestiaryContent == none) {
    yellowLog("Warning (!) No bestiary content provided");
    return;
  }
  
  // Set a list of bestiary indices
  for (i = 0; i < bestiaryContent.enemyClasses.length; i++) {
    bestiaryIndices.addItem(i);
  }
  
  for (i = 0; i < 6; i++) {
    // Set level info
    spawnerStats.levelRange.min = levelAmps[i] * (10 + gameInfo.getActiveParty().getHuntingProwess() / 420);
    spawnerStats.levelRange.max = spawnerStats.levelRange.min * 1.2;
    
    // Select random index
    randomIndex = bestiaryIndices[rand(bestiaryIndices.length)];
    
    // Generate enemies
    enemyList[i] = class'ROTT_Combat_Enemy'.static.generateMonster(
      bestiaryContent.enemyClasses[randomIndex],
      spawnerStats,
      SPAWN_CHAMPION
    );
    
    // Remove used index
    if (bestiaryContent.enemyClasses.length >= 6) {
      bestiaryIndices.removeItem(randomIndex);
    }
  }
}

/*=============================================================================
 * loadBestiary()
 * 
 * Given bestiary content, loads the monster list
 *===========================================================================*/
public function loadBestiary(ROTT_Resource_Bestiary_Seed bestiaryInfo) {
  // Check if already loaded content
  if (bestiaryLoaded) return;
  
  // Mark content has been loaded
  bestiaryLoaded = true;
  
  // Store content
  bestiaryContent = bestiaryInfo;
  
  // Reload monsters from given content
  reloadBestiary();
}

/*=============================================================================
 * combatTransition()
 * 
 * This pushes an effect to transition into combat
 *===========================================================================*/
public function combatTransition() {
  // Execute transition to combat
  gameInfo.sceneManager.transitioner.setTransition(
    TRANSITION_OUT,                              // Transition direction
    DOOR_PORTAL_TRANSITION_OUT,                  // Sorting config
    ,                                            // Pattern reversal
    SCENE_COMBAT_ENCOUNTER,                      // Destination scene
    ,                                            // Destination page
    ,                                            // Destination world
    ,                                            // Color
    10,                                          // Tile speed
    0.4f,                                        // Delay
    true,
    "Page_Combat_Transition"
  );
  
  // Mark for reload after service
  bPendingReload = true;
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties 
{
  bResetOnLoad=true
  
  levelAmps=(1,2,3,5,8,9)
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  /** ===== Pages ===== **/
  // Bestiary Instructions
  begin object class=ROTT_UI_Page_Bestiary_Instructions Name=Page_Bestiary_Instructions
    tag="Page_Bestiary_Instructions"
    bInitialPage=true
  end object
  pageComponents.add(Page_Bestiary_Instructions)
  
  // Bestiary Menu
  begin object class=ROTT_UI_Page_Bestiary_Menu Name=Page_Bestiary_Menu
    tag="Page_Bestiary_Menu"
  end object
  pageComponents.add(Page_Bestiary_Menu)
  
}









