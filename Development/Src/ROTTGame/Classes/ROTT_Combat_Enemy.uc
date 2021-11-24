/*=============================================================================
 * ROTT_Combat_Enemy
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is a base class for enemy units.
 *===========================================================================*/
 
class ROTT_Combat_Enemy extends ROTT_Combat_Unit
dependsOn(ROTT_Game_Info);

// Display name for combat screen
var protectedwrite string monsterName;

// Monster type from enumeration, for assigning sprite index
var protectedwrite EnemyTypes monsterType;
  
// Clan color
var protectedwrite ClanColors clanColor;

// Graphics
var public instanced UI_Texture_Storage enemySprites;
var public instanced UI_Texture_Storage champSprites;

// Used to store how this unit was spawned, for applying drop modifiers
var protectedwrite SpawnTypes spawnType;
  
// Drop modifiers
var protectedwrite array<ItemDropMod> itemDropRates;
  
// Stat generation
var protected int baseStatsPerLvl[StatTypes];  // Constant amount to add per level
var protected int randStatsPerLvl;             // Random amount to add per level
var protected int statPreferences[StatTypes];  // Weights for allocating random stats, must add to 100%

// Name generation
// (An enumeration is the closest thing to a constant string array that I can
// find in this language)
enum TitleEnum {
  Nephilim, Arkhon, Ancient, Grand, Master, Phantom, Lord, Elite, Oblivion, 
  Hellspawn, Diabolic, Obsidian, Unholy, Hellion, Warlord, Heretic, Fearmore,
  Shadow, Juggernaught, Reckless, Noxious, Chthonic, Malefic, Wicked,
  Chieftain, Behemoth, Executioner, Anointed, Treacherous, Devouring, Cursed
};

enum PrefixEnum {
  Blood, Dark, Cold, Grim, Bone, Spider, Viral, Death, Wraith, Night, Ghost, 
  Stone, Iron, Venom, Doom, Fang, Dread, Widow, Scarab, Hex, Mammoth, Malice,
  Gore
};

enum SuffixEnum {
  Fist, Heart, Skull, Claw, Bolt, Throat, Grip, Prince, Star, Bite, Spell, 
  Fever, Fiend, Crawler, Stalker, Scowl, Zealot, Mauler, Caster, Cleaver,
  Nemesis, Lurker, Reaver, Tyrant, Crusader
};

// Elite status, true for champions, minibosses, bosses
var protectedwrite bool bLargeDisplay;

// Abilities
var protected ROTT_Descriptor_Enemy_Skill_Attack attackAbility;
///var protected ROTT_Descriptor_Enemy_Skill_Defend defendAbility;

// Combat action list
var private delegate<actionRoutine> combatActions; 
/* to do... turn this into a weighted array and roll actions randomly */

// Mob positioning data
var public int mobIndex;

// Animation timer
var private ROTT_Timer animationTimer;
///var public ROTT_UI_Displayer_Combat_Enemy uiComponent;

// Experience modifier
var public float expAmp;

// Loot amplifier
var public float lootAmplifier;

// Action delay
var private float actionDelay;

// Store gem price for bestiary summoning
var privatewrite int bestiaryCost;

// Store a randomized portrait for champions
var privatewrite UI_Texture_Info portraitInfo;
var privatewrite bool bPortraitInitialized;

// Action delegate stub
delegate bool actionRoutine
(
  ROTT_Combat_Unit target,
  ROTT_Combat_Enemy caster
);

/*============================================================================= 
 * generateMonster()
 *
 * Constructor for creating monster units from spawn records.
 *===========================================================================*/
public static function ROTT_Combat_Enemy generateMonster
(
  class<ROTT_Combat_Enemy> enemyClass, 
  SpawnerInfo spawnRecord, 
  SpawnTypes spawnMode
) 
{
  local ROTT_Combat_Enemy newEnemy;
  
  // Create the enemy
  newEnemy = new() enemyClass;
  
  // Generate enemy info
  newEnemy.initEnemy(spawnRecord, spawnMode);
  
  return newEnemy;
}

/*============================================================================= 
 * getPortrait()
 *
 * Returns the draw info for the enemy sprite (in combat.)
 *===========================================================================*/
public function UI_Texture_Info getPortrait() {
  local UI_Texture_Info info;
  
  // Cache portrait
  if (bPortraitInitialized) return portraitInfo;
  bPortraitInitialized = true;
  
  // Access texture-set
  switch (spawnType) {
    case SPAWN_CHAMPION:
      info = champSprites.images[rand(champSprites.images.length)];
      break;
    case SPAWN_MINIBOSS:
    case SPAWN_BOSS:
      info = champSprites.images[clanColor];
      break;
    default:
      info = enemySprites.images[clanColor];
      break;
  } 
  
  // Randomize texture selection
  info.randomizeTexture();
  
  // Randomize texture orientation
  info.randomizeOrientation();
  
  // Cache portrait
  portraitInfo = info;
  
  return info;
}

/*============================================================================= 
 * initEnemy()
 *
 * This is only called when the unit is first created
 *===========================================================================*/
public function initEnemy
(
  SpawnerInfo spawnRecord, 
  SpawnTypes spawnMode
) 
{
  local int randStatCount;
  local int investMultiplier;
  local int i;
  
  // Setup link to gameInfo
  linkReferences();
  
  // Assign type
  monsterType = spawnRecord.enemyType;
  clanColor = ClanColors(spawnRecord.clanColor);
  spawnType = spawnMode;
  
  // Assign reward amplifiers for each spawn type
  switch (spawnType) {
    case SPAWN_NORMAL:     expAmp = 1;    amplifyCurrencies(1);    break;
    case SPAWN_ALTERNATE:  expAmp = 1.5;  amplifyCurrencies(1);    break;
    case SPAWN_CHAMPION:   expAmp = 4;    amplifyCurrencies(1);    break;
    case SPAWN_MINIBOSS:   expAmp = 3;    amplifyCurrencies(1.25); break;
    case SPAWN_BOSS:       expAmp = 5;    amplifyCurrencies(1.5);  break;
  }
  
  // Item amplifiers
  switch (spawnType) {
    case SPAWN_NORMAL:     break;
    case SPAWN_ALTERNATE:  break;
    case SPAWN_CHAMPION:   lootAmplifier = 3.f;  break;
    case SPAWN_MINIBOSS:   lootAmplifier = 4.f;  break;
    case SPAWN_BOSS:       lootAmplifier = 10.f; break;
  }
  
  switch (spawnType) {
    case SPAWN_CHAMPION:  
    case SPAWN_MINIBOSS:  
    case SPAWN_BOSS:      
      // Force elite mobs to drop gems
      gemDropChance(100);
      break;
  }
  
  // Calculate level
  switch (spawnType) {
    case SPAWN_CHAMPION:
      // Push level higher than max
      level = spawnRecord.levelRange.max + 1 + spawnRecord.levelRange.max / 5;
      break;
    default:
      // Roll a level in specified range
      level = spawnRecord.levelRange.min;
      level += rand(spawnRecord.levelRange.max - spawnRecord.levelRange.min + 1);
      break;
  }
  
  // Get class-specific stat generation info
  initStats(monsterType, spawnType);
  
  // Assign baseline stat values
  hardStats[PRIMARY_VITALITY] += baseStatsPerLvl[PRIMARY_VITALITY] * (level - 1);
  hardStats[PRIMARY_STRENGTH] += baseStatsPerLvl[PRIMARY_STRENGTH] * (level - 1);
  hardStats[PRIMARY_COURAGE] += baseStatsPerLvl[PRIMARY_COURAGE] * (level - 1);
  hardStats[PRIMARY_FOCUS] += baseStatsPerLvl[PRIMARY_FOCUS] * (level - 1);
  
  // Increase stat per level for champs
  if (spawnType == SPAWN_CHAMPION) randStatsPerLvl++;
  
  // Set random stat total
  randStatCount = randStatsPerLvl * (level - 1);
  
  // Set multiplier and reduce loop iterations
  investMultiplier = 1;
  while (randStatCount > 250) {
    randStatCount /= 5;
    investMultiplier *= 5;
  }
  
  // Distribute random stat investments
  for (i = 0; i < randStatCount; i++) {
    rollRandom(investMultiplier);
  }
  
  // Add abilities to unit
  attackAbility = new class'ROTT_Descriptor_Enemy_Skill_Attack';
  
  // Assign abilities
  combatActions = attackAbility.skillAction;
  
  // Set initial stats and health
  restore();
  
  // Populate active mods
  populateSkillMods();
  
  // Set Elite status for UI scale
  switch (spawnType) {
    case SPAWN_CHAMPION:
    case SPAWN_MINIBOSS:
    case SPAWN_BOSS:
      // Large display mode
      bLargeDisplay = true;
      break;
  }
  
  // Sprite and name display settings
  switch (spawnType) {
    case SPAWN_CHAMPION:
      // Randomized name and sprite
      monsterName = generateMonsterName();
      break;
    default:
      // Assign a fixed sprite
      break;
  }
  
  // Set bestiary gem cost
  bestiaryCost = level / 10 + rand(3);
  
  // Setup UI
  enemySprites.initializeComponent();
  champSprites.initializeComponent();
  
  // Show stat generation
  debugStatGeneration();
}

/*=============================================================================
 * initStats()
 *
 * Called before all other initialization functions (Implemented in children)
 *===========================================================================*/
public function initStats
(
  EnemyTypes enemyType, 
  SpawnTypes spawnerType
);

/*============================================================================= 
 * amplifyCurrencies()
 *
 * Multiplies the currency quantity drop ranges with the given scalar.
 *===========================================================================*/
public function amplifyCurrencies(float lootAmp) {
  local ItemDropMod currencyMod;
  local class<ROTT_Inventory_Item> currencyTypes[2];
  local bool bFound;
  local int i, k;
  
  // Set currency list
  currencyTypes[0] = class'ROTT_Inventory_Item_Gold';
  currencyTypes[1] = class'ROTT_Inventory_Item_Gem';
  
  // For each currency type
  for (k = 0; k < 2; k++) {
    // Scan for an existing currency mod
    for (i = 0; i < itemDropRates.length; i++) {
      if (itemDropRates[i].dropType == currencyTypes[k]) {
        // Amplify currency quantity
        itemDropRates[i].quantityAmp *= lootAmp;
        
        // Mark that we found and modified this value
        bFound = true;
        break;
      }
    }
    if (!bFound) {
      // Make currency mod
      currencyMod.dropType = currencyTypes[k];
      currencyMod.quantityAmp = lootAmp;
      
      // Add currency mod
      itemDropRates.addItem(currencyMod);
    }
  }
}

/*============================================================================= 
 * gemDropChance()
 *
 * Sets the gem drop chance to the given percentage.
 *===========================================================================*/
public function gemDropChance(float gemChance) {
  local ItemDropMod currencyMod;
  local int i;

  // Scan for an existing gem mod
  for (i = 0; i < itemDropRates.length; i++) {
    if (itemDropRates[i].dropType == class'ROTT_Inventory_Item_Gem') {
      // Set chance to drop
      itemDropRates[i].chanceOverride = gemChance;
      return;
    }
  }
  
  // Make currency mod
  currencyMod.dropType = class'ROTT_Inventory_Item_Gem';
  currencyMod.chanceOverride = gemChance;
  
  // Add currency mod
  itemDropRates.addItem(currencyMod);
}

/*=============================================================================
 * elapseTime()
 *
 * This function is called every tick.
 *===========================================================================*/
public function elapseTime(float deltaTime) {
  if (bDead) return;
  
  super.elapseTime(deltaTime);
  
  // Dreamfire DPS
  if (gameInfo.playerProfile.getEnchantBoost(DREAMFIRE_RELIC) != 0) {
    subStats[CURRENT_HEALTH] -= deltaTime * gameInfo.playerProfile.getEnchantBoost(DREAMFIRE_RELIC);
    updateSubStats();
  }
  
  // Increment TUNA bar
  if (bActionReady) {
    if (actionDelay < 0) {
      // Perform an action
      /* to do ... randomize actions, add delay (based on focus?) ... */
      combatActions(
        gameInfo.getActiveParty().getRandomHero(),
        self
      );
      
      bActionReady = false;
    } else {
      actionDelay -= deltaTime;
    }
  }
}

/*=============================================================================
 * attackTimeComplete
 *
 * Called when the attack time bar reaches its maximum
 *===========================================================================*/
protected function attackTimeComplete() {
  bActionReady = true;
  actionDelay = fRandRange(0.2, 0.4);
}

/*=============================================================================
 * fRandRange()
 *
 * Returns a random float in the given range
 *===========================================================================*/
protected function float fRandRange(float min, float max) {
  return fRand() * (max - min) + min;
}

/*=============================================================================
 * getMonsterExp()
 *
 * Calculates the exp reward for killing this unit
 *===========================================================================*/
public function int getMonsterExp() {
  local float enchantmentAmp;
  local float exp;
  local int i;
  
  // Sum stats with affinity weights (weight range: 3 to 5)
  for (i = 0; i < 4; i++) {
    exp += (statAffinities[i] + 3) * (hardStats[i] + 2.5);
  }
  
  // Amplify enchantment boost
  enchantmentAmp = gameInfo.getActiveParty().getExpMultiplier();
  exp += exp * enchantmentAmp;
  
  // Final balancing
  return exp * expAmp / 6.f;
}

/*============================================================================= 
 * setAnimation()
 *
 * Adds a set of sprites to animate an incoming skill effect on this unit.
 *===========================================================================*/
public function setAnimation(UI_Texture_Storage sprites) {
  uiComponent.showSkillEffects(sprites);
}

/*=============================================================================
 * setUIComponent()
 *
 * This function looks up a UI component for this unit.
 *
 * Pre condition notes: The combat UI must be up when this is called.
 *===========================================================================*/
public function setUIComponent() {
  // Fetch UI component
  uiComponent = gameInfo.getEnemyUI(mobIndex);
  
  // Initial component setup
  uiComponent.attachDisplayer(self);
  
  if (uiComponent == none) {
    yellowLog("Warning (!) Enemy UI fetch failed, is combat page not up?");
  }
}

/*=============================================================================
 * getChanceToHit()
 *
 * Given a target, this randomly rolls a hit chance and returns true if hit.
 *===========================================================================*/
public function bool getChanceToHit(ROTT_Combat_Unit target) {
  local ROTT_Combat_Hero hero;
  local bool result;
  
  result = super.getChanceToHit(target);
  
  // Analysis tracking
  hero = ROTT_Combat_Hero(target);
  if (hero != none) {
    hero.battleStatistics[INCOMING_ACTIONS] += 1;
    if (result == true) {
      hero.battleStatistics[INCOMING_HITS] += 1;
    } else {
      hero.battleStatistics[INCOMING_MISSES] += 1;
    }
  }
  
  return result;
}

/*=============================================================================
 * showBhDamage()
 *
 * This is called to display the black hole damage on screen
 *===========================================================================*/
public function showBhDamage(ROTT_Combat_Unit caster) {
  // Show damage on screen
  showDamageOnUI(blackHoleDamage, 1);
  
  // Statistic tracking
  caster.damageFeedback(blackHoleDamage, true);
  
  // Reset damage tracker
  blackHoleDamage = 0;
  /* This should be generalized for other types of damage of time displays */
}

/*============================================================================= 
 * updateSubStats()
 *
 * This needs to be called every time this unit is targeted by a skill, or uses
 * a skill, or changes levels of skill, enchantments, or changes item
 *
 * The post condition for this function is that all substats are accurate,
 * whether it be for the menu or for a combat scenario.
 *===========================================================================*/
public function updateSubStats() {
  super.updateSubStats();
  
}

/*=============================================================================
 * onDeath()
 *
 * This function is called when the unit dies
 *===========================================================================*/
protected function onDeath() {
  super.onDeath();
  
  // Animation delay before unit destroyed
  animationTimer = gameInfo.spawn(class'ROTT_Timer');
  animationTimer.makeTimer(1.00, LOOP_OFF, destroyUnit);
  
  // Sound
  sfxBox.playSfx(SFX_COMBAT_ENEMY_DEATH);
}

/*=============================================================================
 * destroyUnit()
 *
 * This function is called after the death animation to destroy the object
 *===========================================================================*/
private function destroyUnit() {
  // Clean up UI for this unit
  uiComponent.unitDestroyed();
  
  // Remove unit
  gameInfo.enemyEncounter.removeEnemy(self);
  
  // Destroy the timer
  animationTimer.destroy();
}

/*=============================================================================
 * Generate Monster Name
 *
 * Used for elite spawns, not for normal monsters or bosses
 *===========================================================================*/
private function string generateMonsterName() {
  local string title, prefix, suffix;
  
  title = string(GetEnum(enum'TitleEnum', rand(TitleEnum.EnumCount)));
  prefix = string(GetEnum(enum'PrefixEnum', rand(PrefixEnum.EnumCount)));
  suffix = string(GetEnum(enum'SuffixEnum', rand(SuffixEnum.EnumCount)));
  
  return title @ prefix @ suffix;
}

/*============================================================================= 
 * rollRandom()
 *
 * Rolls a random stat using weighted preferences
 *===========================================================================*/
private function rollRandom(optional int amp = 1) {
  local int randRoll;
  
  // Roll random value out of 100%
  randRoll = rand(100);
  
  // Vitality roll
  if (randRoll < statPreferences[PRIMARY_VITALITY]) {
    // Stat increase
    hardStats[PRIMARY_VITALITY] += amp;
    return;
  } 
  
  // Strength roll
  randRoll -= statPreferences[PRIMARY_VITALITY];
  if (randRoll < statPreferences[PRIMARY_STRENGTH]) {
    // Stat increase
    hardStats[PRIMARY_STRENGTH] += amp;
    return;
  } 
  
  // Courage roll
  randRoll -= statPreferences[PRIMARY_STRENGTH];
  if (randRoll < statPreferences[PRIMARY_COURAGE]) {
    // Stat increase
    hardStats[PRIMARY_COURAGE] += amp;
    return;
  } 
  
  // Focus stat increase
  hardStats[PRIMARY_FOCUS] += amp;
}

/*=============================================================================
 * debugStatGeneration()
 *
 * Shows results of stat generation
 *===========================================================================*/
public function debugStatGeneration() {
  whiteLog("", DEBUG_COMBAT);
  whiteLog("Level " $ level @ monsterName @ "spawned with:", DEBUG_COMBAT);
  cyanlog("Spawn mode " $ spawnType, DEBUG_COMBAT);
  whiteLog(" - Vitality: " $ getPrimaryStat(PRIMARY_VITALITY) $ " (" $ subStats[MAX_HEALTH] $ ")", DEBUG_COMBAT);
  whiteLog(" - Strength: " $ getPrimaryStat(PRIMARY_STRENGTH) $ " (" $ subStats[MIN_PHYSICAL_DAMAGE] $ " - " $ subStats[MAX_PHYSICAL_DAMAGE] $ ")", DEBUG_COMBAT);
  whiteLog(" - Courage: " $ getPrimaryStat(PRIMARY_COURAGE) $ " (" $ subStats[TOTAL_ATK_INTERVAL] $ ")", DEBUG_COMBAT);
  whiteLog(" - Focus: " $ getPrimaryStat(PRIMARY_FOCUS), DEBUG_COMBAT);
  whiteLog("", DEBUG_COMBAT);  
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Base health
  baseHealth=10
  
  baseMinDamage=2
  baseMaxDamage=4
  
  armorPerLvl=0.f
  
  affinity(CRIT_MULTIPLIER)=(amp[MINOR]=1.1, amp[AVERAGE]=1.1, amp[MAJOR]=1.1) 
  
  // Reward info
  expAmp=1.f
  lootAmplifier=1.f
}


















