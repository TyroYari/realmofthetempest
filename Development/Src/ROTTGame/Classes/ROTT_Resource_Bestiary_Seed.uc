/*=============================================================================
 * ROTT_Resource_Bestiary_Seed
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *===========================================================================*/

class ROTT_Resource_Bestiary_Seed extends Actor abstract;

// Reference
var protected ROTT_Game_Info gameInfo;

// Store enemy classes
var() protectedwrite array<class<ROTT_Combat_Enemy> > enemyClasses;

/*=============================================================================
 * postBeginPlay()
 *
 * Called when the game has started
 *===========================================================================*/
event postBeginPlay() {
  super.postBeginPlay();
  
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  
}



















