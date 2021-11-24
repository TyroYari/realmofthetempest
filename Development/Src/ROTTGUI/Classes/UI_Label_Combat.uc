/*=============================================================================
 * UI_Label_Combat
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is supposed to be able to draw text on screen with fonts
 * and draw styles that are not shared with other labels.
 *===========================================================================*/
 
class UI_Label_Combat extends UI_Label;

// Fonts for label components are stored here
var private instanced UI_String_Style stringStyle;

// Track lifetime
var privatewrite float lifeTime;
var privatewrite float elapsedTime;

// Font styles
enum CombatFonts {
  FONT_LARGE,
  FONT_MEDIUM,
  FONT_MEDIUM_ITALICS
};
var private Font labelFonts[CombatFonts];

// Color styles
enum ColorStyles {
  COLOR_GRAY,
  COLOR_RED,
  COLOR_ORANGE,
  COLOR_YELLOW,
  COLOR_TAN,
  COLOR_GOLD,
  COLOR_GREEN,
  COLOR_CYAN,
  COLOR_BLUE,
  COLOR_PURPLE
};
var private Color labelColors[ColorStyles];

// Animation styles
enum AnimationStyles {
  ANIMATE_UP_AND_FADE_QUICK,
  ANIMATE_UP_AND_FADE,
  
  ANIMATE_UP_BOUNCE,
  ANIMATE_POP_RIGHT,
  ANIMATE_LEFT_BOUNCE,
  ANIMATE_SLOW_BOUNCE,
  
  ANIMATE_STILL,
};

var private AnimationStyles labelAnim;

// Label classes, which define animation style and placement
enum LabelClass {
  LABEL_TYPE_STAT_REPORT,
  LABEL_TYPE_STAT_CHANGE,
  LABEL_TYPE_HEALTH_GAIN,
  LABEL_TYPE_MANA_GAIN,
  LABEL_TYPE_DAMAGE,
  LABEL_TYPE_MANA_DAMAGE,
  LABEL_TYPE_RESIST,
}; 

/*============================================================================= 
 * initializeComponent
 *
 * Called once from HUD's PostBeginPlay() when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
}

/*============================================================================= 
 * setStyle()
 *
 * Used to set font, color, and animation styles for the font.
 *===========================================================================*/
public function setStyle
(
  CombatFonts fontIndex,
  ColorStyles colorIndex,
  AnimationStyles newAnim
) 
{
  // Create new string style
  stringStyle = new class'UI_String_Style';
  
  // Set display info
  stringStyle.drawColor = labelColors[colorIndex];
  stringStyle.font = labelFonts[fontIndex];
  labelAnim = newAnim;
  
  // Set animation info
  switch (labelAnim) {
    case ANIMATE_UP_AND_FADE_QUICK:
      addEffectToQueue(DELAY, 0.8);
      addEffectToQueue(FADE_OUT, 1.7);
      lifeTime = 2.5;
      break;
      
    case ANIMATE_UP_AND_FADE:
      addEffectToQueue(DELAY, 0.75);
      addEffectToQueue(FADE_OUT, 0.5);
      lifeTime = 1.25;
      break;
      
    case ANIMATE_UP_BOUNCE:
      addEffectToQueue(DELAY, 0.75);
      addEffectToQueue(FADE_OUT, 0.25);
      lifeTime = 1.0;
      break;
      
    case ANIMATE_POP_RIGHT:  
      addEffectToQueue(DELAY, 0.75);
      addEffectToQueue(FADE_OUT, 0.5);
      alignX = LEFT;
      lifeTime = 1.25;
      break;
      
    case ANIMATE_LEFT_BOUNCE:
      addEffectToQueue(DELAY, 1.0);
      addEffectToQueue(FADE_OUT, 0.25);
      alignX = LEFT;
      lifeTime = 1.25;
      break;
      
    case ANIMATE_SLOW_BOUNCE:
      addEffectToQueue(DELAY, 1.2);
      addEffectToQueue(FADE_OUT, 0.2);
      lifeTime = 1.4;
      break;
      
    case ANIMATE_STILL:
      addEffectToQueue(DELAY, 2.0);
      addEffectToQueue(FADE_OUT, 2.0);
      lifeTime = 4.0;
      break;
  }
}

/*============================================================================= 
 * countLabelClass()
 *
 * Returns the size o the LabelClass enum
 *===========================================================================*/ 
public static function int countLabelClass() {
  return LabelClass.enumCount;
}

/*=============================================================================
 * setFontOnCanvas()
 *
 * Called to set a font on the texture
 *===========================================================================*/
protected function bool setFontOnCanvas(out Canvas canvas) {
  if (stringStyle.font != none) {
    canvas.font = stringStyle.font;
    return true;
  } else {
    yellowLog("Warning (!) Font is missing for " $ self);
    scriptTrace();
    return false;
  }
}

/*=============================================================================
 * update()
 *
 * Called before rendering the canvas, which is drawn every frame.
 *===========================================================================*/
public function update() {
  // Animation
  switch (labelAnim) {
    case ANIMATE_UP_AND_FADE_QUICK:
      updatePosition(
        homePos.x,
        homePos.y - int(elapsedTime * 35)
      );
      break;
      
    case ANIMATE_UP_AND_FADE:
      updatePosition(
        homePos.x,
        homePos.y - int(elapsedTime * 50)
      );
      break;
      
    case ANIMATE_UP_BOUNCE:
      if (elapsedTime < 0.9 && elapsedTime > 0) {
        updatePosition(
          homePos.x,
          homePos.y - 350 * bounce(elapsedTime, 0.9)
        );
      }
      break;
      
    case ANIMATE_POP_RIGHT: 
      updatePosition(
        homePos.x + elapsedTime * 25,
        homePos.y - 180 * bounce(elapsedTime + 0.6, 2.0) + 133
      );
      break;
      
    case ANIMATE_LEFT_BOUNCE: 
      if (elapsedTime < 1) {
        updatePosition(
          homePos.x + 60 * bounce(elapsedTime + 0.2, 1),
          homePos.y
        );
      }
      break;
      
    case ANIMATE_SLOW_BOUNCE:
      if (elapsedTime < 1.4) {
        updatePosition(
          homePos.x,
          homePos.y - 20 * bounce(elapsedTime, 1.4)
          //      <distance>      <input>     <time>
        );
      }
      break;
  }
}


/*=============================================================================
 * getColor()
 *
 * Returns the draw color for the text
 *===========================================================================*/
protected function Color getColor() {
  return multiplyColors(super(UI_Component_Visual).getColor(), stringStyle.drawColor);
}

/*=============================================================================
 * elapseTimer
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  // Stall for activation delay
  if (activationDelay > 0) { return; } /// This line could be encapsulated better
  
  // Track lifetime
  lifeTime -= deltaTime;
  elapsedTime += deltaTime;
  
  // Delete component if lifetime is up
  if (lifeTime <= 0) UI_Component(outer).removeByReference(self);
}

/*=============================================================================
 * resetEffects()
 *
 * Clears the effect queue
 *===========================================================================*/
public function resetEffects(optional bool bShow = true) {
  super.resetEffects();

  if (stringStyle != none) {
    stringStyle.drawColor.A = (bShow) ? 255 : 0;
  }
}

/*=============================================================================
 * bounce()
 *
 * Returns a value from a parobola, based on a time parameter
 *===========================================================================*/
private function float bounce(coerce float x, coerce float t) {
  local float a;
  
  a = t / 2;
  
  return -((x - a) * (x - a)) + a * a;
}

/*=============================================================================
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  local int i;
  
  super.deleteComp();
  
  if (stringStyle != none) {
    stringStyle.deleteInfo();
    stringStyle = none;
  }
  
  for (i = 0; i < CombatFonts.enumCount; i++) {
    labelFonts[i] = none;
  }
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Default life time
  lifeTime=.1
  
  // Padding
  padding=(top=0, left=12, right=12, bottom=8)
  
  // Alignment
  alignY=CENTER 
  alignX=CENTER
  
  // Scroll effect
  cycleIndex=0
  
  // Style cycling
  ///bCycleStyles=false
  cycleStyleLength=0.1  // Seconds
  
  // Fonts
  labelFonts(FONT_LARGE)=Font'GUI.Combat_Font_48'
  labelFonts(FONT_MEDIUM)=Font'GUI.Combat_Font_36'
  labelFonts(FONT_MEDIUM_ITALICS)=Font'GUI.Combat_Font_36_Italics'
  
  // Colors
  labelColors(COLOR_GRAY)  =(R=185,G=185,B=185,A=255)
  labelColors(COLOR_RED)   =(R=255,G=60 ,B=0  ,A=255)
  labelColors(COLOR_ORANGE)=(R=255,G=145,B=0  ,A=255) 
  labelColors(COLOR_YELLOW)=(R=255,G=255,B=102,A=255)
  labelColors(COLOR_TAN)   =(R=230,G=217,B=164,A=255)
  labelColors(COLOR_GOLD)  =(R=255,G=245,B=200,A=255)
  labelColors(COLOR_GREEN) =(R=80 ,G=235,B=90 ,A=255) 
  labelColors(COLOR_CYAN)  =(R=51 ,G=204,B=255,A=255)
  labelColors(COLOR_BLUE)  =(R=30 ,G=120,B=255,A=255) 
  labelColors(COLOR_PURPLE)=(R=175,G=30 ,B=255,A=255) 
}





















