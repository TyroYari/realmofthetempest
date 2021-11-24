/*=============================================================================
 * ROTT_Combat_Hero
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is a combat unit that is controlled by the player.
 *===========================================================================*/

class ROTT_Combat_Hero extends ROTT_Combat_Unit
dependsOn(ROTT_Descriptor_List_Glyph_Skills)
dependsOn(ROTT_Descriptor_Rituals)
abstract;
  
// Design Constant
const STATS_PER_LEVEL        = 10;
const SKILL_POINTS_PER_LEVEL = 2;

// Life ratio to resurrect to
const RESURRECTION_PERCENT = 1.0;

// Party information
var public int partyIndex;

// Character descriptors
enum HeroClassEnum {
  UNSPECIFIED, 
  
  VALKYRIE,
  GOLIATH,
  WIZARD,
  TITAN,
  ASSASSIN
};

// Combat action options
enum CombActEnum {
  ATTACK,
  PRIMARY_SKILL,
  SECONDARY_SKILL,
  DEFEND,
};

var privatewrite CombActEnum actionType;

// Hero Class
var protectedwrite HeroClassEnum myClass;             

// Stat info
var protectedwrite ROTT_Descriptor_List_Stats statDescriptors;

// Skill trees
var protected class<ROTT_Descriptor_List> skillTreeType;             
var protected ROTT_Descriptor_List classSkillSet;             
var protected ROTT_Descriptor_List_Mastery_Skills masterySkillSet;
var protected ROTT_Descriptor_List_Glyph_Skills glyphSkillSet;

// Default abilities
var protectedwrite ROTT_Descriptor_Skill_Attack attackAbility;
var protectedwrite ROTT_Descriptor_Skill_Defend defendAbility;

// Stat and Skill Point Investments
var protectedwrite int classSkillPts[8];
var protectedwrite int glyphSkillPts[GlyphSkills];
var protectedwrite int masterySkillPts[MasterySkills];

// Stat Blessings
var protectedwrite int blessingCount;

// Selected combat skills
var protectedwrite byte primarySkill; 
var protectedwrite byte secondarySkill; 

var protectedwrite ROTT_Descriptor_Hero_Skill primaryScript; 
var protectedwrite ROTT_Descriptor_Hero_Skill secondaryScript; 

// Experience and Leveling 
var protectedwrite float experience;               // Total experience since level 1
var protectedwrite int nextLvlExp;                 // Total experience needed for next level
var protectedwrite int unspentSkillPoints;         // Unspent Skills
var protectedwrite int unspentStatPoints;          // Unspent Stats

// Experience animation
var public bool bPrepExp;
var protectedwrite bool bAnimateExp;
var protectedwrite float elapsedExpTime;
var protectedwrite float animatedExp;
var protectedwrite float pendingExp;
var protectedwrite int expDestination;

// Combat           
var privatewrite int activeGlyphCollection[GlyphEnum];  // Active glyph counts during battle
var privatewrite int totalGlyphCollection[GlyphSkills]; // Total glyph counts for battle statistics

// Battle statistic tracking
enum StatisticEnum {
  OUTGOING_ACTIONS,         // Total number of enemy targetting actions 
  OUTGOING_HITS,            // Total number of hits on enemy targets
  OUTGOING_MISSES,          // Total number of misses
  OUTGOING_DAMAGE,          // Total damage dealt in a battle
  
  INCOMING_ACTIONS,         // Total number of enemy actions targeting this hero
  INCOMING_HITS,            // Total number of hits taken by hero
  INCOMING_MISSES,          // Total number of attacks dodged by hero
  INCOMING_DAMAGE,          // Total number of damage taken by hero
  
  BATTLE_TIME,              // Total time spent in combat
  
  RECOVERED_HEALTH,         // Total health recovered via HP glyphs
  RECOVERED_MANA,           // Total mana recovered via MP glyphs
  RECOVERED_MANA_REGEN,     // Total amount of mana gained by MP Regen glyphs
  
  ADDED_GLYPH_ACCURACY,
  ADDED_GLYPH_DODGE,
  ADDED_GLYPH_DAMAGE,       // Total damage added from glyphs
  ADDED_GLYPH_ARMOR,
  
};

// Battle Statistics for combat analysis
var public float battleStatistics[StatisticEnum];

// Persistent statistic tracking (These stats are never reset)
enum PersistentHeroEnum {
  TRACK_PHYSICAL_DAMAGE,    
  TRACK_ELEMENTAL_DAMAGE,   
  TRACK_ATMOSPHERIC_DAMAGE, 
};

// Persistent statistics that are never reset
var public float persistentStatistics[PersistentHeroEnum];

// Held Item reference
var privatewrite ROTT_Inventory_Item heldItem;
var privatewrite class<ROTT_Inventory_Item> heldItemType;

// Store enemy selection
var public int lastEnemySelection;

// Stores persistence parameters
///var privatewrite CombActEnum lastActionType;
var privatewrite ChosenTargetEnum lastTarget;

// Combat action delegates
var privatewrite delegate<actionRoutine> selectedAction;

var privatewrite delegate<actionRoutine> attackAction;
var privatewrite delegate<actionRoutine> defendAction;
var privatewrite delegate<actionRoutine> primaryAction;
var privatewrite delegate<actionRoutine> secondaryAction;

delegate bool actionRoutine
(
  array<ROTT_Combat_Unit> targets,
  ROTT_Combat_Hero caster,
  optional AttributeSets AttributeSet = COMBAT_ACTION_SET 
);

/*=============================================================================
 * initialize()
 *
 * This function is called every time a new hero object is created.
 * (This is necessary every time a saved game is loaded, so it happens often)
 *
 * Precondition note: Gameinfo reference is unfortunately none here
 *===========================================================================*/
public function initialize() {
  linkReferences();
  
  // Skip if game is not engaged
  if (gameInfo.playerProfile == none) return;
  
  // Set up stat data
  statDescriptors = new(self) class'ROTT_Descriptor_List_Stats';
  statDescriptors.initialize();
  
  // Initialize data structures for skills and scripts
  initializeSkills();
  
  // Populate active mods
  populateSkillMods();
  
  // Link skills, if weve loaded skills
  updateSkillScripts();
  
  // Prevent dead state
  if (!bDead) subStats[CURRENT_HEALTH] = 1; 
  
  // Calculate initial substats
  updateSubStats();
  
  // Initial stat info
  restore();
}

/*=============================================================================
 * initializeSkills()
 *
 * Called to setup initial skills.  Additional skills expanded in sub classes.
 *===========================================================================*/
protected function initializeSkills() {
  // Create skill trees
  glyphSkillSet = new(self) class'ROTT_Descriptor_List_Glyph_Skills';
  glyphSkillSet.initialize();
  
  masterySkillSet = new(self) class'ROTT_Descriptor_List_Mastery_Skills';
  masterySkillSet.initialize();
  
  classSkillSet = new(self) skillTreeType;
  classSkillSet.initialize();
  
  // Create skills, and initial combat action delegates
  attackAbility = new(self) class'ROTT_Descriptor_Skill_Attack';
  attackAbility.initialize();
  attackAbility.initUI();
  defendAbility = new(self) class'ROTT_Descriptor_Skill_Defend';
  defendAbility.initialize();
  defendAbility.initUI();
  attackAction = attackAbility.skillAction;
  defendAction = defendAbility.skillAction;
  
}

/*=============================================================================
 * equipItem()
 *
 * Attaches an item to this character, returns previous item if swapping out.
 *===========================================================================*/
public function ROTT_Inventory_Item equipItem(ROTT_Inventory_Item newItem) { 
  local ROTT_Inventory_Item currentItem;
  
  // Check if hero is alive
  if (bDead && gameInfo.playerProfile.gameMode == MODE_HARDCORE) {
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT); 
    return none;
  }
  
  // Check for valid quantity
  if (newItem.quantity != 1) {
    yellowLog("Warning (!) Equipment quantity must be one: " $ newItem.quantity);
    return none;
  }
  
  // Store previous item reference
  currentItem = heldItem;
  
  // Swap in new item reference
  heldItem = newItem;
  
  // Store held item type info for save data
  heldItemType = newItem.class;
  
  // Check for profile loaded before updating stats
  if (gameInfo.playerProfile == none) {
    return none;
  }
  
  // Update stat info
  updateSubStats();
  
  // Update UI
  if (gameInfo.sceneManager != none) {
    if (gameInfo.sceneManager.sceneGameMenu.leftGameMenu != none) {
      gameInfo.sceneManager.sceneGameMenu.leftGameMenu.refresh();
    }
  }
  
  // Return previously held item
  return currentItem;
}

/*=============================================================================
 * unequipItem()
 *
 * Removes equiped item, returns the item as output
 *===========================================================================*/
public function ROTT_Inventory_Item unequipItem() { 
  local ROTT_Inventory_Item previousItem;
  
  // Store previous item reference
  previousItem = heldItem;
  
  // Remove item reference
  heldItem = none;
  
  // Reset held item type info for save data
  heldItemType = none;
  
  // Update stat info
  updateSubStats();
  
  // Update UI
  gameInfo.sceneManager.sceneGameMenu.leftGameMenu.refresh();
  
  // Return previously held item
  return previousItem;
}

/*============================================================================= 
 * heldItemStat()
 *
 * Returns an attribute boost value from held item
 *===========================================================================*/
public function float heldItemStat(EquipmentAttributes attributeIndex) {
  if (heldItem == none) return 0;
  
  return heldItem.itemStats[attributeIndex];
}

/*=============================================================================
 * getSpiritualProwess()
 *
 * Returns spiritual prowess rating
 *===========================================================================*/
public function int getSpiritualProwess() {
  local int prowess;
  
  prowess += 250 * glyphSkillPts[GLYPH_TREE_MANA];
  prowess += 250 * glyphSkillPts[GLYPH_TREE_MP_REGEN];
  prowess += 250 * glyphSkillPts[GLYPH_TREE_DODGE];
  
  prowess += 0.01 * persistentStatistics[TRACK_ATMOSPHERIC_DAMAGE];
  
  prowess += 100 * hardStats[PRIMARY_COURAGE];
  prowess += 100 * hardStats[PRIMARY_FOCUS];
  
  return prowess;
}
  
/*=============================================================================
 * getHuntingProwess()
 *
 * Returns hunting prowess rating
 *===========================================================================*/
public function int getHuntingProwess() {
  local int prowess;
  
  prowess += 250 * glyphSkillPts[GLYPH_TREE_ARMOR];
  prowess += 250 * glyphSkillPts[GLYPH_TREE_DAMAGE];
  
  prowess += 0.001 * persistentStatistics[TRACK_PHYSICAL_DAMAGE];
  prowess += 1 * ROTT_Party(outer).persistentStatistics[TRACK_MONSTERS_SLAIN];
  prowess += 1000 * ROTT_Party(outer).persistentStatistics[TRACK_BOSSES_SLAIN];
  
  prowess += 25 * hardStats[PRIMARY_STRENGTH];
  
  return prowess;
}

/*=============================================================================
 * getBotanicalProwess()
 *
 * Returns botanical prowess rating
 *===========================================================================*/
public function int getBotanicalProwess() {
  local int prowess;
  
  prowess += 100 * glyphSkillPts[GLYPH_TREE_HEALTH];
  prowess += 100 * glyphSkillPts[GLYPH_TREE_SPEED];
  prowess += 100 * glyphSkillPts[GLYPH_TREE_ACCURACY];
  
  prowess += 0.002 * persistentStatistics[TRACK_ELEMENTAL_DAMAGE];
  
  prowess += 100 * hardStats[PRIMARY_VITALITY];
  
  return prowess;
}

/*=============================================================================
 * populateSkillMods()
 *
 * This function initializes the list of all active stat modifying skills,
 * items, enchantments. 
 *===========================================================================*/
protected function populateSkillMods() {
  local int i;
  
  activeMods.length = 0;
  
  // Populate skill mods
  for (i = 0; i < classSkillSet.getScriptCount(); i++) {
    addUnitMod(getSkillScript(i));
  }
  for (i = 0; i < glyphSkillSet.getScriptCount(); i++) {
    addUnitMod(getGlyphScript(i));
  }
  for (i = 0; i < masterySkillSet.getScriptCount(); i++) {
    addUnitMod(getMasteryScript(i));
  }
  
  // Populate item mods
  /* to do ... */
  /// Moved to updateSubStats  sub routines
  
  // Populate enchantment mods
  /* to do ... */
  /// Moved to updateSubStats  sub routines
}

/*=============================================================================
 * addUnitMod()
 *
 * This is a generic function for populating any type of unit mod
 *===========================================================================*/
private function addUnitMod(object unitModifier) {
  local ROTT_Descriptor_Hero_Skill mod;
  // Type cast unit modifier
  mod = ROTT_Descriptor_Hero_Skill(unitModifier);
  
  // Add unit modifier
  if (mod != none) {
    activeMods.addItem(mod);
  } else {
    yellowLog("Warning (!) Unit mod failed: " $ unitModifier);
  }
}

/*=============================================================================
 * battlePrep()
 *
 * This function is called right before a battle starts
 *===========================================================================*/
public function battlePrep() {
  super.battlePrep();
  
  // Apply passive party boosts (normal passives are handled elsewhere)
  classSkillSet.onBattlePrep(self);
  
  // Track first attack interval, for statistics
  firstAtkInterval = currentAtkInterval;
}

/*=============================================================================
 * onAnalysisComplete()
 *
 * This function is called after a battle is done, and after battle analysis
 * is finished.
 *===========================================================================*/
public function onAnalysisComplete() {
  super.onAnalysisComplete();
  
  // Heal
  restore();
  
  // Reset selection
  lastEnemySelection = 0;
}

/*=============================================================================
 * updateSkillScripts()
 *
 * This must be called any time a new primaryskill or secondaryskill is set.
 *===========================================================================*/
private function updateSkillScripts() {
  // Primary & Secondary skill scripts and actions
  primaryScript = ROTT_Descriptor_Hero_Skill(getSkillScript(primarySkill));
  primaryAction = primaryScript.skillAction;
  secondaryScript = ROTT_Descriptor_Hero_Skill(getSkillScript(secondarySkill));
  secondaryAction = secondaryScript.skillAction;
}

/*=============================================================================
 * setInitialStats()
 *
 * Called when a new hero is added to a team, and sets initial exp
 *===========================================================================*/
public function setInitialStats(int slot) {
  // Party slot
  partyIndex = slot;
  
  // Initial experience settings
  switch (slot) {
    case 0:  level = 1;  break;
    case 1:  level = 5;  break;
    case 2:  level = 10;  break;
  }
  
  // Experience settings
  experience = getExpForLevel(level);
  nextLvlExp = getExpForLevel(level + 1);
  unspentStatPoints += STATS_PER_LEVEL * (level-1);
  unspentSkillPoints += SKILL_POINTS_PER_LEVEL * (level-1);
  
  // Calculate the resulting substats
  updateSubStats();
  
  // Sub classes may allocate skills, so we let them go first and update here
  updateSkillScripts();
}

/*=============================================================================
 * clearTemporaryInfo()
 *
 * This resets all battle statistics and temporary stat boosts
 *===========================================================================*/
protected function clearTemporaryInfo() {
  local int i;
  
  super.clearTemporaryInfo();
  
  // Reset battle statistics
  for (i = 0; i < StatisticEnum.enumCount; i++) {
    battleStatistics[i] = 0;
  }
  
  // Reset glyph statistics
  for (i = 0; i < GlyphSkills.enumCount; i++) {
    totalGlyphCollection[i] = 0;
  }
  
  // Reset glyph mechanics
  for (i = 0; i < GlyphEnum.enumCount; i++) {
    activeGlyphCollection[i] = 0;
  }
  
  updateSubStats();
}

/*=============================================================================
 * addBattleStatistic()
 *
 * This is called for tracking battle statistics.  Other functions are used
 * from classes that dont have access to the enumeration.
 *===========================================================================*/
public function addBattleStatistic(StatisticEnum type, float value) {
  // Battle statistics tracking
  battleStatistics[type] += value;
}

/*=============================================================================
 * reportHealthIncrease()
 *
 * This is called to report statistics for a health increase
 *===========================================================================*/
protected function reportHealthIncrease(float healValue) {
  // Battle statistics tracking
  battleStatistics[RECOVERED_HEALTH] += healValue;
}

/*=============================================================================
 * reportManaIncrease()
 *
 * This is called to report statistics for a mana increase
 *===========================================================================*/
protected function reportManaIncrease(float healMana, bool bManaRegen) {
  // Battle statistics tracking
  if (bManaRegen) {
    battleStatistics[RECOVERED_MANA_REGEN] += healMana;
  } else {
    battleStatistics[RECOVERED_MANA] += healMana;
  }
}

/*=============================================================================
 * Skill descriptor accessors
 *
 * These functions are used to access skill descriptors by ID
 *===========================================================================*/
public function ROTT_Descriptor getSkillScript(int skillID) {
  return classSkillSet.getScript(skillID, self);
}
public function ROTT_Descriptor getGlyphScript(int skillID) {
  return glyphSkillSet.getScript(skillID, self);
}
public function ROTT_Descriptor getMasteryScript(int skillID) {
  return masterySkillSet.getScript(skillID, self);
}

/*=============================================================================
 * Skill level accessors
 *
 * These functions are used to access baseline hard skillpoints
 *===========================================================================*/
public function int getClassLevel(int index) {
  return classSkillPts[index];
}

public function int getGlyphLevel(int index) {
  return glyphSkillPts[index];
}

public function int getMasteryLevel(int index) {
  return masterySkillPts[index];
}

/*=============================================================================
 * Skill level boosters
 *
 * Returns the held item boost for an enchantment
 *===========================================================================*/
public function int getHeldItemEnchantment(byte enchantIndex) {
  // Check if held item exists
  if (heldItem == none) return 0;
  
  // Check if enchantment boost type matches this item
  if (enchantIndex == heldItem.enchantmentType) {
    // Return enchantment boost level
    return heldItemStat(ITEM_ADD_ENCHANTMENT_LEVEL);
  }
  return 0;
}

/*=============================================================================
 * Skill level boosters
 *
 * These functions are used to access skillpoints boosts
 *===========================================================================*/
public function int getClassLevelBoost(int index) {
  local int boostLevel;
  
  if (getClassLevel(index) != 0) {
    // Add enchantment
    boostLevel = gameInfo.playerProfile.getEnchantBoost(OATH_PENDANT);
    
    // Add held item boosts
    if (heldItem != none) {
      // All class skill boost
      boostLevel += heldItem.itemStats[ITEM_ADD_CLASS_SKILLS];
      
      // Check class for specific skill boost
      if (heldItem.heroSkillType == myClass) {
        // Check specific skill boost index
        if (heldItem.heroSkillID == index) {
          // Specific skill boost
          boostLevel += heldItem.itemStats[ITEM_ADD_SKILL_POINTS];
        }
      }
    }
  
    return boostLevel;
  }
  return 0;
}

public function int getGlyphLevelBoost(int index) {
  local int boostLevel;
  
  if (getGlyphLevel(index) != 0) {
    // Add enchantment
    boostLevel = gameInfo.playerProfile.getEnchantBoost(EMPERORS_TALISMAN);
    
    // Add held item boosts
    if (heldItem != none) {
      boostLevel += heldItem.itemStats[ITEM_ADD_GLYPH_SKILLS];
    }
    
    return boostLevel;
  }
  return 0;
}

/*============================================================================= 
 * Primary Stat Accessor
 *
 * This accessor provides vitality/strength/courage/focus values, with bonuses
 *===========================================================================*/
public function int getPrimaryStat(StatTypes statType) {
  return super.getPrimaryStat(statType);
}

/*============================================================================= 
 * addRitualBoosts()
 *
 * Provides boosts from rituals, shrine donations
 *===========================================================================*/
public function addRitualBoosts() {
  // Max health
  subStats[MAX_HEALTH] += getRitualAmp(RITUAL_HEALTH_BOOST);
  
  // Max Mana
  subStats[MAX_MANA] += getRitualAmp(RITUAL_MANA_BOOST);
  
  // Regen enchantments and rituals
  subStats[HEALTH_REGEN] = gameInfo.playerProfile.getEnchantBoost(ROSEWOOD_PENDANT);
  subStats[MANA_REGEN] = gameInfo.playerProfile.getEnchantBoost(ETERNAL_SPELLSTONE);
  
  subStats[HEALTH_REGEN] += getRitualAmp(RITUAL_HEALTH_REGEN);
  subStats[MANA_REGEN] += getRitualAmp(RITUAL_MANA_REGEN);
  
  subStats[MIN_PHYSICAL_DAMAGE] *= 1 + getRitualAmp(RITUAL_PHYSICAL_DAMAGE) / 100.f;
  subStats[MAX_PHYSICAL_DAMAGE] *= 1 + getRitualAmp(RITUAL_PHYSICAL_DAMAGE) / 100.f;
  
  // Armor
  subStats[ARMOR_RATING] += getRitualAmp(RITUAL_ARMOR);
}

/*============================================================================= 
 * getRitualAmp()
 *
 * Returns the full amplitude as the product of ritual level and boost level.
 *===========================================================================*/
public function float getRitualAmp(RitualTypes ritualType) {
  local int lvl; lvl = ritualStatBoosts[ritualType];
  
  return lvl * class'ROTT_Descriptor_Rituals'.static.getRitualBoost(ritualType);
}

/*============================================================================= 
 * updateStrength()
 *
 * Updates Strength, and related substats
 *===========================================================================*/
public function updateStrength(int strength, int affinityCut, float scorpionTalon) {
  local float dmgAmp;
  
  // Apply affinity cut to strength 
  strength += strength / affinityCut;
  
  // Calculate base damages
  subStats[MIN_PHYSICAL_DAMAGE] = strength / 2 + baseMinDamage;
  ///subStats[MAX_PHYSICAL_DAMAGE] = (1 + (strength * 3) / 4) + baseMaxDamage;
  subStats[MAX_PHYSICAL_DAMAGE] = (1 + (strength * 4) / 3) + baseMaxDamage;
  
  // Add temporary combat boosts
  subStats[MIN_PHYSICAL_DAMAGE] += statBoosts[ADD_MIN_PHYS_DAMAGE];
  subStats[MAX_PHYSICAL_DAMAGE] += statBoosts[ADD_MAX_PHYS_DAMAGE];
  
  // Add passive boosts
  subStats[MIN_PHYSICAL_DAMAGE] += getPassiveBoost(PASSIVE_ADD_PHYSICAL_MIN);
  subStats[MAX_PHYSICAL_DAMAGE] += getPassiveBoost(PASSIVE_ADD_PHYSICAL_MAX);
  
  // Add held item boosts
  if (heldItem != none) {
    subStats[MIN_PHYSICAL_DAMAGE] += heldItem.itemStats[ITEM_ADD_PHYSICAL_MIN];
    subStats[MAX_PHYSICAL_DAMAGE] += heldItem.itemStats[ITEM_ADD_PHYSICAL_MAX];
  }
  
  // Multipliers for physical damage
  dmgAmp = 1;
  dmgAmp += scorpionTalon;
  subStats[MIN_PHYSICAL_DAMAGE] *= dmgAmp;
  subStats[MAX_PHYSICAL_DAMAGE] *= dmgAmp;
}

/*=============================================================================
 * onDeath()
 *
 * This function is called when the unit dies
 *===========================================================================*/
protected function onDeath() {
  // Bypass through cheats
  if (gameInfo.playerProfile.cheatInvincibility) return;
  
  // Normal death routine
  super.onDeath();
  
  // Notify party of death, to check for gameover conditions and such
  gameInfo.getActiveParty().onDeath();
  
  // Status update
  uiComponent.removeAllStatus();
  if (getMasteryLevel(MASTERY_RESURRECT) > 0) {
    uiComponent.addStatus(ROTT_Descriptor_Hero_Skill(getMasteryScript(MASTERY_RESURRECT)));
  }
  
  // Remove equipment and move to inventory
  if (gameInfo.playerProfile.gameMode == MODE_HARDCORE) {
    gameInfo.playerProfile.playerInventory.addItem(unequipItem());
  }
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_COMBAT_HERO_DEATH);
}

/*=============================================================================
 * getPartySize()
 *
 * This function initializes the hero class
 *===========================================================================*/
public function int getPartySize() {
  return ROTT_Party(outer).getPartySize();
}

/*=============================================================================
 * selectAction()
 *
 * This allows the action panel to select a move to make later on through
 * targeting
 *===========================================================================*/
public function selectAction(CombActEnum selection) {
  actionType = selection;
}

/*=============================================================================
 * manaSufficient()
 *
 * This checks mana cost for the selected action
 *===========================================================================*/
public function bool manaSufficient() {
  local ROTT_Descriptor_Hero_Skill selectedScript;
  local int skillLvl;
  
  // Bypass mana cheat
  if (gameInfo.playerProfile.cheatManaSkip) return true;
  
  // Bypass for persistence
  if (persistenceCount > 0) return true;
  
  // Get script
  switch (actionType) {
    case ATTACK:            selectedScript = attackAbility;       break;
    case DEFEND:            selectedScript = defendAbility;       break;
    case PRIMARY_SKILL:     selectedScript = primaryScript;       break;
    case SECONDARY_SKILL:   selectedScript = secondaryScript;     break;
  }
  
  // Get level
  skillLvl = getActionLevel(actionType);
  
  // Check mana
  if (subStats[CURRENT_MANA] < selectedScript.getAttributeInfo(MANA_COST, self, skillLvl)) {
    return false;
  }
  
  return true;
}

/*=============================================================================
 * glyphSufficient()
 *
 * This checks if a glyph is required, and if a glyph is accumulated
 *===========================================================================*/
public function bool glyphSufficient() {
  local ROTT_Descriptor_Hero_Skill selectedScript;
  local int glyphsRequired;
  local int skillLvl;
  
  // Bypass mana cheat
  if (gameInfo.playerProfile.cheatManaSkip) return true;
  
  // Get script
  switch (actionType) {
    case ATTACK:            selectedScript = attackAbility;       break;
    case DEFEND:            selectedScript = defendAbility;       break;
    case PRIMARY_SKILL:     selectedScript = primaryScript;       break;
    case SECONDARY_SKILL:   selectedScript = secondaryScript;     break;
  }
  
  skillLvl = getActionLevel(actionType);
  glyphsRequired = int(selectedScript.getAttributeInfo(REQUIRES_GLYPH, self, skillLvl));
  
  return (selectedScript.glyphCount >= glyphsRequired);
}

/*=============================================================================
 * getTotalGlyphCount()
 *
 * This returns the total number of glyphs obtained during battle for analysis
 *===========================================================================*/
public function int getTotalGlyphCount() {
  local int total;
  local int i;
  
  for (i = 0; i < GlyphSkills.enumCount; i++) {
    total += totalGlyphCollection[i];
  }
  
  return total;
}

/*=============================================================================
 * getTargetingStyle()
 *
 * This returns the targeting mode for whatever skill is selected
 *===========================================================================*/
public function TargetingClassification getTargetingStyle() {
  local ROTT_Descriptor_Hero_Skill selectedScript;
  
  // Get script for selected action
  switch (actionType) {
    case ATTACK:            selectedScript = attackAbility;       break;
    case DEFEND:            selectedScript = defendAbility;       break;
    case PRIMARY_SKILL:     selectedScript = primaryScript;       break;
    case SECONDARY_SKILL:   selectedScript = secondaryScript;     break;
  }
  
  return selectedScript.targetingLabel;
}

/*=============================================================================
 * getActionLevel()
 *
 * Returns a hardpoint skill level for a selected action type
 *===========================================================================*/
public function int getActionLevel(CombActEnum actType) {
  switch (actType) {
    case PRIMARY_SKILL:   return classSkillPts[primarySkill];
    case SECONDARY_SKILL: return classSkillPts[secondarySkill];
    default:
      return 0;
  }
}

/*=============================================================================
 * sendAction()
 *
 * Returns: true if sufficient mana, false otherwise
 *===========================================================================*/
public function bool sendAction(ChosenTargetEnum target) {
  local array<ROTT_Combat_Unit> targets;
  local ROTT_Party party;
  local ROTT_Mob mob;
  local bool bHit;
  local int i;
  
  // Get fighting parties
  mob = gameInfo.enemyEncounter;
  party = gameInfo.getActiveParty();
  
  // Mana check
  if (!manaSufficient()) {
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT); 
    return false;
  }
  
  // Get selected action
  switch (actionType) {
    case ATTACK:            selectedAction = attackAction;       break;
    case DEFEND:            selectedAction = defendAction;       break;
    case PRIMARY_SKILL:     selectedAction = primaryAction;      break;
    case SECONDARY_SKILL:   selectedAction = secondaryAction;    break;
  }
  
  // Store targets for persistence
  lastTarget = target;
  
  // Create target list
  switch (target) {
    case TARGET_HERO_1:   targets.addItem(party.getHero(0));  break;
    case TARGET_HERO_2:   targets.addItem(party.getHero(1));  break;
    case TARGET_HERO_3:   targets.addItem(party.getHero(2));  break;
    case TARGET_ALL_HEROES:  
      for (i = 0; i < 3; i++) {
        if (party.getHero(i) != none) {
          targets.addItem(party.getHero(i));
        }
      }
      break;
    case TARGET_ENEMY_1:   targets.addItem(mob.getEnemy(0));  break;
    case TARGET_ENEMY_2:   targets.addItem(mob.getEnemy(1));  break;
    case TARGET_ENEMY_3:   targets.addItem(mob.getEnemy(2));  break;
    case TARGET_ALL_ENEMIES: 
      for (i = 0; i < 3; i++) {
        if (mob.getEnemy(i) != none) {
          targets.addItem(mob.getEnemy(i));
        }
      }
      break;
    case TARGET_LAST_ATTACKER:  
      targets.addItem(autoTargetedUnit);
      break;
    case TARGET_ARENA:  
      /* to do ... */
      break;
    case TARGET_NONE:  
      /* to do ... */
      break;
  }
  
  /* to do ... remove dead units since they are invalid targets? */
  
  // Valid target check
  if (targets.length == 0) {
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT); 
    return false;
  }
  
  // Execute action on targets
  bHit = selectedAction(targets, self);  
  
  // Activate passive attack and defense scripts
  if (bHit) {
    switch (actionType) {
      case ATTACK:
        classSkillSet.onAttack(self, self);  // hm...
        glyphSkillSet.onAttack(self, self);
        masterySkillSet.onAttack(self, self);
        break;
      case DEFEND:      
        classSkillSet.onDefend(self, self);  // hmmmm.......
        glyphSkillSet.onDefend(self, self);  /// New ideas: create an array of 'active skill scripts' in battle prep
        masterySkillSet.onDefend(self, self); /// loop through active skill scripts and call on defend
        break;
    }
  }
  
  // Sound Effects
  if (bHit) {
    switch (actionType) {
      case ATTACK:          sfxBox.playSFX(attackAbility.combatSfx);   break;
      case DEFEND:          sfxBox.playSFX(defendAbility.combatSfx);   break;
      case PRIMARY_SKILL:   sfxBox.playSFX(primaryScript.combatSfx);   break;
      case SECONDARY_SKILL: sfxBox.playSFX(secondaryScript.combatSfx); break;
    }
  } else {
    sfxBox.playSFX(SFX_COMBAT_MISS);
  }
  
  // Store tool tip progress info
  switch (actionType) {
    case PRIMARY_SKILL:   
    case SECONDARY_SKILL: 
      gameInfo.playerProfile.bHasUsedSkill = true;
  }
  
  // Report action sent successfully
  return true;
}

/*=============================================================================
 * takeDamage()
 *
 * This is called after a damage value has been rolled, to impact the unit
 *===========================================================================*/
public function takeDamage
(
  int damage, 
  ROTT_Combat_Unit caster,
  optional float critAmp = 1.f,
  optional bool bAtmosphericDamage = false
) 
{
  super.takeDamage(damage, caster, critAmp, bAtmosphericDamage);
  
  if (damage == 0) return;
  
  // Stance tracking
  classSkillSet.onTakeDamage(caster, self);
  glyphSkillSet.onTakeDamage(caster, self);
  masterySkillSet.onTakeDamage(caster, self);
}

/*=============================================================================
 * onTargeted()
 *
 * Called when a combat action is being performed with this unit as target.
 *===========================================================================*/
public function onTargeted(ROTT_Combat_Unit caster) {
  classSkillSet.onTargeted(caster, self);
}

/*=============================================================================
 * trackDamageGlyph()
 *
 * Used to track how much damage has been added from damage glyphs
 *===========================================================================*/
public function trackDamageGlyph(float damage) {
  battleStatistics[ADDED_GLYPH_DAMAGE] += damage;
}

/*=============================================================================
 * getExpForLevel()
 *
 * Returns the amount of exp needed for the given level value
 *===========================================================================*/
public function int getExpForLevel(int lvl) {
  local int exp;
  if (lvl <= 1) return 0;
  
  // Approximate exp equation
  ///exp = int(FCeil(1.5 ** (lvl ** 0.9)) + (lvl ** 4.2) + (300 * lvl) - 521);
  ///exp = int(FCeil(1.5 ** (lvl ** 0.9)) + (lvl ** 3.3) + (355 * lvl) - 622);
  exp = int(FCeil(1.5 ** (lvl ** 0.9)) + (lvl ** 3.6) + (345 * lvl) - 605);
  
  // Round by 5:
  exp /= 5.0;
  exp = FCeil(exp);
  exp *= 5.0;
  
  // Not sure if this equation is intentionally truncating 
  // with integer casts or not, im leaving it as it was designed
  return exp;
}

/*=============================================================================
 * getPreviousLvlExp()
 *
 * Returns the exp needed for previous level
 *===========================================================================*/
public function int getPreviousLvlExp() {
  return getExpForLevel(level);
}

/*=============================================================================
 * getNextLvlExp()
 *
 * Returns the exp needed for next level, includign animation factors
 *===========================================================================*/
public function int getNextLvlExp() {
  return getExpForLevel(level + 1);
}

/*=============================================================================
 * addExp()
 *
 * Adds experience to the hero
 *===========================================================================*/
public function addExp(int addedExp) {
  // Ignore on  hardcore mode
  if (bDead && gameInfo.playerProfile.gameMode == MODE_HARDCORE) return;
  
  // Exp animation
  pendingExp = addedExp;
  animatedExp = experience;
  expDestination = experience + addedExp;
}

/*=============================================================================
 * addExpByPercent()
 *
 * Adds a percentage of experience to the hero
 *===========================================================================*/
public function addExpByPercent(float expPercent) {
  // Handle percentage per level
  while (1 - getExpRatio() < expPercent) {
    // Track how much exp percent were adding
    expPercent -= 1 - getExpRatio();
    
    // Add just enough exp percent to level
    experience += (1 - getExpRatio()) * (getNextLvlExp() - getExpForLevel(level));
    
    // Exp should be enough for leveling up now
    levelUp();
  }
  
  // Add the remaining percentage of the exp bar
  experience += expPercent * (getNextLvlExp() - getExpForLevel(level));
}

/*=============================================================================
 * deathPenaltyExp()
 *
 * Subtracts experience as penalty for not surviving a battle
 *===========================================================================*/
public function deathPenaltyExp() {
  // Exp animation
  pendingExp = -1.0/8.f * (getPreviousLvlExp() - getNextLvlExp());
  animatedExp = experience;
  expDestination = experience + pendingExp;
}

/*=============================================================================
 * startExpAnim()
 *
 * Starts an exp lerp
 *===========================================================================*/
public function startExpAnim() {
  // Ignore on  hardcore mode
  if (bDead && gameInfo.playerProfile.gameMode == MODE_HARDCORE) return;
  
  // Exp animation
  elapsedExpTime = 0;
  bAnimateExp = true;
}

/*=============================================================================
 * skipExpAnim()
 *
 * Skips all exp animation
 *===========================================================================*/
public function skipExpAnim() {
  // Exp animation
  pendingExp = 0;
  elapsedExpTime = 0;
  experience = expDestination;
  bAnimateExp = false;
  bPrepExp = false;
  
  // Check for level up(s) 
  do {} until (levelUp() == false);
}

/*=============================================================================
 * getScreenExp()
 *
 * Retrieves a "fake" exp value for animation purposes
 *===========================================================================*/
public function float getScreenExp() {
  return (bPrepExp) ? animatedExp : experience;
}

/*=============================================================================
 * hasUnspentPoints()
 *
 * Returns true if there are unspent skill points or stat points
 *===========================================================================*/
public function bool hasUnspentPoints() {
  return (unspentSkillPoints + unspentStatPoints != 0);
}

/*=============================================================================
 * investStats()
 *
 * Invests some unspent stat points into one of the primary stats
 *===========================================================================*/
public function investStats(int statPoints, StatTypes statType) {
  // Check for misuse for robustness
  if (unspentStatPoints < statPoints) { 
    yellowLog("Warning (!) bad stat invest request in investStats()");
    return;
  }
  
  // Move unspent points into the selected primary stat
  hardStats[statType] += statPoints;
  unspentStatPoints -= statPoints;
  
  // Update substats
  updateSubStats();
}

/*=============================================================================
 * investSkill()
 *
 * Invests an unspent skill point into one of the skill trees
 *===========================================================================*/
public function int investSkill(byte treeIndex, byte skillIndex) {
  local ROTT_Descriptor_Hero_Skill script;
  local float mana;
  
  // Check for insufficient skill points
  if (unspentSkillPoints < 1) { 
    return -1;
  }
  
  // Check for insufficient maximum mana
  switch (treeIndex) {
    case 0: 
      script = ROTT_Descriptor_Hero_Skill(getSkillScript(skillIndex));   
      break;
    case 1: 
      script = ROTT_Descriptor_Hero_Skill(getGlyphScript(skillIndex));   
      break;
    case 2: 
      script = ROTT_Descriptor_Hero_Skill(getMasteryScript(skillIndex)); 
      break;
  }
  
  // Store mana for next level use
  mana = script.getAttributeInfo(MANA_COST, self, script.getSkillLevel(self, true) + 1);
  
  // Check if next level uses too much mana
  if (subStats[MAX_MANA] < mana) {
    return -2;
  }
  
  // Check for insufficient stat requirements
  if (!script.statReqCheck(self)) {
    return -3;
  }
  
  // Invest skill point
  unspentSkillPoints--;
  switch (treeIndex) {
    case 0: classSkillPts[skillIndex]++;   break;
    case 1: glyphSkillPts[skillIndex]++;   break;
    case 2: masterySkillPts[skillIndex]++; break;
  }
  
  // Update substats
  updateSubStats();
  
  return 0;
}

/*=============================================================================
 * removeStat()
 *
 * Removes a point from a stat, if possible.  Returns false if operation fails.
 *===========================================================================*/
public function bool removeStat(StatTypes statType) {
  // Check for valid stat removal
  if (hardStats[statType] <= 1) return false;
  
  // Check for sufficient currency
  if (gameInfo.canDeductCosts(gameInfo.getResetStatCost())) {
    // Deduct cost
    gameInfo.deductCosts(gameInfo.getResetStatCost());
  } else {
    // Exit if insufficient currencies
    return false;
  }
  
  // Move unspent points into the selected primary stat
  hardStats[statType] -= 1;
  unspentStatPoints++;
  
  // Update substats
  updateSubStats();
  
  return true;
}

/*=============================================================================
 * checkBlessingCap()
 *
 * Returns true if room for more blessings
 *===========================================================================*/
public function bool checkBlessingCap() {
  // Ignore cap after 20
  if (level >= 20) return true;
  
  // One per level cap
  return (blessingCount < level);
}

/*=============================================================================
 * blessStat()
 *
 * Attempts to add a blessed stat point.  Returns false on failure.
 *===========================================================================*/
public function int blessStat(StatTypes statType) {
  // Exit if blessings are maxed
  if (!checkBlessingCap()) return -2;

  // Check for sufficient currency
  if (gameInfo.canDeductCosts(gameInfo.getBlessingCost())) {
    // Deduct cost
    gameInfo.deductCosts(gameInfo.getBlessingCost());
  } else {
    // Exit if insufficient currencies
    return -1;
  }
  
  // Allocate blessings
  hardStats[statType] += 1;
  blessingCount++;
  
  // Update substats
  updateSubStats();
  
  return 0;
}

/*=============================================================================
 * shrineRitual()
 *
 * Performs a ritual that exchanges items for stat boosts. 
 *===========================================================================*/
public function bool shrineRitual(RitualTypes ritualType) {
  local array<ItemCost> shrineCost;
  
  // Get shrine cost
  shrineCost = class'ROTT_Descriptor_Rituals'.static.getRitualCost(ritualType);
  
  // Check for sufficient ritual items
  if (gameInfo.canDeductCosts(shrineCost)) {
    // Deduct cost
    gameInfo.deductCosts(shrineCost);
  } else {
    // Exit if insufficient currencies
    return false;
  }
  
  // Count ritual
  ritualStatBoosts[ritualType] += 1;
  
  // Provide permanent boost
  switch (ritualType) {
    case RITUAL_EXPERIENCE_BOOST:
      addExpByPercent(1 / 8.f);
      break;
    case RITUAL_SKILL_POINT:
      unspentSkillPoints++;
      break;
  }
  
  // Update substats
  updateSubStats();
  
  return true;
}

/*=============================================================================
 * removeSkillPoint()
 *
 * Removes a skill point, if possible.  Returns false if operation fails.
 *===========================================================================*/
public function bool removeSkillPoint(byte treeIndex, byte skillIndex) {
  
  // Check for valid skill removal
  switch (treeIndex) {
    case 0: 
      if (skillIndex == primarySkill && classSkillPts[primarySkill] == 1) {
        return false;
      }
      if (skillIndex == secondarySkill && classSkillPts[secondarySkill] == 1) {
        return false;
      }
      if (classSkillPts[skillIndex] == 0) return false;
      break;
    case 1: 
      if (skillIndex == GLYPH_TREE_HEALTH && glyphSkillPts[GLYPH_TREE_HEALTH] == 1) {
        return false;
      }
      if (glyphSkillPts[skillIndex] == 0) return false;
      break;
    case 2:
      if (masterySkillPts[skillIndex] == 0) return false;
      break;
  }
  
  // Check for sufficient currency
  if (gameInfo.canDeductCosts(gameInfo.getResetSkillCost())) {
    // Deduct cost
    gameInfo.deductCosts(gameInfo.getResetSkillCost());
  } else {
    // Exit if insufficient currencies
    return false;
  }
  
  // Free up the skill point
  switch (treeIndex) {
    case 0: classSkillPts[skillIndex]--;   break;
    case 1: glyphSkillPts[skillIndex]--;   break;
    case 2: masterySkillPts[skillIndex]--; break;
  }
  unspentSkillPoints++;
  
  // Update substats
  updateSubStats();
  
  return true;
}

/*=============================================================================
 * setPrimary()
 *
 * Assigns a skill to be the primary skill
 *===========================================================================*/
public function bool setPrimary(int skillIndex) {
  // Check if swapping primary with secondary
  if (skillIndex == secondarySkill) {
    // Swap skill indices
    secondarySkill = primarySkill;
    primarySkill = skillIndex;
    
    // Set skill scripts
    updateSkillScripts();
    return true;
  }
  
  // Check if skill points invested
  if (classSkillPts[skillIndex] > 0) { 
    primarySkill = skillIndex;
    
    // Set skill scripts
    updateSkillScripts();
    return true;
  }
  
  return false;
}

/*=============================================================================
 * setSecondary()
 *
 * Assigns a skill to be the secondary skill
 *===========================================================================*/
public function bool setSecondary(int skillIndex) {
  // Check if swapping primary with secondary
  if (skillIndex == primarySkill) {
    primarySkill = secondarySkill;
    secondarySkill = skillIndex;
    
    // Set skill scripts
    updateSkillScripts();
    return true;
  }
  
  // Check if skill points invested
  if (classSkillPts[skillIndex] > 0) { 
    secondarySkill = skillIndex;
    
    // Set skill scripts
    updateSkillScripts();
    return true;
  }
  
  return false;
}

/*=============================================================================
 * getHealthRatio()
 *
 * Returns a percentage to represent the units current health
 *===========================================================================*/
public function float getHealthRatio() {
  return super.getHealthRatio();
}

/*=============================================================================
 * getManaRatio()
 *
 * Returns a percentage to represent the units current mana
 *===========================================================================*/
public function float getManaRatio() {
  return super.getManaRatio();
}

/*=============================================================================
 * getExpRatio()
 *
 * Returns a percentage to represent the units current exp
 *===========================================================================*/
public function float getExpRatio() {
  local float screenExp;
  local float expRatio;
  local float numerator, denominator;
  
  // Get exp
  screenExp = (bPrepExp) ? animatedExp : experience;
  
  // Get exp info
  numerator = screenExp - getPreviousLvlExp();
  denominator = nextLvlExp - getPreviousLvlExp();
  
  // No division by zero
  if (denominator == 0) return 0;  
  
  // Calculate ratio
  expRatio = numerator / denominator;
  
  return expRatio;
}

/*=============================================================================
 * levelUp()
 *
 * This will level up the character if they have enough exp.
 * Returns true if another level up is needed, false otherwise. 
 *===========================================================================*/
private function bool levelUp() {
  // Check for sufficient experience
  if (experience < nextLvlExp) return false;
  
  // Grant level up results
  unspentStatPoints += STATS_PER_LEVEL;
  unspentSkillPoints += SKILL_POINTS_PER_LEVEL;
  level++;
  nextLvlExp = getExpForLevel(level + 1);
  
  // Calculate the resulting substats
  updateSubStats();
  
  // Queue sfx
  if (gameInfo.sceneManager.scene == gameInfo.sceneManager.sceneCombatResults) {
    gameInfo.sceneManager.sceneCombatResults.pageCombatVictory.playLvlUpSfx = true;
    whitelog("---");
    cyanlog("queue levelup sfx effects");
  }
  
  return (experience >= nextLvlExp);
}

/*=============================================================================
 * getChanceToHit()
 *
 * Given a target, this randomly rolls a hit chance and returns true if hit.
 *===========================================================================*/
public function bool getChanceToHit(ROTT_Combat_Unit target) {
  local bool result;
  
  result = super.getChanceToHit(target);
  
  // Analysis tracking
  if (ROTT_Combat_Enemy(target) != none) {
    if (result == true) {
      battleStatistics[OUTGOING_HITS] += 1;
    } else {
      battleStatistics[OUTGOING_MISSES] += 1;
    }
  }
  
  return result;
}

/*=============================================================================
 * decrementStanceSteps()
 *
 * This function is called to reduce all stances by one step
 *===========================================================================*/
private function decrementStanceSteps() {
  // Stance tracking
  classSkillSet.decrementSteps(self);
  glyphSkillSet.decrementSteps(self);
  masterySkillSet.decrementSteps(self);
  
  // More stance tracking
  if (attackAbility.stanceCount > 0) attackAbility.modifyStanceSteps(self, -1);
  if (defendAbility.stanceCount > 0) defendAbility.modifyStanceSteps(self, -1);
}

/*=============================================================================
 * resetTuna()
 *
 * This function resets the attack time bar after using a combat action
 *===========================================================================*/
public function resetTuna() {
  // Remove a stance step counter
  decrementStanceSteps();
  
  // Reset time until next attack
  super.resetTuna();
  
  // Scale attack time by party size
  currentAtkInterval *= getPartySize();
}

/*=============================================================================
 * glyphToSkillIndex()
 *
 * Given a glyph ID, a skill tree index is returned
 *===========================================================================*/
public function int glyphToSkillIndex(GlyphEnum glyph) {
  switch (glyph) {
    // Tree skill indexing
    case GLYPH_ARMOR:                 return GLYPH_TREE_ARMOR;
    case GLYPH_HEALTH:                return GLYPH_TREE_HEALTH;
    case GLYPH_MANA:                  return GLYPH_TREE_MANA;
    case GLYPH_DAMAGE:                return GLYPH_TREE_DAMAGE;
    case GLYPH_SPEED:                 return GLYPH_TREE_SPEED;
    case GLYPH_MANA_REGAIN:           return GLYPH_TREE_MP_REGEN;
    case GLYPH_ACCURACY:              return GLYPH_TREE_ACCURACY;
    case GLYPH_DODGE:                 return GLYPH_TREE_DODGE;
    
    // Class skill indexing
    case GLYPH_GOLIATH_COUNTER:       return GOLIATH_COUNTER_GLYPHS;
    case GLYPH_WIZARD_SPECTRAL_SURGE: return WIZARD_SPECTRAL_SURGE;
    case GLYPH_VALKYRIE_RETALIATION:  return VALKYRIE_VOLT_RETALIATION;
    case GLYPH_TITAN_STORM:           return TITAN_ICE_STORM;
  }
}

/*=============================================================================
 * consumeGlyph()
 *
 * Called when a glyph is collected during combat.  Provides benefits based on
 * each heroes skill level.
 *===========================================================================*/
public function consumeGlyph(GlyphEnum glyph, optional bool classGlyph = false) {
  //local int displayValue; // Displays a relevant glyph value (e.g. health gainted)
  local ROTT_Descriptor_Hero_Skill script;
  local array<ROTT_Combat_Unit> targets;
  local int skillIndex;
  local int i;
  
  // Filter for class specific glyphs
  switch (glyph) {
    case GLYPH_GOLIATH_COUNTER:       
      if (myClass != GOLIATH) return; 
      break;
    case GLYPH_WIZARD_SPECTRAL_SURGE: 
      if (myClass != WIZARD) return; 
      break;
    case GLYPH_VALKYRIE_RETALIATION:  
      if (myClass != VALKYRIE) return; 
      break;
    case GLYPH_TITAN_STORM:           
      if (myClass != TITAN) return; 
      break;
  }
  
  // Get skill index for skill tree access
  skillIndex = glyphToSkillIndex(glyph);
  
  // Get skill descriptor
  if (classGlyph) {
    script = ROTT_Descriptor_Hero_Skill(getSkillScript(skillIndex));
  } else {
    script = ROTT_Descriptor_Hero_Skill(getGlyphScript(skillIndex));
  }
  
  // Statistics tracking
  activeGlyphCollection[glyph] += 1;
  totalGlyphCollection[glyphToSkillIndex(glyph)] += 1;
  
  // Apply glyph mechanics
  targets.addItem(self);
  script.skillAction(
    targets,
    self,
    GLYPH_SET
  );
  
  // Send action set to enemies
  targets.length = 0;
  for (i = 0; i < 3; i++) {
    if (gameInfo.enemyEncounter.getEnemy(i) != none) {
      targets.addItem(gameInfo.enemyEncounter.getEnemy(i));
    }
  }
  if (
    script.skillAction(
      targets,
      self,
      GLYPH_ACTION_SET 
    )
  ) sfxBox.playSFX(script.secondarySfx);
}

/*=============================================================================
 * getGlyphChance()
 *
 * Returns the chance of the given glyph to spawn in the grid
 *===========================================================================*/
public function int getGlyphChance(GlyphEnum glyph) {
  local ROTT_Descriptor_Hero_Skill script;
  local int requiredCount;
  local int skillIndex;
  local int skillLvl;
  
  if (bDead && glyph != GLYPH_HEALTH) return 0;
  
  skillIndex = glyphToSkillIndex(glyph);
  
  // Check for skill class combatability
  switch (glyph) {
    case GLYPH_GOLIATH_COUNTER:
      if (myClass != GOLIATH)  return 0; 
      break;
    case GLYPH_WIZARD_SPECTRAL_SURGE: 
      if (myClass != WIZARD)   return 0; 
      break;
    case GLYPH_VALKYRIE_RETALIATION:
      if (myClass != VALKYRIE) return 0; 
      break;
    case GLYPH_TITAN_STORM:
      if (myClass != TITAN)    return 0; 
      break;
  }
  
  // Get skill descriptor
  switch (glyph) {
    // Class skill indexing
    case GLYPH_GOLIATH_COUNTER:
    case GLYPH_WIZARD_SPECTRAL_SURGE:
    case GLYPH_VALKYRIE_RETALIATION:
    case GLYPH_TITAN_STORM:
      script = ROTT_Descriptor_Hero_Skill(getSkillScript(skillIndex));
      skillLvl = classSkillPts[skillIndex];
      break;
      
    // Tree skill indexing
    default:
      script = ROTT_Descriptor_Hero_Skill(getGlyphScript(skillIndex));
      skillLvl = glyphSkillPts[skillIndex];
      break;
  }
  
  // Return zero chance if no skill points invested
  if (skillLvl == 0) return 0;
  
  // Debug
  //greenlog(" Chance for " $ glyph $ " is "  $ script.getAttributeInfo(GLYPH_SPAWN_CHANCE, self, skillLvl));
  
  // Check for required cast count
  requiredCount = script.getAttributeInfo(REQUIRES_CAST_COUNT, self, skillLvl);
  if (script.castCount < requiredCount) return 0;
  
  // Return chance
  return script.getAttributeInfo(GLYPH_SPAWN_CHANCE, self, skillLvl);
}

/*=============================================================================
 * skillReset()
 *
 * Clears all battle variable info for this unit's skill sets.
 * Should be called before each battle.
 *===========================================================================*/
public function skillReset() {
  // Pass skill reset to skill trees
  classSkillSet.skillReset();
  glyphSkillSet.skillReset();
  masterySkillSet.skillReset();
  
  // Pass skill reset to defend skill
  defendAbility.skillReset();
}

/*=============================================================================
 * elapseExpTime()
 *
 * This function is called every tick from the victory page
 *===========================================================================*/
public function elapseExpTime(float deltaTime) {
  if (bAnimateExp) {
    elapsedExpTime += deltaTime;
    if (elapsedExpTime > 1) {
      bAnimateExp = false;
      bPrepExp = false;
      elapsedExpTime = 0;
    }
    animatedExp += pendingExp * deltaTime;
    experience = int(animatedExp);
  }
  
  // Check for level up(s) 
  do {} until (levelUp() == false);
}

/*=============================================================================
 * elapseTime()
 *
 * This function is called every tick.
 *===========================================================================*/
public function elapseTime(float deltaTime) {
  local float m, d;
  
  // Analysis tracking for total battle time
  battleStatistics[BATTLE_TIME] += deltaTime / gameInfo.gameSpeed;
  
  // Ignore time for dead units
  if (bDead) {
    // Track time while dead
    classSkillSet.onDeadTick(self, deltaTime); 
    glyphSkillSet.onDeadTick(self, deltaTime); 
    masterySkillSet.onDeadTick(self, deltaTime); 
    return;
  }
  
  super.elapseTime(deltaTime);
  
  // Call on tick skill mechanics
  classSkillSet.onTick(self, deltaTime); 
  glyphSkillSet.onTick(self, deltaTime); 
  masterySkillSet.onTick(self, deltaTime); 
  
  // Enchanted mana regen
  m = subStats[MANA_REGEN] * deltaTime;
  recoverMana(m, false, true);
  
  // Enchanted health regen
  m = subStats[HEALTH_REGEN] * deltaTime;
  d = subStats[MAX_HEALTH] - subStats[CURRENT_HEALTH];
  if (m > d) m = d;
  subStats[CURRENT_HEALTH] += m;
  
}

/*=============================================================================
 * transferHp()
 *
 * This transfers health for fusion, showing no UI feedback.
 *===========================================================================*/
public function transferHp(float changeValue) {
  subStats[CURRENT_HEALTH] += changeValue;
}

/*=============================================================================
 * transferMp()
 *
 * This transfers mana for fusion, showing no UI feedback.
 *===========================================================================*/
public function transferMp(float changeValue) {
  subStats[CURRENT_MANA] += changeValue;
}

/*=============================================================================
 * alwaysDefendMode
 *
 * Returns true if option to always defend has been set.
 *===========================================================================*/
protected function bool alwaysDefendMode() {
  // Check options cookie based on what slot the hero is in
  switch (partyIndex) {
    case 0: return gameInfo.optionsCookie.bAlwaysDefendHero1;
    case 1: return gameInfo.optionsCookie.bAlwaysDefendHero2;
    case 2: return gameInfo.optionsCookie.bAlwaysDefendHero3;
  }
  yellowLog("Warning (!) Always defend has unhandled party index");
  return false;
}

/*=============================================================================
 * attackTimeComplete
 *
 * Called when the attack time bar reaches its maximum
 *===========================================================================*/
protected function attackTimeComplete() {
  local CombActEnum temp;
  
  // Execute persistence
  if (bPersisting && persistenceCount == 0) bPersisting = false;
  if (persistenceCount > 0) {
    // Track number of pending persistence actions 
    persistenceCount--;
    
    // Repeat last action on same targets
    sendAction(getLastTarget());
    return;
  }
  
  // Check if in force defend mode
  if (alwaysDefendMode()) {
    actionType = DEFEND;
    switch (partyIndex) {
      case 0: sendAction(TARGET_HERO_1); break;
      case 1: sendAction(TARGET_HERO_2); break;
      case 2: sendAction(TARGET_HERO_3); break;
    }
    return;
  }
  
  // Check if in force attack mode
  if (bForceAttack) {
    // Look for a target if empty
    if (autoTargetedUnit == none || autoTargetedUnit.bDead) {
      autoTargetedUnit = gameInfo.enemyEncounter.getAnyEnemy();
    }
    
    // Check if a target was found
    if (autoTargetedUnit != none) {
      // Hacky override of selected action type
      temp = actionType;
      actionType = ATTACK;
      sendAction(TARGET_LAST_ATTACKER);
      actionType = temp;
    } else {
      // All enemies are gone!
      bForceAttack = false;
    }
  } else {
    // Switch to ready mode
    bActionReady = true;
    
    // Add ready hero to queue
    ROTT_Party(outer).readyHero(self);
  }
}

/*=============================================================================
 * getLastTarget()
 *
 * Returns the last target or another suitable target if not found
 *===========================================================================*/
public function ChosenTargetEnum getLastTarget() {
  local ROTT_Mob mob;
  mob = gameInfo.enemyEncounter;
  
  // Check last target exists
  switch (lastTarget) {
    case TARGET_ENEMY_1: 
      // Check if target 1 exists
      if (mob.getEnemy(0) != none) {  
        return TARGET_ENEMY_1;
      } else {  
        // Try to switch target
        if (mob.getEnemy(1) != none) return TARGET_ENEMY_2; 
        if (mob.getEnemy(2) != none) return TARGET_ENEMY_3; 
        yellowLog("Warning (!) No enemy target found");
      }
      break;
    case TARGET_ENEMY_2: 
      // Check if target 1 exists
      if (mob.getEnemy(1) != none) {  
        return TARGET_ENEMY_2;
      } else {  
        // Try to switch target
        if (mob.getEnemy(0) != none) return TARGET_ENEMY_1; 
        if (mob.getEnemy(2) != none) return TARGET_ENEMY_3; 
        yellowLog("Warning (!) No enemy target found");
      }
      break;
    case TARGET_ENEMY_3: 
      // Check if target 1 exists
      if (mob.getEnemy(2) != none) {  
        return TARGET_ENEMY_3;
      } else {  
        // Try to switch target
        if (mob.getEnemy(1) != none) return TARGET_ENEMY_2; 
        if (mob.getEnemy(0) != none) return TARGET_ENEMY_1; 
        yellowLog("Warning (!) No enemy target found");
      }
      break;
  }
  
  yellowLog("Warning (!) Last target was not an enemy, filter misused?");
  return lastTarget;
}

/*=============================================================================
 * getBlessingCost()
 *
 * Returns the cost for a stat blessing.  Each blessing costs 100 more than
 * the last.
 *===========================================================================*/
public function int getBlessingCost() {
  local float cost;
  
  // Per level cost
  cost = blessingCount * 250 + 250;
  
  // Cap blessing cost
  if (cost > 5000) return 5000;
  
  return cost;
}

/*=============================================================================
 * uiFormat()
 *
 * Returns a substat in a format for concise spaces
 *===========================================================================*/
public function string uiFormat(SubStatTypes targetStat) {
  // Abbreviate K = 1000, M = 1,000,000, etc
  return class'UI_Label'.static.abbreviate(
    string(int(subStats[targetStat]))
  );
}

/*=============================================================================
 * debugSkillPoints
 *===========================================================================*/
public function debugSkillPoints() {
  local int i;
  
  cyanLog("Class skill points");
  for (i = 0; i < 8; i++) {
    whitelog(" " $ i $ ": " $ classSkillPts[i]);
  }
  grayLog(" ");
  greenLog("Class skill points");
  for (i = 0; i < 8; i++) {
    whitelog(" " $ i $ ": " $ glyphSkillPts[i]);
  }
  
  grayLog(" ");
  darkGreenLog("Class skill points");
  for (i = 0; i < 9; i++) {
    whitelog(" " $ i $ ": " $ masterySkillPts[i]);
  }
  
  grayLog(" ");
}

/*=============================================================================
 * Hero Properties
 *===========================================================================*/
defaultProperties 
{
  // Glyph defaults
  glyphSkillPts[GLYPH_TREE_MANA]=1
  glyphSkillPts[GLYPH_TREE_HEALTH]=1
  
  // Base health
  baseHealth=40
  baseMana=40
  
  // Level 1 Primary stats
  hardStats[PRIMARY_VITALITY]=5
  hardStats[PRIMARY_STRENGTH]=5
  hardStats[PRIMARY_COURAGE]=5
  hardStats[PRIMARY_Focus]=5
}



















