/*=============================================================================
 * ROTT_Input_Controller
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class parses input, and passes it to the proper input handler.
 *===========================================================================*/

class ROTT_Input_Controller extends object
dependsOn(ROTT_Input_Handler);

// Input handlers
var private array<ROTT_Input_Handler> inputHandlers;

`include(ROTTColorLogs.h)

// Handler delegates???
delegate inputDelegate();
delegate bool conditionDelegate();

/*=============================================================================
 * parseInput()
 *
 * This passes input to input handlers based on key and event type.
 *===========================================================================*/
public function bool parseInput(Name inputName, EInputEvent inputEvent) {
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
      // Gamepad
      case 'XBoxTypeS_A':
      case 'XBoxTypeS_B':
      case 'XBoxTypeS_X':
      case 'XBoxTypeS_Y':
      case 'XboxTypeS_LeftShoulder': 
      case 'XboxTypeS_RightShoulder': 
        if (getHandler(inputName) != none) {
          getHandler(inputName).input(); 
          return true;
        }
        return false;
    }
  } else if (inputEvent == IE_Pressed) {
    switch (inputName) {
      // Gamepad, directional press inputs      
      case 'XBoxTypeS_DPad_Up':  
      case 'XBoxTypeS_DPad_Down': 
      case 'XBoxTypeS_DPad_Left':
      case 'XBoxTypeS_DPad_Right':  
        if (getHandler(inputName) != none) {
          getHandler(inputName).input(); 
          return true;
        }
        return false;
    }
  }
  return false;
} 
 
/*=============================================================================
 * addHandler()
 *
 * Attaches a handler to this controller for a given input type.
 *===========================================================================*/
public function addHandler(ROTT_Input_Handler inputHandler) {
  // Check for input redundancy
  if (getHandler(inputHandler.inputName) != none) {
    yellowLog("Warning (!) Attempt to add redundant input: " $ inputHandler.inputName);
    return;
  }
  
  // Set outer page reference
  inputHandler.currentPage = ROTT_UI_Page(outer);
  if (ROTT_UI_Page(outer) == none) redlog("Not a page: " $ outer);
  
  // Add input handler
  inputHandlers.addItem(inputHandler);
} 
 
/*=============================================================================
 * getHandler()
 *
 * Searches for a handler corresponding to the given an input name.
 *===========================================================================*/
public function ROTT_Input_Handler getHandler(Name inputName) {
  local int i;
  
  /// Default page input handlers
  // Iterate through input handlers
  for (i = 0; i < inputHandlers.length; i++) {
    // Check if input type matches
    if (inputHandlers[i].inputName == inputName) {
      return inputHandlers[i];
    }
  }
  
  // Return none if nothing is found
  return none;
} 
 
/*============================================================================= 
 * setInputDelegates()
 *
 * Assigns delegates for handling a given input
 *===========================================================================*/
public function setInputDelegates
(
  Name inputName, 
  delegate<inputDelegate> inputActionDelegate,
  delegate<conditionDelegate> inputConditionDelegate
) 
{
  if (getHandler(inputName) != none) {
    // Overwrite check
    if (getHandler(inputName).inputActionDelegate != none) {
      yellowLog("Warning (!) Overwriting input handler");
    }
    
    // Delegate assignment
    getHandler(inputName).inputActionDelegate = inputActionDelegate;
    getHandler(inputName).inputConditionDelegate = inputConditionDelegate;
  }
}

/*=============================================================================
 * deleteController()
 *
 * Clear memory for garbage collection
 *===========================================================================*/
public function deleteController() {
  local int i;
  
  for (i = 0; i < inputHandlers.length; i++) {
    inputHandlers[i].deleteHandler();
  }
} 
 
/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  
}






















