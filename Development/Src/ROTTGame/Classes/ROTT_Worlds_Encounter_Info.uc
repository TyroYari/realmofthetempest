/*=============================================================================
 * ROTT_Worlds_Encounter_Info
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This zone enables an enemy spawn list when the player is 
 * inside it.
 *===========================================================================*/

class ROTT_Worlds_Encounter_Info extends Volume
dependsOn(ROTT_Combat_Enumerations);

// References
var privatewrite ROTT_Game_Info gameInfo;

// Enables the enemy spawners in this list if true
var privatewrite bool bActiveZone;
  
// Spawn rarity
enum SpawnRarity {
  Common,
  Uncommon,
  Rare
};
  
// Level range
struct LvlRange {
  var() int min;
  var() int max;
};

// Spawn types for exp/loot modifiers 
enum SpawnTypes {
  SPAWN_NORMAL,
  SPAWN_ALTERNATE,
  SPAWN_CHAMPION,
  SPAWN_MINIBOSS,
  SPAWN_BOSS
};

// Enemy Types
enum EnemyTypes {
  No_Spawn,
  
  Ash_Reaper,  
  Basilisk,  
  Blood_Weaver,
  Bone_Mage,
  Corrupter,
  Cyclops,
  Dimedius,
  Dragon_Lord,
  Dreadskold,
  Elder,
  Emissary,
  Gatekeeper,
  Ghoul,
  Harshoax,
  Lycanthrox,
  Mimic,
  Minotaur,
  Nether_Hydra,
  Nightingale,
  Ocules,
  Oculox,
  Ogre,
  Okitian_Spirit,
  Orcus,
  Overlord,
  Phantom_Brute,
  Raider,
  Ravager,
  Scourge,
  Sorceress,
  Strangler,
  Thirst_Demon,
  Thrasher,
  Wasp,
  Watcher,
  Whispers,
  Zombie,
  
  // Bosses
  Boss_Rhunia,
  Boss_Etzland,
  Boss_Haxlyn,
  Boss_Valimor,
  
};

// Spawner info
struct SpawnerInfo {
  var() EnemyTypes enemyType;
  var() ClanColors clanColor;
  var() SpawnRarity rarity;
  var() SpawnTypes spawnMode;
  var() LvlRange levelRange;
  
  /// additional ItemDropMods could go here
  /// with an exp amp
};

// Stores monster spawning records for this zone
var() privatewrite array<SpawnerInfo> spawnList;

// Alternative spawn list (enabled when praying)
var() privatewrite array<SpawnerInfo> altSpawnList;

// Links to enemy NPC classes, populated at the TSGame directory
var protectedwrite array<class<ROTT_Combat_Enemy> > enemyClasses;

/*===========================================================================*/

`include(ROTTColorLogs.h)

/*=============================================================================
 * PostBeginPlay()
 *
 *===========================================================================*/
simulated event postBeginPlay() {
  super.postBeginPlay();

  if (brushComponent != none)  {
    bProjTarget = brushComponent.blockZeroExtent;
  }
  
  // Link game info for convenience
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  gameInfo.addEncounterZone(self);
  grayLog("Added encounter zone: " $ self);
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
  
  // Add enemies to spawn list
  bActiveZone = true;
  
  // Call event for player touching zone
  gameInfo.zoneTouchUpdate();
}

/*=============================================================================
 * untouch()
 *
 * Called when any object leaves this volume.  Removes enemies.
 *===========================================================================*/
simulated event untouch(Actor other) {
  // ignore irrelevant events
  if (ROTT_Player_Pawn(other) == none) return;
  
  // Remove enemies from spawn list
  bActiveZone = false;
}

// Disable projectile functionality
simulated function bool stopsProjectile(Projectile P) {  return false; }

/*=============================================================================
 * getEnemyClass()
 *
 * Used to fetch enemy classes
 *===========================================================================*/
public function class<ROTT_Combat_Enemy> getEnemyClass(EnemyTypes index) {
  return enemyClasses[index];
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  BrushColor=(R=0,G=180,B=255,A=255)

  bProjTarget=true
  SupportedEvents.Empty
  SupportedEvents(0)=class'SeqEvent_Touch'
  SupportedEvents(1)=class'SeqEvent_TakeDamage'
  
}














