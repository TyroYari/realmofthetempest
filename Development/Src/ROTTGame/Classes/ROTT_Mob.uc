/*=============================================================================
 * ROTT_Mob
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object manages a mob of enemy units.
 *===========================================================================*/

class ROTT_Mob extends ROTT_Object;

const MAX_MOB_SIZE = 3;

// The enemies in the mob are stored here
var privatewrite array<ROTT_Combat_Enemy> mobLineup;  

// The enemy placement is handled here by 3 slots
var private ROTT_Combat_Enemy enemyUnits[MAX_MOB_SIZE];  

// Stores mob size
var privatewrite int mobCapacity;

// Store exp provided upon defeat of this mob
var privatewrite int mobExp;

// Combat status
var privatewrite bool bCombatEnded;

// Store black hole status
var public bool bBlackHoleActive;

// Store average level of enemy units
var privatewrite int averageLevel;

// Rewards for defeating this mob
var protectedwrite ROTT_Inventory_Package itemPackage;

// Stores true when summoned via bestiary services
var public bool bBestiarySummon;

/*=============================================================================
 * battlePrep()
 *
 * This function is called after a mob lineup has been established, before a
 * combat scenario starts
 *===========================================================================*/
public function battlePrep() {
  local ROTT_Combat_Enemy tempUnit;
  local int avgLevel;
  local int enemyCount;
  local int i;
  
  bCombatEnded = false;
  
  // Valid lineup check
  if (mobLineup.length == 0) {
    yellowLog("Warning (!) No mob lineup!");
    return;
  } 
  
  // Gather drop items from each enemy
  generateBounty();
  
  // Elite enemy check (champions, bosses)
  for (i = 0; i < mobLineup.length; i++) {
    if (mobLineup[i].bLargeDisplay == true) {
      // Single center unit
      enemyUnits[1] = mobLineup[i];
      
      // Remove champion from lineup
      mobLineup.remove(i, 1);
      
      // Valid henchmen check
      if (mobLineup.length == 1) {
        yellowLog("Warning (!) Champion should never have a single henchman.");
        return;
      } 
    }
  }
  
  // Formation
  switch (mobLineup.length) {
    case 0:
      // Solo champion
      break;
    case 1:
      // Single center unit
      enemyUnits[1] = mobLineup[0];
      
      // Remove one unit from index zero
      mobLineup.remove(0, 1);
      break;
    case 2:
      // Duo pair formation
      enemyUnits[0] = mobLineup[0];
      enemyUnits[2] = mobLineup[1];
      
      // Remove two unit from index zero
      mobLineup.remove(0, 2);
      break;
    default:
      // Full trio formation
      enemyUnits[0] = mobLineup[0];
      enemyUnits[1] = mobLineup[1];
      enemyUnits[2] = mobLineup[2];
      
      // Remove three units from index zero
      mobLineup.remove(0, 3);
      break;
  }
  
  // Initial attack time bars
  for (i = 0; i < MAX_MOB_SIZE; i++) {
    if (enemyUnits[i] != none) { 
      enemyUnits[i].setTUNA(randRange(0, 0.6));
      enemyUnits[i].battlePrep();
    }
  }
  
  // Sort enemies (for matching end units)
  if (getMobSize() == 3 && !enemyUnits[1].bLargeDisplay) {
    if (enemyUnits[0].monsterType == enemyUnits[1].monsterType) {
      // Swap slots 1 and 2
      tempUnit = enemyUnits[2];
      enemyUnits[2] = enemyUnits[1];
      enemyUnits[1] = tempUnit;
    } else if (enemyUnits[1].monsterType == enemyUnits[2].monsterType) {
      // Swap slots 1 and 0
      tempUnit = enemyUnits[1];
      enemyUnits[1] = enemyUnits[0];
      enemyUnits[0] = tempUnit;
    }
  }
  
  // Assign slot values
  for (i = 0; i < MAX_MOB_SIZE; i++) {
    if (enemyUnits[i] != none) enemyUnits[i].mobIndex = i;
  }
  
  // Store average mob level
  for (i = 0; i < MAX_MOB_SIZE; i++) {
    if (enemyUnits[i] != none) {
      avgLevel += enemyUnits[i].level;
      enemyCount++;
    }
  }
  avgLevel /= enemyCount;
  averageLevel = avgLevel;
}

/*=============================================================================
 * battleEnd()
 *
 * This function is called after a battle is done, when the transition out is
 * complete.
 *===========================================================================*/
public function battleEnd() {
  local int i;
  
  // Reset enemy displayers
  for (i = 0; i < 3; i++) {
    gameInfo.getEnemyUI(i).resetUI();
  }
  
  // Report mob
  gameInfo.playerProfile.reportMobLevel(averageLevel); 
}

/*=============================================================================
 * generateBounty()
 *
 * Called when the battle starts to set a reward if the player wins.
 *===========================================================================*/
public function generateBounty() {
  local int itemLevel;
  local int i;
  
  // Create item package
  itemPackage = new class'ROTT_Inventory_Package';
  
  // Add drops from each monster to the package
  for (i = 0; i < mobLineup.length; i++) {
    // Set drop level for items
    itemLevel = mobLineup[i].level;
    
    // Amplify based on spawn type
    switch (mobLineup[i].spawnType) {
      case SPAWN_BOSS:
        itemLevel *= 2.5;
        break;
      case SPAWN_MINIBOSS:
        itemLevel *= 1.5;
        break;
      case SPAWN_CHAMPION:
        itemLevel *= 1.25;
        break;
    }
    
    itemPackage.takeInventory(
      gameInfo.generateLoot(
        itemLevel,
        mobLineup[i].lootAmplifier,
        mobLineup[i].itemDropRates
      )
    );
  }
  
  // Cull the total inventory for 8 slot limit
  itemPackage.cullInventory();
}

/*=============================================================================
 * addEnemy()
 *
 * This function adds an enemy to the mob lineup before a battle starts. 
 *
 * pre condition notes: The combat UI is not loaded yet.
 *===========================================================================*/
public function addEnemy(ROTT_Combat_Enemy enemyUnit) {
  if (enemyUnit.level == 0) {
    yellowLog("Warning (!) Enemy unit not initialized (level 0)");
    return; 
  }
  
  // Pass down common references
  enemyUnit.linkReferences();
  
  // Add enemy to the combat queue
  mobLineup.addItem(enemyUnit);
  
  // Track mob reward
  mobExp += enemyUnit.getMonsterExp();
}
  
/*=============================================================================
 * removeEnemy()
 *
 * This function removes an enemy after its death animation completes
 *===========================================================================*/
public function removeEnemy(ROTT_Combat_Enemy unit) {
  local int i;
  
  if (unit == none) {
    yellowLog("Warning (!) Attempt to remove enemy 'none'");
    return;
  }
  
  // Remove UI
  unit.uiComponent.attachDisplayer(none);
  
  // Remove enemy
  for (i = 0; i < MAX_MOB_SIZE; i++) {
    if (enemyUnits[i] == unit) enemyUnits[i] = none;
  }
  
  // Check if mob defeated
  for (i = 0; i < MAX_MOB_SIZE; i++) {
    if (enemyUnits[i] != none) return;
  }
  
  // end combat
  if (mobLineup.length == 0 && bCombatEnded == false) {
    gameInfo.endCombat();
    bCombatEnded = true;
  }
}

/*=============================================================================
 * setUIComponents()
 *
 * This function looks up UI components for this mob.
 *
 * Pre condition notes: The combat UI must be up when this is called.
 *===========================================================================*/
public function setUIComponents() {
  local int i;
  
  for (i = 0; i < MAX_MOB_SIZE; i++) {
    if (enemyUnits[i] != none) { 
      enemyUnits[i].setUIComponent();
    }
  }
}
  
/*=============================================================================
 * getEnemy()
 *
 * This function accesses an enemy.
 *===========================================================================*/
public function ROTT_Combat_Enemy getEnemy(int index) {
  if (index < MAX_MOB_SIZE) return enemyUnits[index];
  
  yellowLog("Warning (!) Index outside of max mob size");
  scripttrace();
  return none;
}

/*=============================================================================
 * getAnyEnemy()
 *
 * This function accesses the first available enemy
 *===========================================================================*/
public function ROTT_Combat_Enemy getAnyEnemy() {
  local int i;
  
  for (i = 0; i < getMaxMobSize(); i++) {
    if (getEnemy(i) != none) return getEnemy(i);
  }
}

/*=============================================================================
 * getMaxMobSize()
 *
 * Returns the max size of the mob (size is static)
 *===========================================================================*/
public function int getMaxMobSize() {
  return MAX_MOB_SIZE;
}

/*=============================================================================
 * getMobSize()
 *
 * Returns the number of living enemy units.  (THIS DOES NOT RETURN MAX SIZE)
 *===========================================================================*/
public function int getMobSize() {
  local int size, i;
  
  for (i = 0; i < MAX_MOB_SIZE; i++) {
    if (getEnemy(i) != none && !getEnemy(i).bDead) size++;
  }
  
  return size;
}

/*=============================================================================
 * elapseTime()
 *
 * This function is called every tick.
 *============================================================================*/
public function elapseTime(float deltaTime) {
  local int i;
  
  for (i = 0; i < getMaxMobSize(); i++) {
    if (getEnemy(i) != none) getEnemy(i).elapseTime(deltaTime);
  }
}

/*=============================================================================
 * drainMobLife()
 *
 * This function is called to drain life from the mob, regardless of armor
 *============================================================================*/
public function drainMobLife(float life, optional bool bTrackBlackHoleDamage = false) {
  local int i;
  
  for (i = 0; i < getMaxMobSize(); i++) {
    if (getEnemy(i) != none) getEnemy(i).drainLife(life, bTrackBlackHoleDamage);
  }
}

/*=============================================================================
 * showBhDamage()
 *
 * This function is called to show black hole damage
 *============================================================================*/
public function showBhDamage(ROTT_Combat_Unit caster) {
  local int i;
  
  for (i = 0; i < getMaxMobSize(); i++) {
    if (getEnemy(i) != none) getEnemy(i).showBhDamage(caster);
  }
}

/*=============================================================================
 * debugDataStructure()
 * 
 * Dumps most of the data structure to the console log when called
 * (Note: excludes player profile, see DEBUG_PLAYER_PROFILE instead)
 *===========================================================================*/
public function debugDataStructure() {
  local int i;  
  
  greenLog("  Mob data:");
  greenLog("    Size: " $ mobCapacity);
  greenLog("    Mob Lineup:");
  for (i = 0; i < mobLineup.length; i++) {
    darkGreenLog("      " $ mobLineup[i]);
  }
  greenLog("    Enemy Units:");
  for (i = 0; i < MAX_MOB_SIZE; i++) {
    darkGreenLog("      " $ enemyUnits[i]);
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  
}










