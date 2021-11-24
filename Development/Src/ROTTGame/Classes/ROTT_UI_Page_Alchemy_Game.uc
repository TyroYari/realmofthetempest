/*=============================================================================
 * ROTT_UI_Page_Alchemy_Game
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The game for starting the alchemy game.
 *===========================================================================*/
 
class ROTT_UI_Page_Alchemy_Game extends ROTT_UI_Page;

// Game manager
var private ROTT_UI_Alchemy_Tile_Manager tileManager;

// Internal references
var private UI_Selector selector;

// Transition variables
var private bool bGameOver;
var private float transitionDelay;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  selector = UI_Selector(findComp("Alchemy_Game_Selector"));
  tileManager = ROTT_UI_Alchemy_Tile_Manager(findComp("Alchemy_Tiles"));
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  findSprite("Game_Fade_In").addEffectToQueue(FADE_OUT, 0.25);
  selector.forceSelection(2, 2);
  tileManager.reset();
  tileManager.setPattern1();
}

/*=============================================================================
 * elapseTimers()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  // Game over transitioning
  if (bGameOver) {
    // Track delay until transition
    transitionDelay -= deltaTime;
    
    // Check if time is complete
    if (transitionDelay <= 0) {
      // Change to game over page
      parentScene.popPage();
      parentScene.pushPageByTag("Page_Alchemy_Game_Over");
      bGameOver = false;
      selector.setActive(true);
      
      // Sound effect
      gameInfo.sfxbox.playSfx(SFX_ALCHEMY_GAME_OVER);
      
    }
  } else {
    // Check for game over
    if (tileManager.tiles[selector.getSelection()].getHeatState() == HEATED) {
      // Copy round reached
      ROTT_UI_Scene_Service_Alchemy(parentScene).enchantmentLevel = tileManager.level;
      
      // Sound effect
      gameInfo.sfxbox.playSfx(SFX_ALCHEMY_DEATH);
      
      // Start game over transition
      bGameOver = true;
      transitionDelay = 1.5;
      selector.setActive(false);
      selector.inactiveSprite.clearEffects();
      selector.inactiveSprite.addFlickerEffect(-1, 0.1, 0, 200, 255);
      selector.inactiveSprite.addEffectToQueue(DELAY, 0.8);
      selector.inactiveSprite.addEffectToQueue(FADE_OUT, 0.01);
    }
  }
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
  // A button press
  if (Key == 'XBoxTypeS_A' && Event == IE_Pressed) pressA();
  if (Key == 'LeftMouseButton' && Event == IE_Pressed) pressA();
  if (Key == 'SpaceBar' && Event == IE_Pressed) pressA();
  
  return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
}

/*============================================================================*
 * Button controls
 *===========================================================================*/
protected function pressA() {
  if (bGameOver) return;
  
  // Attempt to claim tile
  tileManager.claim(selector.getSelection());
  
}

protected function navigationRoutineB();

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bPageForcesCursorOff=true
  
  /** ===== Input ===== **/
  //begin object class=ROTT_Input_Handler Name=Input_A
  //  inputName="XBoxTypeS_A"
  //  buttonComponent=none
  //end object
  //inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Game_Background
    componentTextures.add(Texture2D'ROTT_Alchemy.Alchemy_Menu_Background')
  end object
  
  /** ===== Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Alchemy_Game_Background
    tag="Alchemy_Game_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Game_Background
  end object
  componentList.add(Alchemy_Game_Background)
  
  // Alchemy Tiles
  begin object class=ROTT_UI_Alchemy_Tile_Manager Name=Alchemy_Tiles
    tag="Alchemy_Tiles"
    posX=370
    posY=100
  end object
  componentList.add(Alchemy_Tiles)
  
  // Selector
  begin object class=UI_Selector Name=Alchemy_Game_Selector
    tag="Alchemy_Game_Selector"
    bEnabled=true
    bActive=true
    bWrapAround=false
    navSound=SFX_ALCHEMY_GAME_MOVE
    posX=369
    posY=100
    navigationType=SELECTION_2D
    selectionOffset=(x=140,y=140)  // Distance from neighboring spaces
    gridSize=(x=5,y=5)             // Total size of 2d selection space
    
    // Selector
    begin object class=UI_Texture_Info Name=Game_Selector
      componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Selector')
    end object
    
    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Game_Selector
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.8, min = 235, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Game_Selector
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Alchemy_Game_Selector)
  
  // Fade effects
  begin object class=UI_Sprite Name=Game_Fade_In
    // Texture
    begin object class=UI_Texture_Info Name=Black_Texture
      componentTextures.add(Texture2D'GUI.Black_Square')
    end object
    
    tag="Game_Fade_In"
    posX=343
    posY=73
    posXEnd=1097
    posYEnd=827
    images(0)=Black_Texture
    drawColor=(r=255,g=255,b=255,a=50)
    
  end object
  componentList.add(Game_Fade_In)
  
}





















