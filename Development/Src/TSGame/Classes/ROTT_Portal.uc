/*=============================================================================
 * ROTT_Portal
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object allows the player to travel between maps
 *===========================================================================*/

class ROTT_Portal extends InterpActor placeable; 

// Parameter used for save/load transitions
const TRANSITION_SAVE = true;      

// If true, set the travel type to local
var() privatewrite bool bLocalDestination;

// Destination information
var() privatewrite MapNameEnum destination; 

// Checkpoint arrival index (default position is -1)
var() privatewrite int arrivalIndex; 

// Custom material appearances
var() privatewrite MaterialInterface openMaterial;
var() privatewrite MaterialInterface closedMaterial;

// Lock types
enum LockMechanics {
  LOCK_DEFAULT,
  UNLOCK_AFTER_BOSS,
  ALWAYS_UNLOCK
};

// Lock mechanics for this portal
var() privatewrite LockMechanics lockType;

// Stores whether the portal is open or closed
var privatewrite PortalState currentState; 

// Reference
var private ROTT_Game_Info gameInfo;
  
`include(ROTTColorLogs.h)

/*=============================================================================
 * PostBeginPlay()
 *
 * Description: Initilize the graphics and the portal state based on player
 *              profile information
 *===========================================================================*/
simulated event PostBeginPlay() {
  super.PostBeginPlay();
  
  // Link game info for convenience
  gameInfo = ROTT_Game_Info(WorldInfo.Game);///ROTT_Game_Info(class'WorldInfo'.static.GetWorldInfo().Game);
  
  // Initial portal state based on lock type
  switch (lockType) {
    case UNLOCK_AFTER_BOSS:
      setPortalState(GATE_CLOSED);
      break;
    case ALWAYS_UNLOCK:
      setPortalState(GATE_OPEN);
      break;
    case LOCK_DEFAULT:
      setPortalState(gameInfo.getPortalState(destination));
      break;
  }
}

/*=============================================================================
 * openBossLock()
 *
 * Called when a boss is defeated to open the portal
 *===========================================================================*/
public function openBossLock() {
  // Ignore if no boss lock
  if (lockType != UNLOCK_AFTER_BOSS) return;
  
  // Open portal
  setPortalState(GATE_OPEN);
}

/*=============================================================================
 * setPortalState()
 *
 * Description: Changes the portal state and portal graphics
 *===========================================================================*/
private function setPortalState(PortalState pState) {
  // change portal state
  currentState = pState;
  
  // change portal graphics
  switch(currentState) {
    case GATE_OPEN:
      staticMeshComponent.setMaterial(0, openMaterial);
      break;
    case GATE_CLOSED:
      staticMeshComponent.setMaterial(0, closedMaterial);
      break;
  }
}

/*=============================================================================
 * Touch()
 *
 * Description: This describes how players travel through the game
 *===========================================================================*/
simulated event touch
(
  Actor Other, 
  PrimitiveComponent OtherComp, 
  vector HitLocation, 
  vector HitNormal
)
{
  local string mapName;
  
  // ignore irrelevant events
  if (ROTT_Player_Pawn(Other) == none) return;
  if (currentState == GATE_CLOSED) return;
  
  if (bLocalDestination == false) {
    // Perform a temp save of the game
    gameInfo.saveGame(TRANSITION_SAVE, arrivalIndex);
    
    // Load destination
    gameInfo.pauseGame();
    mapName = gameInfo.getMapFileName(destination);
    gameInfo.sceneManager.sceneOverWorld.portalTransition(mapName);
    
    // Sfx
    gameInfo.sfxBox.playSfx(SFX_WORLD_PORTAL); 
  } else { 
    // Transition
    gameInfo.teleportPlayerTo(arrivalIndex);
  }
  
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // Travel type 
  bLocalDestination=false
  
  // Lock mechanic
  lockType=LOCK_DEFAULT
  
  // Move player to this Checkpoint (if not -1)
  arrivalIndex=-1
  
  // Default appearance
  openMaterial=Material'ROTT_Utilities.Portals.M_Portal_Vortex_Blue'
  closedMaterial=Material'ROTT_Utilities.Portals.M_Portal_Vortex_Black'
  
  // Actor properties
  bStatic=false
  bCollideActors=true
  CollisionType=COLLIDE_TouchAll
  
  // Visual components
  begin object class=StaticMeshComponent name=PortalGraphic
    StaticMesh=StaticMesh'ROTT_Utilities.Portals.SM_Portal_1A'
  end object
  Components.Add(PortalGraphic);
  CollisionComponent=PortalGraphic
  StaticMeshComponent=PortalGraphic
  
  // I think this is just ugly
  /**
  begin object class=ParticleSystemComponent name=PortalParticle
    SecondsBeforeInactive=1.0f    
  end object
  MyPSC=PortalParticle
  //ParticleSystemComponent=PortalParticle
  Components.Add(PortalParticle)
  */
}
