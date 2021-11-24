/*=============================================================================
 * ROTT_UI_Displayer_Mana_Globe
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object displays a heroes visual information.
 * (See: ROTT_Combat_Hero.uc)
 *
 *===========================================================================*/

class ROTT_UI_Displayer_Mana_Globe extends ROTT_UI_Displayer;

// Internal references
var private UI_Sprite manaGlobe;
var private UI_Sprite discCap;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Set internal references
  manaGlobe = findSprite("Hero_Mana_Globe");
  discCap = findSprite("Hero_Mana_Disc_Cap");
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
  local float xOffset, yOffset;
  local float theta, r;
  local float yTop;
  
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Mana masking
  manaGlobe.setVerticalMask(hero.getManaRatio());
  
  // Hide disc at the top (when it looks buggy)
  discCap.setEnabled(hero.getManaRatio() < 0.84 && hero.getManaRatio() > 0.1);
  if (hero.getManaRatio() >= 0.84) { 
    return true;
  }
  
  // Scaling horizontal
  r = 26;
  theta = hero.getManaRatio() * PI - PI / 2;
  xOffset = r - (r * cos(theta));
  
  // Follow top of pool
  //yTop = posY + 91 - (192/2) + (192 * (1 - hero.getManaRatio()));
  yTop = getY() - 7 + (99 * (1 - hero.getManaRatio()));
  
  // Scaling vertical
  r = 12;
  yOffset = r - (r * cos(theta));
  
  // Vertical Masking and Horizontal Stretch
  discCap.updatePosition(
    (getX() + 4) + xOffset, 
    yTop + yOffset,
    (getX() + 100) - xOffset,
    yTop + 16 - yOffset
  );
  
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
  begin object class=UI_Texture_Info Name=Mana_Globe_Background
    componentTextures.add(Texture2D'GUI.Mana_Globe_Background')
  end object
  begin object class=UI_Texture_Info Name=Mana_Globe
    componentTextures.add(Texture2D'GUI.Mana_Globe')
    bFlipVerticalMask=true
  end object
  begin object class=UI_Texture_Info Name=Mana_Globe_Cover
    componentTextures.add(Texture2D'GUI.Mana_Globe_Cover')
  end object
  
  // Disc cap
  begin object class=UI_Texture_Info Name=Disc_Cap
    componentTextures.add(Texture2D'GUI.Mana_Disc_Cap')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Hero_Mana_Globe_Background
    tag="Hero_Mana_Globe_Background"
    posX=0
    posY=0
    images(0)=Mana_Globe_Background
  end object
  componentList.add(Hero_Mana_Globe_Background)
  
  // Bar
  begin object class=UI_Sprite Name=Hero_Mana_Globe
    tag="Hero_Mana_Globe"
    posX=3
    posY=2
    images(0)=Mana_Globe
  end object
  componentList.add(Hero_Mana_Globe)
  
  // Disc Cap
  begin object class=UI_Sprite Name=Hero_Mana_Disc_Cap
    tag="Hero_Mana_Disc_Cap"
    posX=14
    posY=88
    images(0)=Disc_Cap
  end object
  componentList.add(Hero_Mana_Disc_Cap)
  
  // Cover
  begin object class=UI_Sprite Name=Hero_Mana_Globe_Cover
    tag="Hero_Mana_Globe_Cover"
    posX=0
    posY=0
    images(0)=Mana_Globe_Cover
  end object
  componentList.add(Hero_Mana_Globe_Cover)
  
}




















