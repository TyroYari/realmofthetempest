/*=============================================================================
 * Cookie_Options
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Stores game option data for saved files.
 *===========================================================================*/
 
class Cookie_Options extends object;

// Sound volume
var float sfxVolume;

// Music volume
var float musicVolume;

// Action selection memory
var bool bTickActionMemory;

// Target selection memory
var bool bTickTargetMemory;

// Scale mode
var int scaleModeType;

// Combat view mode
var bool showCombatDetail;

// 3D World turning speed
var float turnSpeed;

// Invert view Josytick axis
var bool bInvertY;

// Always defend hero combat options
var bool bAlwaysDefendHero1;
var bool bAlwaysDefendHero2;
var bool bAlwaysDefendHero3;

/*=============================================================================
 * toggleCombatDetail()
 *
 * Shows or hides combat details, like hp and mp numbers
 *===========================================================================*/
public function toggleCombatDetail() {
  showCombatDetail = !showCombatDetail;
  scripttrace();
  `log("showCombatDetail"@showCombatDetail);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Default display settings
  showCombatDetail=true 
  
  scaleModeType=1  ///NO_STRETCH_SCALE
  
}