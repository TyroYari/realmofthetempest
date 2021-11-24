/*=============================================================================
 * UI_Fade_System
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Tracks and calculates a queue of fading effects to produce a final alpha
 * scalar.
 *===========================================================================*/

class UI_Fade_System extends object;

// Fade effect states
enum EffectStates {
  DELAY,
  FADE_IN,
  FADE_OUT,
  FADE_BLACK,
};

// Fade effect information
struct EffectStruct {
  var EffectStates state;
  var float elapsedTime;
  var float totalTime;
};

// A queue to store fade effects
var privatewrite array<EffectStruct> effects;  

// True if the last effect was a fade out, false if fade in, unchanged otherwise
var privatewrite bool bFadedOut;

// True if faded black effect was used
var privatewrite bool bFadedBlack;

// Colors
`include(ROTTColorLogs.h)

/*=============================================================================
 * updateFadeTime()
 *
 * Calculates the transparency from the fade effects
 *===========================================================================*/
public function updateFadeTime(float deltaTime) {
  if (effects.length == 0) return;
  
  // Tack time
  effects[0].elapsedTime += deltaTime;
  if (effects[0].elapsedTime >= effects[0].totalTime) {
    // Track last fade state
    if (effects[0].state == FADE_OUT) bFadedOut = true;
    if (effects[0].state == FADE_IN) bFadedOut = false;
    if (effects[0].state == FADE_BLACK) bFadedBlack = true;
    
    // Remove effect on completion
    effects.remove(0, 1);
  }
}

/*=============================================================================
 * isFadingIn()
 *
 * True if a fading in effect exists before all fading out effects, if any
 *===========================================================================*/
public function bool isFadingIn() {
  local int i;
  
  // Look for first fade effect
  for (i = 0; i < effects.length; i++) {
    if (effects[i].state == FADE_IN) return true;
    if (effects[i].state == FADE_OUT) return false;
  }
  return false;
}

/*=============================================================================
 * getFadeToBlackScalar()
 *
 * Returns the current fade to black scalar
 *===========================================================================*/
public function float getFadeToBlackScalar() {
  if (bFadedBlack) return 0.f;
  
  // Return multiplicative identity by default
  if (effects.length == 0) return 1.f; 
  
  switch (effects[0].state) {
    case FADE_BLACK:  return (1 - effects[0].elapsedTime / effects[0].totalTime);
    default: return 1.f;
  }
}

/*=============================================================================
 * getFadeScalar()
 *
 * Returns the current fade scalar
 *===========================================================================*/
public function float getFadeScalar() {
  // Return multiplicative identity by default
  if (effects.length == 0) return (bFadedOut) ? 0.f : 1.f; 
  
  switch (effects[0].state) {
    case FADE_IN:  return (effects[0].elapsedTime / effects[0].totalTime);
    case FADE_OUT: return ((effects[0].totalTime - effects[0].elapsedTime) / effects[0].totalTime);
    default: return (bFadedOut || isFadingIn()) ? 0.f : 1.f;
  }
}

/*=============================================================================
 * addEffectToQueue()
 *
 * Allows special effects to be queued
 *===========================================================================*/
public function addEffectToQueue(EffectStates state, float time) {
  local EffectStruct newEffect;
  
  // Set effect info
  newEffect.state = state;
  newEffect.totalTime = time;
  
  // Add effect
  effects.addItem(newEffect);
}

/*=============================================================================
 * debugEffectDump()
 *
 * Debug information is dumped to the console window for the effect queue.
 *===========================================================================*/
protected function debugEffectDump() {
  local int i;
  
  grayLog("Effect list:  (" $ effects.length $ ")");
  for (i = 0; i < effects.length; i++) {
    greenlog(" Effect #" $ i);
    darkgreenlog("  Effect State: " $ effects[i].state);
    darkgreenlog("  Elapsed time: " $ effects[i].elapsedTime $ " remaining of " $ effects[i].totalTime);
  }
}

/*============================================================================= 
 * hideForFadeIn()
 *
 * Called to set this component as hidden before a fade in effect
 *===========================================================================*/
public function hideForFadeIn() {
  bFadedOut = true;
}

/*=============================================================================
 * clearEffects()
 *
 * Removes all effects
 *===========================================================================*/
public function clearEffects() {
  effects.length = 0;
  bFadedOut = false;
}

/*=============================================================================
 * Variable settings
 *===========================================================================*/
defaultProperties
{

}






















