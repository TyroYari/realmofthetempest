/*=============================================================================
 * ROTT_Loot_Trigger_Sequence
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Used to link a trigger to a chest object in kismet.
 *===========================================================================*/

class ROTT_Loot_Trigger_Sequence extends SequenceAction;

// Loot generation information
var(Loot) ROTT_Resource_Chest lootSource;

// Chest empty or not
var(Loot) bool bChestMimic;

// Mimic enemy info
var() private array<SpawnerInfo> mimicInfo;

// Chest empty or not
var private bool bChestEmpty;

// Chest empty or not
var private ROTT_Game_Info gameInfo;

/*=============================================================================
 * activated()
 *
 * Called when the kismet node recieves an impulse
 *===========================================================================*/
event activated() {
  local bool p; local bool q;
  
  // Link to game information
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.GetWorldInfo().game);
  
  // Checks for skipping combat
  p = (gameInfo.playerProfile.gameMode == MODE_TOUR);
  q = (gameInfo.playerProfile.cheatNoEncounters);
  
  if (bChestMimic && !p && !q) {
    // Door sound
    gameInfo.sfxBox.playSfx(SFX_WORLD_DOOR);
  
    // Start combat
    gameInfo.forceEncounterDelay(mimicInfo, 1.0);
    
  } else {
    // Skip looting process if transitioning to combat, or if empty
    if (gameInfo.bEncounterActive || bChestEmpty) return;
    
    // Use target or specified source
    if (ROTT_Resource_Chest(targets[0]) != none && lootSource == none) {
      lootSource = ROTT_Resource_Chest(targets[0]);
    }
    
    // Open the chest
    lootSource.openChest();
  }
  
  // Empty the chest
  bChestEmpty = true;
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  ObjName="OpenChest"
  ObjCategory="ROTT" 
  
  bCallHandler=false
}