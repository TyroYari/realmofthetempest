/*=============================================================================
 * ROTT_UI_Displayer_Hero_Over_World
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displays hero info in the over world
 * (See: ROTT_Combat_Hero.uc, ROTT_UI_Page_Over_World.uc)
 *===========================================================================*/

class ROTT_UI_Displayer_Hero_Over_World extends ROTT_UI_Displayer;

/*=============================================================================
 * validAttachment()
 *
 * Called to check if the displayer attachment is valid. Returns true if it is.
 *===========================================================================*/
protected function bool validAttachment() {
  // This displayer requires a party attachment
  return (hero != none);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Textures ===== **/
  // Portraits & Exp Frames
  begin object class=UI_Texture_Info Name=World_HUD_Party_Portraits_Goliath
    componentTextures.add(Texture2D'GUI_Overworld.World_HUD_Party_Portraits_Goliath'
  end object
  begin object class=UI_Texture_Info Name=World_HUD_Party_Portraits_Valkyrie
    componentTextures.add(Texture2D'GUI_Overworld.World_HUD_Party_Portraits_Valkyrie'
  end object
  begin object class=UI_Texture_Info Name=World_HUD_Party_Portraits_Wizard
    componentTextures.add(Texture2D'GUI_Overworld.World_HUD_Party_Portraits_Wizard'
  end object
  begin object class=UI_Texture_Info Name=World_HUD_Party_Portraits_Titan
    componentTextures.add(Texture2D'GUI_Overworld.World_HUD_Party_Portraits_Titan'
  end object
  
  /** ===== GUI Components ===== **/
  // Hero Exp Bar
  begin object class=ROTT_UI_Displayer_Stat_Bar Name=Hero_Exp_Bar
    tag="Hero_Exp_Bar"
    bEnabled=true
    posX=85
    posY=54
    statBarLength=143
    statBarHeight=11
    statType=HERO_EXP_BAR
  end object
  componentList.add(Hero_Exp_Bar)
  
  // Hero Class Icons & Exp frames
  begin object class=ROTT_UI_Displayer_Class_Portrait Name=Over_World_Class_Portrait
    tag="Over_World_Class_Portrait"
    bEnabled=true
    
    // Portrait Sprites
    begin object class=UI_Texture_Storage Name=Class_Portrait_Sprites
      tag="Class_Portrait_Sprites"
      bEnabled=true
      textureWidth=240
      textureHeight=100
      images(GOLIATH)=World_HUD_Party_Portraits_Goliath
      images(VALKYRIE)=World_HUD_Party_Portraits_Valkyrie
      images(WIZARD)=World_HUD_Party_Portraits_Wizard
      images(TITAN)=World_HUD_Party_Portraits_Titan
    end object
    componentList.add(Class_Portrait_Sprites)
    
  end object
  componentList.add(Over_World_Class_Portrait)
  
}

















