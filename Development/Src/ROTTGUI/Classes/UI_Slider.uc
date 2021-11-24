/*=============================================================================
 * UI_Slider
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A slider to represent a scalar quantity.
 *===========================================================================*/

class UI_Slider extends UI_Widget;

// The value expressed by this UI component
var privatewrite float sliderScalar;

// Speed for joystick control
var privatewrite float sliderSpeed;
var privatewrite float dpadSpeed;

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  refresh();
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  if (bDpadLeft) slideKnob(-0.5 * dpadSpeed * deltaTime);
  if (bDpadRight) slideKnob(0.5 * dpadSpeed * deltaTime);
}

/*=============================================================================
 * setKnob()
 *
 * Slides to a specific value.
 *===========================================================================*/
public function setKnob(float setAmount) {
  sliderScalar = setAmount;
  refresh();
}

/*=============================================================================
 * slideKnob()
 *
 * Slides the slider some amount to the left.
 *===========================================================================*/
public function slideKnob(float slideAmount) {
  // Slide left
  sliderScalar += slideAmount;
  
  // Caps
  if (sliderScalar < 0) sliderScalar = 0;
  if (sliderScalar > 1) sliderScalar = 1;
  
  refresh();
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  // Draw bar
  findSprite("Slider_Bar").setHorizontalMask(sliderScalar);
  findSprite("Slider_Knob_Sprite").updatePosition(
    getX() + 58 + 577 * sliderScalar
  );
}

/*=============================================================================
 * joyStickX()
 *
 * Joystick input to this widget.
 *===========================================================================*/
protected function joyStickX(float analogX) {
  // Set slider speed
  analogX *= sliderSpeed;

  // Move slider
  slideKnob(analogX);
}

/*=============================================================================
 * onActivation()
 *
 * Called when the widget is activated
 *===========================================================================*/
protected function onActivation() {
  findSprite("Slider_Knob_Sprite").setDrawIndex(1);
}

/*=============================================================================
 * onDeactivation()
 *
 * Called when the widget is deactivated
 *===========================================================================*/
protected function onDeactivation() {
  findSprite("Slider_Knob_Sprite").setDrawIndex(0);
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // Container draw settings
  bDrawRelative=true
  
  sliderScalar=0.5
  sliderSpeed=0.020
  dpadSpeed=0.90
  
  /** ===== Textures ===== **/
  // Frame graphics
  begin object class=UI_Texture_Info Name=Slider_Background
    componentTextures.add(Texture2D'GUI.Experience_Bar_Back')
  end object
  begin object class=UI_Texture_Info Name=Slider_Frame
    componentTextures.add(Texture2D'ROTT_GUI_Options.Slider_Bar_Frame')
  end object
  
  // Bar graphics
  begin object class=UI_Texture_Info Name=Bar_Color
    componentTextures.add(Texture2D'ROTT_GUI_Options.Slider_Bar_Color_Blue')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Slider_Background_Sprite
    tag="Slider_Background_Sprite"
    bEnabled=true
    posX=63
    posY=28
    images(0)=Slider_Background
  end object
  componentList.add(Slider_Background_Sprite)
  
  // Bar graphic
  begin object class=UI_Sprite Name=Slider_Bar
    tag="Slider_Bar"
    bEnabled=true
    posX=75
    posY=42
    posXEnd=651
    posYEnd=58
    images(0)=Bar_Color
  end object
  componentList.add(Slider_Bar)
  
  // Frame overlay
  begin object class=UI_Sprite Name=Experience_Bar_Frame
    tag="Experience_Bar_Frame"
    bEnabled=true
    posX=63
    posY=28
    images(0)=Slider_Frame
  end object
  componentList.add(Experience_Bar_Frame)
  
  // Slider Knob
  begin object class=UI_Sprite Name=Slider_Knob_Sprite
    tag="Slider_Knob_Sprite"
    bEnabled=true
    posX=58
    posY=28
    
    // Textures
    begin object class=UI_Texture_Info Name=Slider_Knob
      componentTextures.add(Texture2D'ROTT_GUI_Options.Option_Slider_Knob')
    end object
    begin object class=UI_Texture_Info Name=Slider_Knob_Active
      componentTextures.add(Texture2D'ROTT_GUI_Options.Option_Slider_Knob_Active')
    end object
    
    images(0)=Slider_Knob
    images(1)=Slider_Knob_Active
  end object
  componentList.add(Slider_Knob_Sprite)
  
}























