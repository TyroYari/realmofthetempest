/*=============================================================================
 * ROTT_UI_Page_Combat_Victory
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page shows the exp rewarded after battle
 *===========================================================================*/
 
class ROTT_UI_Page_Combat_Victory extends ROTT_UI_Page;

/** ============================== **/

enum MenuStates {
  EXP_PENDING,
  EXP_ANIMATING,
  EXP_GRANTED
};

var private MenuStates menuState;

/** ============================== **/

enum ControlState {
  IGNORE_INPUT,
  ACCEPT_INPUT
};

var private ControlState menuControl;

/** ============================== **/

// Input delay timer
var public ROTT_Timer inputDelayTimer; 
var public ROTT_Timer expLerpTimer; 
  
// Internal references
var private ROTT_UI_Party_Display partyDisplay;
var private ROTT_UI_Displayer_Victory_Hero heroInfo[3];

// Parent scene
var private ROTT_UI_Scene_Combat_Results someScene;

// Set by heroes when they level up, to queue sfx
var public bool playLvlUpSfx;

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // set parent scene
  someScene = ROTT_UI_Scene_Combat_Results(outer);
  
  // Internal references
  partyDisplay = ROTT_UI_Party_Display(findComp("Party_Displayer"));
  for (i = 0; i < 3; i++) {
    heroInfo[i] = ROTT_UI_Displayer_Victory_Hero(findComp("Hero_Displayer_" $ i+1));
  }
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  local int i;
  
  // Execute transition
  gameInfo.sceneManager.transitioner.setTransition(
    TRANSITION_IN,                               // Transition direction
    RIGHT_SWEEP_TRANSITION_IN,                   // Sorting config
    ,                                            // Pattern reversal
    ,                                            // Destination scene
    ,                                            // Destination page
    ,                                            // Destination world
    ,                                            // Color
    20,                                          // Tile speed
    0.2f,                                        // Delay
    false,                                       // Input consumption
    "Page_Transition_In"
  );
  
  // Input delay
  menuState = EXP_PENDING;
  menuControl = IGNORE_INPUT;
  inputDelayTimer = gameInfo.spawn(class'ROTT_Timer');
  inputDelayTimer.makeTimer(0.4, LOOP_OFF, allowInput);
  
  // Attach unit info
  for (i = 0; i < 3; i++) {
    heroInfo[i].attachDisplayer(gameInfo.getActiveParty().getHero(i));
  }
  
  // Draw exp
  gameInfo.getActiveParty().prepExpAnim();
  refresh();
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  local int i;
  
  // Display hero exp results
  partyDisplay.renderParty(gameInfo.getActiveParty()); 
  for (i = 0; i < 3; i++) {
    heroInfo[i].updateDisplay(); 
  }
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
event onFocusMenu();

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  gameInfo.getActiveParty().elapseExpTime(deltaTime);
  refresh();
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  navigateNext();
}

protected function navigationRoutineB() {
  navigateNext();
}

protected function navigateNext() {
  // Ignore controls before delay completes
  if (menuControl != ACCEPT_INPUT) return;
  
  // Behavior based on menu state
  switch (menuState) {
    case EXP_PENDING: 
      // Start animating exp transfer
      menuState = EXP_ANIMATING;
      sfxBox.playSfx(SFX_MENU_EXP_GAIN);
      
      // Animate exp
      gameInfo.getActiveParty().startExpAnim();
      expLerpTimer = gameInfo.spawn(class'ROTT_Timer');
      expLerpTimer.makeTimer(1, LOOP_OFF, finishedExpAnim);
      break;
    case EXP_ANIMATING: 
      // Skip the rest of the animation
      menuState = EXP_GRANTED;
      
      // Skip exp animation
      gameInfo.getActiveParty().skipExpAnim();
      expLerpTimer.destroy();
      
      // Check for level up sfx and transfer
      if (playLvlUpSfx) {
        sfxBox.playSfx(SFX_MENU_LEVEL_UP);
        playLvlUpSfx = false;
        someScene.bLevelUpTransfer = true;
      } else {
        someScene.bLevelUpTransfer = false;
      }
      
      break;
    case EXP_GRANTED: 
      // Ignore input
      menuControl = IGNORE_INPUT;
      
      // Execute transition to combat analysis
      gameInfo.sceneManager.transitioner.setTransition(
        TRANSITION_OUT,                              // Transition direction
        RIGHT_SWEEP_TRANSITION_OUT,                  // Sorting config
        ,                                            // Pattern reversal
        ,                                            // Destination scene
        gameInfo.sceneManager.sceneCombatResults.pageCombatAnalysis,
        // Destination page
        ,                                            // Destination world
        ,                                            // Color
        ,                                            // Tile speed
        0.2f,                                         // Delay
        true,                                        // Input consumption
        "Page_Transition_Out_Over_World"
      );
      break;
  }
}

/*============================================================================= 
 * allowInput()
 *
 * This function is delegated to a timer, thus no paramaters.
 * Re-enables selection input, and renders selected class info.
 *===========================================================================*/
private function allowInput() { 
  // Allow input
  menuControl = ACCEPT_INPUT;

  // Destroy invoking timer
  if (inputDelayTimer != none) inputDelayTimer.destroy();
} 

/*============================================================================= 
 * finishedExpAnim()
 *
 * 
 *===========================================================================*/
private function finishedExpAnim() { 
  menuState = EXP_GRANTED;
  if (playLvlUpSfx) {
    sfxBox.playSfx(SFX_MENU_LEVEL_UP);
    playLvlUpSfx = false;
    someScene.bLevelUpTransfer = true;
  } else {
    someScene.bLevelUpTransfer = false;
  }
  
  expLerpTimer.destroy();
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
  
  /** ===== Textures ===== **/
  // Left menu backgrounds
  begin object class=UI_Texture_Info Name=Victory_Background
    componentTextures.add(Texture2D'GUI.Victory_Background')
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
    images(0)=Victory_Background
  end object
  componentList.add(Background_Sprite)
  
  // Party Displayer
  begin object class=ROTT_UI_Party_Display Name=Party_Displayer
    tag="Party_Displayer"
    bEnabled=true
    posX=106
    posY=124
    XOffset=44
    YOffset=246
    displayMode=MANAGER_PORTRAITS
  end object
  componentList.add(Party_Displayer)
  
  // Exp and class info displayer
  begin object class=ROTT_UI_Displayer_Victory_Hero Name=Hero_Displayer_1
    tag="Hero_Displayer_1"
    bEnabled=true
    posX=106
    posY=124
  end object
  componentList.add(Hero_Displayer_1)
  
  // Exp and class info displayer
  begin object class=ROTT_UI_Displayer_Victory_Hero Name=Hero_Displayer_2
    tag="Hero_Displayer_2"
    bEnabled=true
    posX=150
    posY=370
  end object
  componentList.add(Hero_Displayer_2)
  
  // Exp and class info displayer
  begin object class=ROTT_UI_Displayer_Victory_Hero Name=Hero_Displayer_3
    tag="Hero_Displayer_3"
    bEnabled=true
    posX=194
    posY=616
  end object
  componentList.add(Hero_Displayer_3)
  
  
}
















