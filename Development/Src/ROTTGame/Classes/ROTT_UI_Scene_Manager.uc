/*=============================================================================
 * ROTT_UI_Scene_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *  A scene is an independent collection of menus. 
 *  Only one scene can be rendered at a time.
 *  The scene manager is the interface for selecting which scene to render.
 *  + We also must be able to access information from any scene at any time?
 *===========================================================================*/

class ROTT_UI_Scene_Manager extends UI_Scene_Manager;

// External references
var privatewrite ROTT_Game_Info gameInfo; 

// UI Scenes
enum DisplayScenes {
  SCENE_TITLE_SCREEN,
  SCENE_SAVE_MANAGER,
  SCENE_CHARACTER_CREATION,
  SCENE_OVER_WORLD,
  SCENE_WORLD_MAP,
  SCENE_GAME_MENU,
  SCENE_GAME_MANAGER,
  SCENE_PARTY_MANAGER,
  SCENE_NPC_DIALOG,
  SCENE_SERVICE_BLESSINGS,
  SCENE_SERVICE_ALCHEMY,
  SCENE_SERVICE_BESTIARY,
  SCENE_SERVICE_BARTERING,
  SCENE_SERVICE_INFORMATION,
  SCENE_SERVICE_NECROMANCY,
  SCENE_SERVICE_LOTTERY,
  SCENE_SERVICE_SHRINE,
  SCENE_COMBAT_ENCOUNTER,
  SCENE_COMBAT_RESULTS,
  SCENE_GAME_OVER,
  SCENE_CREDITS,
  
  NO_SCENE
  
};

var privatewrite instanced array<ROTT_UI_Scene> uiScenes;

// The scene currently being rendered
var protectedwrite ROTT_UI_Scene scene;

// Note: Individual scenes are stored to avoid tedious type casting
// Index corresponding to which scene is being drawn to screen
var privatewrite DisplayScenes currentSceneType;

// Title Screen
var privatewrite ROTT_UI_Scene_Title_Screen sceneTitleScreen;

// Save Manager
var privatewrite ROTT_UI_Scene_Save_Manager sceneSaveManager;

// Character Creation
var privatewrite ROTT_UI_Scene_Character_Creation sceneCharacterCreation;

// Over World
var privatewrite ROTT_UI_Scene_Over_World sceneOverWorld;

// World map
var privatewrite ROTT_UI_Scene_World_Map sceneWorldMap;

// Game Menu
var privatewrite ROTT_UI_Scene_Game_Menu sceneGameMenu;

// Game Manager
var privatewrite ROTT_UI_Scene_Game_Manager sceneGameManager;

// Party Manager
var privatewrite ROTT_UI_Scene_Party_Manager scenePartyManager;

// Game Manager
var privatewrite ROTT_UI_Scene_Npc_Dialog sceneNpcDialog;

// Blessing services
var privatewrite ROTT_UI_Scene_Service_Blessings sceneServiceBlessing;

// Shrine services
var privatewrite ROTT_UI_Scene_Service_Shrine sceneServiceShrine;

// Alchemy Mini Game
var privatewrite ROTT_UI_Scene_Service_Alchemy sceneMiniGame;

// Barter Service (Merchant)
var privatewrite ROTT_UI_Scene_Service_Barter sceneBarter;

// Bestiary Service (Dragon Tamer)
var privatewrite ROTT_UI_Scene_Service_Bestiary sceneBestiary;

// Information Service (Prince)
var privatewrite ROTT_UI_Scene_Service_Information sceneInformation;

// Lottery Service (Witch)
var privatewrite ROTT_UI_Scene_Service_Lottery sceneLottery;

// Necromancy Service
var privatewrite ROTT_UI_Scene_Service_Necromancy sceneNecromancy;

// Combat
var privatewrite ROTT_UI_Scene_Combat_Encounter sceneCombatEncounter;

// Combat Results
var privatewrite ROTT_UI_Scene_Combat_Results sceneCombatResults;

// Game Over
var privatewrite ROTT_UI_Scene_Game_Over sceneGameOver;

// scene Credits
var privatewrite ROTT_UI_Scene_Credits sceneCredits;

// Transitioner
var public ROTT_UI_Transitioner transitioner;

/*=============================================================================
 * initSceneManager()
 * 
 * This is called to setup the scene manager.
 *===========================================================================*/
event initSceneManager() {
  // Console msg
  whitelog("--+-- ROTT_UI_Scene_Manager: initSceneManager() --+--");
  
  // Useful external references for convenience
  gameInfo = ROTT_Game_Info(ROTT_UI_HUD(Outer).WorldInfo.Game);
  gameInfo.setSceneManager(self);
  `assert(gameInfo != none);
  
  // Note: Cannot initialize scenes here
  // Set references to avoid type casting
  sceneTitleScreen = ROTT_UI_Scene_Title_Screen(uiScenes[SCENE_TITLE_SCREEN]);
  sceneSaveManager = ROTT_UI_Scene_Save_Manager(uiScenes[SCENE_SAVE_MANAGER]);
  sceneCharacterCreation = ROTT_UI_Scene_Character_Creation(uiScenes[SCENE_CHARACTER_CREATION]);
  
  sceneOverWorld = ROTT_UI_Scene_Over_World(uiScenes[SCENE_OVER_WORLD]);
  sceneWorldMap = ROTT_UI_Scene_World_Map(uiScenes[SCENE_WORLD_MAP]);
  sceneGameMenu = ROTT_UI_Scene_Game_Menu(uiScenes[SCENE_GAME_MENU]);
  sceneGameManager = ROTT_UI_Scene_Game_Manager(uiScenes[SCENE_GAME_MANAGER]);
  scenePartyManager = ROTT_UI_Scene_Party_Manager(uiScenes[SCENE_PARTY_MANAGER]);
  
  sceneNpcDialog = ROTT_UI_Scene_Npc_Dialog(uiScenes[SCENE_NPC_DIALOG]);
  sceneServiceBlessing = ROTT_UI_Scene_Service_Blessings(uiScenes[SCENE_SERVICE_BLESSINGS]);
  sceneServiceShrine = ROTT_UI_Scene_Service_Shrine(uiScenes[SCENE_SERVICE_SHRINE]);
  sceneMiniGame = ROTT_UI_Scene_Service_Alchemy(uiScenes[SCENE_SERVICE_ALCHEMY]);
  sceneBarter = ROTT_UI_Scene_Service_Barter(uiScenes[SCENE_SERVICE_BARTERING]);
  sceneBestiary = ROTT_UI_Scene_Service_Bestiary(uiScenes[SCENE_SERVICE_BESTIARY]);
  sceneLottery = ROTT_UI_Scene_Service_Lottery(uiScenes[SCENE_SERVICE_LOTTERY]);
  sceneNecromancy = ROTT_UI_Scene_Service_Necromancy(uiScenes[SCENE_SERVICE_NECROMANCY]);
  sceneInformation = ROTT_UI_Scene_Service_Information(uiScenes[SCENE_SERVICE_INFORMATION]);
  
  sceneCombatEncounter = ROTT_UI_Scene_Combat_Encounter(uiScenes[SCENE_COMBAT_ENCOUNTER]);
  sceneCombatResults = ROTT_UI_Scene_Combat_Results(uiScenes[SCENE_COMBAT_RESULTS]);
  sceneGameOver = ROTT_UI_Scene_Game_Over(uiScenes[SCENE_GAME_OVER]);
  sceneCredits = ROTT_UI_Scene_Credits(uiScenes[SCENE_CREDITS]);
}

/*=============================================================================
 * setInitScene()
 *
 * Sets the first scene to draw depending on what map is being loaded
 *===========================================================================*/
public function setInitScene() {
  whiteLog("--+-- ROTT_UI_Scene_Manager : setInitScene() --+--");
  
  // Set camera control by map info
  switch (gameInfo.getCurrentMap()) {
    case MAP_UI_TITLE_MENU:
      switchScene(SCENE_TITLE_SCREEN);
      break; 
    case MAP_UI_CREDITS:
      switchScene(SCENE_CREDITS);
      break; 
    case MAP_UI_GAME_OVER:
      switchScene(SCENE_GAME_OVER);
      break; 
    default:
      switchScene(SCENE_OVER_WORLD);
      break;
  }
}

/*=============================================================================
 * switchScene()
 *
 * Sets a new scene to be drawn, and stops drawing the previous scene.
 *===========================================================================*/
public function switchScene(DisplayScenes newScene) {
  // Call unload event on previous scene
  if (uiScenes[currentSceneType] != none) {
    uiScenes[currentSceneType].unloadScene();
  }
  
  // Set new scene to be drawn
  currentSceneType = newScene;
  scene = uiScenes[currentSceneType];
  whitelog("--+-- Scene Load: " $ newScene $ " --+--");
  
  // Initialize if needed
  if (uiScenes[currentSceneType].isNotInitialized()) {
    grayLog("--+-- Scene Init: " $ newScene $ " --+--");
    uiScenes[currentSceneType].initScene();
  }
  
  // Call load event on new scene
  uiScenes[currentSceneType].loadScene();
  
  // Reset gamespeed
  gameinfo.setGameSpeed(1);
}

/*=============================================================================
 * renderScene()
 *
 * Called every frame to render the scene.
 *===========================================================================*/
public function renderScene(Canvas canvas) {
  uiScenes[currentSceneType].drawScene(canvas);
  transitioner.drawEvent(canvas, TOP_LAYER);
}

/*=============================================================================
 * closeGameMenu()
 *
 * Called every time the game menu is closed.
 *===========================================================================*/
public function closeGameMenu() {
  sceneGameMenu.closeGameMenu();
}

/*=============================================================================
 * elapseSceneTime()
 *
 * Provides a sense of time the current scene
 *===========================================================================*/
public function elapseSceneTime(float deltaTime) {
  uiScenes[currentSceneType].elapseTimers(deltaTime);
}

/*=============================================================================
 * debugDataStructure()
 * 
 * Dumps most of the data structure to the console log when called
 * (Note: excludes player profile)
 *===========================================================================*/
public function debugDataStructure() {
  local int i;
  
  for (i = 0; i < uiScenes.length; i++) {
    if (uiScenes[i] != none) {
      uiScenes[i].debugDataStructure();
    }
  }
}

/*=============================================================================
 * deleteSceneManager()
 *===========================================================================*/
public function deleteSceneManager() {
  local int i;
  
  // Delete all scenes
  for (i = 0; i < uiScenes.length; i++) {
    if (uiScenes[i] != none) {
      uiScenes[i].deleteScene();
      uiScenes[i] = none;
    }
  }
  
  // Delete transitioner
  transitioner.deleteComp();
  transitioner = none;
  
  gameInfo = none;
}

/*=============================================================================
 * raveSelectors()
 * 
 * This cheat enables rave mode on selector items
 *===========================================================================*/
public function raveSelectors() {
  local ROTT_UI_Page page;
  local int i; local int j; 
  
  for (i = 0; i < uiScenes.length; i++) {
    if (uiScenes[i] != none) {
      if (uiScenes[i].isNotInitialized()) uiScenes[i].initScene(); /// this causes problems...
      for (j = 0; j < uiScenes[i].pageComponents.length; j++) {
        page = uiScenes[i].pageComponents[j];
        page.raveHighwindCall();
      }
    }
  }
}

/*=============================================================================
 * raveMode()
 * 
 * This cheat enables rave mode on all sprites
 *===========================================================================*/
public function raveMode() {
  local ROTT_UI_Page page;
  local UI_Sprite sprite;
  local int i; local int j; local int k; 
  
  for (i = 0; i < uiScenes.length; i++) {
    if (uiScenes[i] != none) {
      for (j = 0; j < uiScenes[i].pageComponents.length; j++) {
        page = uiScenes[i].pageComponents[j];
        for (k = 0; k < page.componentList.length; k++) {
          sprite = UI_Sprite(page.componentList[k]);
          if (sprite != none) {
            sprite.addHueEffect(,2.0,fRand() * 2, 200, 255);
          }
        }
      }
    }
  }
}

/**=============================================================================
 * getSelectedStat()
 *
 * Returns a stat that has been selected in the menu (Vitality, Strength, etc)
 *===========================================================================*/
public function byte getSelectedStat() {
  return scene.getSelectedStat();
}

/**=============================================================================
 * getSelectedSkill()
 *
 * Returns a skill that has been selected from a skill tree.
 *===========================================================================*/
public function byte getSelectedSkill() {
  return scene.getSelectedSkill();
}

/**=============================================================================
 * getSelectedtree()
 *
 * Returns the index for what skill tree is up on the HUD.
 *===========================================================================*/
public function byte getSelectedtree() {
  return scene.getSelectedtree();
}


/*=============================================================================
 * Scene Assets
 *===========================================================================*/
defaultProperties
{
  
  // Title Screen
  begin object class=ROTT_UI_Scene_Title_Screen Name=UI_Scene_Title_Screen
  end object
  uiScenes[SCENE_TITLE_SCREEN]=UI_Scene_Title_Screen
  
  // Save Files 
  begin object class=ROTT_UI_Scene_Save_Manager Name=UI_Scene_Save_Manager
  end object
  uiScenes[SCENE_SAVE_MANAGER]=UI_Scene_Save_Manager
  
  // Character Creation
  begin object class=ROTT_UI_Scene_Character_Creation Name=UI_Scene_Character_Creation
  end object
  uiScenes[SCENE_CHARACTER_CREATION]=UI_Scene_Character_Creation
  
  // Over World
  begin object class=ROTT_UI_Scene_Over_World Name=UI_Scene_Over_World
  end object
  uiScenes[SCENE_OVER_WORLD]=UI_Scene_Over_World
  
  // World Map
  begin object class=ROTT_UI_Scene_World_Map Name=UI_Scene_World_Map
  end object
  uiScenes[SCENE_WORLD_MAP]=UI_Scene_World_Map
  
  // Game Menu
  begin object class=ROTT_UI_Scene_Game_Menu Name=UI_Scene_Game_Menu
  end object
  uiScenes[SCENE_GAME_MENU]=UI_Scene_Game_Menu
  
  // Game Manager
  begin object class=ROTT_UI_Scene_Game_Manager Name=UI_Scene_Game_Manager
  end object
  uiScenes[SCENE_GAME_MANAGER]=UI_Scene_Game_Manager
  
  // Party Manager
  begin object class=ROTT_UI_Scene_Party_Manager Name=UI_Scene_Party_Manager
  end object
  uiScenes[SCENE_PARTY_MANAGER]=UI_Scene_Party_Manager
  
  // Game Manager
  begin object class=ROTT_UI_Scene_Npc_Dialog Name=UI_Scene_Npc_Dialog
  end object
  uiScenes[SCENE_NPC_DIALOG]=UI_Scene_Npc_Dialog
  
  // Blessing Service
  begin object class=ROTT_UI_Scene_Service_Blessings Name=UI_Scene_Service_Blessings
  end object
  uiScenes[SCENE_SERVICE_BLESSINGS]=UI_Scene_Service_Blessings
  
  // Alchemy Service
  begin object class=ROTT_UI_Scene_Service_Alchemy Name=UI_Scene_Mini_Game
  end object
  uiScenes[SCENE_SERVICE_ALCHEMY]=UI_Scene_Mini_Game
  
  // Bestiary Service
  begin object class=ROTT_UI_Scene_Service_Bestiary Name=UI_Scene_Bestiary
  end object
  uiScenes[SCENE_SERVICE_BESTIARY]=UI_Scene_Bestiary
  
  // Bartering Service
  begin object class=ROTT_UI_Scene_Service_Barter Name=UI_Scene_Bartering
  end object
  uiScenes[SCENE_SERVICE_BARTERING]=UI_Scene_Bartering
  
  // Information Service
  begin object class=ROTT_UI_Scene_Service_Information Name=UI_Scene_Information
  end object
  uiScenes[SCENE_SERVICE_INFORMATION]=UI_Scene_Information
  
  // Lottery Service
  begin object class=ROTT_UI_Scene_Service_Lottery Name=UI_Scene_Lottery
  end object
  uiScenes[SCENE_SERVICE_LOTTERY]=UI_Scene_Lottery
  
  // Necromancy Service
  begin object class=ROTT_UI_Scene_Service_Necromancy Name=UI_Scene_Necromancy
  end object
  uiScenes[SCENE_SERVICE_NECROMANCY]=UI_Scene_Necromancy
  
  // Shrine Service
  begin object class=ROTT_UI_Scene_Service_Shrine Name=UI_Scene_Service_Shrine
  end object
  uiScenes[SCENE_SERVICE_SHRINE]=UI_Scene_Service_Shrine
  
  // Combat
  begin object class=ROTT_UI_Scene_Combat_Encounter Name=UI_Scene_Combat_Encounter
  end object
  uiScenes[SCENE_COMBAT_ENCOUNTER]=UI_Scene_Combat_Encounter
  
  // Combat Results
  begin object class=ROTT_UI_Scene_Combat_Results Name=UI_Scene_Combat_Results
  end object
  uiScenes[SCENE_COMBAT_RESULTS]=UI_Scene_Combat_Results
  
  // Game Over
  begin object class=ROTT_UI_Scene_Game_Over Name=UI_Scene_Game_Over
  end object
  uiScenes[SCENE_GAME_OVER]=UI_Scene_Game_Over
  
  // Scene Credits
  begin object class=ROTT_UI_Scene_Credits Name=UI_Scene_Credits
  end object
  uiScenes[SCENE_CREDITS]=UI_Scene_Credits
    
  /**
  // Title Screen
  begin object class=ROTT_UI_Scene_Title_Screen Name=UI_Scene_Title_Screen
  end object
  uiScenes[SCENE_TITLE_SCREEN]=UI_Scene_Title_Screen
  
  // Character Creation
  begin object class=ROTT_UI_Scene_Character_Creation Name=UI_Scene_Character_Creation
  end object
  uiScenes.add(UI_Scene_Character_Creation)
  
  // Over World
  begin object class=ROTT_UI_Scene_Over_World Name=UI_Scene_Over_World
  end object
  uiScenes.add(UI_Scene_Over_World)
  
  // World Map
  begin object class=ROTT_UI_Scene_World_Map Name=UI_Scene_World_Map
  end object
  uiScenes.add(UI_Scene_World_Map)
  
  // Game Menu
  begin object class=ROTT_UI_Scene_Game_Menu Name=UI_Scene_Game_Menu
  end object
  uiScenes.add(UI_Scene_Game_Menu)
  
  // Game Manager
  begin object class=ROTT_UI_Scene_Game_Manager Name=UI_Scene_Game_Manager
  end object
  uiScenes.add(UI_Scene_Game_Manager)
  
  // Party Manager
  begin object class=ROTT_UI_Scene_Party_Manager Name=UI_Scene_Party_Manager
  end object
  uiScenes.add(UI_Scene_Party_Manager)
  
  // Game Manager
  begin object class=ROTT_UI_Scene_Npc_Dialog Name=UI_Scene_Npc_Dialog
  end object
  uiScenes.add(UI_Scene_Npc_Dialog)
  
  // Blessing Service
  begin object class=ROTT_UI_Scene_Service_Blessings Name=UI_Scene_Service_Blessings
  end object
  uiScenes.add(UI_Scene_Service_Blessings)
  
  // Shrine Service
  begin object class=ROTT_UI_Scene_Service_Shrine Name=UI_Scene_Service_Shrine
  end object
  uiScenes.add(UI_Scene_Service_Shrine)
  
  // Mini Game
  begin object class=ROTT_UI_Scene_Service_Alchemy Name=UI_Scene_Mini_Game
  end object
  uiScenes.add(UI_Scene_Mini_Game)
  
  // Combat
  begin object class=ROTT_UI_Scene_Combat_Encounter Name=UI_Scene_Combat_Encounter
  end object
  uiScenes.add(UI_Scene_Combat_Encounter)
  
  // Combat Results
  begin object class=ROTT_UI_Scene_Combat_Results Name=UI_Scene_Combat_Results
  end object
  uiScenes.add(UI_Scene_Combat_Results)
  
  // Game Over
  begin object class=ROTT_UI_Scene_Game_Over Name=UI_Scene_Game_Over
  end object
  uiScenes.add(UI_Scene_Game_Over)
  
  // Scene Credits
  begin object class=ROTT_UI_Scene_Credits Name=UI_Scene_Credits
  end object
  uiScenes.add(UI_Scene_Credits)
  **/
  /*
  // Title Screen
  begin object class=ROTT_UI_Scene_Title_Screen Name=UI_Scene_Title_Screen
  end object
  uiScenes[SCENE_TITLE_SCREEN]=UI_Scene_Title_Screen
  
  // Over World
  begin object class=ROTT_UI_Scene_Over_World Name=UI_Scene_Over_World
  end object
  uiScenes[SCENE_OVER_WORLD]=UI_Scene_Over_World
  
  // Game Menu
  begin object class=ROTT_UI_Scene_Game_Menu Name=UI_Scene_Game_Menu
  end object
  uiScenes[SCENE_GAME_MENU]=UI_Scene_Game_Menu
  
  // Game Manager
  begin object class=ROTT_UI_Scene_Game_Manager Name=UI_Scene_Game_Manager
  end object
  uiScenes[SCENE_GAME_MANAGER]=UI_Scene_Game_Manager
  
  // Game Manager
  begin object class=ROTT_UI_Scene_Npc_Dialog Name=UI_Scene_Npc_Dialog
  end object
  uiScenes[SCENE_NPC_DIALOG]=UI_Scene_Npc_Dialog
  
  // Alchemy Game
  begin object class=ROTT_privatewrite Name=privatewrite
  end object
  uiScenes[SCENE_SERVICE_ALCHEMY]=privatewrite
  
  // Combat
  begin object class=ROTT_UI_Scene_Combat Name=UI_Scene_Combat
  end object
  uiScenes[SCENE_COMBAT]=UI_Scene_Combat
  
  // Combat Results
  begin object class=ROTT_UI_Scene_Combat_Results Name=UI_Scene_Combat_Results
  end object
  uiScenes[SCENE_COMBAT_RESULTS]=UI_Scene_Combat_Results
  
  // Game Over
  begin object class=ROTT_UI_Scene_Game_Over Name=UI_Scene_Game_Over
  end object
  uiScenes[SCENE_GAME_OVER]=UI_Scene_Game_Over
  
  // Scene Credits
  begin object class=ROTT_UI_Scene_Credits Name=UI_Scene_Credits
  end object
  uiScenes[SCENE_CREDITS]=UI_Scene_Credits
  */
  
}























