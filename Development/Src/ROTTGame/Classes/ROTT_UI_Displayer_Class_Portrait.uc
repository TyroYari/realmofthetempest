/*=============================================================================
 * ROTT_UI_Displayer_Class_Portrait
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displays a portrait for a hero unit
 *===========================================================================*/

class ROTT_UI_Displayer_Class_Portrait extends ROTT_UI_Displayer;

// Visual components
var private UI_Sprite classSprite;
var private UI_Texture_Storage classSprites;

/*============================================================================= 
 * initializeComponent()
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  classSprite = findSprite("Class_Portrait_Sprite");
  classSprites = UI_Texture_Storage(findComp("Class_Portrait_Sprites"));
}

/*=============================================================================
 * validAttachment()
 *
 * Called to check if the displayer attachment is valid. Returns true if it is.
 *===========================================================================*/
protected function bool validAttachment() {
  // This displayer requires a hero attachment
  return (hero != none);
}

/*=============================================================================
 * updateDisplay()
 *
 * This updates the UI with the info of the attached combat unit.  
 * Returns true when there actually exists a unit to display, false otherwise.
 *===========================================================================*/
public function bool updateDisplay() {
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Update portrait graphic
  classSprite.copySprite(classSprites, hero.myClass);
  
  // Report that we have successfully drawn the unit info
  return true;
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  /** ===== UI Components ===== **/
  // Class Portrait Sprite
  begin object class=UI_Sprite Name=Class_Portrait_Sprite
    tag="Class_Portrait_Sprite"
    bEnabled=true
  end object
  componentList.add(Class_Portrait_Sprite)
}




















