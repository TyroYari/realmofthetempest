/*=============================================================================
 * ROTT_UI_Page_Save_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The party manager allows the player to select which party
 * they want to play as.
 *===========================================================================*/
class ROTT_UI_Page_Save_Manager extends ROTT_UI_Page;

/** ============================== **/

enum ControlState {
  IGNORE_INPUT,
  ACCEPT_INPUT
};

// Menu state
var private ControlState menuControl;

/** ============================== **/

// Parent scene
var privatewrite ROTT_UI_Scene_Save_Manager saveManagerScene;

// This tracks which party is actually targetted by the selector
var privatewrite int selectionIndex;

// This is the cap for selectionIndex, based on the number of save folders
var private int maxIndex;

// Internal UI references
///var private ROTT_UI_Party_Manager_Container_List containerList;
var private ROTT_UI_Party_Manager_Container infoContainer[2];
var private UI_Selector selector;

var private bool bSetTransition;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // Set parent scene
  saveManagerScene = ROTT_UI_Scene_Save_Manager(outer);
  
  // Internal References
  selector = UI_Selector(findComp("Party_Mgmt_Selector"));
  
  // Party info panel
  for (i = 0; i < 2; i++) {
    infoContainer[i] = ROTT_UI_Party_Manager_Container(
      findComp("Party_Manager_Container_" $ i + 1)
    );
  }
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  selector.setActive(true);
  
  // Enable input
  menuControl = ACCEPT_INPUT;
  
}

/*============================================================================= 
 * onSceneActivation()
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  local ROTT_Game_Player_Profile profile;
  
  // Reset selector
  selectionIndex = 0;
  selector.resetSelection();
  
  // Render the party system
  ///containerList.displayParties(partySystem);
  
  // Selection data is based on number of save folders
  maxIndex = 2;
  
  // Render save info to screen
  profile = gameInfo.getSaveFile();
  profile.loadProfile(false);
  infoContainer[0].renderSaveFile(profile, 1);
  
  profile = gameInfo.getSaveFile("temp");
  profile.loadProfile(true);
  infoContainer[1].renderSaveFile(profile);
  
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  
  // Render the party system
  ///containerList.refreshParties();
  
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  if (bSetTransition) {
    // Execute transition
    saveManagerScene.transitionLoadGame();
    
    // Disable input
    menuControl = IGNORE_INPUT;
    selector.setActive(false);
    
    bSetTransition = false;
  }
  
}

/*=============================================================================
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  // Check for disabled input
  if (menuControl == IGNORE_INPUT) return;
  
  // Load game
  switch(selector.getSelection()) {
    // Load hard save
    case 0:
      // Check for valid file
      if (!gameInfo.saveFileExist(selector.getSelection())) return;
      
      // Load save file #1
      gameInfo.loadSavedGame(false);
      // Move save file to autosave slot
      gameInfo.saveGame(true);
      break;
    // Load autosave
    case maxIndex - 1:
      // Check for valid file
      if (!gameInfo.saveFileExist(-1)) return;
      
      // Load autosave
      gameInfo.loadSavedGame(true);
      
      // Reset arrival checkpoint
      gameInfo.playerProfile.arrivalCheckpoint = 0;
      
      // Move save file to autosave slot
      gameInfo.saveGame(true);
      break;
  }
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
  
  // Delay transition call to avoid iteration count overflow
  bSetTransition = true;
  
  // Execute transition
  ///saveManagerScene.transitionLoadGame();
  ///
  ///// Disable input
  ///menuControl = IGNORE_INPUT;
  ///selector.setActive(false);
  
}

protected function navigationRoutineB() {
  // Back to title scene
  sceneManager.switchScene(SCENE_TITLE_SCREEN);
  
  // Unlock controls
  sceneManager.sceneTitleScreen.titlePage.bLockControls = false;
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function bool preNavigateDown() {
  if (selectionIndex == 0 || (selectionIndex == maxIndex - 1 && maxIndex >= 3)) {
    selectionIndex++;
    return true;
  } else if (selectionIndex < maxIndex - 1) {
    ///if (containerList.lerpUp()) {
      selectionIndex++;
      return true;
    ///}
  }
  return false;
}

public function bool preNavigateUp() {
  if (selectionIndex == maxIndex || selectionIndex == 1) {
    selectionIndex--;
    return true;
  } else if (selectionIndex > 0) {
    ///if (containerList.lerpDown()) {
      selectionIndex--;
      return true;
    ///}
  }
  return false;
}

public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Assets
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
  begin object class=UI_Texture_Info Name=Party_Manager_Background
    componentTextures.add(Texture2D'GUI.Party_Manager_Background')
  end object
  
  // Border
  begin object class=UI_Texture_Info Name=Party_Manager_Border
    componentTextures.add(Texture2D'GUI.Party_Manager_Border')
  end object
  
  /** Visual Page Setup **/
  tag="Party_MGR_Page"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  
  // Party Management Background
  begin object class=UI_Sprite Name=Party_Mgmt_Background
    tag="Party_Mgmt_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Party_Manager_Background
  end object
  componentList.add(Party_Mgmt_Background)
  
  // Party Management - Container List
  ///begin object class=ROTT_UI_Party_Manager_Container_List Name=Party_Manager_Container_List
  ///  tag="Party_Manager_Container_List" 
  ///end object
  ///componentList.add(Party_Manager_Container_List)
  
  
  // Party backdrop
  begin object class=UI_Texture_Info Name=Party_Member_Backdrops
    componentTextures.add(Texture2D'GUI.Party_Manager_Party_Member_Backdrops')
  end object
  
  // Save slot 1: Party info
  begin object class=ROTT_UI_Party_Manager_Container Name=Party_Manager_Container_1
    tag="Party_Manager_Container_1" 
    posX=756
    posY=42
  end object
  componentList.add(Party_Manager_Container_1)
  
  // Save slot 2: Party info
  begin object class=ROTT_UI_Party_Manager_Container Name=Party_Manager_Container_2
    tag="Party_Manager_Container_2" 
    posX=756
    posY=322
  end object
  componentList.add(Party_Manager_Container_2)
  
  // Selector
  begin object class=UI_Selector Name=Party_Mgmt_Selector
    tag="Party_Mgmt_Selector"
    bActive=true
    posX=53
    posY=39
    selectionOffset=(x=0,y=280)
    numberOfMenuOptions=3
    hoverCoords(0)=(xStart=58,yStart=44,xEnd=1408,yEnd=298)
    hoverCoords(1)=(xStart=58,yStart=310,xEnd=1408,yEnd=578)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.PartyMGR_Selection_Box')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
    // Selection arrow
    begin object class=UI_Texture_Info Name=Inactive_Selection_Arrow
      componentTextures.add(Texture2D'GUI.Menu_Selection_Arrow')
    end object
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      posy=90
      posx=-30
      images(0)=Inactive_Selection_Arrow
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Party_Mgmt_Selector)
  
  // Party Management Border
  begin object class=UI_Sprite Name=Party_Mgmt_Border
    tag="Party_Mgmt_Border"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Party_Manager_Border
  end object
  componentList.add(Party_Mgmt_Border)
  
  
  
}



