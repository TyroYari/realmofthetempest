/*============================================================================= 
 * ROTT_UI_Page_Shrine_Notification
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Shows a prompt for interacting with item shrines, monument shrines, etc.
 *===========================================================================*/
 
class ROTT_UI_Page_Shrine_Notification extends ROTT_UI_Page;

// Internal references
var private UI_Sprite backgroundSprite;
var private UI_Label interfaceText1;
var private UI_Label interfaceText2;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  // Draw each component
  super.initializeComponent(newTag);
  
  // UI references
  backgroundSprite = findSprite("Text_Bar");
  interfaceText1 = findLabel("Interface_Text_Line_1");
  interfaceText2 = findLabel("Interface_Text_Line_2");
}

/*=============================================================================
 * setText()
 * 
 * This writes text to the interface
 *===========================================================================*/
public function setText(string textLine1, string textLine2) {
  // Set the interface text
  interfaceText1.setText(textLine1);
  interfaceText2.setText(textLine2);
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  backgroundSprite.clearEffects();
  backgroundSprite.addEffectToQueue(FADE_IN, 0.5);
  
  interfaceText1.addEffectToQueue(DELAY, 0.1);
  interfaceText1.addEffectToQueue(FADE_IN, 0.6);
  
  interfaceText2.addEffectToQueue(DELAY, 0.1);
  interfaceText2.addEffectToQueue(FADE_IN, 0.6);
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  backgroundSprite.clearEffects();
  interfaceText1.resetEffects();
  interfaceText2.resetEffects();
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
 * onSceneActivation()
 *
 * This event is called every time the parent scene is activated
 *===========================================================================*/
public function onSceneActivation() {
  
}

/*============================================================================= 
 * onSceneDeactivation()
 *
 * This event is called every time the parent scene is deactivated
 *===========================================================================*/
public function onSceneDeactivation() {
  
}

/*=============================================================================
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
  // Remap each key set
  switch (Key) {
    // Mouse and keyboard remapping
    case 'LeftMouseButton': Key = 'XBoxTypeS_X'; break;
  }
  
  // Pass input to input controller
  if (inputController != none) {
    inputController.parseInput(Key, Event);
  }
  
  switch (Key) {
    case 'LeftShift': 
    case 'XboxTypeS_LeftTrigger': 
      if (Event == IE_Pressed) gameinfo.setTemporalBoost();
      if (Event == IE_Released) gameinfo.SetGameSpeed(1);
      break;
  }
  return false;
  
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft();
public function onNavigateRight();

/*============================================================================*
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  
}

protected function navigationRoutineB() {
  
}

protected function navigationRoutineX() {
  parentScene.pushPage(ROTT_UI_Scene_Over_World(parentScene).shrineOptionsPage);
}

/*============================================================================= 
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  super.deleteComp();
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bPauseGameWhenUp=false
  bMandatoryScaleToWindow=true
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_X
    inputName="XBoxTypeS_X"
    buttonComponent=none
  end object
  inputList.add(Input_X)
  
  /** ===== Textures ===== **/
  // Chest interface
  begin object class=UI_Texture_Info Name=Over_World_Text_Bar
    componentTextures.add(Texture2D'GUI.Over_World_Text_Bar')
  end object
  
  // Fader 
  begin object class=UI_Sprite Name=Text_Bar
    tag="Text_Bar"
    posX=0
    posY=544
    images(0)=Over_World_Text_Bar
  end object
  componentList.add(Text_Bar)
  
  // Interface text
  begin object class=UI_Label Name=Interface_Text_Line_1
    tag="Interface_Text_Line_1"
    posX=0
    posY=562
    posXEnd=NATIVE_WIDTH
    posYEnd=612
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_MEDIUM_PEACH
    labelText="The Obelisk shrine awaits your prayers."
  end object
  componentList.add(Interface_Text_Line_1)
  
  begin object class=UI_Label Name=Interface_Text_Line_2
    tag="Interface_Text_Line_2"
    posX=0
    posY=600
    posXEnd=NATIVE_WIDTH
    posYEnd=621
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_MEDIUM_PEACH
    labelText="The Obelisk shrine awaits your prayers."
  end object
  componentList.add(Interface_Text_Line_2)
  
}








