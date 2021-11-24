/*=============================================================================
 * ROTT_Player_Input
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Handles some input for the players 3D behavior
 *===========================================================================*/

class ROTT_Player_Input extends UI_Player_Input within ROTT_Player_Controller
  config(Input);

/*============================================================================= 
 * jump()
 *
 * Over world jump controls
 *===========================================================================*/
exec function jump() {
  if (bCrouching || bStomping) return;
  if (bJumpCrouchLock == LOCKED) return;
  
  super.jump();
}

/*============================================================================= 
 * playerInput()
 *
 * Called every frame
 *===========================================================================*/
event playerInput(float deltaTime) {
  super.playerInput(deltaTime);
  
  // Check for HUD
  if (ROTT_UI_Hud(myHUD) != none) {
    if (int(aMouseX * cursorSpeed) != 0 || int(aMouseY * cursorSpeed) != 0) {
      // Unhide mouse
      if (gameInfo.sceneManager.scene.isMouseVisible()) {
        ROTT_UI_Hud(myHUD).unlockCursorHidden();
      } else {
        ROTT_UI_Hud(myHUD).lockCursorHidden();
      }
    }
  }

}

/*=============================================================================
 * Process an input key event routed through unrealscript from another object. 
 * This method is assigned as the value for the OnRecievedNativeInputKey
 * delegate so that native input events are routed to this unrealscript function.
 *
 * @param   ControllerId    the controller that generated this input key event
 * @param   Key             the name of the key which an event occured for (KEY_Up, KEY_Down, etc.)
 * @param   EventType       the type of event which occured (pressed, released, etc.)
 * @param   AmountDepressed for analog keys, the depression percent.
 *
 * @return  true to consume the key event, false to pass it on.
 *===========================================================================*/
public function bool onInputKey
(
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
)
{
  local UI_Scene activeScene;
  
  super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
  
  // Retrieve the active scene
  activeScene = gameInfo.getActiveScene();
  
  // Delegate control to active scene
  if (activeScene != none) {
    return activeScene.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad) && !(Key == 'XBoxTypeS_A' && Event == IE_Released);
  }

  return true;
}

/*============================================================================= 
 * default properties
 *===========================================================================*/
defaultProperties
{
  OnReceivedNativeInputKey=onInputKey
  //OnReceivedNativeInputChar=InputChar
}















