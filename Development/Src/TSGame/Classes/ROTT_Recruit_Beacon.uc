/*=============================================================================
 * ROTT_Recruit_Beacon
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: When touched, a character is added to the team, if the 
 * designated slot is available.
 *===========================================================================*/

class ROTT_Recruit_Beacon extends StaticMeshActor 
  ClassGroup(ROTT_Utilities)
  placeable;

// Hero slots
enum HeroSlots {
  FIRST_HERO_SLOT,
  SECOND_HERO_SLOT,
  THIRD_HERO_SLOT
};
  
// Recruitment settings
var() HeroSlots designatedHeroIndex;
var private bool bEnabled;

// Mesh
var private StaticMeshComponent beaconMesh;

// Particle 
var private ParticleSystemComponent beaconParticles;

// Reference
var private ROTT_Game_Info gameInfo;

`include(ROTTColorLogs.h)

/*=============================================================================
 * PreBeginPlay()
 *
 * Called when the game is starting
 *===========================================================================*/
event PreBeginPlay() {
  local ROTT_Combat_Hero hero, prevHero;
  
  super.PreBeginPlay();
  
  // Check validity of hero index
  if (designatedHeroIndex == FIRST_HERO_SLOT) {
    yellowLog("Warning (!) First hero slot makes no sense on recruit beacon.");
    return;
  }
  
  // Set up references
  gameInfo = ROTT_Game_Info(WorldInfo.Game);
  
  // Initialize beacon settings
  hero = gameInfo.playerProfile.getActiveParty().getHero(designatedHeroIndex);
  prevHero = gameInfo.playerProfile.getActiveParty().getHero(designatedHeroIndex - 1);
  bEnabled = (hero == none && prevHero != none);
  
  // Initialize graphics
  setGraphics(bEnabled);
}

/*=============================================================================
 * touch()
 *
 * Called when any object collides with this volume.  
 *===========================================================================*/
simulated event Touch
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
  
  // Push class selection menu
  gameInfo.playerProfile.sceneManager.switchScene(SCENE_CHARACTER_CREATION);
  
  // Disable beacon
  bEnabled = false;
  setGraphics(bEnabled);
  
}

/*=============================================================================
 * setGraphics()
 *
 * Changes the 3D world graphics to resemble the beacons state
 *===========================================================================*/
private function setGraphics(bool state) {
  if (state) {
    beaconMesh.SetMaterial(0, Material'ROTT_Utilities.Beacons.M_Jump_Beacon_Blue_Purple');
    beaconMesh.SetMaterial(1, Material'ROTT_Utilities.Beacons.Recruit_Gradiant');
    beaconParticles.activateSystem();
  } else {
    beaconMesh.SetMaterial(0, Material'ROTT_Utilities.Beacons.M_Recruit_Beacon_Disabled');
    beaconMesh.SetMaterial(1, MaterialInstanceConstant'MyPackage.M_Invisible');
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
  components.Add(CylinderComp)
  CollisionComponent=CylinderComp
  
  // Static Mesh
  begin object class=StaticMeshComponent name=Beacon_Mesh
    StaticMesh=StaticMesh'ROTT_Utilities.SM_Portal_Beacon'
    bForceDirectLightMap=True
    bUsePrecomputedShadows=True
    LightingChannels=(bInitialized=True,Static=True)
  end object
  components.Add(Beacon_Mesh);
  beaconMesh=Beacon_Mesh
  StaticMeshComponent=Beacon_Mesh
  
  // Particles
  begin object Class=ParticleSystemComponent Name=Beacon_Particles
    bAutoActivate=true
    Template=ParticleSystem'ROTT_Utilities.Beacons.Recruit_Beacon_Stars_1A'
    SecondsBeforeInactive=1
  end object
  beaconParticles=Beacon_Particles
  components.Add(Beacon_Particles)
  
  // Recruitment properties
  designatedHeroIndex=FIRST_HERO_SLOT
  
}























