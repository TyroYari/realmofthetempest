/*=============================================================================
 * ROTT_UI_Page_Game_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles the UI for game management.
 * Supports: [Save] [Options] [Exit]
 *===========================================================================*/

class ROTT_UI_Page_Game_Manager extends ROTT_UI_Page;

enum GameMgmtOptions {
  GAME_MGMT_JOURNAL,
  GAME_MGMT_OPTIONS,
  GAME_MGMT_CONTROLS,
  GAME_MGMT_CONTENT,
  GAME_MGMT_SAVE,
  GAME_MGMT_EXIT
};

// Internal references
var private UI_Selector gameMgmtSelector;
 
/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  gameMgmtSelector = UI_Selector(findComp("Game_Mgmt_Selection_Box"));
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  gameMgmtSelector.setActive(true);
}
event onUnfocusMenu() {
  gameMgmtSelector.setActive(false);
}

/*============================================================================= 
 * onSceneActivation
 *
 * Called when the parent scene is activated
 *===========================================================================*/
public function onSceneActivation() {
  // Initial selector settings
  gameMgmtSelector.resetSelection();
}

protected function navigationRoutineA() {
  local GameMgmtOptions selection;
  
  selection = GameMgmtOptions(gameMgmtSelector.getSelection());
  
  switch (selection) {
    case GAME_MGMT_JOURNAL:
      // Show Journal
      parentScene.pushPageByTag("Page_Journal");
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case GAME_MGMT_OPTIONS:
      // Show options page
      parentScene.pushPageByTag("Page_Game_Options");
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case GAME_MGMT_CONTROLS:
      // Show control sheet
      parentScene.pushPageByTag("Page_Control_Sheet");
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case GAME_MGMT_CONTENT:
      // Show table of contents
      parentScene.pushPageByTag("Page_Table_Of_Contents");
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case GAME_MGMT_SAVE:
      // Save game
      gameInfo.saveGame();
      sfxBox.playSfx(SFX_MENU_SAVE_GAME);
      
      // Close menu
      gameInfo.closeGameMenu();
      gameInfo.showGameplayNotification("Your game has been saved");
      break;
    case GAME_MGMT_EXIT:  
      // Default sfx
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      
      // Give player controls to warning window
      parentScene.pushPageByTag("Game_Mgmt_Warning_Window");
      break;
  }
}

protected function navigationRoutineB() {
  sceneManager.switchScene(SCENE_GAME_MENU);
  
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bMandatoryScaleToWindow=true
  
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
  // Game Management Background
  begin object class=UI_Texture_Info Name=Game_Management_Background
    componentTextures.add(Texture2D'GUI.Main_Menu_Page')
  end object
  
  /** Visual Page Setup **/
  tag="Game_Management_Page"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  
  /** ===== UI Components ===== **/
  // Game Mgmt background
  begin object class=UI_Sprite Name=Main_Menu_Background
    tag="Main_Menu_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Game_Management_Background
  end object
  componentList.add(Main_Menu_Background)
  
  // Game Mgmt selection box
  begin object class=UI_Selector Name=Game_Mgmt_Selection_Box
    tag="Game_Mgmt_Selection_Box"
    posX=444
    posY=54
    selectionOffset=(x=0,y=96)
    numberOfMenuOptions=6
    hoverCoords(0)=(xStart=486,yStart=62,xEnd=944,yEnd=141)
    hoverCoords(1)=(xStart=486,yStart=158,xEnd=944,yEnd=237)
    hoverCoords(2)=(xStart=486,yStart=254,xEnd=944,yEnd=333)
    hoverCoords(3)=(xStart=486,yStart=350,xEnd=944,yEnd=429)
    hoverCoords(4)=(xStart=486,yStart=446,xEnd=944,yEnd=525)
    hoverCoords(5)=(xStart=486,yStart=542,xEnd=944,yEnd=621)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Game_Manager_Selection_Box')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Game_Mgmt_Selection_Box)
  
}











