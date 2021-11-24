/*=============================================================================
 * ROTT_UI_Page_Title_Screen
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles the display and controls for the title menu
 *===========================================================================*/
 
class ROTT_UI_Page_Title_Screen extends ROTT_UI_Page;
 
/** ============================== **/

enum UISceneStates {
  
  MENU_HIDDEN,
  GAMEPLAY_MENU_VISIBLE,
  GAMEMODE_MENU_VISIBLE,
};

var private UISceneStates currentUIScene;
var public bool bLockControls;

/** ============================== **/

enum UIMenuOptions {
  
  NEW_GAME,
  CONTINUE_GAME
  
};

/** ============================== **/

const REQUIREMENTS_PASS = false;  // Used for the system settings hack
const REQUIREMENTS_FAIL = true;

// Internal references
var private UI_Selector menuSelector;
var private UI_Label gameVersionText;
var private UI_Sprite titleMenuOptions;
var private UI_Sprite gameModeMenuOptions;

// Timers
var private float fadeInTime;           // Used to ignore inputs until fade in
var private ROTT_Timer newGameTimer;    // Used to fade out before a new game

// Tracks if a reset to native resolution is needed for vsync trick
var private bool bResetRes;

/*=============================================================================
 * initialize Component
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  menuSelector = UI_Selector(findComp("Title_Menu_Selector"));
  gameVersionText = findLabel("Game_Version_Text");
  gameModeMenuOptions = findSprite("Game_Mode_Menu_Options");
  titleMenuOptions = findSprite("Title_Menu_Options");
  
  // Draw version info
  gameVersionText.setText(gameInfo.getVersionInfo()); 
  addEffectToComponent(DELAY, "Title_Fade_Component", 1.2);
  addEffectToComponent(FADE_OUT, "Title_Fade_Component", 0.8);
  
  // Set scene to no input, until fade in effects complete
  bLockControls = true;
  
  // Check if resolution vsync trick is needed
  if (checkSystemSettings() == REQUIREMENTS_FAIL) {
    // Force VSync via resolution change
    fixVSync();
    gameInfo.setResolution(1768, 992);
    bResetRes = true;
  }
  
  // Time delay until input
  fadeInTime = 1.6;
  
  // Build and version info
  if (!gameInfo.bDevMode) {
    if (gameInfo.bQaMode) {
      findLabel("Dev_Build_Warning").setText("QA Mode: Phase " $ gameInfo.const.PHASE_INFO);
      findLabel("Dev_Build_Warning").setFont(DEFAULT_SMALL_ORANGE);
    } else {
      findLabel("Dev_Build_Warning").setText("");
    }
  } 
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
}

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  // Check if fade in time remaining
  if (fadeInTime > 0) {
    // Subtract from timer
    fadeInTime -= deltaTime;
    
    // Check if timer completed
    if (fadeInTime <= 0) {
      allowInput();
    }
  }
}

/*============================================================================*
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * inputName        the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
( 
  int ControllerId, 
  name inputName, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  // Check for exit (via escape)
  if (inputName == 'Escape') gameInfo.consoleCommand("EXIT");
  
  // Open options from title page
  switch (inputName) {
    case 'Tab':
    case 'XBoxTypeS_Start':
      // Change scene for options
      gameInfo.sceneManager.switchScene(SCENE_GAME_MANAGER);
      
      // Push options page to front
      gameInfo.sceneManager.sceneGameManager.pushPage(
        gameInfo.sceneManager.sceneGameManager.gameOptionsPage
      );
      
      // Store redirection in memory for navigating back to title page
      gameInfo.sceneManager.sceneGameManager.bTitleMenuDirection = true;
      
      // Play sound
      sfxBox.playSfx(SFX_MENU_NAVIGATE);
      break;
  }
  
  return super.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  switch (currentUIScene) {
    case MENU_HIDDEN:            showMenu();        break;
    case GAMEPLAY_MENU_VISIBLE:  menuSelect();      break;
    case GAMEMODE_MENU_VISIBLE:  modeMenuSelect();  break;
  }
}

/*=============================================================================
 * requirementRoutineA()
 *
 * Returns true if input is valid for a button.  This function must be 
 * delegated to a button, because each button has different requirements.
 *===========================================================================*/
protected function bool requirementRoutineA() {
  // Ignore input when controls are locked (for fade in effects)
  if (bLockControls) return false;
  return true;
}

protected function navigationRoutineB() {
  // Back out of game mode selection
  if (currentUIScene == GAMEMODE_MENU_VISIBLE) {
    // Back out of scene
    currentUIScene = GAMEPLAY_MENU_VISIBLE;
    // Hide this menu
    titleMenuOptions.setEnabled(true);
    // Show game mode menu
    gameModeMenuOptions.setEnabled(false);
    // Set number of options
    menuSelector.setNumberOfMenuOptions(2);
    menuSelector.resetSelection();
    
    // Sfx
    gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
  }
}

/*=============================================================================
 * showMenu()
 *
 * This function pulls up the "New Game / Continue" menu
 *===========================================================================*/
private function showMenu() {
  // Update scene info
  currentUIScene = GAMEPLAY_MENU_VISIBLE;
  menuSelector.setActive(true);
  
  // Render menu scene
  titleMenuOptions.setEnabled(true);
  menuSelector.setEnabled(true);
  
  if (gameInfo.saveFilesExist()) {
    titleMenuOptions.setDrawIndex(0);
  } else {
    titleMenuOptions.setDrawIndex(1);
  }
  
  // Sound effects
  gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
}

/*=============================================================================
 * modeMenuSelect()
 *
 * This function selects an option from the game mode menu
 *===========================================================================*/
private function modeMenuSelect() {
  whitelog("--+ New Game +--");
  
  // initiate fade out
  addEffectToComponent(FADE_IN, "Title_Fade_Component", 0.75);
  
  // Block player input
  bLockControls = true;
  
  // Audio controls
  gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
  jukebox.fadeOut(1);
  
  // Wait to launch new game
  newGameTimer = gameInfo.Spawn(class'ROTT_Timer');
  newGameTimer.makeTimer(1.0, LOOP_OFF, showIntroPage);
  
  // Deactivate selector
  menuSelector.setActive(false);
  
  // Set game mode
  gameInfo.newGameSetup(GameModes(menuSelector.getSelection()));
  
}

/*=============================================================================
 * menuSelect()
 *
 * This function selects an option from the gameplay menu
 *===========================================================================*/
private function menuSelect() {
  switch (menuSelector.getSelection()) {
    case NEW_GAME:
      // Hide this menu
      titleMenuOptions.setEnabled(true);
      // Show game mode menu
      gameModeMenuOptions.setEnabled(true);
      
      // Update viewmode data for this menu
      currentUIScene = GAMEMODE_MENU_VISIBLE;
      
      // Reset selector
      menuSelector.resetSelection();
      menuSelector.setNumberOfMenuOptions(3);
      
      // Play audio
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
      
    case CONTINUE_GAME:
      whitelog("--+ Save Manager +--");
      
      // Transition effect
      gameInfo.sceneManager.sceneTitleScreen.transitionOnContinue();
      clearWidgets();
      
      // Control lock
      bLockControls = true;
      
      // Sfx
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
  }
  
}

/*=============================================================================
 * fixVSync()
 *
 * Initializes vsync settings to prevent screen tearing
 *===========================================================================*/
private function fixVSync() {
  local CustomSystemSettings settings;

  settings = class'WorldInfo'.static.getWorldInfo().spawn(class'CustomSystemSettings');
  
  settings.setUseVsync(true);
}

/*=============================================================================
 * checkSystemSettings()
 *
 * Uses a cookie to check if the vsync resolution trick has been used
 *===========================================================================*/
private function bool checkSystemSettings() {
  local ROTT_Cookie_Requirement cookie;

  cookie = new(self) class'ROTT_Cookie_Requirement';
  
  // Hacky! check version info to see if the game has been run before
  if (class'Engine'.static.basicLoadObject(cookie, "Save\\version_cookie.bin", true, 0)) {
    if (cookie.sVersion == gameInfo.getVersionInfo()) {
      return REQUIREMENTS_PASS;
    }
  }
  
  // Hacky! Save version info out to allow future requirement checks to pass
  cookie.sVersion = gameInfo.getVersionInfo();
  class'Engine'.static.basicSaveObject(cookie, "Save\\version_cookie.bin", true, 0);

  return REQUIREMENTS_FAIL; // resolution change required

}

/*=============================================================================
 * showIntroPage()
 *
 * 
 *===========================================================================*/
private function showIntroPage() { 
  parentScene.pushPageByTag("Page_Game_Intro");
} 

/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  if (currentUIScene != MENU_HIDDEN) menuSelector.setActive(true);
}

/*=============================================================================
 * allowInput()
 *
 * Description: This function is delegated to a timer, thus no paramaters.
 *===========================================================================*/
private function allowInput() { 
  // Triggered after fade in, control is given to player
  currentUIScene = MENU_HIDDEN; 
  bLockControls = false;
  
  // Check if resolution vsync trick is needed
  if (bResetRes) {
    // Force VSync via resolution change
    fixVSync();
    gameInfo.setResolution(1440, 900);
    bResetRes = false;
  }
} 

/*=============================================================================
 * deleteComp()
 *
 * Called for memory clean up
 *===========================================================================*/
event deleteComp() {
  super.deleteComp();
    
  if (newGameTimer != none) newGameTimer.destroy();     
}

/*=============================================================================
 * Default Properties
 *
 * By convention, names and tags should use capitalized words separated by
 * underscores.  (e.g. Example_Component_Name)
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
  begin object class=UI_Texture_Info Name=Title_Image_Texture
    componentTextures.add(Texture2D'GUI.Tempest_Stronghold_Title')
  end object
  begin object class=UI_Texture_Info Name=Title_Menu_Buttons_Texture
    componentTextures.add(Texture2D'GUI.Title_Menu_Buttons')
  end object
  begin object class=UI_Texture_Info Name=Title_Menu_Buttons_Disabled_Texture
    componentTextures.add(Texture2D'GUI.Title_Menu_Buttons_Disabled')
  end object
  begin object class=UI_Texture_Info Name=Game_Mode_Menu_Buttons_Texture
    componentTextures.add(Texture2D'GUI.Game_Mode_Menu_Buttons')
  end object
  begin object class=UI_Texture_Info Name=Black_Texture
    componentTextures.add(Texture2D'GUI.Black_Square')
  end object
  begin object class=UI_Texture_Info Name=Restart_Required_Texture
    componentTextures.add(Texture2D'GUI.RestartRequired')
  end object
  
  // Game title sprite
  begin object class=UI_Sprite Name=Game_Title_Image
    tag="Game_Title_Image"
    posX=420
    posY=160
    posXEnd=1020
    posYEnd=430
    images(0)=Title_Image_Texture
  end object
  componentList.add(Game_Title_Image)
  
  // Game Play Options
  begin object class=UI_Sprite Name=Title_Menu_Options
    tag="Title_Menu_Options"
    bEnabled=false
    posX=539
    posY=547
    images(0)=Title_Menu_Buttons_Texture
    images(1)=Title_Menu_Buttons_Disabled_Texture
  end object
  componentList.add(Title_Menu_Options)
  
  // Game Mode Options
  begin object class=UI_Sprite Name=Game_Mode_Menu_Options
    tag="Game_Mode_Menu_Options"
    bEnabled=false
    posX=539
    posY=547
    images(0)=Game_Mode_Menu_Buttons_Texture
  end object
  componentList.add(Game_Mode_Menu_Options)
  
  // Selector
  begin object class=UI_Selector Name=Title_Menu_Selector
    tag="Title_Menu_Selector"
    bEnabled=false
    posX=519
    posY=549
    selectionOffset=(x=0,y=71)
    numberOfMenuOptions=2
    hoverCoords(0)=(xStart=548,yStart=567,xEnd=888,yEnd=630)
    hoverCoords(1)=(xStart=548,yStart=637,xEnd=888,yEnd=700)
    hoverCoords(2)=(xStart=548,yStart=707,xEnd=888,yEnd=770)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.ContinueSelector')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Title_Menu_Selector)
  
  // Version
  begin object class=UI_Label Name=Game_Version_Text
    tag="Game_Version_Text"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=LEFT
    alignY=BOTTOM
    fontStyle=DEFAULT_SMALL_BEIGE
    labelText=""
  end object
  componentList.add(Game_Version_Text)
  
  // Build info
  begin object class=UI_Label Name=Dev_Build_Warning
    tag="Dev_Build_Warning"
    posX=105
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=LEFT
    alignY=BOTTOM
    fontStyle=DEFAULT_SMALL_RED
    labelText="Dev Build"
  end object
  componentList.add(Dev_Build_Warning)
  
  // Options info
  begin object class=UI_Label Name=Options_Info_Label
    tag="Options_Info_Label"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=BOTTOM
    fontStyle=DEFAULT_SMALL_BEIGE
    labelText="Press Start for Options"
  end object
  componentList.add(Options_Info_Label)
  
  // Fade effects
  begin object class=UI_Sprite Name=Title_Fade_Component
    tag="Title_Fade_Component"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
  end object
  componentList.add(Title_Fade_Component)
  
}


















