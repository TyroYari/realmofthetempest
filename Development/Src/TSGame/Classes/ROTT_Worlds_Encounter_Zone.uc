/*=============================================================================
 * ROTT_Worlds_Encounter_Zone
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This zone enables an enemy spawn list when the player is 
 * inside it.
 *===========================================================================*/

class ROTT_Worlds_Encounter_Zone extends ROTT_Worlds_Encounter_Info
  placeable;

/*=============================================================================
 * PostBeginPlay()
 *
 *===========================================================================*/
simulated event postBeginPlay() {
  super.postBeginPlay();
  
  // Bosses
  enemyClasses[Boss_Rhunia]=class'ROTT_Combat_Enemy_Boss_Rhunia';
  enemyClasses[Boss_Etzland]=class'ROTT_Combat_Enemy_Boss_Etzland';
  enemyClasses[Boss_Haxlyn]=class'ROTT_Combat_Enemy_Boss_Haxlyn';
  enemyClasses[Boss_Valimor]=class'ROTT_Combat_Enemy_Boss_Valimor';
  
  // Ash Reaper
  enemyClasses[Ash_Reaper]=class'ROTT_Combat_Enemy_Ash_Reaper';
  
  // Basilisk
  enemyClasses[Basilisk]=class'ROTT_Combat_Enemy_Basilisk';
  
  // Blood Weaver
  enemyClasses[Blood_Weaver]=class'ROTT_Combat_Enemy_Blood_Weaver';
  
  // Bone Mage
  enemyClasses[Bone_Mage]=class'ROTT_Combat_Enemy_Bone_Mage';
  
  // Cyclops
  enemyClasses[Cyclops]=class'ROTT_Combat_Enemy_Cyclops';
  
  // Corrupter
  enemyClasses[Corrupter]=class'ROTT_Combat_Enemy_Corrupter';
  
  // Dimedius
  enemyClasses[Dimedius]=class'ROTT_Combat_Enemy_Dimedius';
  
  // Dragon Lord
  enemyClasses[Dragon_Lord]=class'ROTT_Combat_Enemy_Dragon_Lord';
  
  // Dreadskold
  enemyClasses[Dreadskold]=class'ROTT_Combat_Enemy_Dreadskold';
  
  // Elder
  enemyClasses[Elder]=class'ROTT_Combat_Enemy_Elder';
  
  // Emissary
  enemyClasses[Emissary]=class'ROTT_Combat_Enemy_Emissary';
  
  // Gatekeepers
  enemyClasses[Gatekeeper]=class'ROTT_Combat_Enemy_Gatekeeper';
  
  // Ghoul
  enemyClasses[Ghoul]=class'ROTT_Combat_Enemy_Ghoul';
  
  // Harshoax
  enemyClasses[Harshoax]=class'ROTT_Combat_Enemy_Harshoax';
  
  // Lycanthrox 
  enemyClasses[Lycanthrox]=class'ROTT_Combat_Enemy_Lycanthrox';
  
  // Mimic 
  enemyClasses[Mimic]=class'ROTT_Combat_Enemy_Mimic';
  
  // Minotaur
  enemyClasses[Minotaur]=class'ROTT_Combat_Enemy_Minotaur';
  
  // Nether Hydra
  enemyClasses[Nether_Hydra]=class'ROTT_Combat_Enemy_Nether_Hydra';
  
  // Nightingale
  enemyClasses[Nightingale]=class'ROTT_Combat_Enemy_Nightingale';
  
  // Ocules
  enemyClasses[Ocules]=class'ROTT_Combat_Enemy_Ocule';
  
  // Oculox
  enemyClasses[Oculox]=class'ROTT_Combat_Enemy_Oculox';
  
  // Ogres
  enemyClasses[Ogre]=class'ROTT_Combat_Enemy_Ogre';
  
  // Okitian Spirit
  enemyClasses[Okitian_Spirit]=class'ROTT_Combat_Enemy_Okitian_Spirit';
  
  // Orcus
  enemyClasses[Orcus]=class'ROTT_Combat_Enemy_Orcus';
  
  // Overlord
  enemyClasses[Overlord]=class'ROTT_Combat_Enemy_Overlord';
  
  // Phantom Brute 
  enemyClasses[Phantom_Brute]=class'ROTT_Combat_Enemy_Phantom_Brute';
  
  // Raider 
  enemyClasses[Raider]=class'ROTT_Combat_Enemy_Raider';
  
  // Ravager 
  enemyClasses[Ravager]=class'ROTT_Combat_Enemy_Ravager';
  
  // Scourge
  enemyClasses[Scourge]=class'ROTT_Combat_Enemy_Scourge';
  
  // Sorceress
  enemyClasses[Sorceress]=class'ROTT_Combat_Enemy_Sorceress';
  
  // Stranglers
  enemyClasses[Strangler]=class'ROTT_Combat_Enemy_Strangler';
  
  // Thirst Demon
  enemyClasses[Thirst_Demon]=class'ROTT_Combat_Enemy_Thirst_Demon';
  
  // Thrasher
  enemyClasses[Thrasher]=class'ROTT_Combat_Enemy_Thrasher';
  
  // Wasps
  enemyClasses[Wasp]=class'ROTT_Combat_Enemy_Wasp';
  
  // Watcher
  enemyClasses[Watcher]=class'ROTT_Combat_Enemy_Watcher';
  
  // Whispers
  enemyClasses[Whispers]=class'ROTT_Combat_Enemy_Whispers';
  
  // Zombies
  enemyClasses[Zombie]=class'ROTT_Combat_Enemy_Zombie';
  
  // Verify all classes have been set
  debugEnemyList();
  gameInfo.debugSpawnRecords();
}

/*=============================================================================
 * debugEnemyList()
 *
 * 
 *===========================================================================*/
public function debugEnemyList() {
  local ROTT_Combat_Enemy newEnemy;
  local SpawnerInfo spawnRecord;
  local SpawnTypes spawnMode;
  local string enemyName;
  local bool bSuccess;
  local int i;
  
  spawnMode = SPAWN_NORMAL;
  
  bSuccess = true;
  for (i = No_Spawn+1; i < EnemyTypes.enumCount; i++) {
    if (enemyClasses[i] == none) {
      // Report missing enemy class
      bSuccess = false;
      enemyName = string(getEnum(enum'EnemyTypes', i));
      yellowLog("Warning (!) Enemy class not specified for " $ enemyName);
    } else {
      // Test stat initialization 
      if (true) {
        newEnemy = new() getEnemyClass(EnemyTypes(i));
        spawnRecord.enemyType = EnemyTypes(i);
        newEnemy.initEnemy(spawnRecord, spawnMode);
      }
    }
  }
  
  // Check for valid enemy zone populations
  bSuccess = bSuccess && checkZoneValidation();
  
  // Report results
  if (bSuccess) {
    greenLog("Enemy list validated successfully.");
  } else {
    redLog("Enemy list has critical errors.");
  }
}

/*=============================================================================
 * checkZoneValidation()
 *
 * Returns true if enemy populations are valid
 *===========================================================================*/
private function bool checkZoneValidation() {
  local int i;
  
  for (i = 0; i < spawnList.length; i++) {
    if (spawnList[i].enemyType == No_Spawn) {
      redLog("Default enemy list has No_Spawn specified!");
      return false;
    }
  }
  
  for (i = 0; i < altSpawnList.length; i++) {
    if (altSpawnList[i].enemyType == No_Spawn) {
      redLog("Alt enemy list has No_Spawn specified!");
      return false;
    }
  }
  
  return true;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Editor visuals
  BrushColor=(B=0,G=113,R=248,A=255)
  bColored=true
}














