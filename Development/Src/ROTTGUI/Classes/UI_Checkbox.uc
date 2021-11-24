/*=============================================================================
 * UI_Checkbox
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A checkbox that can be ticked or unticked.
 *===========================================================================*/

class UI_Checkbox extends UI_Container;

// True if the checkbox is ticked
var privatewrite bool bTick;

/*=============================================================================
 * toggleTick()
 *
 * Toggles the checkbox.
 *===========================================================================*/
public function toggleTick() {
  // Store new tick state
  bTick = !bTick;
  
  // Update graphics
  findSprite("Checkmark_Sprite").setEnabled(bTick);
}

/*=============================================================================
 * setTick()
 *
 * Sets the state of the checkbox.
 *===========================================================================*/
public function setTick(bool bTickState) {
  // Store new tick state
  bTick = bTickState;
  
  // Update graphics
  findSprite("Checkmark_Sprite").setEnabled(bTick);
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Textures ===== **/
  // Textures
  begin object class=UI_Texture_Info Name=Option_Slider_Knob
    componentTextures.add(Texture2D'ROTT_GUI_Options.Option_Slider_Knob')
  end object
  begin object class=UI_Texture_Info Name=Options_Checkbox
    componentTextures.add(Texture2D'ROTT_GUI_Options.Options_Checkbox')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Checkbox_Background_Sprite
    tag="Checkbox_Background_Sprite"
    bEnabled=true
    images(0)=Options_Checkbox
  end object
  componentList.add(Checkbox_Background_Sprite)
  
  // Checkmark
  begin object class=UI_Sprite Name=Checkmark_Sprite
    tag="Checkmark_Sprite"
    bEnabled=false
    posX=18
    posY=19
    images(0)=Option_Slider_Knob
  end object
  componentList.add(Checkmark_Sprite)
  
}























