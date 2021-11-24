/*=============================================================================
 * ROTT_Worlds_Trap
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * In the 3D world the player can be hit by this trap, causing an enemy 
 * encounter
 *===========================================================================*/

class ROTT_Worlds_Trap extends InterpActor placeable;

// Graphic representation
var() ParticleSystemComponent trapGraphic;

// Respawn index
var() int respawnCheckpoint;

// Trap states
enum TrapStates {
  Trap_Active,
  Trap_Passive
};

// Track current trap status
var private TrapStates trapStatus;

// Trap pattern info
struct TrapPattern {
  // Length of state
  var() float time;
  
  // Trap state
  var() TrapStates trapState;
  
  // Default
  structdefaultproperties {
    time=1.f
  }
};

var() private array<TrapPattern> trapSequence;

// Initial time offset
var() private float timeOffset;

// Track elapsed time for each patter
var private float elapsedPatternTime;

// Track pattern index
var private int patternIndex;

// Track player collision
var private bool bPlayerInTrap;

/*=============================================================================
 * postBeginPlay()
 *
 *===========================================================================*/
simulated event postBeginPlay() {
  // Set initial graphics
  if (trapSequence.length == 0) {
    // Default on
    setTrapState(Trap_Active);
  } else {
    // Copy time offset to elapsed time
    elapsedPatternTime = timeOffset;
    
    // Calculate initial state
    while (elapsedPatternTime > trapSequence[patternIndex].time) {
      // Trap is always on if no time info is given
      if (trapSequence[patternIndex].time == 0) return;
      
      // Progress to next pattern index and shave elapsed time
      elapsedPatternTime -= trapSequence[patternIndex].time;
      incrementPatternIndex();
    }
    
    // Set state
    setTrapState(trapSequence[patternIndex].trapState);
  }
}

/*=============================================================================
 * touch()
 *
 * Called when any object collides with this volume.  Updates the encounter
 * list profile when touched by the player.
 *===========================================================================*/
simulated event touch
(
  Actor other, 
  PrimitiveComponent otherComp, 
  vector hitLocation, 
  vector hitNormal
)
{
  // ignore irrelevant events
  if (ROTT_Player_Pawn(other) == none) return;
  
  bPlayerInTrap = true;
  
  // Trap response types
  switch (trapStatus) {
    case Trap_Active:
      activateTrap();
      break;
    case Trap_Passive:
      // Do nothing
      break;
  }
}

/*=============================================================================
 * untouch()
 *
 * Called when any object leaves this volume.  Removes enemies.
 *===========================================================================*/
simulated event untouch(Actor other) {
  // ignore irrelevant events
  if (ROTT_Player_Pawn(other) == none) return;
  
  bPlayerInTrap = false;
}

/*=============================================================================
 * setTrapState()
 *
 * Called to enable or disable the trap
 *===========================================================================*/
private function setTrapState(TrapStates state) {
  // Update state info
  trapStatus = state;
  
  // Update graphics
  switch (trapStatus) {
    case Trap_Active:
      trapGraphic.activateSystem();
      
      if (bPlayerInTrap) activateTrap();
      break;
    case Trap_Passive:
      trapGraphic.deactivateSystem();
      break;
  }
  
}

/*=============================================================================
 * tick()
 *
 * Called on each frame update
 *===========================================================================*/
event tick(float deltaTime) {
  // Ignore empty pattern data
  if (trapSequence.length == 0) return;
  if (trapSequence[patternIndex].time == 0) return;
  
  // Track time
  elapsedPatternTime += deltaTime;
  
  // Track trap status
  if (elapsedPatternTime > trapSequence[patternIndex].time) {
    // Progress to next pattern index and shave elapsed time
    elapsedPatternTime -= trapSequence[patternIndex].time;
    incrementPatternIndex();
    
    // Set status
    setTrapState(trapSequence[patternIndex].trapState);
  }
}

/*=============================================================================
 * incrementPatternIndex()
 *
 * Called increment pattern index
 *===========================================================================*/
private function incrementPatternIndex() {
  // Increment pattern
  patternIndex++;
  
  // Loop around
  if (trapSequence.length != 0) {
    patternIndex = patternIndex % trapSequence.length;
  }
}

/*=============================================================================
 * activateTrap()
 *
 * Called to inflict trap effect on player
 *===========================================================================*/
private function activateTrap() {
  // Inflict trap effect, respawn player
  if (respawnCheckpoint != -1) {
    ROTT_Game_Info(WorldInfo.Game).setPlayerFallen(respawnCheckpoint);
  } else {
    ROTT_Game_Info(WorldInfo.Game).setPlayerFallen();
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Default checkpoint
  respawnCheckpoint=-1
  
  // Actor settings
  bStatic=false
  
  // Collision mode
  CollisionType=COLLIDE_TouchAll

  // Collision mesh
  begin object class=StaticMeshComponent name=Collision_Mesh
    HiddenGame=true
    HiddenEditor=true // Can disable for proper collision placement
    StaticMesh=StaticMesh'EditorMeshes.TexPropCube'
    Translation=(X=0.0, Y=0, Z=182)
    Scale3D=(X=1.52,Y=1.52,Z=3.0)
  end object
  components.Add(Collision_Mesh)
  collisionComponent=Collision_Mesh
  
  // Trap particles
  begin object class=ParticleSystemComponent name=Trap_Particle_System
    bAutoActivate=true 
    Scale=1.1
    Template=ParticleSystem'ROTT_Utilities.Traps.Trap_Lightning_Orange_1A'
    Translation=(X=0.0, Y=0, Z=182)
    SecondsBeforeInactive=1.0f    
  end object
  trapGraphic=Trap_Particle_System
  components.Add(Trap_Particle_System)
  

}