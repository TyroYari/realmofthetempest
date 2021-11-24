/*=============================================================================
 * ROTT_Conflict_Emitter (ROTT_World_Event_Emitter)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a particle system whose appearance is based on an event status
 *===========================================================================*/
class ROTT_Conflict_Emitter extends InterpActor
  ClassGroup(ROTT_Objects)
  placeable;

// Event info
var() private TopicList eventTopic;

// Event actor appearance information
var() const ParticleSystemComponent activeParticles;
var() const ParticleSystemComponent inactiveParticles;

// References
var private ROTT_Game_Info gameInfo;


`include(ROTTColorLogs.h)

/*=============================================================================
 * postBeginPlay()
 *
 * Called when the game has started
 *===========================================================================*/
simulated event postBeginPlay() {
  super.postBeginPlay();
  
  // Get game reference
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
  if (bEventActive) {
    // Show activated event particles
    activeParticles.activateSystem();
    inactiveParticles.deactivateSystem();
  } else {
    // Show deactivated event particles
    activeParticles.deactivateSystem();
    inactiveParticles.activateSystem();
  }
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // Inactive particle system 
  begin object Class=ParticleSystemComponent Name=Inactive_Particles
    SecondsBeforeInactive=1
  end object
  inactiveParticles=Inactive_Particles
  Components.Add(Inactive_Particles)
  
  // Active particle system 
  begin object Class=ParticleSystemComponent Name=Active_Particles
    SecondsBeforeInactive=1
  end object
  activeParticles=Active_Particles
  Components.Add(Active_Particles)
  
}















