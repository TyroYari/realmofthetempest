/*=============================================================================
 * ROTT_UI_Page_Control_Sheet
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Shows controller input information for guiding the player
 *===========================================================================*/
 
class ROTT_UI_Page_Control_Sheet extends ROTT_UI_Page;

const BLACK_BAR_COUNT = 60;

// Track time this page has been up
var private float elapsedTime;

// Vertical fade effect time
var private float elapsedEffectTime;
var private bool bTransitionOut;

// Internal references
var private UI_Sprite blackBars[BLACK_BAR_COUNT];

// Navigation variables
var private bool bRedirectToMenu;

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  local UI_Texture_Info texture;
  texture = new class'UI_Texture_Info';
  texture.componentTextures.addItem(Texture2D'GUI.Black_Square');
  
  super.initializeComponent(newTag);
  
  // Column iteration
  for (i = 0; i < BLACK_BAR_COUNT; i++) {
    // Create sprites
    blackBars[i] = new class'UI_Sprite';
    blackBars[i].images.addItem(new class'UI_Texture_Info');
    blackBars[i].modifyTexture(texture);
    componentList.addItem(blackBars[i]);
    blackBars[i].bMandatoryScaleToWindow = true;
    
    // Position black bar sprites across the screen for retro fading effect
    blackBars[i].updatePosition(
      0, 
      i * NATIVE_HEIGHT / BLACK_BAR_COUNT, 
      NATIVE_WIDTH, 
      (i+1) * NATIVE_HEIGHT / BLACK_BAR_COUNT
    );
    blackBars[i].setEnabled(false);
    blackBars[i].drawLayer=TOP_LAYER;
    blackBars[i].initializeComponent();
  }
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Skip effects if not part of intro
  if (!bRedirectToMenu) {
    // Fade out music
    gameInfo.jukebox.fadeOut(1, true);
    
    // Fade in control sheet
    addEffectToComponent(FADE_OUT, "Fade_Component", 0.3);
  } else {
    findSprite("Fade_Component").setEnabled(false);
  }
  
  // Decide to draw keyboard or gamepad controls
  findSprite("Controls_Background").setDrawIndex(
    UI_Player_Input(getPlayerInput()).bGamepadActive ? 0 : 1
  );
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  
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
  
  // Track time that this page has been up
  elapsedTime += deltaTime;
  
  // Column iteration
  if (bTransitionOut) {
    // Track elapsed time for the fading black bars effect
    elapsedEffectTime += deltaTime;
    
    // Adjust the vertical mask over time
    blackBars[0].setVerticalMask(elapsedEffectTime * 1.2);
    
    // Start new game after effect
    if (elapsedEffectTime > 1.35) {
      gameInfo.consoleCommand(
        "open " $ gameInfo.getMapFileName(MAP_TALONOVIA_TOWN)
      );
    }
  }
}

/*=============================================================================
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  if (!bRedirectToMenu) startTransitionOut();
}

protected function navigationRoutineB() {
  // Navigation
  if (!bRedirectToMenu) {
    // End of intro
    startTransitionOut();
  } else {
    // Back to menu
    parentScene.popPage();
  }
  
  // Sound effect
  if (!bTransitionOut) sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * startTransitionOut()
 *
 * Called to start the transition into a new game
 *===========================================================================*/
protected function startTransitionOut() {
  local int i;
  
  // Column iteration
  for (i = 0; i < BLACK_BAR_COUNT; i++) {
    blackBars[i].setEnabled(true);
  }
  
  bTransitionOut = true;
  
}

/*=============================================================================
 * Requirements
 *===========================================================================*/
protected function bool requirementRoutineA() { 
  return elapsedTime > 1 || bRedirectToMenu; 
}

protected function bool requirementRoutineB() { 
  return elapsedTime > 1 || bRedirectToMenu; 
}


/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  bRedirectToMenu=false
  
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
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  componentList.add(Screen_Frame)
  
  /** ===== Textures ===== **/
  // Control Sheet Background
  begin object class=UI_Texture_Info Name=Background_Texture
    componentTextures.add(Texture2D'GUI.Control_Sheet')
  end object
  begin object class=UI_Texture_Info Name=Background_Texture_Keyboard
    componentTextures.add(Texture2D'GUI.Keyboard_Control_Sheet')
  end object
  
  /** ===== UI Components ===== **/
  // Background Sprite
  begin object class=UI_Sprite Name=Controls_Background
    tag="Controls_Background"
    bEnabled=true
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Background_Texture
    images(1)=Background_Texture_Keyboard
  end object
  componentList.add(Controls_Background)
  
  // Black Texture
  begin object class=UI_Texture_Info Name=Black_Texture
    componentTextures.add(Texture2D'GUI.Black_Square')
  end object
  
  // Fade effects
  begin object class=UI_Sprite Name=Fade_Component
    tag="Fade_Component"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
  end object
  componentList.add(Fade_Component)
  
  
}



