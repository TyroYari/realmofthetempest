/*=============================================================================
 * UI_Menu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A page that supports selection of objects.
 *===========================================================================*/
 
class UI_Menu extends UI_Page;

// We store the object that we are selecting from, which we can type cast later
var public object selectionSource;

// We store the object that we are selecting from, which we can type cast later
var protectedwrite UI_Sprite selectionSprite;

// For offset pixels
struct IntPair {
  var int x, y;
};

// Size of 2D grid
var private IntPair gridSize;      

// If true, menu selection wraps around from top to bottom
var private bool bWrapAround;

// Tracks which menu option this selector occupies
var private IntPair selectionCoords;      

// Pixels between each option selection
var private IntPair selectionOffset;      

// Navigation modes for selector input
enum SelectorTypes {
  SELECTION_VERTICAL,
  SELECTION_HORIZONTAL,
  SELECTION_2D,
};

var public SelectorTypes navigationType;

// Select a sfx for navigation
///var private SoundEffectsEnum navSound;      

// Widget graphics 
var public UI_Sprite selectorSprite;
var public UI_Sprite inactiveSprite;

// Graphics that represent each selection index
var public UI_Sprite graphicalSelections;

/** This class needs to handle two things
 ** 1) Representation of the selection
 ** 2) Traversal of the selector
**/

// Representation of the selection needs to support: 
// - A link to a sprite
// - Storing the coordinates of the sprites selection locations

// Traversal of the selector needs to support: 
// - Gamepad input
// - Mouse input
// --- requires coordinates of selection boxes
// --- this ties directly to the representation of the selection, the coordinates should be in this class

/// This implies that selectors are obsolete!!

/*=============================================================================
 * getSelection()
 *
 * Description: Accessor for selection coordinates (x,y)
 *===========================================================================*/
public function int getSelection() {
  return selectionCoords.x + selectionCoords.y * gridSize.x;
}

/*=============================================================================
 * clearSelection()
 *
 * Resets and hides selection.
 *===========================================================================*/
public function clearSelection() {
  resetSelection();
  setEnabled(false);
}

/*=============================================================================
 * resetSelection()
 *
 * Resets selection index to its default value.
 *===========================================================================*/
public function resetSelection() {
  selectionCoords.x = 0;
  selectionCoords.y = 0;
  selectionUpdate();
}

/*=============================================================================
 * forceSelection()
 *
 * Selects the given index
 *===========================================================================*/
public function forceSelection(int xIndex, optional int yIndex = -1) {
  if (yIndex == -1) {
    if (gridSize.x == 0) { selectionCoords.x = xIndex; return; }
    selectionCoords.x = xIndex % gridSize.x;
    selectionCoords.y = xIndex / gridSize.x;
  } else {
    if (gridSize.y == 0) { selectionCoords.y = xIndex; return; }
    selectionCoords.x = xIndex % gridSize.x;
    selectionCoords.y = yIndex % gridSize.y;
  }
  
  selectionUpdate();
}

/*=============================================================================
 * raveHighwindCall()
 *
 * Called by a cheat that enables rave mode graphics on selectors.
 *===========================================================================*/
public function raveHighwindCall() {
  super.raveHighwindCall();
  
  if (selectorSprite != none) selectorSprite.addHueEffect();
  if (inactiveSprite != none) inactiveSprite.addHueEffect();
}


/*=============================================================================
 * selectionUpdate()
 *
 * Called whenever a change has been made to the selection
 *===========================================================================*/
private function selectionUpdate() {
  // Active widget graphics
  if (selectorSprite != none) selectorSprite.setOffset(
    selectionOffset.x * selectionCoords.x,
    selectionOffset.y * selectionCoords.y
  );
  
  // Inactive widget graphics
  if (inactiveSprite != none) inactiveSprite.setOffset(
    selectionOffset.x * selectionCoords.x,
    selectionOffset.y * selectionCoords.y
  );
  
  // Selection graphics
  if (graphicalSelections != none) {
    graphicalSelections.setDrawIndex(getSelection());
  }
}

defaultProperties
{
  
}







/**
============================================================================= 
 * initializeComponent
 *
 * Called once from HUD's PostBeginPlay() when the scene is first initialized.
 *===========================================================================
public function initializeComponent(optional string newTag = "") {
  selectorSprite = findSprite("Selector_Sprite");
  inactiveSprite = findSprite("Inactive_Selector_Sprite");
  graphicalSelections = findSprite("Graphical_Selections");
  
  super.initializeComponent(newTag);
  
  // Automatically set option count
  if (graphicalSelections != none) {
    numberOfMenuOptions = graphicalSelections.images.length;
  }
  switch (navigationType) {
    case SELECTION_2D:
      numberOfMenuOptions = gridSize.x * gridSize.y;
      break;
    case SELECTION_HORIZONTAL:
      gridSize.x = numberOfMenuOptions;
      gridSize.y = 1;
      break;
    case SELECTION_VERTICAL:
      gridSize.y = numberOfMenuOptions;
      gridSize.x = 1;
      break;
  }
  
  // Set up navigation
  onInputLeft = navigateLeft;
  onInputRight = navigateRight;
  onInputDown = navigateDown;
  onInputUp = navigateUp;
  
  /// temp hack
  if (UI_Widget(outer) != none) {
    UI_Widget(outer).onInputLeft = navigateLeft;
    UI_Widget(outer).onInputRight = navigateRight;
    UI_Widget(outer).onInputDown = navigateDown;
    UI_Widget(outer).onInputUp = navigateUp;
  }
}

=============================================================================
 * setNumberOfMenuOptions()
 *
 * Sets the total number of options
 *===========================================================================
public function setNumberOfMenuOptions(int optionCount) {
  numberOfMenuOptions = optionCount;
  if (navigationType == SELECTION_HORIZONTAL) gridSize.x = optionCount;
  if (navigationType == SELECTION_VERTICAL) gridSize.y = optionCount;
}

=============================================================================
 * forceNextSelection()
 *
 * Changes menu selection to next item
 *===========================================================================
public function forceNextSelection() {
  (navigationType == SELECTION_VERTICAL) ? selectDown() : selectRight();
}

=============================================================================
 * forcePreviousSelection()
 *
 * Changes menu selection to previous item
 *===========================================================================
public function forcePreviousSelection() {
  (navigationType == SELECTION_VERTICAL) ? selectUp() : selectLeft();
}

=============================================================================
 * nextSelection()
 *
 * Changes menu selection to next item
 *===========================================================================
public function nextSelection() {
  if (!bActive) return;
  
  forceNextSelection();
}

=============================================================================
 * previousSelection()
 *
 * Changes menu selection to previous item
 *===========================================================================
public function previousSelection() {
  if (!bActive) return;
  
  forcePreviousSelection();
}

=============================================================================
 * selectDown()
 *
 * Changes menu selection
 *===========================================================================
protected function bool selectDown() {
  local int distance;
  distance = (isNavSkipped(NAV_DOWN) == true) ? 2 : 1;
  
  if (selectionCoords.y == gridSize.y - 1) {
    if (bWrapAround) {
      selectionCoords.y = 0;
    } else {
      return false;
    }
  } else {
    selectionCoords.y += distance;
    if (gridSize.y != 0) selectionCoords.y = selectionCoords.y % gridSize.y;
  }
  
  selectionUpdate();
  return true;
}

=============================================================================
 * selectRight()
 *
 * Changes menu selection
 *===========================================================================
protected function bool selectRight() {
  local int distance;
  distance = (isNavSkipped(NAV_RIGHT) == true) ? 2 : 1;
  
  if (selectionCoords.x == gridSize.x - 1) {
    if (bWrapAround) {
      selectionCoords.x = 0;
    } else {
      return false;
    }
  } else {
    selectionCoords.x += distance;
    if (gridSize.x != 0) selectionCoords.x = selectionCoords.x % gridSize.x;
  }
  
  selectionUpdate();
  return true;
}

=============================================================================
 * selectUp()
 *
 * Changes menu selection
 *===========================================================================
protected function bool selectUp() {
  local int distance;
  distance = (isNavSkipped(NAV_UP) == true) ? 2 : 1;
  
  if (selectionCoords.y == 0) {
    if (bWrapAround) {
      selectionCoords.y = gridSize.y - 1;
    } else {
      return false;
    }
  } else {
    selectionCoords.y -= distance;
  }
  
  selectionUpdate();
  return true;
}

=============================================================================
 * selectLeft()
 *
 * Changes menu selection
 *===========================================================================
protected function bool selectLeft() {
  local int distance;
  distance = (isNavSkipped(NAV_LEFT) == true) ? 2 : 1;
  
  if (selectionCoords.x == 0) {
    if (bWrapAround) {
      selectionCoords.x = gridSize.x - 1;
    } else {
      return false;
    }
  } else {
    selectionCoords.x -= distance;
  }
  
  selectionUpdate();
  return true;
}

=============================================================================
 * onActivation()
 *
 * Called when the widget is activated
 *===========================================================================
protected function onActivation() {
  if (selectorSprite != none) selectorSprite.setEnabled(true);
  if (inactiveSprite != none) inactiveSprite.setEnabled(false);
}

=============================================================================
 * onDeactivation()
 *
 * Called when the widget is deactivated
 *===========================================================================
protected function onDeactivation() {
  if (selectorSprite != none) selectorSprite.setEnabled(false);
  if (inactiveSprite != none) inactiveSprite.setEnabled(true);
}

=============================================================================
 * selectionUpdate()
 *
 * Called whenever a change has been made to the selection
 *===========================================================================
private function selectionUpdate() {
  // Active widget graphics
  if (selectorSprite != none) selectorSprite.setOffset(
    selectionOffset.x * selectionCoords.x,
    selectionOffset.y * selectionCoords.y
  );
  
  // Inactive widget graphics
  if (inactiveSprite != none) inactiveSprite.setOffset(
    selectionOffset.x * selectionCoords.x,
    selectionOffset.y * selectionCoords.y
  );
  
  // Selection graphics
  if (graphicalSelections != none) {
    graphicalSelections.setDrawIndex(getSelection());
  }
}

=============================================================================
 * initJoyStick()
 *
 * Initializes joy stick positions
 *===========================================================================
public function initJoyStick() {
  joyStateX = JOY_MID;
  joyStateY = JOY_MID;
  if (getPlayerInput().rawJoyRight < -0.5) joyStateX = JOY_LEFT;
  if (getPlayerInput().rawJoyRight > 0.5) joyStateX = JOY_RIGHT;
  if (getPlayerInput().rawJoyUp < -0.5) joyStateY = JOY_DOWN;
  if (getPlayerInput().rawJoyUp > 0.5) joyStateY = JOY_UP;
}

=============================================================================
 * joyStickX()
 *
 * Joystick input to this widget.
 *===========================================================================
protected function joyStickX(float analogX) {
  switch (joyStateX) {
    case JOY_RIGHT: if (analogX < 0.5) joyStateX = JOY_MID; break;
    case JOY_LEFT:  if (analogX > -0.5) joyStateX = JOY_MID; break;
  }
  
  if (analogX < -0.6 && joyStateX != JOY_LEFT) {
    navigateLeft();
    joyStateX = JOY_LEFT;
  }
  if (analogX > 0.6 && joyStateX != JOY_RIGHT) {
    navigateRight();
    joyStateX = JOY_RIGHT;
  }
}

=============================================================================
 * joyStickY()
 *
 * Joystick input to this widget.
 *===========================================================================
protected function joyStickY(float analogY) {
  switch (joyStateY) {
    case JOY_UP:   if (analogY < 0.5) joyStateY = JOY_MID; break;
    case JOY_DOWN: if (analogY > -0.5) joyStateY = JOY_MID; break;
  }
  
  if (analogY > 0.6 && joyStateY != JOY_UP) {
    navigateUp();
    joyStateY = JOY_UP;
  }
  if (analogY < -0.6 && joyStateY != JOY_DOWN) {
    navigateDown();
    joyStateY = JOY_DOWN;
  }
}

=============================================================================
 * D-Pad controls
 *===========================================================================
public function navigateLeft() {
  if (!bEnabled || !bActive) return;
  if (navigationType == SELECTION_VERTICAL) return;
  if (!getParentPage().preNavigateLeft()) return;
  
  if (selectLeft()) {
    uiGameInfo.sfxBox.playSfx(navSound);
    
    getParentPage().onNavigateLeft();
  }
}

public function navigateRight() {
  if (!bEnabled || !bActive) return;
  if (navigationType == SELECTION_VERTICAL) return;
  if (!getParentPage().preNavigateRight()) return;
  
  if (selectRight()) {
    uiGameInfo.sfxBox.playSfx(navSound);
    
    getParentPage().onNavigateRight();
  }
}

public function navigateDown() {
  if (!bEnabled || !bActive) return;
  if (navigationType == SELECTION_HORIZONTAL) return;
  if (!getParentPage().preNavigateDown()) return;
  
  if (selectDown()) {
    uiGameInfo.sfxBox.playSfx(navSound);
    
    getParentPage().onNavigateDown();
  }
}

public function navigateUp() {
  if (!bEnabled || !bActive) return;
  if (navigationType == SELECTION_HORIZONTAL) return;
  if (!getParentPage().preNavigateUp()) return;
  
  if (selectUp()) {
    uiGameInfo.sfxBox.playSfx(navSound);
    
    getParentPage().onNavigateUp();
  }
}

=============================================================================
 * getParentPage()
 *
 * Returns a reference to the page that this selector is contained in.
 *===========================================================================
///protected function UI_Page getParentPage() {
///  local object traverseParent;
///  
///  traverseParent = outer;
///  while (traverseParent != none) {
///    if (UI_Page(traverseParent) != none) return UI_Page(traverseParent);
///    traverseParent = traverseParent.outer;
///  }
///  
///  return none;
///}

============================================================================= 
 * setDrawIndex()
 *
 * 
 *===========================================================================
public function setDrawIndex(byte index) {
  local int i;
  
  for (i = 0; i < componentList.length; i++) {
    if (UI_Sprite(componentList[i]) != none) {
      UI_Sprite(componentList[i]).setDrawIndex(index);
      UI_Sprite(componentList[i]).resetImageSize();
    }
  }
}

/// wip
=============================================================================
 * isNavSkipped()
 *
 * Given a direction, this function returns true if navigation skip applies
 * for the selector's coordinates
 *===========================================================================
*
 private function bool isNavSkipped(NavDirections direction) {
  local int i;
  // Search through navigation skips
  for (i = 0; i < navSkips.Length; i++) {
    if (navSkips[i].xCoord == selectionCoords.x) {
      if (navSkips[i].yCoord == selectionCoords.y) {
        if (navSkips[i].skipDirection == direction) {
          return true;
        }
      }
    }
  }
  return false;
}
**/








