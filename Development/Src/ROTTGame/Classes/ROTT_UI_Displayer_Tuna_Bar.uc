/*=============================================================================
 * ROTT_UI_Displayer_Tuna_Bar
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object displays the time until next attack bar for a hero.
 * (See: ROTT_Combat_Hero.uc)
 *
 *===========================================================================*/

class ROTT_UI_Displayer_Tuna_Bar extends ROTT_UI_Displayer;

var private UI_Sprite tunaBar;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  tunaBar = findSprite("Combat_Tuna_Bar");
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
  
  // Draw TUNA mask
  tunaBar.setHorizontalMask(hero.getTunaRatio());
  
  // Successfully drew hero information
  return true;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  /** ===== Textures ===== **/
  // Tuna Bar
  begin object class=UI_Texture_Info Name=Tuna_Background
    componentTextures.add(Texture2D'GUI.Encounter_TUNA_Background')
  end object
  begin object class=UI_Texture_Info Name=Tuna_Bar
    componentTextures.add(Texture2D'GUI.Encounter_TUNA_Bar')
  end object
  begin object class=UI_Texture_Info Name=Tuna_Cover
    componentTextures.add(Texture2D'GUI.Encounter_TUNA_Cover')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Combat_Tuna_Background
    tag="Combat_Tuna_Background"
    posX=10
    posY=8
    images(0)=Tuna_Background
  end object
  componentList.add(Combat_Tuna_Background)

  // Bar
  begin object class=UI_Sprite Name=Combat_Tuna_Bar
    tag="Combat_Tuna_Bar"
    posX=10
    posY=8
    images(0)=Tuna_Bar
  end object
  componentList.add(Combat_Tuna_Bar)
    
  // Cover
  begin object class=UI_Sprite Name=Combat_Tuna_Cover
    tag="Combat_Tuna_Cover"
    posX=0
    posY=0
    images(0)=Tuna_Cover
  end object
  componentList.add(Combat_Tuna_Cover)
  
}




















