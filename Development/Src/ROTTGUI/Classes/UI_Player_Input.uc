/*=============================================================================
 * UI_Player_Input
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Handles input for the players 3D world behavior.
 *===========================================================================*/

class UI_Player_Input extends PlayerInput;

// Default dimensions, same size as our mock up UI designs
const NATIVE_WIDTH  = 1440; 
const NATIVE_HEIGHT = 900;

// Store last used input mode, true if controller
var privatewrite bool bGamepadActive;

// Store mouse position
var privatewrite IntPoint mousePosition;

// Store mouse position
var public float cursorSpeed;

// Padding for screen edges
var const float padSize;

// Store keys currently pressed down
var private array<name> downKeys;

`include(ROTTColorLogs.h)

/*============================================================================= 
 * setMousePosition()
 *
 * Sets mouse coordinates
 *===========================================================================*/
public function setMousePosition(int x, int y) {
  mousePosition.x = x;
  mousePosition.y = y;
}

/*============================================================================= 
 * getMousePositionX()
 *
 * 
 *===========================================================================*/
public function int getMousePositionX(bool bMandatoryScaleToWindow = false) {
  local float scaleX, scaleY, scaleMin;
  local float xOffset;
  
  if (!bMandatoryScaleToWindow) {
    // Get window scale
    scaleX = UI_HUD(myHUD).sizeX / NATIVE_WIDTH;
    scaleY = UI_HUD(myHUD).sizeY / NATIVE_HEIGHT;
    
    // Scaling mode
    switch (UI_HUD(myHUD).scaleMode) {
      case FIXED_SCALE:
        // Calculate offset for unscaled UI
        xOffset = UI_HUD(myHUD).sizeX - NATIVE_WIDTH;
        
        // Set draw position
        return mousePosition.x - xOffset / 2;
      case NO_STRETCH_SCALE:
        // Use smallest scaler
        scaleMin = (scaleX < scaleY) ? scaleX : scaleY;
        
        // Get offset
        xOffset = (scaleX - scaleMin) * NATIVE_WIDTH / 2;
        
        // Use uniform scale
        return mousePosition.x * (NATIVE_WIDTH / (UI_HUD(myHUD).sizeX - xOffset * 2)) - xOffset;
    }
  }
  
  return mousePosition.x * (NATIVE_WIDTH / UI_HUD(myHUD).sizeX);
}

/*============================================================================= 
 * getMousePositionY()
 *
 * 
 *===========================================================================*/
public function int getMousePositionY(bool bMandatoryScaleToWindow = false) {
  local float scaleX, scaleY, scaleMin;
  local float yOffset;
  
  if (!bMandatoryScaleToWindow) {
    // Get window scale
    scaleX = UI_HUD(myHUD).sizeX / NATIVE_WIDTH;
    scaleY = UI_HUD(myHUD).sizeY / NATIVE_HEIGHT;
    
    // Scaling mode
    switch (UI_HUD(myHUD).scaleMode) {
      case FIXED_SCALE:
        // Calculate offset for unscaled UI
        yOffset = UI_HUD(myHUD).sizeY - NATIVE_HEIGHT;
        
        // Set draw position
        return mousePosition.y - yOffset / 2;
      case NO_STRETCH_SCALE:
        // Use smallest scaler
        scaleMin = (scaleX < scaleY) ? scaleX : scaleY;
        
        // Get offset
        yOffset = (scaley - scaleMin) * NATIVE_HEIGHT / 2;
        
        // Use uniform scale
        /// this is probably incorrect... see above
        return mousePosition.y * (NATIVE_HEIGHT / UI_HUD(myHUD).sizeY) + yOffset;
    }
  }
  
  return mousePosition.y * (NATIVE_HEIGHT / UI_HUD(myHUD).sizeY);
}

/*=============================================================================
 * Process an input key event routed through unrealscript from another object. 
 * This method is assigned as the value for the OnRecievedNativeInputKey
 * delegate so that native input events are routed to this unrealscript function.
 *
 * @param   ControllerId    the controller that generated this input key event
 * @param   inputName       the name of the key which an event occured for
 * @param   EventType       the type of event which occured (pressed, released, etc.)
 * @param   AmountDepressed for analog keys, the depression percent.
 *
 * @return  true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
(
  int controllerId, 
  Name inputName, 
  EInputEvent inputEvent, 
  float amountDepressed = 1.f, 
  bool bGamepad = false
)
{
  // Remap for keyboard and mouse support
  remapInput(inputName);
  
  // Store key states
  switch (inputEvent) {
    case IE_Pressed:  downKeys.addItem(inputName); break;
    case IE_Released: releaseKey(inputName); break;
  }
  
  // Check if input is from controller
  if (bGamepad) {
    // Hide cursor on controller use
    hideCursor();
    bGamepadActive = true;
  } else {
    // Show mouse control menus
    showMouseMenus();
    bGamepadActive = false;
  }
  
  return false;
}

/*============================================================================= 
 * remapInput()
 *
 * 
 *===========================================================================*/
public function remapInput(out name remapKey) {
  // Remap each key set
  switch (remapKey) {
    // Mouse and keyboard remapping
    case 'SpaceBar':          remapKey = 'XBoxTypeS_A'; break;   
      
    case 'W': case 'Up':      remapKey = 'XBoxTypeS_DPad_Up'; break;   
    case 'A': case 'Left':    remapKey = 'XBoxTypeS_DPad_Left'; break;   
    case 'S': case 'Down':    remapKey = 'XBoxTypeS_DPad_Down'; break;   
    case 'D': case 'Right':   remapKey = 'XBoxTypeS_DPad_Right'; break;
  }
}
  
/*============================================================================= 
 * releaseKey()
 *
 * 
 *===========================================================================*/
public function releaseKey(name releaseKey) {
  local int i;
  
  // Scan for key in the list of pressed keys
  for (i = downKeys.length - 1; i >= 0; i--) {
    // Check if match found, then remove match
    if (releaseKey == downKeys[i]) downKeys.remove(i, 1);
  }
}

/*============================================================================= 
 * isKeyDown()
 *
 * 
 *===========================================================================*/
public function int isKeyDown(name searchKey, optional name altKey = '') {
  local int i;
  
  // Scan for key in the list of pressed keys
  for (i = downKeys.length - 1; i >= 0; i--) {
    if (searchKey == downKeys[i]) return 1;
    if (altKey == downKeys[i]) return 1;
  }
  
  return 0;
}

/*============================================================================= 
 * hideCursor()
 *
 * Called when controller input is given.  Hides mouse UI. 
 *===========================================================================*/
public function hideCursor() {
  if (UI_HUD(myHUD) != none) UI_HUD(myHUD).hideCursor();
}

/*============================================================================= 
 * showMouseMenus()
 *
 * Called when keyboard and mouse input is given.  Shows mouse UI.
 *===========================================================================*/
public function showMouseMenus() {
  if (UI_HUD(myHUD) != none) UI_HUD(myHUD).showMouseMenus();
}

/*============================================================================= 
 * playerInput()
 *
 * Called every frame to handle player input
 *===========================================================================*/
event playerInput(float deltaTime) {
  local float fovScale, timeScale;

  // Save Raw values
  rawJoyUp = aBaseY;
  rawJoyRight = aStrafe;
  rawJoyLookRight = aTurn;
  rawJoyLookUp = aLookUp;
  
  // WASD (sloppy... remapped)
  if (!bGamepadActive) {
    if (isKeyDown('XBoxTypeS_DPad_Up') == 1) aBaseY = 100;
    if (isKeyDown('XBoxTypeS_DPad_Down') == 1) aBaseY = -100;
    if (isKeyDown('XBoxTypeS_DPad_Left') == 1) aStrafe = -100;
    if (isKeyDown('XBoxTypeS_DPad_Right') == 1) aStrafe = 100;
  }
  
  // Ignore time dilation
  deltaTime /= worldInfo.timeDilation;
  if (Outer.bDemoOwner && worldInfo.NetMode == NM_Client) {
    deltaTime /= worldInfo.demoPlaytimeDilation;
  }

  preProcessInput(deltaTime);

  // Scale to game speed
  timeScale = 100.f * deltaTime;
  aBaseY *= timeScale * moveForwardSpeed;
  aStrafe *= timeScale * moveStrafeSpeed;
  aUp *= timeScale * moveStrafeSpeed;
  aTurn *= timeScale * lookRightScale;
  aLookUp *= timeScale * lookUpScale;

  postProcessInput(deltaTime);

  processInputMatching(deltaTime);

  // Check for Double click movement.
  catchDoubleClickInput();

  // Take FOV into account (lower FOV == less sensitivity).
  if (bEnableFOVScaling) {
    fovScale = getFOVAngle() * 0.01111; // 1 / 90.0
  } else {
    fovScale = 1.0;
  }

  adjustMouseSensitivity(fovScale);

  aLookUp *= fovScale;
  aTurn *= fovScale;

  // Turning and strafing share the same axis.
  if (bStrafe > 0 ) {
    aStrafe += aBaseX + aMouseX;
  } else {
    aTurn += aBaseX + aMouseX;
  }
  
  // Look up/down.
  aLookup += aMouseY;
  if (bInvertMouse) {
    aLookup *= -1.f;
  }

  if (bInvertTurn) {
    aTurn *= -1.f;
  }
  
  if (aBaseY < 100 && aBaseY > -100) {
    aBaseY = 0;
  }
  
  // Forward/ backward movement
  aForward += aBaseY;

  // Handle walking.
  handleWalking();

  // check for turn locking
  if (bLockTurnUntilRelease) {
    if (rawJoyLookRight != 0) {
      aTurn = 0.f;
      if (autoUnlockTurnTime > 0.f) {
        autoUnlockTurnTime -= deltaTime;
        if (autoUnlockTurnTime < 0.f) {
          bLockTurnUntilRelease = false;
        }
      }
    } else {
      bLockTurnUntilRelease = false;
    }
  }
  
  // ignore move input
  // Do not clear rawJoy flags, as we still want to be able to read input.
  if (isMoveInputIgnored()) {
    aForward = 0.f;
    aStrafe = 0.f;
    aUp = 0.f;
  }

  // ignore look input
  // Do not clear rawJoy flags, as we still want to be able to read input.
  if (isLookInputIgnored()) {
    aTurn = 0.f;
    aLookup = 0.f;
  }
  
  // Check for HUD
  if (myHUD != none) {
    // Move mouse on x & y axis 
    mousePosition.x += aMouseX * cursorSpeed;
    mousePosition.y -= aMouseY * cursorSpeed;
    
    // Clamp mouse within viewport width and height 
    mousePosition.x = clamp(mousePosition.x, 0, myHUD.sizeX - padSize);
    mousePosition.y = clamp(mousePosition.y, 0, myHUD.sizeY - padSize);
    
  }

}

/*============================================================================= 
 * default properties
 *===========================================================================*/
defaultProperties
{
  // Mouse speed
  cursorSpeed=0.4125
  
  // Distance from edges
  padSize=10
  
  //OnReceivedNativeInputKey=onInputKey
  //OnReceivedNativeInputChar=InputChar
}















