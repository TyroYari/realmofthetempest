/*=============================================================================
 * ROTT_Input_Handler
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class receives input from the ROTT_Input_Controller, and executes any
 * action or navigation operations for the input.
 *===========================================================================*/

class ROTT_Input_Handler extends object;

// Store the page that contains the input controller for this handler
var public ROTT_UI_Page currentPage;

// Name of input handled by this handler
var privatewrite Name inputName;

// Optional sprite for click input boundaries
var private UI_Sprite buttonComponent;

// Sound effects
///var private bool bUseCustomSound;
///var private SoundEffectsEnum inputSuccessSfx;
///var private SoundEffectsEnum inputBlockedSfx;

// NPC dialog delegate to display after NPC transition
var public delegate<inputDelegate> inputActionDelegate;
var public delegate<conditionDelegate> inputConditionDelegate;

`include(ROTTColorLogs.h)

delegate inputDelegate();
delegate bool conditionDelegate();

/*=============================================================================
 * input()
 *
 * Called when input to this handler has been received.
 *===========================================================================*/
public function input() {
  // Check if input is blocked
  if (inputConditionDelegate != none) {
    if (!inputConditionDelegate()) {
      // Blocked Sfx
      ///playBlockedSfx();
      
      // Block input
      return;
    }
  } 
  // Success Sfx
  ///playSuccessSfx();

  // Execute input action
  if (inputActionDelegate != none) inputActionDelegate();
  
  // Execute per-instance customizable navigation
  if (inputName == 'XBoxTypeS_A') currentPage.forwardNavigation();  // This can always be left blank and handled in the action delegate instead
  if (inputName == 'XBoxTypeS_B') currentPage.backwardNavigation(); // for more complicated scenarios
}

/**=============================================================================
 * playBlockedSfx()
 *
 * Plays the sfx for blocked input
 *===========================================================================
public function playBlockedSfx() {
  if (bUseCustomSound) {
    // Play custom
    currentPage.gameInfo.sfxBox.playSFX(inputBlockedSfx);
  } else {
    // Play default
    currentPage.gameInfo.sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
  }
}
*/
/**=============================================================================
 * playSuccessSfx()
 *
 * Plays the sfx for successful input
 *===========================================================================
public function playSuccessSfx() {
  if (bUseCustomSound) {
    // Play custom
    currentPage.gameInfo.sfxBox.playSFX(inputSuccessSfx);
  } else {
    // Play default
    switch (inputName) {
      case 'XBoxTypeS_A': 
        currentPage.gameInfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
        break;
      case 'XBoxTypeS_B': 
        currentPage.gameInfo.sfxBox.playSFX(SFX_MENU_BACK);
        break;
      default: 
        currentPage.gameInfo.sfxBox.playSFX(SFX_MENU_NAVIGATE);
        break;
    }
  }
}
*/
/*=============================================================================
 * deleteHandler()
 *
 * Clear memory for garbage collection
 *===========================================================================*/
public function deleteHandler() {
  buttonComponent = none;
  inputActionDelegate = none;
  inputConditionDelegate = none;
  currentPage = none;
} 
 
/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Default navigation sound effects
  ///inputSuccessSfx=SFX_MENU_NAVIGATE
  ///inputBlockedSfx=SFX_MENU_INSUFFICIENT
}






















