/*=============================================================================
 * ROTT_Conflict_Actor (ROTT_World_Event_Actor)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is an actor whose appearance is based on an event status
 *===========================================================================*/
class ROTT_Conflict_Actor extends InterpActor
  ClassGroup(ROTT_Objects)
  placeable;

// Event info
var() private TopicList eventTopic;

// Event actor appearance information
struct EventDisplaySet {
  var() int materialIndex;
  
  var() MaterialInstanceConstant inactiveMaterial;
  var() MaterialInstanceConstant activeMaterial;
};
  
var() privatewrite array<EventDisplaySet> displayInfo;

// References
var private ROTT_Game_Info gameInfo;

`include(ROTTColorLogs.h)

/*=============================================================================
 * postBeginPlay()
 *
 * Called when the game has started
 *===========================================================================*/
simulated event postBeginPlay() {
  gameInfo = ROTT_Game_Info(WorldInfo.Game);
  
  // Initialize appearance based on event status
  if (gameInfo.playerProfile.getEventStatus(eventTopic) == ACTION_TAKEN) {
    setAppearance(true);
  } else {
    setAppearance(false);
  }
}

/*=============================================================================
 * setAppearance()
 * 
 * Updates the appearance based on
 *===========================================================================*/
public function setAppearance(bool bEventActive) {
  local int i;
  
  // Scan through display info
  for (i = 0; i < displayInfo.length; i++) {
    // Flip materials based on event status
    if (bEventActive) {
      staticMeshComponent.setMaterial(
        displayInfo[i].materialIndex, 
        displayInfo[i].activeMaterial
      );
    } else {
      staticMeshComponent.setMaterial(
        displayInfo[i].materialIndex, 
        displayInfo[i].inactiveMaterial
      );
    }
  }
}


/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{

}









