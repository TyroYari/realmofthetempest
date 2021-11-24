/*============================================================================= 
 * ROTT_UI_Page_Shrine_Options
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Shows a prompt for interacting with item shrines, monument shrines, etc.
 *===========================================================================*/
 
class ROTT_UI_Page_Shrine_Options extends ROTT_UI_Page;

/** ============================== **/

enum UIShrineOptions {
  
  COMMENCE_RITUAL,
  CANCEL_RITUAL
  
};

var private UIShrineOptions menuSelection;

/** ============================== **/

// Internal references
var private UI_Sprite optionsSprite;
var private UI_Dialogue_Options shrineOptions;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  // Draw each component
  super.initializeComponent(newTag);
  
  // UI references
  optionsSprite = findSprite("Shrine_Options_Background");
  shrineOptions = UI_Dialogue_Options(findComp("Shrine_Options"));
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  super.onPushPageEvent();
  
  // Reset selector
  shrineOptions.hideSelector();
  shrineOptions.showSelector();
  
  // Display options
  shrineOptions.setOptions(
    "Commence ritual", "Cancel", 
    "", ""
  );
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
 * D-Pad controls
 *===========================================================================
public function onNavigateDown() {
  shrineOptions.selectDown();  
  sfxBox.playSFX(SFX_MENU_NAVIGATE);
}
public function onNavigateUp() { 
  shrineOptions.selectUp();  
  sfxBox.playSFX(SFX_MENU_NAVIGATE);
}
public function onNavigateLeft() {
  shrineOptions.selectLeft();  
  sfxBox.playSFX(SFX_MENU_NAVIGATE);
}
public function onNavigateRight() {
  shrineOptions.selectRight();  
  sfxBox.playSFX(SFX_MENU_NAVIGATE);
}
*/

public function bool preNavigateUp() { return false; }
public function bool preNavigateDown() { return false; }

/*============================================================================*
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  // Select an option
  switch (shrineOptions.getSelectionIndex()) {
    case COMMENCE_RITUAL:
      // Call kismet event
      gameInfo.triggerGlobalEventClass(
        class'ROTT_Kismet_Event_Shrine_Use', 
        gameInfo.tempestPawn
      );
      break;
    case CANCEL_RITUAL:
      parentScene.popPage(tag);
      gameInfo.unpauseGame();
      break;
  }
}

protected function navigationRoutineB() {
  parentScene.popPage(tag);
  gameInfo.unpauseGame();
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
  bPauseGameWhenUp=true
  bMandatoryScaleToWindow=true
  bPageForcesCursorOn=true
  
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
  // Shrine options 
  begin object class=UI_Texture_Info Name=Shrine_Options_Texture
    componentTextures.add(Texture2D'GUI.Monument_Interface_Options')
  end object
  
  /** ===== UI Components ===== **/
  // Shrine options 
  begin object class=UI_Sprite Name=Shrine_Options_Background
    tag="Shrine_Options_Background"
    posX=0
    posY=664
    images(0)=Shrine_Options_Texture
  end object
  componentList.add(Shrine_Options_Background)
  
  // NPC Dialogue Options
  begin object class=UI_Dialogue_Options Name=Shrine_Options
    tag="Shrine_Options"
  end object
  componentList.add(Shrine_Options)
  
}








