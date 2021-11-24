/*=============================================================================
 * ROTT_Kismet_Shrine_Activation
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This kismet event is triggered through using the shrine.
 *===========================================================================*/

class ROTT_Kismet_Shrine_Activation extends SequenceAction
dependsOn(ROTT_Descriptor_Rituals);

enum ShrineRituals {
  // Item shrines
  RITUAL_DONATION,
  
  // Monument shrines
  RITUAL_OBELISK,
  RITUAL_TOMB,
  RITUAL_GOLEM,
};

// Selected in kismet to specify shrine operations
var(Shrine) protectedwrite ShrineRituals shrineType;
var(Shrine) protectedwrite RitualTypes donationType;

// References
var private ROTT_Game_Info gameInfo;

// Include colored debug logs
`include(ROTTColorLogs.h)

/*=============================================================================
 * activated()
 *
 * Called when the kismet node recieves an impulse
 *===========================================================================*/
event activated() {
  local bool bMonumentIsActive;
  
  // Get game reference
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  
  // Execute shrine behavior
  switch (shrineType) {
    case RITUAL_DONATION:
      // Filter unrelated shrines
      if (gameInfo.queuedRitual != donationType) return;
      
      // Open shrine offerings
      gameInfo.sceneManager.switchScene(SCENE_SERVICE_SHRINE);
      gameInfo.sceneManager.sceneServiceShrine.launchShrine(donationType);
      break;
      
    case RITUAL_OBELISK:
      // Toggle monument state
      bMonumentIsActive = gameInfo.playerProfile.toggleEventStatus(OBELISK_ACTIVATION);
      updateShrineGraphics(bMonumentIsActive);
      break;
    case RITUAL_TOMB:
      // Toggle monument state
      bMonumentIsActive = gameInfo.playerProfile.toggleEventStatus(VALOR_BLOSSOMS);
      updateShrineGraphics(bMonumentIsActive);
      break;
    case RITUAL_GOLEM:
      // Toggle monument state
      bMonumentIsActive = gameInfo.playerProfile.toggleEventStatus(GOLEMS_BREATH);
      updateShrineGraphics(bMonumentIsActive);
      break;
      
    default:
      yellowLog("Warning (!) Unhandled shrine type");
      break;
  }
}

/*=============================================================================
 * updateShrineGraphics()
 *
 * Switches the shrine graphics to the given state
 *===========================================================================*/
public function updateShrineGraphics(bool bMonumentIsActive) {
  local ROTT_Conflict_Emitter shrineEmitter;
  local ROTT_Conflict_Actor shrineActor;
  
  // Update graphics on shrine to active state
  foreach gameInfo.allActors(class'ROTT_Conflict_Emitter', shrineEmitter) {
    shrineEmitter.setAppearance(bMonumentIsActive);
  }
  foreach gameInfo.allActors(class'ROTT_Conflict_Actor', shrineActor) {
    shrineActor.setAppearance(bMonumentIsActive);
  }
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  ObjName="ShrineActivation"
  ObjCategory="ROTT" 
}
















