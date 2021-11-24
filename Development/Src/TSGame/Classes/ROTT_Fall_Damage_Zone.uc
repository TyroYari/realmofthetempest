/*=============================================================================
 * ROTT_Fall_Damage_Zone
 * 
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 * 
 * Description: This object detects when the player falls off the map
 *===========================================================================*/

class ROTT_Fall_Damage_Zone extends Volume
  placeable; 

// Checkpoint overrid
var() bool bOverrideCheckpoint;
var() int checkpointIndex; 

/*=============================================================================
 * touch()
 *  
 * Called when the player enters a falling area
 *===========================================================================*/
simulated event touch
(
  Actor other, 
  PrimitiveComponent otherComp, 
  vector hitLocation, 
  vector hitNormal
)
{
  // Filter out non-player objects
  if (ROTT_Player_Pawn(Other) == none) return;
  
  // Activate falling status
  if (bOverrideCheckpoint) {
    ROTT_Game_Info(WorldInfo.Game).setPlayerFallen(checkpointIndex);
  } else {
    ROTT_Game_Info(WorldInfo.Game).setPlayerFallen();
  }
  
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  bOverrideCheckpoint=false
  checkpointIndex=0
  
  // Editor Appearance
  bColored=true
  BrushColor=(R=255,G=30,B=200,A=255)
  
}











