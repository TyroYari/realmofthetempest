/*=============================================================================
 * ROTT_UI_Page_Party_Selection
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Displays hero units on screen, and allows the player to 
 * select one of them for further inspection.
 *===========================================================================*/
 
class ROTT_UI_Page_Party_Selection extends ROTT_UI_Page;

// Set up navigation for next page
enum NavigationMode {
  DEFAULT_NAVIGATION,
  RESET_STAT_NAVIGATION,
  RESET_SKILL_NAVIGATION,
  BLESS_STAT_NAVIGATION,
  ITEM_SHRINE_NAVIGATION,
};

var private NavigationMode navMode;

// Parent scene information
var private ROTT_UI_Scene_Game_Menu someScene;

// Internal references
var privatewrite UI_Selector heroSelector;

/*=============================================================================
 * initializeComponent()
 *
 * Called once, when the game is loaded
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Scene info
  someScene = ROTT_UI_Scene_Game_Menu(Outer);
  
  // Internal references
  heroSelector = UI_Selector(findComp("Hero_Selection_Box"));
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  updateSelection(class'ROTT_Combat_Hero', heroSelector.getSelection());
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  heroSelector.setActive(true);
}

/*=============================================================================
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu() {
  heroSelector.setActive(false);
}

/*=============================================================================
 * setNavMode()
 *
 * This function changes the navigation destination.  (This should be improved)
 * Note: This should be called after pushpage(), never before
 *===========================================================================*/
public function setNavMode(NavigationMode newNavMode) {
  navMode = newNavMode;
}

/*============================================================================= 
 * previousAvailableHero()
 *
 * Selects next non empty hero slot
 *===========================================================================*/
public function previousAvailableHero() {
  // Ignore party size of 1
  if (gameInfo.getActiveParty().getPartySize() == 1) return;
  
  // Sfx
  sfxBox.playSFX(SFX_MENU_NAVIGATE);
  
  // Find previous non-empty hero
  heroSelector.setLimitedValueRange(gameInfo.getActiveParty().getValidHeroesRange());
  heroSelector.previousValidSelection();
  heroSelector.resetLimitedValueRange();
  
  // Call for selection update
  onNavigateLeft();
}

/*============================================================================= 
 * nextAvailableHero()
 *
 * Selects previous non empty hero slot
 *===========================================================================*/
public function nextAvailableHero() {
  // Ignore party size of 1
  if (gameInfo.getActiveParty().getPartySize() == 1) return;
  
  // Sfx
  sfxBox.playSFX(SFX_MENU_NAVIGATE);
  
  // Find next non-empty hero
  heroSelector.setLimitedValueRange(gameInfo.getActiveParty().getValidHeroesRange());
  heroSelector.nextValidSelection();
  heroSelector.resetLimitedValueRange();
  
  // Call for selection update
  onNavigateRight();
}

/*============================================================================= 
 * navToNewStats()
 *
 * Used to automatically select the first hero with unspent stats
 *===========================================================================*/
public function navToNewStats() {
  // Move selector to first hero with unspent points
  heroSelector.resetSelection();
  heroSelector.setLimitedValueRange(gameInfo.getActiveParty().getUnspentHeroesRange());
  heroSelector.nextValidSelection();
  heroSelector.resetLimitedValueRange();
  
  // Select hero at new index
  updateSelection(class'ROTT_Combat_Hero', heroSelector.getSelection());
  
}

/*============================================================================= 
 * getSelectedHero()
 *
 * This public method is used to access the selected hero from other menu pages
 *===========================================================================*/
///public function ROTT_Combat_Hero getSelectedHero() {
///  local int index;
///  index = heroSelector.getSelection();
///  
///  return gameInfo.getActiveParty().getHero(index);
///}

/*============================================================================= 
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft() { 
  updateSelection(class'ROTT_Combat_Hero', heroSelector.getSelection()); 
}

public function onNavigateRight() {
  updateSelection(class'ROTT_Combat_Hero', heroSelector.getSelection()); 
}

/*============================================================================= 
 * Button inputs
 *===========================================================================*/
protected function bool requirementRoutineA() {
  updateSelection(class'ROTT_Combat_Hero', heroSelector.getSelection());
  return (parentScene.getSelectedHero() != none);
}

protected function navigationRoutineA() {
  switch (navMode) {
    case DEFAULT_NAVIGATION:
    case BLESS_STAT_NAVIGATION:
    case RESET_STAT_NAVIGATION:
      parentScene.pushPageByTag("Stats_Inspection_UI");
      break;
    case RESET_SKILL_NAVIGATION:
      someScene.pushMenu(CLASS_SKILLTREE);
      break;
    case ITEM_SHRINE_NAVIGATION:
      parentScene.pushPageByTag("Stats_Inspection_UI", false);
      parentScene.pushPageByTag("Shrine_Management_UI");
      break;
  }
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
}

protected function navigationRoutineB() {
  // Close party selection
  heroSelector.resetSelection();
  parentScene.removeObjectSelection(class'ROTT_Combat_Hero'); /// encapsulate this into the selector? store selection type in selector
  
  // Navigate out from party selection
  switch (navMode) {
    case BLESS_STAT_NAVIGATION:
      // Switch back to NPC
      sceneManager.switchScene(SCENE_NPC_DIALOG);
      break;
    case ITEM_SHRINE_NAVIGATION:
      // Switch back to 3D World
      sceneManager.switchScene(SCENE_OVER_WORLD);
      break;
    default:
      parentScene.popPage();
      break;
  }
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*============================================================================= 
 * Assets
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
  
  /** ===== UI Components ===== **/
  // Party Selection Box
  begin object class=UI_Selector Name=Hero_Selection_Box
    tag="Hero_Selection_Box"
    bEnabled=true
    posX=61
    posY=541
    navigationType=SELECTION_HORIZONTAL
    selectionOffset=(x=200,y=0)
    numberOfMenuOptions=3
    hoverCoords(0)=(xStart=64,yStart=546,xEnd=254,yEnd=837)
    hoverCoords(1)=(xStart=264,yStart=546,xEnd=454,yEnd=837)
    hoverCoords(2)=(xStart=464,yStart=546,xEnd=654,yEnd=837)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Party_Selection_Box')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
    // Inactive arrow
    begin object class=UI_Texture_Info Name=Inactive_Selection_Arrow
      componentTextures.add(Texture2D'GUI.Party_Selection_Nav_Marker')
    end object
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      posX=79
      posY=-18
      images(0)=Inactive_Selection_Arrow
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Hero_Selection_Box)
  
}



























