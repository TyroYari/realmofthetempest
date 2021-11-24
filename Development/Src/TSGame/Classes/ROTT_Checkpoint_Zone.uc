/*=============================================================================
 * ROTT_Checkpoint_Zone
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: When a player reaches this volume, their respawn location is
 * updated based on a related checkpoint marker.
 *===========================================================================*/

class ROTT_Checkpoint_Zone extends Volume
  placeable; 
 
// Index of checkpoint associated with reaching this zone
var() int checkpointIndex;  

// Color logging
`include(ROTTColorLogs.h)

/*=============================================================================
 * touch()
 *
 * Called when actors collide with this zone.
 *===========================================================================*/
simulated event touch
(
  Actor other, 
  PrimitiveComponent otherComp, 
  vector hitLocation, 
  vector hitNormal
) 
{
  local ROTT_Checkpoint checkpoint;
  
  // Filter out non-player objects
  if (ROTT_Player_Pawn(Other) == none) return;
  
  // Get checkpoint
  checkpoint = getCheckpoint(checkpointIndex);
  
  // Update player's respawn location
  if (checkpoint == none) {
    yellowLog("Checkpoint missing for index " $ checkpointIndex);
    return;
  }
  
  // Update respawn for player
  ROTT_Player_Pawn(Other).setRespawnIndex(checkpointIndex);
}

/*=============================================================================
 * getCheckpoint()
 *
 * Given a checkpoint index, this returns that checkpoint
 *===========================================================================*/
public function ROTT_Checkpoint getCheckpoint(int index) {
  local ROTT_Checkpoint checkpoint;
  
  // Look through checkpoint actors
  foreach AllActors(class'ROTT_Checkpoint', checkpoint) {
    if (checkpoint.Checkpoint_Index == checkpointIndex) {
      return checkpoint;
    }
  }
  
  return none;
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // Unique ID set in editor for each checkpoint zone
  checkpointIndex=0
  
  // Editor Appearance
  bColored=true
  BrushColor=(R=40,G=255,B=185,A=255)
}

















