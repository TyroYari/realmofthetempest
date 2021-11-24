/*=============================================================================
 * ROTT_Waypoint_Beacon
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: When touched, all portal access to a specified map is unlocked.
 *===========================================================================*/

class ROTT_Waypoint_Beacon extends StaticMeshActor 
  ClassGroup(ROTT_Utilities)
  placeable;
  
// Waypoint settings
var() private MapNameEnum unlockDestination;
var private bool bEnabled;

// Mesh
var private StaticMeshComponent beaconMesh;

// Particle 
var private ParticleSystemComponent beaconParticles;
var private ParticleSystemComponent explosionEffect;

// Reference
var private ROTT_Game_Info gameInfo;

`include(ROTTColorLogs.h)

/*=============================================================================
 * PreBeginPlay()
 *
 * Called when the game is starting
 *===========================================================================*/
event PreBeginPlay() {
  super.PreBeginPlay();
  
  // Set up references
  gameInfo = ROTT_Game_Info(WorldInfo.Game);
  
  // Initialize beacon state
  setEnabled(gameInfo.getPortalState(unlockDestination) != GATE_OPEN);
  
  // Position effects
  beaconParticles.SetTranslation(vect(0,0,175));
  explosionEffect.SetTranslation(vect(0,0,175));
}

/*=============================================================================
 * touch()
 *
 * Called when any object collides with this volume.  
 *===========================================================================*/
simulated event touch
(
  Actor other, 
  PrimitiveComponent otherComp, 
  vector hitLocation,  
  vector hitNormal
)
{
  // Ignore non-player colliders
  if (ROTT_Player_Pawn(other) == none) return;
  
  // Ignore disabled beacon collision
  if (bEnabled == false) return;
  
  // Unlock portal destination
  gameInfo.showGameplayNotification("Portal Tethered");
  gameInfo.playerProfile.setPortalUnlocked(unlockDestination);
  explosionEffect.activateSystem();
  
  // Sound
  gameInfo.sfxBox.playSfx(SFX_COMBAT_BUFF);
  
  // Disable beacon
  setEnabled(false);
  
}

/*=============================================================================
 * setEnabled()
 *
 * Changes the state, and updates the 3D world graphics
 *===========================================================================*/
private function setEnabled(bool state) {
  // Store enabled state
  bEnabled = state;
  
  // Update graphics
  if (bEnabled) {
    beaconMesh.SetMaterial(0, MaterialInstanceConstant'ROTT_Utilities.Waypoint.M_Waypoint_Beacon_Effect_Ring_1A');
    beaconMesh.SetMaterial(2, MaterialInstanceConstant'ROTT_Utilities.Waypoint.M_Waypoint_Beacon_Effect_Fade_1A');
    beaconParticles.activateSystem();
  } else {
    beaconMesh.SetMaterial(0, Material'MyPackage.Fog.BlankMaterial');
    beaconMesh.SetMaterial(2, Material'MyPackage.Fog.BlankMaterial');
    beaconParticles.deactivateSystem();
  }
}

simulated event untouch(Actor Other);

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bStatic=false
  
  // Collision
  bCollideActors=true
  CollisionType=COLLIDE_TouchAll
  
  // Collision Mesh
  begin object Class=CylinderComponent Name=CylinderComp
    CollisionRadius=128
    CollisionHeight=480
    CollideActors=true        
    BlockActors=false
  end object
  Components.Add(CylinderComp)
  CollisionComponent=CylinderComp
  
  // Static Mesh
  begin object class=StaticMeshComponent name=Beacon_Mesh
    StaticMesh=StaticMesh'ROTT_Utilities.SM_Portal_Beacon'
    bForceDirectLightMap=True
    bUsePrecomputedShadows=True
    LightingChannels=(bInitialized=True,Static=True)
  end object
  Components.Add(Beacon_Mesh);
  beaconMesh=Beacon_Mesh
  StaticMeshComponent=Beacon_Mesh
  
  // Particle decoration
  begin object Class=ParticleSystemComponent Name=Beacon_Particles
    bAutoActivate=true
    Template=ParticleSystem'ROTT_Monument_Shrines.Golems.Golem_Sys_1E_Blue'
    //SecondsBeforeInactive=1
  end object
  beaconParticles=Beacon_Particles
  Components.Add(Beacon_Particles)
  
  // Explosion
  begin object Class=ParticleSystemComponent Name=Explosion_Particles
    bAutoActivate=false
    Template=ParticleSystem'ROTT_Waypoints.Waypoint_Explosion_1A'
    SecondsBeforeInactive=1
  end object
  explosionEffect=Explosion_Particles
  Components.Add(Explosion_Particles)
}























