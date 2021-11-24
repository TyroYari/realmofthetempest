/*=============================================================================
 * UI_Component_Visual
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Visual components are UI components that are drawn in some way, and support
 * draw effects.
 *===========================================================================*/

class UI_Component_Visual extends UI_Component
abstract;

// This is the color calculated in real time from effects
var protected Color realTimeColor;

// Layer priorirty, zero is bottom layer
///var public int drawLayer;

// Visual effects
enum EffectTypes {
  EFFECT_HUE_SHIFT,
  EFFECT_ALPHA_CYCLE,
  EFFECT_FLICKER,
  EFFECT_FLIPBOOK,
};

// Stores effect information
struct EffectInfo {
  // Effect
  var EffectTypes effectType;
  
  // Time
  var float lifeTime;
  var float elapsedTime;
  var float intervalTime;
  
  // Parameters
  var byte min;
  var byte max;
  
  // Defaults
  structdefaultproperties
  {
    lifeTime=-1
  }
};

// Active image effects
var protected array<EffectInfo> activeEffects;

/*=============================================================================
 * Initialize Component
 * 
 * Description: This event is called as the UI is loaded.
 *              Our initial components are drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
}
  
/*============================================================================= 
 * elapseTimer()
 *
 * Called every tick from the outer container page.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  local int i;
  
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  // Process image effects
  for (i = activeEffects.length - 1; i >= 0; i--) {
    // Track time
    activeEffects[i].elapsedTime += deltaTime / gameSpeedOverride;
    
    // Track lifeTime if its been set
    if (activeEffects[i].lifeTime != -1) {
      activeEffects[i].lifeTime -= deltaTime / gameSpeedOverride;
      
      // Remove if lifetime complete
      if (activeEffects[i].lifeTime < 0) {
        activeEffects.remove(i, 1);
        resetColor();
      }
    }
  }
}

/*=============================================================================
 * getColor()
 *
 * Returns the draw color for the visual component
 *===========================================================================*/
protected function Color getColor() { 
  local Color returnColor;
  returnColor = super.getColor();
  applyEffects(returnColor);
  
  return multiplyAlpha(returnColor, fadeSystem.getFadeScalar());
}

/*=============================================================================
 * applyEffects()
 *
 * Applies effects to the given color
 *===========================================================================*/
final protected function applyEffects(out color c) {
  local int i;
  
  // Iterate through active effects
  for (i = 0; i < activeEffects.length; i++) {
    // Apply effects to color
    applyEffect(c, activeEffects[i]);
  }
}

/*=============================================================================
 * applyEffect()
 *
 * Applies the given effect to the given color
 *===========================================================================*/
protected function applyEffect(out color c, EffectInfo fx) {
  switch (fx.effectType) {
    case EFFECT_HUE_SHIFT:
      renderHueFX(c, fx);
      break;
    case EFFECT_ALPHA_CYCLE:
      renderAlphaFx(c, fx);
      break;
    case EFFECT_FLIPBOOK:
      renderFlipFx(c, fx);
      break;
    case EFFECT_FLICKER:
      renderFlickerFx(c, fx);
      break;
    
  }
}

/*=============================================================================
 * renderHueFX()
 *
 * Calculates a color cycling effect.
 *===========================================================================*/
private function renderHueFX(out color c, EffectInfo fx) {
  local int cycleStage;
  local byte hueValue;
  local float subCycleTime;
  local float subInterval;
  
  // Calculate hue state
  cycleStage = ((fx.elapsedTime % fx.intervalTime) / fx.intervalTime) * 6;
  subInterval = (fx.intervalTime / 6.0);
  subCycleTime = fx.elapsedTime % subInterval;
  
  // Calculate hue
  hueValue = fx.min;
  if (cycleStage % 2 == 0) {
    // Ascending chroma
    hueValue += (subCycleTime / subInterval) * (fx.max - fx.min);
  } else {
    // Descending chroma
    hueValue += ((subInterval - subCycleTime) / subInterval) * (fx.max - fx.min);
  }
  
  // Set hue based on rainbow interval
  switch (cycleStage) {
    case 0:
      c.r = hueValue;
      c.g = fx.max;
      c.b = fx.min;
      break;
    case 1:
      c.r = fx.max;
      c.g = hueValue;
      c.b = fx.min;
      break;
    case 2:
      c.r = fx.max;
      c.g = fx.min;
      c.b = hueValue;
      break;
    case 3:
      c.r = hueValue;
      c.g = fx.min;
      c.b = fx.max;
      break;
    case 4:
      c.r = fx.min;
      c.g = hueValue;
      c.b = fx.max;
      break;
    case 5:
      c.r = fx.min;
      c.g = fx.max;
      c.b = hueValue;
      break;
    
  }
}

/*=============================================================================
 * renderAlphaFx()
 *
 * Calculates a transparency oscillation effect.
 *===========================================================================*/
private function renderAlphaFx(out color c, EffectInfo fx) {
  local float alphaRatio;
  local float subCycleTime;
  
  // Calculate alpha ratio
  subCycleTime = fx.elapsedTime % fx.intervalTime;
  alphaRatio = 1 - (2 * subCycleTime / fx.intervalTime);
  alphaRatio = abs(alphaRatio);
  
  // Set alpha value
  c.a = fx.min + alphaRatio * (fx.max - fx.min);
}

/*=============================================================================
 * renderFlickerFx()
 *
 * Calculates a flicker effect.
 *===========================================================================*/
private function renderFlickerFx(out color c, EffectInfo fx) {
  local float subCycleTime;
  
  // Calculate alpha ratio
  subCycleTime = (fx.elapsedTime % fx.intervalTime) * 2;
  
  // Set alpha value
  if (subCycleTime < fx.intervalTime) {
    c.a *= (fx.min/255.f);
  } else {
    c.a *= (fx.max/255.f);
  }
}

/*=============================================================================
 * renderFlipFx()
 *
 * Cycles through textures on the sprite.
 *===========================================================================*/
private function renderFlipFx(out color c, EffectInfo fx) {
  local int index;
  
  // Calculate alpha ratio
  index = (int(fx.elapsedTime / fx.intervalTime) % getDrawOptionCount()); 
  
  // Set sprite index
  setDrawIndex(index);
}

/*=============================================================================
 * getDrawOptionCount()
 *
 * Returns the number of draw options (e.g. textures, fonts)
 *===========================================================================*/
public function int getDrawOptionCount();

/*============================================================================= 
 * setDrawIndex()
 *
 * Switches the draw method (e.g. textures, fonts)
 *===========================================================================*/
public function bool setDrawIndex(coerce byte index);

/*=============================================================================
 * resetColor()
 *
 * This should reset original draw color info.  
 *===========================================================================*/
public function resetColor(optional byte alpha = 255);


/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  drawColor=(R=255,G=255,B=255,A=255)
}






















