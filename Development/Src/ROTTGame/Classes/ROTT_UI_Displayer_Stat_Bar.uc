/**=============================================================================
 * ROTT_UI_Displayer_Stat_Bar
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displayer draws a horizontal stat bar.
 *===========================================================================*/

 
 
 
/// Apparently only used for exp bars
 
 
 
 
class ROTT_UI_Displayer_Stat_Bar extends ROTT_UI_Displayer;

// Types of stat bars
enum StatBarTypes {
  HERO_EXP_BAR
};

var private StatBarTypes statType;

// GUI Components
var privatewrite UI_Sprite statBar;

// Graphic specification for max stat bar length
var private int statBarLength;
var private int statBarHeight;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Set UI references
  statBar = findSprite("Stat_Bar_Sprite");
  
  // Set bar height
  statBar.updatePosition(,,, statBar.getY() + statBarHeight);
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
  local float ratio;
  
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Get ratio based on bar type
  switch(statType) {
    ///case HERO_HEALTH_BAR: ratio = enemy.getHealthRatio();       break;
    ///case HERO_MANA_BAR:   ratio = enemy.getManaRatio();         break;
    case HERO_EXP_BAR:    ratio = hero.getExpRatio();           break;
    ///case HERO_TUNA_BAR:   
    ///  if (enemy != none) {
    ///    ratio = enemy.getTunaRatio();
    ///  } else if (hero != none) {
    ///    ratio = hero.getTunaRatio();
    ///  }
    ///  break;
  }
  
  // Update horizontal mask
  statBar.updatePosition(,, statBar.getX() + (statBarLength * ratio));
  
  // Successfully drew hero information
  return true;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Default dimensions
  bDrawRelative=true
  statBarLength=100
  statBarHeight=10
  
  /** ===== Textures ===== **/
  // Exp bar
  begin object class=UI_Texture_Info Name=Stat_Tube_EXP
    componentTextures.add(Texture2D'GUI.Stat_Tube_EXP')
  end object
  
  /** ===== GUI Components ===== **/
  // Stat bar sprite
  begin object class=UI_Sprite Name=Stat_Bar_Sprite
    tag="Stat_Bar_Sprite"
    images(0)=Stat_Tube_EXP
  end object
  componentList.add(Stat_Bar_Sprite)
  
}




















