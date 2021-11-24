/*=============================================================================
 * ROTT_Resource_Bartering_Seed
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *===========================================================================*/

class ROTT_Resource_Bartering_Seed extends Actor abstract;

// Reference
var protected ROTT_Game_Info gameInfo;

// Store enemy classes
var() protectedwrite array<class<ROTT_Inventory_Item> > itemClasses;

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



















