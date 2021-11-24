/*=============================================================================
 * UI_Page
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Container for components that is structured like a page.
 *===========================================================================*/
 
class UI_Page extends UI_Container dependsOn(UI_Fade_System);
 
// Pause game control
var protectedwrite bool bPauseGameWhenUp;

// Hide cursor setting
var protectedwrite bool bPageForcesCursorOff;
var protectedwrite bool bPageForcesCursorOn;

// This page is always displayed after a reset if true
var protectedwrite bool bInitialPage;

// Event stubs
event onPushPageEvent();
event onPopPageEvent();

/*=============================================================================
 * unfocusMenu()
 *
 * Removes control from the menu, while the menu is still up
 *===========================================================================*/
final public function unfocusMenu() {
  local UI_Component comp;
  
  foreach componentList(comp) {
    if (UI_Selector(comp) != none) UI_Selector(comp).setActive(false);
  }
  
  // Event implemented on children
  onUnfocusMenu();
}

/*=============================================================================
 * onClick()
 *
 * Called when the mouse is clicked on this page
 *===========================================================================*/
protected function onClick(int x, int y) {
  
}

/*=============================================================================
 * focusMenu()
 *
 * Gives control to the menu
 *===========================================================================*/
final public function focusMenu() {
  ///local UI_Component comp;
  ///
  ///foreach componentList(comp) {
  ///  /* you must init joy stick in focus menu for UI_Menu */
  ///  ///if (UI_Selector(comp) != none) UI_Selector(comp).initJoyStick();
  ///}
  ///
  // Event implemented on children
  onFocusMenu();
}

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
 * updateSelection()
 *
 * This function is the interface the selectors use to send their updates to us
 *===========================================================================*/
public function bool updateSelection
(
  class<object> selectionType, 
  int selectionIndex
);

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh();

/*=============================================================================
 * resetEffectOnComponent()
 *
 * Finds a component matching the tag, and resets its effects
 *===========================================================================*/
public function resetEffectOnComponent(string ctag) {
  findComp(ctag).resetEffects();
}

/*=============================================================================
 * addEffectToComponent()
 *
 * Adds an effect to a specified component on this page
 *===========================================================================*/
public function addEffectToComponent
(
  EffectStates effect, 
  string ctag, 
  float timeLength
) 
{
  findComp(ctag).addEffectToQueue(effect, timeLength);
}

/*=============================================================================
 * Button inputs
 *===========================================================================*/
public function onNavigateUp();
public function onNavigateDown();
public function onNavigateLeft();
public function onNavigateRight();
public function bool preNavigateUp() { return true; }
public function bool preNavigateDown() { return true; }
public function bool preNavigateLeft() { return true; }
public function bool preNavigateRight() { return true; }

/*=============================================================================
 * pCase()
 *
 * Takes a string, and outputs the string in "Propercase"
 * https://english.stackexchange.com/questions/15910/what-is-the-verb-that-means-to-capitalize-the-first-letter-of-a-word
 *===========================================================================*/
public static function string pCase(coerce string msg) {
  return caps(left(msg, 1)) $ locs(right(msg, len(msg) - 1));
}

defaultProperties
{
  posX=0
  posY=0
  posXEnd=1
  posYEnd=1
}















