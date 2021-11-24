/*=============================================================================
 * UI_Widget
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A widget can be activated to take input from the player, with a graphical
 * representation.
 *===========================================================================*/

class UI_Widget extends UI_Container;

// Store the input state for the widget
var protectedwrite bool bActive; 

// Store dpad button states
var protectedwrite bool bDpadUp, bDpadDown, bDpadLeft, bDpadRight; 

// Button inputs
var public delegate<inputDelegation> onInputA;
var public delegate<inputDelegation> onInputB;
var public delegate<inputDelegation> onInputX;
var public delegate<inputDelegation> onInputY;
var public delegate<inputDelegation> onInputRB;
var public delegate<inputDelegation> onInputLB;

var public delegate<inputDelegation> onInputLeft;
var public delegate<inputDelegation> onInputRight;
var public delegate<inputDelegation> onInputUp;
var public delegate<inputDelegation> onInputDown;

var public delegate<inputDelegation> onInputLeftRelease;
var public delegate<inputDelegation> onInputRightRelease;
var public delegate<inputDelegation> onInputUpRelease;
var public delegate<inputDelegation> onInputDownRelease;

// Input delegation type
delegate inputDelegation();

/*=============================================================================
 * parseInput()
 *
 * This passes input to input handlers based on key and event type.
 *===========================================================================*/
public function parseInput(Name inputName, EInputEvent inputEvent) {
  if (!bActive) return;

  // Remap
  switch (inputName) {
    // Mouse and keyboard
    case 'LeftMouseButton':   inputName = 'XBoxTypeS_A'; break;
    case 'Q':                 inputName = 'XBoxTypeS_B'; break;
    case 'SpaceBar':          inputName = 'XBoxTypeS_A'; break;   
    
    case 'W': case 'Up':      inputName = 'XBoxTypeS_DPad_Up'; break;   
    case 'A': case 'Left':    inputName = 'XBoxTypeS_DPad_Left'; break;   
    case 'S': case 'Down':    inputName = 'XBoxTypeS_DPad_Down'; break;   
    case 'D': case 'Right':   inputName = 'XBoxTypeS_DPad_Right'; break;
  }
  
  // Check input event type
  if (inputEvent == IE_Released) {
    // Button release inputs
    switch (inputName) {
      case 'XBoxTypeS_A': onInputA(); break;
      case 'XBoxTypeS_B': onInputB(); break;
      case 'XBoxTypeS_X': onInputX(); break;
      case 'XBoxTypeS_Y': onInputY(); break;
      case 'XboxTypeS_LeftShoulder': onInputLB(); break;
      case 'XboxTypeS_RightShoulder': onInputRB(); break;
    }
    
    // Dpad release
    switch (inputName) {
      case 'XBoxTypeS_DPad_Up': bDpadUp = false; break;
      case 'XBoxTypeS_DPad_Down': bDpadDown = false; break;
      case 'XBoxTypeS_DPad_Left': bDpadLeft = false; break;
      case 'XBoxTypeS_DPad_Right': bDpadRight = false; break;
    }
    
  } else if (inputEvent == IE_Pressed) {
    // Directional press inputs
    switch (inputName) {
      case 'XBoxTypeS_DPad_Up': onInputUp(); bDpadUp = true; break;
      case 'XBoxTypeS_DPad_Down': onInputDown(); bDpadDown = true; break;
      case 'XBoxTypeS_DPad_Left': onInputLeft(); bDpadLeft = true; break;
      case 'XBoxTypeS_DPad_Right': onInputRight(); bDpadRight = true; break;
    }
  }
}

/*=============================================================================
 * start()
 *
 * Called after data is initialized for this component.
 *===========================================================================*/
public function start() {
  (bActive) ? onActivation() : onDeactivation();
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  if (!bActive) return;
  
  // Get player input
  joyStickX(getPlayerInput().rawJoyRight);
  joyStickY(getPlayerInput().rawJoyUp);
  
}

/*=============================================================================
 * joyStickX()
 *
 * Joystick input to this widget.
 *===========================================================================*/
protected function joyStickX(float analogX);

/*=============================================================================
 * joyStickY()
 *
 * Joystick input to this widget.
 *===========================================================================*/
protected function joyStickY(float analogY);

/*=============================================================================
 * setActive()
 *
 * Called to set the widget status.  When active, the widget listens for input.
 *===========================================================================*/
public function setActive(bool activeState) {
  // Store active state
  bActive = activeState;
  
  // Call activation events
  (activeState) ? onActivation() : onDeactivation();
  
  // Clear widget controls on  deactivation
  if (!activeState) resetWidgetControls();
}

/*=============================================================================
 * onActivation()
 *
 * Called when the widget is activated
 *===========================================================================*/
protected function resetWidgetControls() {
  bDpadUp = false; 
  bDpadDown = false; 
  bDpadLeft = false; 
  bDpadRight = false;
}

/*=============================================================================
 * onActivation()
 *
 * Called when the widget is activated
 *===========================================================================*/
protected function onActivation();

/*=============================================================================
 * onDeactivation()
 *
 * Called when the widget is deactivated
 *===========================================================================*/
protected function onDeactivation();

/*=============================================================================
 * stub()
 *===========================================================================*/
public function stub();

/*=============================================================================
 * Default settings
 *===========================================================================*/
defaultProperties
{
  bActive=true
  
  onInputA=stub
  onInputB=stub
  onInputX=stub
  onInputY=stub
  
  onInputUp=stub
  onInputDown=stub
  onInputLeft=stub
  onInputRight=stub
  
  onInputLB=stub
  onInputRB=stub
}






















