/*=============================================================================
 * ROTT_UI_Page
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is a generic UI page with ROTT references
 *===========================================================================*/
 
class ROTT_UI_Page extends UI_Page
dependsOn(ROTT_UI_Scene_Manager);

// Parent scene
var protected ROTT_UI_Scene parentScene;

// Input controller for parsing all input to the page
var protected instanced ROTT_Input_Controller inputController;

// Input handlers that pass to the controller
var protected instanced array<ROTT_Input_Handler> inputList;

// External game references
var protectedwrite ROTT_Game_Info gameInfo;
var protectedwrite ROTT_Game_Sfx sfxBox;
var protectedwrite ROTT_Game_Music jukebox;
var protectedwrite ROTT_UI_Scene_Manager sceneManager;

// Convenient references
var protected ROTT_Party_System partySystem;
/** Add more convenient references here **/

// Navigation destination tags
var public string nextPage;
var public string backPopPage;
var public DisplayScenes nextScene;
var public DisplayScenes backScene;
  
/*=============================================================================
 * initialize references
 *===========================================================================*/
public function setGameInfo() {
  // Hook up some external references
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  sfxBox = ROTT_Game_Sfx(gameInfo.sfxBox);
  jukebox = gameInfo.jukebox;
}

/*=============================================================================
 * initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // Parent scene
  parentScene = ROTT_UI_Scene(outer);
  
  // Link references
  sceneManager = gameInfo.sceneManager;
  
  // Load player profile, if needed
  if (gameInfo.playerProfile != none) {
    partySystem = gameInfo.playerProfile.partySystem;
  }
  
  // Set up input controller
  inputController = new(self) class'ROTT_Input_Controller';
  
  for (i = 0; i < inputList.length; i++) {
    inputController.addHandler(inputList[i]);
  }
  
  // Set up some automatic delegates
  inputController.setInputDelegates('XBoxTypeS_A', navigationRoutineA, requirementRoutineA);
  inputController.setInputDelegates('XBoxTypeS_B', navigationRoutineB, requirementRoutineB);
  inputController.setInputDelegates('XBoxTypeS_X', navigationRoutineX, requirementRoutineX);
  inputController.setInputDelegates('XBoxTypeS_Y', navigationRoutineY, requirementRoutineY);
  
  inputController.setInputDelegates('XboxTypeS_LeftShoulder', navigationRoutineLB, requirementRoutineLB);
  inputController.setInputDelegates('XboxTypeS_RightShoulder', navigationRoutineRB, requirementRoutineRB);
  
  // Mouse and keyboard delegates
  inputController.setInputDelegates('LeftMouseButton', navigationRoutineA, requirementRoutineA);
  inputController.setInputDelegates('SpaceBar', navigationRoutineA, requirementRoutineA);
  
  inputController.setInputDelegates('Q', navigationRoutineB, requirementRoutineB);
  
  /// inputController.setInputDelegates('XBoxTypeS_DPad_Left', navigateLeft, noRequirement);
  /// inputController.setInputDelegates('XBoxTypeS_DPad_Right', navigateRight, noRequirement);
  /// inputController.setInputDelegates('XBoxTypeS_DPad_Up', navigateUp, noRequirement);
  /// inputController.setInputDelegates('XBoxTypeS_DPad_Down', navigateDown, noRequirement);

  
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh();

/*=============================================================================
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * inputName        the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
( 
  int ControllerId, 
  name inputName, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  local array<UI_Widget> activeWidgets;
  local int i;
  
  // Get list of active widgets
  for (i = 0; i < componentList.length; i++) {
    if (UI_Widget(componentList[i]) != none) {
      if (UI_Widget(componentList[i]).bActive) {
        activeWidgets.addItem(UI_Widget(componentList[i]));
      }
    }
  }
  
  // Pass input to widgets
  for (i = 0; i < activeWidgets.length; i++) {
    activeWidgets[i].parseInput(inputName, Event);
  }
  
  // Pass input to input controller 
  if (inputController != none) {
    inputController.parseInput(inputName, Event);
  }
  
  return true;
}

/*============================================================================= 
 * updateSelection()
 *
 * This function is the interface the selectors use to send their updates out.
 * Return value used for sound effects.
 *===========================================================================*/
public function bool updateSelection
(
  class<object> selectionType, 
  int selectionIndex
) 
{
  ///local ROTT_Combat_Hero hero;
  ///local int index;
  
  // Default selection updates
  switch (selectionType) {
    case class'ROTT_Party': 
      // Search to select party data in party system 
      if (parentScene.selectObject(gameInfo.playerProfile.partySystem.getParty(selectionIndex))) {
        // Report success
        return true;
      } else {
        // Remove selection
        if (gameInfo.playerProfile.partySystem.getParty(selectionIndex) == none) {
          parentScene.removeObjectSelection(selectionType);
        }
      }
      break;
    case class'ROTT_Combat_Hero':
      // Search to select hero data in party
      if (parentScene.selectObject(gameInfo.getActiveParty().getHero(selectionIndex))) {
        // Report success
        return true;
      } else {
        // Remove selection
        if (gameInfo.getActiveParty().getHero(selectionIndex) == none) {
          parentScene.removeObjectSelection(selectionType);
        }
      }
      break;
  }
  
  return false;
}

/*=============================================================================
 * clearWidgets()
 *
 * Sets all widgets to be inactive.
 *===========================================================================*/
public function clearWidgets() {
  local int i;
  
  // Disable all widgets
  for (i = 0; i < componentList.length; i++) {
    if (UI_Widget(componentList[i]) != none) {
      UI_Widget(componentList[i]).setActive(false);
    }
  }
}

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  local UI_Component comp;
  
  // Track time on components
  foreach componentList(comp) {
    if (comp != none) comp.elapseTimer(deltaTime, gameInfo.gameSpeed);
  }
}

/*=============================================================================
 * clearTempUI()
 *
 * Removes any UI that is meant to be temporary 
 *===========================================================================*/
public function clearTempUI() {
  local int i;
  
  for (i = componentList.length - 1; i >= 0; i--) {
    if (componentList[i].bTemporaryUI) {
      componentList[i].deleteComp();
      componentList.remove(i, 1);
    }
  }
}

/*=============================================================================
 * setDonationCosts()
 *
 * Called to update donation costs, in order, dynamically
 *===========================================================================*/
public function setDonationCosts(array<ItemCost> costList) {
  local ROTT_UI_Displayer_Cost costDisplayer;
  local int i, k;
  k = 0;
  
  // Iterate through the displayers
  for (i = 0; i < componentList.length; i++) {
    // Cast to cost displayer
    costDisplayer = ROTT_UI_Displayer_Cost(componentList[i]);
  
    // Check for valid displayer
    if (costDisplayer != none) {
      if (k < costList.length) {
        // Update cost info
        costDisplayer.setEnabled(true);
        costDisplayer.setDonationCost(costList[k]);
        k++;
      } else {
        costDisplayer.setEnabled(false);
      }
    }
  }
}

/*=============================================================================
 * setCostValues()
 *
 * Called to update all the cost displayers
 *===========================================================================*/
public function setCostValues(array<ItemCost> costList) {
  local ROTT_UI_Displayer_Cost costDisplayer;
  local bool bCostFound;
  local int i, j;
  
  // Iterate through the cost list
  for (i = 0; i < costList.length; i++) {
    // Track if costs are found, for warnings
    bCostFound = false;
    
    // Iterate through the displayers
    for (j = 0; j < componentList.length; j++) {
      // Cast to cost displayer
      costDisplayer = ROTT_UI_Displayer_Cost(componentList[j]);
      
      // Check for valid displayer
      if (costDisplayer != none) {
        // Check for matching cost type
        if (costList[i].currencyType == costDisplayer.currencyType) {
          // Track warning info
          bCostFound = true;
          
          // Set cost value
          costDisplayer.costValue = costList[i].quantity;
        }
        
        // Refresh displayer
        costDisplayer.refresh();
      }
    }
    
    if (bCostFound == false) {
      yellowLog("Warning (!) Cost not found in UI for " $ costList[i].currencyType $ " on " $ self);
    }
  }
  
}

/*============================================================================= 
 * digitCycleTrick
 *
 * Description: This function cycles through digits for visual effects
 *===========================================================================*/
static function digitCycleTrick(int trueValue, out int displayValue) { 
  local int onesTrick;    
  local int difference;
  
  // Set up the desired change for visually cycling through the digits
  onesTrick = 111111111;
  
  // Store the difference between displayed value and actual value
  difference = trueValue - displayValue;
  
  if (difference == 0) return;
  if (difference > 0) {
    // Spin the digits upward
    do {
      onesTrick -= 10 ** (Len(onesTrick) - 1); 
    } until (onesTrick <= difference);
    
    displayValue += onesTrick;
    
  } else {
    // Spin the digits downward
    do {
      onesTrick -= 10 ** (Len(onesTrick) - 1);
    } until (onesTrick <= abs(difference));
    
    displayValue -= onesTrick;
  }
  
}

/*=============================================================================
 * onSceneActivation()
 *
 * Called when the parent scene is activated
 *===========================================================================*/
event onSceneActivation();

/*=============================================================================
 * onSceneDeactivation()
 *
 * Called when the parent scene is deactivated
 *===========================================================================*/
event onSceneDeactivation();

/*============================================================================= 
 * onScenePause()
 *
 * This event is called when the parent scene pauses
 *===========================================================================*/
event onScenePause();

/*============================================================================= 
 * onSceneUnpause()
 *
 * This event is called when the parent scene unpauses
 *===========================================================================*/
event onSceneUnpause();

/*=============================================================================
 * onFocusMenu()
 *
 * Called when the menu is given focus.  Enable controls and update graphics
 * here.
 *===========================================================================*/
event onFocusMenu();

/*=============================================================================
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu();

/*=============================================================================
 * forwardNavigation()
 * 
 * Called from the input handler if we are nevigating with 'A'
 *===========================================================================*/
public function forwardNavigation() {
  if (nextScene != NO_SCENE) {
    sceneManager.switchScene(nextScene);
  }
  if (nextPage != "") {
    sceneManager.scene.pushPageByTag(nextPage);
  }
}

/*=============================================================================
 * backwardNavigation()
 * 
 * Called from the input handler if we are nevigating with 'B'
 *===========================================================================*/
public function backwardNavigation() {
  if (backScene != NO_SCENE) {
    sceneManager.switchScene(backScene);
  }
  if (backPopPage != "") {
    sceneManager.scene.popPage(backPopPage);
  }
}

/*============================================================================= 
 * makeLabel()
 *
 * Creates a label on the screen. [should encapsulate this more into the label]
 *===========================================================================*/
protected function UI_Label_Combat makeLabel(string text) {
  local UI_Label_Combat label;
  
  // Create label
  label = new(self) class'UI_Label_Combat';
  componentList.addItem(label);
  label.initializeComponent();
  label.startEvent();
  label.setText(text);
  label.bTemporaryUI = true;
  
  // Set position of message
  label.updatePosition(0, 0, 1440, 900);
  
  // Set display info
  label.setStyle(
    FONT_LARGE,
    COLOR_TAN,
    ANIMATE_SLOW_BOUNCE
  );
  
  // Sets home position data
  label.postInit();
  
  return label;
}

/*=============================================================================
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA();
protected function navigationRoutineB();
protected function navigationRoutineX();
protected function navigationRoutineY();
protected function navigationRoutineRB();
protected function navigationRoutineLB();

/*=============================================================================
 * Button requirements
 *===========================================================================*/
protected function bool requirementRoutineA() { return true; }
protected function bool requirementRoutineB() { return true; }
protected function bool requirementRoutineX() { return true; }
protected function bool requirementRoutineY() { return true; }
protected function bool requirementRoutineLB() { return true; }
protected function bool requirementRoutineRB() { return true; }
protected function bool noRequirement() { return true; }

/*=============================================================================
 * deleteComp()
 *
 * Called when the parent scene is destroyed.  (Not used currently)
 *===========================================================================*/
event deleteComp() {
  super.deleteComp();
  
  // Clear references
  gameInfo = none;
  sfxBox = none;
  jukebox = none;
  sceneManager = none;
  
  // Remove input controller and its handlers
  if (inputController != none) {
    inputController.deleteController();
    inputController = none;
  }
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_Left
    inputName="XBoxTypeS_DPad_Left"
    buttonComponent=none
  end object
  inputList.add(Input_Left)
  
  begin object class=ROTT_Input_Handler Name=Input_Right
    inputName="XBoxTypeS_DPad_Right"
    buttonComponent=none
  end object
  inputList.add(Input_Right)
  
  begin object class=ROTT_Input_Handler Name=Input_Up
    inputName="XBoxTypeS_DPad_Up"
    buttonComponent=none
  end object
  inputList.add(Input_Up)
  
  begin object class=ROTT_Input_Handler Name=Input_Down
    inputName="XBoxTypeS_DPad_Down"
    buttonComponent=none
  end object
  inputList.add(Input_Down)
  
  // Navigation destination tags
  nextPage=""
  backPopPage=""
  nextScene=NO_SCENE
  backScene=NO_SCENE
}













