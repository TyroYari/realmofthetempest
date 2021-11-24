/*=============================================================================
 * ROTT_Combat_Stance_Mod
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A Stance mod applies to a combat unit for some number of
 * combat actions, applying stat modifiers while active.
 *===========================================================================*/

class ROTT_Combat_Stance_Mod extends ROTT_Combat_Object;

// Stores sub stats mods
var public float subStatsMods[SubStatTypes]; 

// Time until next attack multiplier
var public float tunaMultiplier; 

// Number of steps until mod dissipates
var protectedwrite int stepCount; 

// Name for tracking this status
var protectedwrite string modTag;

/*=============================================================================
 * addSteps()
 *
 * Used to add steps to the life time of this mod
 *===========================================================================*/
public function addSteps(int steps) {
  stepCount += steps;
}

/*=============================================================================
 * decrementStep()
 *
 * Used to add steps to the life time of this mod
 *===========================================================================*/
public function decrementStep() {
  stepCount--;
  
  if (stepCount == 0) {
    // Remove this mod...
  }
}

/*=============================================================================
 * Hero Properties
 *===========================================================================*/
defaultProperties 
{
  
}



















