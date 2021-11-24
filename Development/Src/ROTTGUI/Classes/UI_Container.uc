/*=============================================================================
 * UI_Container
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class groups together UI components
 *===========================================================================*/

class UI_Container extends UI_Component;

// If true, the subcomponents are offset by the container that holds them
var private bool bDrawRelative;

/*=============================================================================
 * Initialize Component
 * 
 * Description: This event is called as the UI is loaded.
 *              Our initial components are drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local UI_Component uiComp;
  
  super.initializeComponent(newTag);
  
  // Pass down scaling parameter to children
  if (bMandatoryScaleToWindow == true) {
    foreach componentList(uiComp) {
      uiComp.bMandatoryScaleToWindow = true;
    }
  }
  
  // Initialize children components
  foreach componentList(uiComp) {
    uiComp.initializeComponent();
  }
  
  // Set initial positions for children components
  foreach componentList(uiComp) {
    // Add offsets for relative containers, but ignore sub containers
    if (bDrawRelative) {
      /* Warning: this might not work properly with recursive sub containers! */
      if (uiComp.bRelativeEnd) {
        // Set relative coordinate based on parent
        uiComp.updatePosition(
          , 
          , 
          getXEnd() + uiComp.getXEnd(), 
          getYEnd() + uiComp.getYEnd()
        );
      } 
      
      // Move inner components
      uiComp.shiftX(getX());
      uiComp.shiftY(getY());
      
      if (uiComp.bRelativeEnd) {
        // Undo adjustments to end coordinates
        uiComp.updatePosition(
          , 
          , 
          uiComp.getXEnd() - getX(), 
          uiComp.getYEnd() - getY()
        );
      }
    }
  }
  
  // Hacky fix for selector relative home coords
  foreach componentList(uiComp) {
    uiComp.postInit();
  }
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  local UI_Component comp;
  
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  foreach componentList(comp) {
    comp.elapseTimer(deltaTime, gameSpeedOverride);
  }
}

/*=============================================================================
 * findComp()
 *
 * Returns a component that has been created as subobject with matching name.
 *===========================================================================*/
public function UI_Component findComp(string ComponentTag) {
  local int i;
  
  // Return none if no tag
  if (componentTag == "") return none;

  // Look up component in selected UI set
  for (i = 0; i < componentList.length; i++) {
    if (componentList[i].tag == componentTag) return componentList[i];
  }

  return none;
}

/*=============================================================================
 * findSprite()
 *
 * Used to access a Sprite on this page
 *===========================================================================*/
public function UI_Sprite findSprite(string searchTag) {
  return UI_Sprite(findComp(searchTag));
}

/*=============================================================================
 * findLabel()
 *
 * Used to access a label on this page
 *===========================================================================*/
public function UI_Label findLabel(string searchTag) {
  return UI_Label(findComp(searchTag));
}

/*=============================================================================
 * updatePosition()
 *
 * Places the sprite at the given coordinates, and optionally stretches it
 * to a given end point
 *===========================================================================*/
public function updatePosition
(
  optional int newX = getX(),
  optional int newY = getY(),
  optional int newXEnd = newX + (getXEnd() - getX()),
  optional int newYEnd = newY + (getYEnd() - getY())
)
{
  local UI_Component uiComp;
  local int deltaX, deltaY;
  
  // Store initial positions for calculating the positions change
  deltaX = getX(); 
  deltaY = getY(); 
  
  // Assign new position coordinates
  super.updatePosition(newX, newY, newXEnd, newYEnd);
  
  // Calculate the difference
  deltaX -= getX(); 
  deltaY -= getY(); 
  deltaX *= -1; 
  deltaY *= -1; 
  
  // Move all children using the calculated change
  foreach componentList(uiComp) {
    uiComp.shiftX(deltaX);
    uiComp.shiftY(deltaY);
  }
}

/*=============================================================================
 * lerpComponent()
 *
 * Updates the position for the container and its children.
 *===========================================================================*/
protected function lerpComponent(float deltaTime) {
  super.lerpComponent(deltaTime);
}

/*=============================================================================
 * addEffectToQueue()
 *
 * Allows special effects to be queued
 *===========================================================================*/
public function addEffectToQueue(EffectStates state, float time) {
  local int i;
  
  for (i = 0; i < componentList.length; i++) {
    componentList[i].fadeSystem.addEffectToQueue(state, time);
  }
}

/*============================================================================*
 * decimal()
 *
 * Takes a string representing a float, and truncates it to the specified
 * number of decimal places
 *===========================================================================*/
static function string decimal(coerce string floatText, int decimalPlaces) {
  return left(floatText, inStr(floatText, ".") + decimalPlaces + 1);
}

/*=============================================================================
 * debugHierarchy()
 *
 * Shows the hierarchy as a tree, tabbed in console.
 *===========================================================================*/
public function debugHierarchy(int tabLength, bool bEnabledParent) {
  local int i;
  
  super.debugHierarchy(tabLength, bEnabledParent);
  
  for (i = 0; i < componentList.length; i++) {
    componentList[i].debugHierarchy(tabLength + 1, bEnabled && bEnabledParent);
  }
}

/*=============================================================================
 * deleteComp()
 *
 * Called by the sceneManager when it's about to get unreferenced by the HUD 
 * for garbage collection.
 *===========================================================================*/
event deleteComp() {
  local UI_Component comp;

  super.deleteComp();

  foreach componentList(comp) {
    comp.deleteComp();
  }
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{

}























