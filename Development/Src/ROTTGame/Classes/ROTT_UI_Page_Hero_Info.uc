/*=============================================================================
 * ROTT_UI_Page_Hero_Info
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page is the base class for pages that inspect hero info.
 *
 * (see: ROTT_UI_Page_Stats_Inspection.uc)
 * (see: ROTT_UI_Page_Class_Skilltree.uc)
 * (see: ROTT_UI_Page_Glyph_Skilltree.uc)
 * (see: ROTT_UI_Page_Mastery_Skilltree.uc)
 *===========================================================================*/
 
class ROTT_UI_Page_Hero_Info extends ROTT_UI_Page
abstract;
  
// Navigation control data
enum MenuControlStates {
  VIEW_MODE,
  SELECTION_MODE,
  RESET_VIEW_MODE,
  RESET_SELECTION_MODE,
  BLESS_SELECTION_MODE,
};

var protected MenuControlStates controlState;

// Parent scene information
var protected ROTT_UI_Scene_Game_Menu gameMenuScene;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Parent scene
  gameMenuScene = ROTT_UI_Scene_Game_Menu(outer);
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  UI_Selector(findComp("Input_Listener")).setActive(true);
  UI_Selector(findComp("Input_Listener")).initJoyStick();
  
}

/*=============================================================================
 * onPopPageEvent()
 *
 * Called when this page is removed from the scene
 *===========================================================================*/
event onPopPageEvent() {
  /// The page arrows will need to be placed separaetly into the 4 hero info pages
  /// when we turn them into buttons.  So we should hide the tag they share in common here.
  if (gameMenuScene != none) gameMenuScene.enablePageArrows(false);
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
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA();
protected function navigationRoutineB() {
  /** delegate me **/
}

/*=============================================================================
 * Bumper inputs
 *===========================================================================*/
protected function navigationRoutineRB() {
  // Navigate to next hero
  switch (controlState) {
    case VIEW_MODE:
    case RESET_SELECTION_MODE:
    case BLESS_SELECTION_MODE:
      parentScene.nextAvailableHero();
      refresh();
      break;
  }
}

protected function navigationRoutineLB() {
  // Navigate to previous hero
  switch (controlState) {
    case VIEW_MODE:
    case RESET_SELECTION_MODE:
    case BLESS_SELECTION_MODE:
      parentScene.previousAvailableHero();
      refresh();
      break;
  }
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_LB
    inputName="XboxTypeS_LeftShoulder"
    buttonComponent=none
  end object
  inputList.add(Input_LB)
  
  begin object class=ROTT_Input_Handler Name=Input_RB
    inputName="XboxTypeS_RightShoulder"
    buttonComponent=none
  end object
  inputList.add(Input_RB)
  
  /** ===== UI Components ===== **/
  begin object class=UI_Selector Name=Input_Listener
    tag="Input_Listener"
    navigationType=SELECTION_2D
    bEnabled=true
    bActive=true
  end object
  componentList.add(Input_Listener)
  
}











