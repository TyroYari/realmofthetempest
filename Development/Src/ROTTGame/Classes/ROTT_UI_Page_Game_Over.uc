/*=============================================================================
 * ROTT_UI_Page_Game_Over
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles the display and controls for the game over
 * screen.
 *===========================================================================*/
 
class ROTT_UI_Page_Game_Over extends ROTT_UI_Page;
 
enum UISceneStates {
  STOP_ALL_INPUT,
  ACCEPT_INPUT
};

var private UISceneStates inputState;
var private ROTT_Timer inputTimer;

/*=============================================================================
 * initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Ignore Controls
  inputState = STOP_ALL_INPUT;
  
  inputTimer = gameInfo.spawn(class'ROTT_Timer');
  inputTimer.makeTimer(4.0, LOOP_OFF, allowInput);
  
  // UI Effects
  addEffectToComponent(FADE_OUT, "Screen_Fade_Component", 3.75);
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
  // Push title page
  if (inputState == ACCEPT_INPUT) {
    gameInfo.consoleCommand("open " $ gameInfo.getMapFileName(MAP_UI_TITLE_MENU));
  }
}

protected function navigationRoutineB() {
  // Push title page
  if (inputState == ACCEPT_INPUT) {
    gameInfo.consoleCommand("open " $ gameInfo.getMapFileName(MAP_UI_TITLE_MENU));
  }
}

/*============================================================================= 
 * allowInput()
 *
 * Delegated to a timer to allow input
 *===========================================================================*/
private function allowInput() {
  // Allow controls
  inputState = ACCEPT_INPUT;
}

/*=============================================================================
 * Default Properties
 *
 * By convention, names and tags should use capitalized words separated by
 * underscores.  (e.g. Example_Component_Name)
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
  begin object class=UI_Texture_Info Name=Game_Over_Title
    componentTextures.add(Texture2D'GUI.Game_Over_Title')
  end object
  begin object class=UI_Texture_Info Name=Black_Texture
    componentTextures.add(Texture2D'GUI.Black_Square')
  end object
  
  /** ===== UI Components ===== **/
  // Game Over Title
  begin object class=UI_Sprite Name=Game_Over_Title_Sprite
    tag="Game_Over_Title_Sprite"
    posX=0
    posY=90
    images(0)=Game_Over_Title
  end object
  componentList.add(Game_Over_Title_Sprite)
  
  // Fade
  begin object class=UI_Sprite Name=Screen_Fade_Component
    tag="Screen_Fade_Component"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
    bMandatoryScaleToWindow=true
  end object
  componentList.add(Screen_Fade_Component)
  
  
}


















