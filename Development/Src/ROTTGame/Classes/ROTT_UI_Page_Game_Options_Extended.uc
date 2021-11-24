/*=============================================================================
 * ROTT_UI_Page_Game_Options_Extended
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Extended gameplay options
 *===========================================================================*/
 
class ROTT_UI_Page_Game_Options_Extended extends ROTT_UI_Page;

/** ============================== **/

// Game option list
enum GameOptionList {
  OPTION_TURN_SPEED,
  OPTION_INVERT_Y,
  OPTION_BLANK,
  OPTION_ALWAYS_DEFEND_HERO_1,
  OPTION_ALWAYS_DEFEND_HERO_2,
  OPTION_ALWAYS_DEFEND_HERO_3,
  OPTION_BACK,
};

/** ============================== **/

// Internal references
var private UI_Selector optionSelector;
var private UI_Slider turnSpeedSlider;
var private UI_Checkbox invertYCheckbox;
var private UI_Checkbox alwaysDefendCheckboxes[3];

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Selector for choosing which option to modify
  optionSelector = UI_Selector(findComp("Menu_Selector"));
  optionSelector.onInputA = optionSelectorInputA;
  optionSelector.onInputB = optionSelectorInputB;
  
  // Turn speed
  turnSpeedSlider = UI_Slider(findComp("Slider_Turn_Speed"));
  turnSpeedSlider.onInputB = widgetSelectorInputB;
  
  // Check boxes
  invertYCheckbox = UI_Checkbox(findComp("Invert_Y_Axis_Checkbox"));
  alwaysDefendCheckboxes[0] = UI_Checkbox(findComp("Always_Defend_Hero_1_Checkbox"));
  alwaysDefendCheckboxes[1] = UI_Checkbox(findComp("Always_Defend_Hero_2_Checkbox"));
  alwaysDefendCheckboxes[2] = UI_Checkbox(findComp("Always_Defend_Hero_3_Checkbox"));
  
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  optionSelector.resetSelection();
  optionSelector.setEnabled(true);
  
  // Load turn speed
  turnSpeedSlider.setKnob(gameInfo.optionsCookie.turnSpeed);
  
  // Load checkboxes from profile
  invertYCheckbox.setTick(gameInfo.optionsCookie.bInvertY);
  alwaysDefendCheckboxes[0].setTick(gameInfo.optionsCookie.bAlwaysDefendHero1);
  alwaysDefendCheckboxes[1].setTick(gameInfo.optionsCookie.bAlwaysDefendHero2);
  alwaysDefendCheckboxes[2].setTick(gameInfo.optionsCookie.bAlwaysDefendHero3);
  
}

/*=============================================================================
 * onPopPageEvent()
 *
 * Called when this page is removed from the scene
 *===========================================================================*/
event onPopPageEvent() {
  // Store changes in options data
  gameInfo.optionsCookie.turnSpeed = turnSpeedSlider.sliderScalar;
  gameInfo.optionsCookie.bInvertY = invertYCheckbox.bTick;
  gameInfo.optionsCookie.bAlwaysDefendHero1 = alwaysDefendCheckboxes[0].bTick;
  gameInfo.optionsCookie.bAlwaysDefendHero2 = alwaysDefendCheckboxes[1].bTick;
  gameInfo.optionsCookie.bAlwaysDefendHero3 = alwaysDefendCheckboxes[2].bTick;
  
  // Save
  gameInfo.saveOptions();
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  gameInfo.optionsCookie.bAlwaysDefendHero1 = alwaysDefendCheckboxes[0].bTick;
  gameInfo.optionsCookie.bAlwaysDefendHero2 = alwaysDefendCheckboxes[1].bTick;
  gameInfo.optionsCookie.bAlwaysDefendHero3 = alwaysDefendCheckboxes[2].bTick;
}

/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  
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
}

/*============================================================================*
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * Key              the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
( 
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  // Remap for keyboard control
  if (Key == 'Z' && Event == IE_Pressed) navigationRoutineLB();
  
  return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
 * Option selector input delegates
 *===========================================================================*/
public function optionSelectorInputA() {
  switch (optionSelector.getSelection()) {
    case OPTION_TURN_SPEED:
      // Give control to turn speed slider
      optionSelector.setActive(false);
      turnSpeedSlider.setActive(true);
      
      // Sfx
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case OPTION_INVERT_Y:
      // Toggle invert Y
      invertYCheckbox.toggleTick();
      
      // Sfx
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case OPTION_BLANK:
      break;
    case OPTION_ALWAYS_DEFEND_HERO_1:
      // Check if option is valid
      if (!isAlwaysDefendValid(0)) return;
      
      // Toggle tick state
      alwaysDefendCheckboxes[0].toggleTick();
      
      // Sound
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case OPTION_ALWAYS_DEFEND_HERO_2:
      // Check if option is valid
      if (!isAlwaysDefendValid(1)) return;
      
      // Toggle tick state
      alwaysDefendCheckboxes[1].toggleTick();
      
      // Sound
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case OPTION_ALWAYS_DEFEND_HERO_3:
      // Check if option is valid
      if (!isAlwaysDefendValid(2)) return;
      
      // Toggle tick state
      alwaysDefendCheckboxes[2].toggleTick();
      
      // Sound
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case OPTION_BACK:
      // Navigate back
      parentScene.popPage();
      parentScene.pushPage(ROTT_UI_Scene_Game_Manager(parentScene).gameOptionsPage);
      
      // Sound
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
  }
}

public function optionSelectorInputB() {
  // Check for redirection to title menu
  if (ROTT_UI_Scene_Game_Manager(parentScene).bTitleMenuDirection) {
    gameInfo.sceneManager.switchScene(SCENE_TITLE_SCREEN);
  }
  
  // Navigate back to game management options
  parentScene.popPage();
  sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Bumper inputs
 *===========================================================================*/
protected function navigationRoutineLB() {
  // Navigate back
  parentScene.popPage();
  parentScene.pushPage(ROTT_UI_Scene_Game_Manager(parentScene).gameOptionsPage);
  
  // Sound
  sfxBox.playSfx(SFX_MENU_ACCEPT);
}

/*=============================================================================
 * isAlwaysDefendValid
 *
 * Checks that at least one hero is available to select combat actions.
 *===========================================================================*/
public function bool isAlwaysDefendValid
(
  optional int index = -1, 
  optional bool bSkipSfx = false
) 
{
  local byte bDefendingHeroes[3];
  local int heroCount;
  local int checkCount;
  local int i;
  
  // Update cookie data
  refresh();
  
  // Check if a player profile is active yet (for options on start screen)
  if (gameInfo.playerProfile == none) return false;
  
  // Get hero count
  heroCount = gameInfo.getActiveParty().getPartySize();
  
  // Store defending statuses, before change
  if (gameInfo.optionsCookie.bAlwaysDefendHero1) bDefendingHeroes[0] = 1;
  if (gameInfo.optionsCookie.bAlwaysDefendHero2) bDefendingHeroes[1] = 1;
  if (gameInfo.optionsCookie.bAlwaysDefendHero3) bDefendingHeroes[2] = 1;
  
  // Store change
  if (index != -1) {
    if (bDefendingHeroes[index] == 1) {
      bDefendingHeroes[index] = 0;
    } else {
      bDefendingHeroes[index] = 1;
    }
  }
  
  // Count down number of unavailable heroes
  checkCount = heroCount;
  for (i = 0; i < heroCount; i++) {
    if (bDefendingHeroes[i] == 1) { checkCount--; }
  }
  /// Theres a problem here...
  
  // Sfx
  if (checkCount == 0 && !bSkipSfx) sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
  
  // Return true if at least one hero is available
  return checkCount > 0;
}

/*=============================================================================
 * Option selector input delegates
 *===========================================================================*/
public function widgetSelectorInputB() {
  // Reset control to option selector
  clearWidgets();
  optionSelector.setActive(true);
  
  // Sfx
  sfxBox.playSfx(SFX_MENU_BACK);
}

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
  
  begin object class=ROTT_Input_Handler Name=Input_LB
    inputName="XboxTypeS_LeftShoulder"
    buttonComponent=none
  end object
  inputList.add(Input_LB)
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  componentList.add(Screen_Frame)
  
  /** ===== Textures ===== **/
  // Left menu backgrounds
  begin object class=UI_Texture_Info Name=Page_Background
    componentTextures.add(Texture2D'ROTT_GUI_Options.Options_Background_Page_2')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Background_Sprite
    tag="Background_Sprite"
    bEnabled=true
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Page_Background
  end object
  componentList.add(Background_Sprite)
  
  // Selection box
  begin object class=UI_Selector Name=Menu_Selector
    tag="Menu_Selector"
    bEnabled=true
    posX=76
    posY=158
    selectionOffset=(x=0,y=100)
    numberOfMenuOptions=7
    
    hoverCoords(0)=(xStart=136,yStart=153,xEnd=1329,yEnd=241)
    hoverCoords(1)=(xStart=136,yStart=253,xEnd=1329,yEnd=341)
    hoverCoords(2)=(xStart=136,yStart=353,xEnd=1329,yEnd=441)
    hoverCoords(3)=(xStart=136,yStart=453,xEnd=1329,yEnd=541)
    hoverCoords(4)=(xStart=136,yStart=553,xEnd=1329,yEnd=641)
    hoverCoords(5)=(xStart=136,yStart=653,xEnd=1329,yEnd=741)
    hoverCoords(6)=(xStart=136,yStart=753,xEnd=1329,yEnd=841)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Arrow_Texture
      componentTextures.add(Texture2D'GUI.Menu_Selection_Arrow')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Arrow_Texture
      activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=170, max=255))
    end object
    componentList.add(Selector_Sprite)
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Selection_Arrow_Texture
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Menu_Selector)
  
  // Slider Turn Speed
  begin object class=UI_Slider Name=Slider_Turn_Speed
    tag="Slider_Turn_Speed"
    bEnabled=true
    bActive=false
    posX=656
    posY=153
  end object
  componentList.add(Slider_Turn_Speed)
  
  // Invert Y Axis Checkbox
  begin object class=UI_Checkbox Name=Invert_Y_Axis_Checkbox
    tag="Invert_Y_Axis_Checkbox"
    bEnabled=true
    bDrawRelative=true
    posX=721
    posY=264
  end object
  componentList.add(Invert_Y_Axis_Checkbox)
  
  // Always Defend Hero 1 Checkbox
  begin object class=UI_Checkbox Name=Always_Defend_Hero_1_Checkbox
    tag="Always_Defend_Hero_1_Checkbox"
    bEnabled=true
    bDrawRelative=true
    posX=761
    posY=464
  end object
  componentList.add(Always_Defend_Hero_1_Checkbox)
  
  // Always Defend Hero 2 Checkbox
  begin object class=UI_Checkbox Name=Always_Defend_Hero_2_Checkbox
    tag="Always_Defend_Hero_2_Checkbox"
    bEnabled=true
    bDrawRelative=true
    posX=761
    posY=564
  end object
  componentList.add(Always_Defend_Hero_2_Checkbox)
  
  // Always Defend Hero 3 Checkbox
  begin object class=UI_Checkbox Name=Always_Defend_Hero_3_Checkbox
    tag="Always_Defend_Hero_3_Checkbox"
    bEnabled=true
    bDrawRelative=true
    posX=761
    posY=664
  end object
  componentList.add(Always_Defend_Hero_3_Checkbox)
  
}
















