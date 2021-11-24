/*=============================================================================
 * ROTT_UI_Displayer_Health_Globe
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object displays a heroes visual information.
 * (See: ROTT_Combat_Hero.uc)
 *===========================================================================*/

class ROTT_UI_Displayer_Health_Globe extends ROTT_UI_Displayer;

// Internal references
var private UI_Sprite healthGlobe;
var private UI_Sprite discCap;
var private UI_Sprite thresholdMarker;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  healthGlobe = findSprite("Hero_Health_Globe");
  discCap = findSprite("Hero_Health_Disc_Cap");
  thresholdMarker = findSprite("Threshold_Marker");
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
  local float globeRatio;
  local float theta, r;
  local float yTop;
  
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  /* some of this should move to an onDeath function */
  // Draw health globe or resurrection globe
  if (hero.bDead) {
    healthGlobe.setDrawIndex(1);
    discCap.setDrawIndex(1);
    globeRatio = hero.getResurrectRatio() * hero.const.RESURRECTION_PERCENT;
    thresholdMarker.setEnabled(false);
  } else {
    healthGlobe.setDrawIndex(0);
    discCap.setDrawIndex(0);
    globeRatio = hero.getHealthRatio();
    
    // Draw morality threshold marker if alive
    thresholdMarker.updatePosition(
      getX() + 184,
      getY() + 192 - (hero.getMoraleRatio()) * 192
    );

    thresholdMarker.setEnabled(true);
    thresholdMarker.setDrawIndex(1 + int(hero.getHealthRatio() < hero.getMoraleRatio()));
  }
  
  // Health mask
  healthGlobe.setVerticalMask(globeRatio);
  discCap.setEnabled (!(globeRatio > 0.92));
  
  // Scaling horizontal
  r = 56;
  theta = globeRatio * PI - PI / 2;
  xOffset = r - (r * cos(theta));
  
  // Follow top of pool
  yTop = getY() - 5 + (192 * (1 - globeRatio));
  
  // Scaling vertical
  r = 14;
  yOffset = r - (r * cos(theta));
  
  // Vertical Masking and Horizontal Stretch
  discCap.updatePosition(
    (getX()+12) + xOffset, 
    yTop + yOffset,
    (getX()+204) - xOffset,
    yTop + 23 - yOffset
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
  // Health Globe
  begin object class=UI_Texture_Info Name=Health_Globe_Background
    componentTextures.add(Texture2D'GUI.Health_Globe_Background')
  end object
  begin object class=UI_Texture_Info Name=Health_Globe
    componentTextures.add(Texture2D'GUI.Health_Globe')
    bFlipVerticalMask=true
  end object
  begin object class=UI_Texture_Info Name=Health_Globe_Cover
    componentTextures.add(Texture2D'GUI.Health_Globe_Cover')
  end object
  
  // Resurrection
  begin object class=UI_Texture_Info Name=Resurrection_Globe
    componentTextures.add(Texture2D'GUI.Resurrection_Globe')
    drawColor=(R=255,G=255,B=255,A=127)
    bFlipVerticalMask=true
  end object
  begin object class=UI_Texture_Info Name=Resurrection_Disc_Cap
    componentTextures.add(Texture2D'GUI.Resurrection_Disc_Cap')
  end object
  
  // Disc cap
  begin object class=UI_Texture_Info Name=Disc_Cap
    componentTextures.add(Texture2D'GUI.Health_Disc_Cap')
  end object
  
  // Threshold markers
  begin object class=UI_Texture_Info Name=Threshold_Marker_Red
    componentTextures.add(Texture2D'GUI.Threshold_Marker_Red')
  end object
  begin object class=UI_Texture_Info Name=Threshold_Marker_Gold
    componentTextures.add(Texture2D'GUI.Threshold_Marker_Gold')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Hero_Health_Globe_Background
    tag="Hero_Health_Globe_Background"
    posX=0
    posY=0
    images(0)=Health_Globe_Background
  end object
  componentList.add(Hero_Health_Globe_Background)
  
  // Globe
  begin object class=UI_Sprite Name=Hero_Health_Globe
    tag="Hero_Health_Globe"
    posX=8
    posY=5
    images(0)=Health_Globe
    images(1)=Resurrection_Globe
  end object
  componentList.add(Hero_Health_Globe)
  
  // Disc Cap
  begin object class=UI_Sprite Name=Hero_Health_Disc_Cap
    tag="Hero_Health_Disc_Cap"
    posX=10
    posY=88
    images(0)=Disc_Cap
    images(1)=Resurrection_Disc_Cap
  end object
  componentList.add(Hero_Health_Disc_Cap)
  
  // Cover
  begin object class=UI_Sprite Name=Hero_Health_Globe_Cover
    tag="Hero_Health_Globe_Cover"
    posX=0
    posY=0
    images(0)=Health_Globe_Cover
  end object
  componentList.add(Hero_Health_Globe_Cover)
  
  // Morale Threshold
  begin object class=UI_Sprite Name=Threshold_Marker
    tag="Threshold_Marker"
    posX=168
    posY=27
    images(0)=Threshold_Marker_Red
    images(1)=Threshold_Marker_Red
    images(2)=Threshold_Marker_Gold
  end object
  componentList.add(Threshold_Marker)
  
}




















