/*=============================================================================
 * ROTT_Utility_Boss
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A placeable utility for the 3D world that triggers boss battles 
 *===========================================================================*/

class ROTT_Utility_Boss extends StaticMeshActor 
  ClassGroup(ROTT_Utilities)
  placeable;

// Parameters used in ROTTTimers:
const LOOP_OFF = false;
const LOOP_ON  = true;

// Enemy info
var() private array<SpawnerInfo> mobInfo;

// Optional NPC prelude combat
var() public class<ROTT_NPC_Container> npcPrelude;

// Visual components
var private StaticMeshComponent beaconMesh;  

// Beacon mechanics
var private bool bEnabled;

// Reference
var private ROTT_Game_Info gameInfo;

// Timer
var private float deactivationTime;

`include(ROTTColorLogs.h)

/*=============================================================================
 * preBeginPlay()
 *
 * Called when the game is starting
 *===========================================================================*/
event preBeginPlay() {
  super.preBeginPlay();
  
  // Set up references
  gameInfo = ROTT_Game_Info(WorldInfo.game);
}

/*=============================================================================
 * postBeginPlay()
 *
 * Called when the game has started
 *===========================================================================*/
simulated event postBeginPlay() {
  super.postBeginPlay();
}

/*=============================================================================
 * touch()
 *===========================================================================*/
simulated event touch
(
  Actor other, 
  PrimitiveComponent otherComp, 
  vector hitLocation, 
  vector hitNormal
)
{
  // Trigger encounter
  if (bEnabled) {
    // Disable beacon
    bEnabled = false;
  
    // Queue beacon graphic change for after transition effects
    deactivationTime = 3.0;
    
    // Door sound
    gameInfo.sfxBox.playSfx(SFX_WORLD_DOOR);
    
    // Skip combat
    if (gameInfo.playerProfile.gameMode == MODE_TOUR) return;
    if (gameInfo.playerProfile.cheatNoEncounters) return;
    
    // Check for NPC prelude
    if (npcPrelude != none) {
      // Display npc interface
      gameInfo.sceneManager.sceneOverWorld.npcPreludeTransition();
      gameInfo.queueEncounter(mobInfo);
      gameInfo.pauseGame();
      
      // Queue the dialog
      gameInfo.queuedNPC = launchBeaconNPC;
    } else {
      // Start combat
      gameInfo.forceEncounter(mobInfo);
    }
  }
}

/*=============================================================================
 * untouch()
 *===========================================================================*/
simulated event untouch(Actor Other) {
  
}

/*=============================================================================
 * tick()
 *
 * Called each frame with time between frames as argument
 *===========================================================================*/
function tick(float fDeltaTime) {
	super.tick(fDeltaTime);
  
  // Check if deactivation time is up
  if (deactivationTime > 0) {
    // Subtract from deactivation time
    deactivationTime -= fDeltaTime;
    
    // On complete, disable beacon
    if (deactivationTime <= 0) disableBeacon();
  }
}

/*=============================================================================
 * launchBeaconNPC()
 *===========================================================================*/
private function launchBeaconNPC() {
  // Display npc interface
  gameInfo.openNPCDialog(npcPrelude);
}

/*=============================================================================
 * disableBeacon()
 *===========================================================================*/
private function disableBeacon() {
  local ROTT_Portal portal;
  local int i;
  
  // Set disabled state graphics
  beaconMesh.setMaterial(0, Material'ROTT_Utilities.Beacons.M_Recruit_Beacon_Disabled');
  beaconMesh.setMaterial(1, Material'MyPackage.NPC_Blank');
  
  // Unlock boss locks on portals
  for (i = 0; i < mobInfo.length; i++) { 
    if (mobInfo[i].spawnMode == SPAWN_BOSS) {
      forEach AllActors(class'ROTT_Portal', portal) {
        portal.openBossLock();
      }
    }
  }
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // Beacon settings
  bEnabled=true
  
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
  components.add(CylinderComp)
  CollisionComponent=CylinderComp  
  
  // Static Mesh
  begin object class=StaticMeshComponent name=Beacon_Mesh
    StaticMesh=StaticMesh'ROTT_Utilities.Beacons.Boss_Beacon'
    bForceDirectLightMap=true
    bUsePrecomputedShadows=true
    LightingChannels=(bInitialized=true,Static=true)
  end object
  components.Add(Beacon_Mesh);
  beaconMesh=Beacon_Mesh
  StaticMeshComponent=Beacon_Mesh

  // Actor settings
  bStatic=false
}
















