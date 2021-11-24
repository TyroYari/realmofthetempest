/*=============================================================================
 * ROTT_Descriptor_Hero_Skill
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class consolodates all information pertaining to a given skill.  
 * 
 * Usage:
 *  Provides the UI with skill information (see: ROTT_UI_Page_Mgmt_Window)
 *  Defines combat action behavior (see: ___ ??? )
 *===========================================================================*/
  
class ROTT_Descriptor_Hero_Skill extends ROTT_Descriptor_Skill
dependsOn(ROTT_Game_Sfx)
abstract;

// Next level offset, used for showing next level info on UI 
const NEXT_LEVEL = 1;

// Maximum chance of persistence per persistence roll
const PERSISTENCE_LIMIT = 80;

// Maximum chance of lacerations per roll
const LACERATION_LIMIT = 80;

// Types of trees that this skill may belong to
enum TreeType {
  NO_TREE,
  CLASS_TREE,
  GLYPH_TREE,
  MASTERY_TREE,
  HYPER_TREE
};

// Assign the enumeration skill ID to this index
var protectedwrite int skillIndex;

// Tree that this skill belongs to
var protectedwrite TreeType parentTree;

// Store boost level for display
var protectedwrite int boostLevel;
  
// Classifications for targeting modes, for skill script UI
enum TargetingClassification {
  PASSIVE_PARTY_BUFF,
  
  MULTI_TARGET_ATTACK,
  MULTI_TARGET_DEBUFF,
  MULTI_TARGET_BUFF,
  MULTI_TARGET_AURA,
  
  SINGLE_TARGET_ATTACK,
  SINGLE_TARGET_BUFF,
  SINGLE_TARGET_DEBUFF,
  
  SELF_TARGET_BUFF,
  
  PASSIVE_ATTACK_PERK,
  PASSIVE_DEFEND_PERK,
  COLLECTIBLE_GLYPH
};

var protectedwrite TargetingClassification targetingLabel;

// Combat mechanic return types (The return value is cast into this type)
// Using 'union' would have been cool here if this was C code
enum ReturnTypes {
  INTEGER,
  DECIMAL,
  COMBAT_STRING
};

// Sets of attributes to execute at different times
enum AttributeSets {
  COMBAT_ACTION_SET,
  PASSIVE_SET,
  PASSIVE_PARTY_SET,
  ATMOSPHERIC_SET,
  GLYPH_SET,
  GLYPH_ACTION_SET,
  TAKE_DAMAGE_SET,
  TARGETED_SET,
  ADD_STANCE_SET,
  REMOVE_STANCE_SET,
  ON_ATTACK_SET,
  ON_DEFEND_SET,
  ON_DEFEND_PARTY_SET,
  ON_TICK_SET,
  QUEUED_ACTION_SET,
  
  INACTIVE_SET
};

// Skill Mechanic Attribute
struct SkillMechanic {
  var AttributeSets attributeSet;
  var AttributeTypes mechanicType;
  var ReturnTypes returnType;
  var string tag;
  var FontStyles font;
};

// List of Skill Mechanic Attributes
var protectedwrite instanced array<SkillMechanic> skillAttributes;

// Skill information template, used to generate p2 and p3
var protected string skillText[3];

// Skill display information
struct SkillInfoSet {
  var string currentText;
  var string nextLvlText;
  var string previousLvlText;
  var FontStyles topFont;
  var FontStyles bottomFont;
};

// Cache last hero reference for refresh
var private ROTT_Combat_Hero lastHeroAccessed;

// Store secondary effect script
var private int secondaryScriptIndex;

// Skill display information, generated from skillText and replaceCodes()
var protected SkillInfoSet skillInfoData[3];
var protectedwrite UI_Texture_Storage skillIcon;
var protectedwrite UI_Texture_Storage skillAnim;
var protectedwrite UI_Texture_Storage altSkillAnim;

// Sound effect
var protectedwrite SoundEffectsEnum combatSfx;
var protectedwrite SoundEffectsEnum secondarySfx;

// Mechanic variables
var privatewrite int castCount;
var privatewrite int glyphCount;
var privatewrite int stanceCount;

// Skill mana pool
var privatewrite float manaPool;

// Status label for when a "stance" is added
var public string statusTag;
var public FontStyles statusColor;

// Used to show previous skill level during reset
var public bool bShowPrevious;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function initialize() {
  linkReferences();
  setUI();
}

/*=============================================================================
 * setUI()
 *
 * this function sets headers and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "DEFAULT HEADER",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "",
    "",
    "",
  );
  
  // Set skill information
  skillInfo(
    "", 
    "",
    ""
  );
}

/*=============================================================================
 * initUI()
 *
 * this function should be called at the same time as initialize() but remains
 * separate so that the template above can be overriden without super calls
 *===========================================================================*/
public function initUI() {
  // Skill Icon
  if (skillIcon != none) {
    skillIcon.initializeComponent();
  }
  // Skill animation
  if (skillAnim != none) {
    skillAnim.initializeComponent();
  }
  // Alt skill animation
  if (altSkillAnim != none) {
    altSkillAnim.initializeComponent();
  }
}

/*=============================================================================
 * refresh()
 *
 * Called when investing skill points to refresh new data for the same hero
 *===========================================================================*/
public function refresh() {
  formatScript(lastHeroAccessed);
}

/*=============================================================================
 * p2()
 *
 * Allows the descriptor to be edited in a clean format
 *===========================================================================*/
///protected function p2
///(
///  string text1, 
///  string text2, 
///  string text3, 
///  string text4, 
///  optional FontStyles font = DEFAULT_SMALL_WHITE
///) 
///{
///  super.p2(text1, text2, text3, text4, font);
///  
///  
///}
///
/*=============================================================================
 * setShowPrevious()
 *
 * 
 *===========================================================================*/
public function setShowPrevious(bool bEnabled) {
  bShowPrevious = bEnabled;
  
  formatScript(lastHeroAccessed);
}

/*=============================================================================
 * formatScript()
 *
 * This must be called when the script is accessed from the descriptor list
 * container.  It updates p2 and p3 based on hero information.
 *===========================================================================*/
public function formatScript(ROTT_Combat_Hero hero) {
  local int skillLevel;
  
  // Cache hero
  lastHeroAccessed = hero;
  
  // Get skill level
  skillLevel = getSkillLevel(hero);
  
  // Store boost level for display
  switch (parentTree) {
    case CLASS_TREE:
      boostLevel = hero.getClassLevelBoost(skillIndex);
      break;
    case GLYPH_TREE:
      boostLevel = hero.getGlyphLevelBoost(skillIndex);
      break;
  }
  
  // Prepare skill info based on skill level
  skillInfoData[0] = replaceCodes(skillText[0], skillLevel);
  skillInfoData[1] = replaceCodes(skillText[1], skillLevel);
  skillInfoData[2] = replaceCodes(skillText[2], skillLevel);
  
  // Set hyper text
  switch(parentTree) {
    case HYPER_TREE:
      // Chance info in 2nd paragraph 
      p2(
        "Maximum chance to hyper spawn is 80%,",
        "but increasing over this cap produces",
        "a multiplier for higher effects.",
        ""
      );
      
      // Override colors of p2
      skillInfoData[0].topFont = DEFAULT_SMALL_WHITE;
      skillInfoData[1].topFont = DEFAULT_SMALL_WHITE;
      skillInfoData[2].topFont = DEFAULT_SMALL_WHITE;
      
      // Chance and effect intensity info 
      p3(
        "Shrine Level: " $ skillLevel,
        skillInfoData[0].currentText,
        skillInfoData[1].currentText,
        skillInfoData[2].currentText
      );
      break;
    default:
      // Format display info
      if (skillLevel == 0) {
        // p2 holds current skill level info, which is empty if skill level is 0
        p2(
          "",
          "",
          "",
          ""
        );
        
        if (bShowPrevious) {
          // Top alignment for reseting skills
          p2(
            "No Level",
            "",
            "",
            ""
          );
          p3(
            "",
            "",
            "",
            ""
          );
        } else {
          
          p2(
            "",
            "",
            "",
            ""
          );
          
          // p3 holds next skill level info, which the first level in this case
          p3(
            "First Level",
            skillInfoData[0].nextLvlText,
            skillInfoData[1].nextLvlText,
            skillInfoData[2].nextLvlText
          );
        }
        
      } else {
        // p2 holds current skill level info
        p2(
          "Skill Level: " $ skillLevel + boostLevel,
          skillInfoData[0].currentText,
          skillInfoData[1].currentText,
          skillInfoData[2].currentText
        );
        
        // p3 holds next (or previous) skill level info
        if (bShowPrevious) {
          // Show previous level info for skill reset
          if (skillLevel == 1) {
            p3(
              "",
              "",
              "",
              ""
            );

          } else {
            p3(
              "Skill Level: " $ skillLevel + boostLevel - 1,
              skillInfoData[0].previousLvlText,
              skillInfoData[1].previousLvlText,
              skillInfoData[2].previousLvlText
            );
          }
        } else {
          // Show next level preview
          p3(
            "Next Level",
            skillInfoData[0].nextLvlText,
            skillInfoData[1].nextLvlText,
            skillInfoData[2].nextLvlText
          );
        }
      }
  }
  
  // Assign font colors
  displayInfo[PARAGRAPH_2_LINE_2].labelFont = skillInfoData[0].topFont;
  displayInfo[PARAGRAPH_2_LINE_3].labelFont = skillInfoData[1].topFont;
  displayInfo[PARAGRAPH_2_LINE_4].labelFont = skillInfoData[2].topFont;
  
  displayInfo[PARAGRAPH_3_LINE_2].labelFont = skillInfoData[0].bottomFont;
  displayInfo[PARAGRAPH_3_LINE_3].labelFont = skillInfoData[1].bottomFont;
  displayInfo[PARAGRAPH_3_LINE_4].labelFont = skillInfoData[2].bottomFont;
  
}

/*=============================================================================
 * skillInfo()
 *
 * this function sets text that describes the skill, used for p2 and p3
 *===========================================================================*/
final protected function skillInfo
(
  string text1,
  string text2,
  string text3
)
{
  skillText[0] = text1;
  skillText[1] = text2;
  skillText[2] = text3;
}

/*=============================================================================
 * replaceCodes()
 *
 * this function finds and replaces different "replacement codes" denoted by %
 *===========================================================================*/
private function SkillInfoSet replaceCodes
(
  string textInfo, 
  int skillLevel
)
{
  local ROTT_Combat_Hero hero;
  local SkillInfoSet returnInfo;
  local int i;
  
  // Get hero attached to skill
  hero = ROTT_Combat_Hero(outer.outer);
  if (hero == none) {
    // Used to ensure hero info for hyper glyph formatting
    hero = lastHeroAccessed;
  }
  
  // Set up replacement info
  returnInfo.currentText = textInfo;
  returnInfo.nextLvlText = textInfo;
  returnInfo.previousLvlText = textInfo;
  
  // Perform all replacements based on skill attributes and hero info
  for (i = 0; i < skillAttributes.length; i++) {
    // Search for the replacement code in the string
    if (inStr(textInfo, skillAttributes[i].tag) != -1) {
      returnInfo.currentText = formatCodes(
        skillAttributes[i].mechanicType,
        hero,
        skillLevel,
        skillAttributes[i].tag,
        skillAttributes[i].returnType,
        returnInfo.currentText
      );
      returnInfo.nextLvlText = formatCodes(
        skillAttributes[i].mechanicType,
        hero,
        skillLevel + 1,
        skillAttributes[i].tag,
        skillAttributes[i].returnType,
        returnInfo.nextLvlText
      );
      returnInfo.previousLvlText = formatCodes(
        skillAttributes[i].mechanicType,
        hero,
        skillLevel - 1,
        skillAttributes[i].tag,
        skillAttributes[i].returnType,
        returnInfo.previousLvlText
      );
      
      // Assign a font color
      switch (skillAttributes[i].mechanicType) { /* to do ... clean up? */
        case MASTERY_REQ_VITALITY:
          if (hero.getPrimaryStat(PRIMARY_VITALITY) < getAttributeInfo(MASTERY_REQ_VITALITY, hero, getSkillLevel(hero))) {
            returnInfo.topFont = DEFAULT_SMALL_RED;
          } else {
            returnInfo.topFont = DEFAULT_SMALL_WHITE;
          }
          if (hero.getPrimaryStat(PRIMARY_VITALITY) < getAttributeInfo(MASTERY_REQ_VITALITY, hero, getSkillLevel(hero) + 1)) {
            returnInfo.bottomFont = DEFAULT_SMALL_RED;
          } else {
            returnInfo.bottomFont = DEFAULT_SMALL_WHITE;
          }
          break;
        case MASTERY_REQ_STRENGTH:
          if (hero.getPrimaryStat(PRIMARY_STRENGTH) < getAttributeInfo(MASTERY_REQ_STRENGTH, hero, getSkillLevel(hero))) {
            returnInfo.topFont = DEFAULT_SMALL_RED;
          } else {
            returnInfo.topFont = DEFAULT_SMALL_WHITE;
          }
          if (hero.getPrimaryStat(PRIMARY_STRENGTH) < getAttributeInfo(MASTERY_REQ_STRENGTH, hero, getSkillLevel(hero) + 1)) {
            returnInfo.bottomFont = DEFAULT_SMALL_RED;
          } else {
            returnInfo.bottomFont = DEFAULT_SMALL_WHITE;
          }
          break;
        case MASTERY_REQ_COURAGE:
          if (hero.getPrimaryStat(PRIMARY_COURAGE) < getAttributeInfo(MASTERY_REQ_COURAGE, hero, getSkillLevel(hero))) {
            returnInfo.topFont = DEFAULT_SMALL_RED;
          } else {
            returnInfo.topFont = DEFAULT_SMALL_WHITE;
          }
          if (hero.getPrimaryStat(PRIMARY_COURAGE) < getAttributeInfo(MASTERY_REQ_COURAGE, hero, getSkillLevel(hero) + 1)) {
            returnInfo.bottomFont = DEFAULT_SMALL_RED;
          } else {
            returnInfo.bottomFont = DEFAULT_SMALL_WHITE;
          }
          break;
        case MASTERY_REQ_FOCUS:
          if (hero.getPrimaryStat(PRIMARY_FOCUS) < getAttributeInfo(MASTERY_REQ_FOCUS, hero, getSkillLevel(hero))) {
            returnInfo.topFont = DEFAULT_SMALL_RED;
          } else {
            returnInfo.topFont = DEFAULT_SMALL_WHITE;
          }
          if (hero.getPrimaryStat(PRIMARY_FOCUS) < getAttributeInfo(MASTERY_REQ_FOCUS, hero, getSkillLevel(hero) + 1)) {
            returnInfo.bottomFont = DEFAULT_SMALL_RED;
          } else {
            returnInfo.bottomFont = DEFAULT_SMALL_WHITE;
          }
          break;
        default:
          returnInfo.topFont = skillAttributes[i].font;
          returnInfo.bottomFont = skillAttributes[i].font;
          break;
      }
    }
  }
  
  return returnInfo;
}

/*=============================================================================
 * formatCodes()
 *
 * this function formats a string for the replaceCode routine
 *===========================================================================*/
private function string formatCodes
(
  AttributeTypes mechanicType,
  ROTT_Combat_Hero hero,
  int skillLevel,
  string tag,
  ReturnTypes returnType,
  string sourceStr
)
{
  local float attribute;
  local string mechStr;
  
  // Fetch mechanic value
  attribute = getAttributeInfo(mechanicType, hero, skillLevel);
  
  // Buffer the mechanic value as a string
  switch (returnType) {
    case INTEGER:
      ///mechStr = string(int(attribute));
      mechStr = class'UI_Label'.static.abbreviate(int(attribute));
      break;
    case DECIMAL:
      // Format to two decimal places
      mechStr = left(attribute, len(attribute) - 2); 
      break;
  }
  
  // Check for a plurality replacer on this same line
  if (inStr(sourceStr, "%plural") != -1) {
    sourceStr = repl(sourceStr, "%plural", (int(attribute) == 1) ? "" : "s");
  }
  
  // Replace the codes in the descriptor
  return repl(sourceStr, tag, mechStr);
}

/*=============================================================================
 * getAttributeInfo()
 *
 * This function allows access to skill info for a given level.
 *===========================================================================*/
public function float getAttributeInfo
(
  AttributeTypes type, 
  ROTT_Combat_Hero hero, 
  optional int level = -1
) 
{
  // Get hard point level with no boosts
  if (level == -1) level = getSkillLevel(hero, true);
  
  // Filter stats for level 0
  if (level == 0) return 0;
  
  // Calculate enchantment impact on skill level
  switch (type) {
    case MANA_COST:
    case TEMP_MANA_DRAIN_TIME:
    case TEMP_MANA_DRAIN_AMOUNT:
      // Prevent enchantment level boosts from penalizing attributes
      break;
    case MANA_OVERFLOW_COST:
      // Slower mana increase for aura
      level += hero.getClassLevelBoost(skillIndex) / 2;
      break;
    default:
      // Apply enchantment and item boosts
      switch (parentTree) {
        case CLASS_TREE:  
          level += hero.getClassLevelBoost(skillIndex);
          break;
        case GLYPH_TREE:  
          level += hero.getGlyphLevelBoost(skillIndex);
          break;
        case MASTERY_TREE: 
          break;
        case HYPER_TREE: 
          break;
      }
      break;
  }
  
  return attributeInfo(type, hero, level);
}

/*=============================================================================
 * attributeInfo()
 *
 * This function should hold all equations pertaining to the skill's behavior.
 *===========================================================================*/
protected function float attributeInfo
(
  AttributeTypes type, 
  ROTT_Combat_Hero hero, 
  int level
) 
{
  local float attribute; attribute = 0; // Anti template warning
  
  switch (type) {
    // Relevant mechanic types should be filled out here in children classes
  }
  
  return attribute;
}

/*============================================================================= 
 * skillReset()
 *
 * Called to reset skill data at the start of a new battle
 *===========================================================================*/
public function skillReset() {
  castCount = 0;
  glyphCount = 0;
  resetStance();
}

/*=============================================================================
 * modifyStanceSteps()
 *
 * Used to add or remove from the stance count.  Applies or removes stance
 * attributes.
 *===========================================================================*/
public function modifyStanceSteps(ROTT_Combat_Hero hero, int addSteps) {
  local array<ROTT_Combat_Unit> targets;
  local int initialSteps;
  
  if (addSteps == 0) return;
  
  // Add steps from persistence
  ///addSteps += hero.heldItemStat(ITEM_PERSISTENCE) / 80;
  ///if (hero.heldItemStat(ITEM_PERSISTENCE) / 80 >= 1) {
  ///  violetLog("Added persistence steps");
  ///  scriptTrace();
  ///}
  
  // Store step value before change
  initialSteps = stanceCount;
  
  // Hacky trick? this fixes an ordering issue for decrementing steps
  if (initialSteps == 0) addSteps++;
  
  // Change step count
  stanceCount += addSteps;
  
  // Set self as target
  targets.addItem(hero);
  
  // Check for attribute removal or addition
  if (initialSteps == 0) {
    // Add attributes
    skillAction(targets, hero, ADD_STANCE_SET);
    hero.addStatus(self);
  }
  if (stanceCount == 0) {
    // Remove attributes
    skillAction(targets, hero, REMOVE_STANCE_SET);
    hero.removeStatus(self);
  }
}

/*=============================================================================
 * resetStance()
 *
 * Called to reset a stance
 *===========================================================================*/
public function resetStance() {
  local array<ROTT_Combat_Unit> targets;
  local ROTT_Combat_Hero hero;
  
  // Reset stance
  stanceCount = 0;
  
  // Get hero
  hero = ROTT_Combat_Hero(outer.outer);
  if (hero == none) hero = ROTT_Combat_Hero(outer); /// hacky, defend doesnt have a tree
  targets.addItem(hero);
  
  // Remove attributes
  skillAction(targets, hero, REMOVE_STANCE_SET);
  
  // Remove status
  hero.removeStatus(self);
}

/*=============================================================================
 * addManaOverflow()
 *
 * Called to track mana that overflows beyond a combat unit's max mana value
 *===========================================================================*/
public function addManaOverflow(float manaOverflow) {
  local ROTT_Combat_Hero hero;
  local float overflowCost;
  local int level;
  
  // Get calculation info
  hero = ROTT_Combat_Hero(outer.outer);
  level = getSkillLevel(hero, true);
  overflowCost = getAttributeInfo(MANA_OVERFLOW_COST, hero, level);
  if (overflowCost == 0) return;
  
  // Track mana overflow
  manaPool += manaOverflow;
  
  // Trigger overflow event
  if (manaPool > overflowCost) {
    manaPool = manaPool % overflowCost;
    onPoolOverflow(hero);
  }
}

/*=============================================================================
 * onTick()
 *
 * Called each tick, implemented in subclasses
 *===========================================================================*/
public function onTick(ROTT_Combat_Hero hero, float deltaTime);

/*=============================================================================
 * onDeadTick()
 *
 * Called each tick only when dead, implemented in subclasses
 *===========================================================================*/
public function onDeadTick(ROTT_Combat_Hero hero, float deltaTime);

/*============================================================================= 
 * onBattlePrep()
 *
 * Called when a battle starts
 *===========================================================================*/
public function onBattlePrep(ROTT_Combat_Hero hero) {
  local array<ROTT_Combat_Unit> targets;
  local int i;
  
  // Skip level zero skills
  if (getSkillLevel(hero) == 0) return;
  
  // Reset mana overflow tracking
  manaPool = 0;
  
  // Set heroes as targets
  for (i = 0; i < gameInfo.getActiveParty().getPartySize(); i++) {
    targets.addItem(gameInfo.getActiveParty().getHero(i));
  }
  
  // Apply party passives
  skillAction(targets, hero, PASSIVE_PARTY_SET);
}

/*============================================================================= 
 * onPoolOverflow()
 *
 * This is called when the mana cost for a passive mana draining skill is met
 *===========================================================================*/
public function onPoolOverflow(ROTT_Combat_Hero hero);

/*=============================================================================
 * onTakeDamage()
 *
 * Called when the owner of this skill takes damage
 *===========================================================================*/
public function onTakeDamage();

/*============================================================================= 
 * skillAction()
 *
 * This will process all skill attributes into combat action mechanics
 *===========================================================================*/
public function bool skillAction
(
  array<ROTT_Combat_Unit> targets,
  ROTT_Combat_Hero caster,
  optional AttributeSets attributeSet = COMBAT_ACTION_SET 
) 
{  
  local ROTT_Combat_Mechanics targetMechanics;
  local ROTT_Combat_Mechanics casterMechanics;
  local ActionPacket skillPacket;
  local float dmgAmp;
  local float dmgAmpElemental;
  local float dmgAmpPhysical;
  local bool bNegateValues;
  local bool bHit;
  local bool bAltAnim;
  local int listLength;
  local int level;
  local int i;
  
  // Check validity of target
  if (targets.length == 0) { 
    yellowLog("Warning (!) Empty targets for skill action");
    return false;
  }
  
  // Check validity of set type
  if (attributeSet == PASSIVE_SET) { 
    yellowLog("Warning (!) Passive set cannot be executed");
    return false;
  }
  
  // Create mechanic arrays
  targetMechanics = new class'ROTT_Combat_Mechanics';
  casterMechanics = new class'ROTT_Combat_Mechanics';
  
  // Handle stance removal setup
  if (attributeSet == REMOVE_STANCE_SET) {
    bNegateValues = true;
    attributeSet = ADD_STANCE_SET;
  }
  
  // Scan to see if list is non-empty for this set
  for (i = 0; i < skillAttributes.length; i++) {
    if (skillAttributes[i].attributeSet == attributeSet) listLength++;
  }
  if (listLength == 0) {
    targetMechanics = none;
    casterMechanics = none;
    return false;
  }
  
  // Log
  darkCyanLog(
    "Executing hero script: " $ self $ " (" $ attributeSet $ ")", DEBUG_COMBAT
  );
  
  // Get skill level
  level = getSkillLevel(caster);
  
  // Initial values for some skill variables
  dmgAmp = 1.f;
  dmgAmpElemental = 1.f;
  dmgAmpPhysical = 1.f;
  
  // Make mechanics from skill attributes
  for (i = 0; i < skillAttributes.length; i++) {
    if (skillAttributes[i].attributeSet == attributeSet) {
      switch (skillAttributes[i].mechanicType) {
        // Mana
        case MANA_COST:
          casterMechanics.addMechanic(
            REDUCE_MANA, 
            getAttributeInfo(MANA_COST, caster, getSkillLevel(caster, true))
          );
          break;
          
        // Prime stat mods
        case INCREASE_VITALITY:
          targetMechanics.addMechanic(
            ADD_VITALITY, 
            getAttributeInfo(INCREASE_VITALITY, caster, level)
          );
          break;
          
        case INCREASE_STRENGTH:
          targetMechanics.addMechanic(
            ADD_STRENGTH, 
            getAttributeInfo(INCREASE_STRENGTH, caster, level)
          );
          break;
          
        case INCREASE_COURAGE:
          targetMechanics.addMechanic(
            ADD_COURAGE, 
            getAttributeInfo(INCREASE_COURAGE, caster, level)
          );
          break;
          
        case INCREASE_ALL_STATS:
          targetMechanics.addMechanic(
            ADD_ALL_STATS, 
            getAttributeInfo(INCREASE_ALL_STATS, caster, level)
          );
          break;
          
        case INCREASE_COURAGE_PERCENT:
          targetMechanics.addMechanic(
            ADD_COURAGE_PERCENT, 
            getAttributeInfo(INCREASE_COURAGE_PERCENT, caster, level)
          );
          break;
          
        case INCREASE_STRENGTH_PERCENT:
          targetMechanics.addMechanic(
            ADD_STRENGTH_PERCENT, 
            getAttributeInfo(INCREASE_STRENGTH_PERCENT, caster, level)
          );
          break;
          
        case DECREASE_STRENGTH_RATING:
          targetMechanics.addMechanic(
            REDUCE_STRENGTH, 
            getAttributeInfo(DECREASE_STRENGTH_RATING, caster, level)
          );
          break;
          
        // Substat mods
        case INCREASE_DODGE_RATING:
          casterMechanics.addMechanic(
            ADD_DODGE, 
            getAttributeInfo(INCREASE_DODGE_RATING, caster, level)
          );
          break;
          
        case INCREASED_CRIT_CHANCE:
          casterMechanics.addMechanic(
            ADD_NEXT_CRIT_CHANCE, 
            getAttributeInfo(INCREASED_CRIT_CHANCE, caster, level)
          );
          break;
          
        case INCREASE_MAX_HEALTH_MAX_MANA:
          targetMechanics.addMechanic(
            ADD_MAX_MANA, 
            getAttributeInfo(INCREASE_MAX_HEALTH_MAX_MANA, caster, level)
          );
          targetMechanics.addMechanic(
            ADD_MAX_HEALTH, 
            getAttributeInfo(INCREASE_MAX_HEALTH_MAX_MANA, caster, level)
          );
          break;
          
        case DECREASE_SPEED_RATING:
          targetMechanics.addMechanic(
            REDUCE_SPEED, 
            getAttributeInfo(DECREASE_SPEED_RATING, caster, level)
          );
          break;
          
        case DECREASE_DODGE_RATING:
          targetMechanics.addMechanic(
            REDUCE_DODGE, 
            getAttributeInfo(DECREASE_DODGE_RATING, caster, level)
          );
          break;
          
        case DECREASE_ACCURACY_RATING:
          targetMechanics.addMechanic(
            REDUCE_ACCURACY, 
            getAttributeInfo(DECREASE_ACCURACY_RATING, caster, level)
          );
          break;
          
        // Glyph mods
        case GLYPH_ARMOR_BOOST:
          caster.addBattleStatistic(
            ADDED_GLYPH_ARMOR, 
            getAttributeInfo(GLYPH_ARMOR_BOOST, caster, level)
          );
          casterMechanics.addMechanic(
            ADD_ARMOR, 
            getAttributeInfo(GLYPH_ARMOR_BOOST, caster, level)
          );
          break;
          
        case GLYPH_MIN_HEALTH_BOOST:
          casterMechanics.addMechanic(
            RECOVER_HEALTH, 
            getAttributeInfo(GLYPH_MIN_HEALTH_BOOST, caster, level),
            getAttributeInfo(GLYPH_MAX_HEALTH_BOOST, caster, level)
          );
          break;
          
        case GLYPH_MIN_MANA_BOOST:
          casterMechanics.addMechanic(
            RECOVER_MANA, 
            getAttributeInfo(GLYPH_MIN_MANA_BOOST, caster, level),
            getAttributeInfo(GLYPH_MAX_MANA_BOOST, caster, level)
          );
          break;
          
        case GLYPH_MANA_REGEN:
          casterMechanics.addMechanic(
            ADD_MANA_REGEN, 
            getAttributeInfo(GLYPH_MANA_REGEN, caster, level)
          );
          break;
          
        case GLYPH_SPEED_BOOST:
          casterMechanics.addMechanic(
            ADD_SPEED, 
            getAttributeInfo(GLYPH_SPEED_BOOST, caster, level)
          );
          break;
          
        case GLYPH_DODGE_BOOST:
          caster.addBattleStatistic(
            ADDED_GLYPH_DODGE, 
            getAttributeInfo(GLYPH_DODGE_BOOST, caster, level)
          );
          casterMechanics.addMechanic(
            ADD_DODGE, 
            getAttributeInfo(GLYPH_DODGE_BOOST, caster, level)
          );
          break;
          
        case GLYPH_ACCURACY_BOOST:
          caster.addBattleStatistic(
            ADDED_GLYPH_ACCURACY, 
            getAttributeInfo(GLYPH_ACCURACY_BOOST, caster, level)
          );
          casterMechanics.addMechanic(
            ADD_ACCURACY, 
            getAttributeInfo(GLYPH_ACCURACY_BOOST, caster, level)
          );
          break;
          
        case GLYPH_DAMAGE_BOOST:
          casterMechanics.addMechanic(
            AMPLIFY_NEXT_DAMAGE, 
            getAttributeInfo(GLYPH_DAMAGE_BOOST, caster, level)
          );
          break;
          
        // Damage
        case PHYSICAL_DAMAGE_MIN:
          targetMechanics.addMechanic(
            PHYSICAL_DAMAGE, 
            getAttributeInfo(PHYSICAL_DAMAGE_MIN, caster), 
            getAttributeInfo(PHYSICAL_DAMAGE_MAX, caster)
          );
          skillPacket.bTrackActionStatistics = true;
          break;
        
        case ELEMENTAL_DAMAGE_MIN:
          targetMechanics.addMechanic(
            ELEMENTAL_DAMAGE, 
            getAttributeInfo(ELEMENTAL_DAMAGE_MIN, caster, level), 
            getAttributeInfo(ELEMENTAL_DAMAGE_MAX, caster, level)
          );
          skillPacket.bTrackActionStatistics = true;
          break;
        
        case ATMOSPHERIC_DAMAGE_MIN:
          skillPacket.bAtmospheric = true;
          targetMechanics.addMechanic(
            ATMOSPHERIC_DAMAGE, 
            getAttributeInfo(ATMOSPHERIC_DAMAGE_MIN, caster, level), 
            getAttributeInfo(ATMOSPHERIC_DAMAGE_MAX, caster, level)
          );
          break;
        
        // Damage amplifiers
        case ELEMENTAL_AMPLIFIER: 
          targetMechanics.addMechanic(
            ELEMENTAL_MULTIPLIER, 
            getAttributeInfo(ELEMENTAL_AMPLIFIER, caster, level)
          );
          break;
          
        case PARTY_ELEMENTAL_AMPLIFIER:
          targetMechanics.addMechanic(
            ELEMENTAL_MULTIPLIER, 
            getAttributeInfo(PARTY_ELEMENTAL_AMPLIFIER, caster, level)
          );
          break;
        
        case PHYSICAL_AMPLIFIER:
          targetMechanics.addMechanic(
            PHYSICAL_MULTIPLIER, 
            getAttributeInfo(PHYSICAL_AMPLIFIER, caster, level)
          );
          break;
          
        case PARTY_PHYSICAL_AMPLIFIER:
          targetMechanics.addMechanic(
            PHYSICAL_MULTIPLIER, 
            getAttributeInfo(PARTY_PHYSICAL_AMPLIFIER, caster, level)
          );
          break;
          
        case DEMORALIZED_ELEMENTAL_AMP:
          targetMechanics.addMechanic(
            TARGET_DEMORALIZED_AMP, 
            getAttributeInfo(DEMORALIZED_ELEMENTAL_AMP, caster, level)
          );
          break;
          
        // Time mods
        case ATTACK_TIME_AMPLIFIER: 
          violetLog("Using ATTACK_TIME_AMPLIFIER" @self);
          //scriptTrace();
                
          ///caster.addTunaAmp(
          ///  getAttributeInfo(ATTACK_TIME_AMPLIFIER, caster, level),
          ///  statusTag,
          ///  getAttributeInfo(ADD_STANCE_COUNT, caster, level)
          ///);
          casterMechanics.addMechanic(
            ADD_ATTACK_TIME_PERCENT, 
            getAttributeInfo(ATTACK_TIME_AMPLIFIER, caster, level)
          );
          break;
          
        case STUN_RATING:
          targetMechanics.addMechanic(
            ADD_STUN, 
            getAttributeInfo(STUN_RATING, caster, level)
          );
          
        // Over-time mods
        case HEALTH_GAIN_OVER_TIME:
          targetMechanics.addMechanic(
            ADD_HEALTH_REGEN, 
            getAttributeInfo(HEALTH_GAIN_OVER_TIME, caster, level)
          );
          break;
        
        case HEALTH_LOSS_OVER_TIME: // Caster version... do we need a target version?
          ///casterMechanics.addMechanic(
          ///  ADD_HEALTH_DRAIN, 
          ///  getAttributeInfo(HEALTH_LOSS_OVER_TIME, caster, level)
          ///);
          break;
          
        case ADD_HEALTH_WHILE_DEFENDING: 
          targetMechanics.addMechanic(
            REGEN_HEALTH_WHILE_DEFENDING, 
            getAttributeInfo(ADD_HEALTH_WHILE_DEFENDING, caster, level)
          );
          break;
          
        case ADD_MANA_WHILE_DEFENDING: 
          targetMechanics.addMechanic(
            REGEN_MANA_WHILE_DEFENDING, 
            getAttributeInfo(ADD_MANA_WHILE_DEFENDING, caster, level)
          );
          break;
          
        case MEDITATION_RATING: 
          targetMechanics.addMechanic(
            MEDITATION_REGEN, 
            getAttributeInfo(MEDITATION_RATING, caster, level)
          );
          break;
          
        case MANA_REGEN_ADDED_ON_DEFEND: 
          targetMechanics.addMechanic(
            ADD_MANA_REGEN_ON_DEFEND, 
            getAttributeInfo(MANA_REGEN_ADDED_ON_DEFEND, caster, level)
          );
          break;
          
        case ADD_MANA_REGENERATION: 
          targetMechanics.addMechanic(
            ADD_MANA_REGEN, 
            getAttributeInfo(ADD_MANA_REGENERATION, caster, level)
          );
          break;
          
        case TEMP_MANA_DRAIN_AMOUNT: 
          caster.addAilment(
            MANA_DRAIN_OVER_TIME,
            attributeInfo(TEMP_MANA_DRAIN_AMOUNT, caster, level),
            attributeInfo(TEMP_MANA_DRAIN_TIME, caster, level)
          );
          break;
          
        // Armor
        case INCREASE_ARMOR:
          casterMechanics.addMechanic(
            ADD_ARMOR, 
            getAttributeInfo(INCREASE_ARMOR, caster, level)
          );
          break;
          
        // Demoralization
        case DEMORALIZE_RATING_NO_STACKING:
          targetMechanics.addMechanic(
            DEMORALIZE_POWER_NO_STACK, 
            getAttributeInfo(DEMORALIZE_RATING_NO_STACKING, caster, level)
          );
          break;
          
        case DEMORALIZE_RATING:
          targetMechanics.addMechanic(
            DEMORALIZE_POWER, 
            getAttributeInfo(DEMORALIZE_RATING, caster, level)
          );
          break;
          
        case SELF_DEMORALIZE_RATING:
          casterMechanics.addMechanic(
            DEMORALIZE_POWER, 
            getAttributeInfo(SELF_DEMORALIZE_RATING, caster, level)
          );
          break;
          
        // Leech
        case HEALTH_LEECH:
          targetMechanics.addMechanic(
            LEECH_HEALTH, 
            getAttributeInfo(HEALTH_LEECH, caster, level)
          );
          break;
          
        case MANA_LEECH:
          targetMechanics.addMechanic(
            LEECH_MANA, 
            getAttributeInfo(MANA_LEECH, caster, level)
          );
          break;
          
        // Stance mods
        case ADD_STANCE_COUNT:
          modifyStanceSteps(caster, getAttributeInfo(ADD_STANCE_COUNT, caster, level));
          break;
          
        case ADD_STANCE_COUNT_PER_GLYPH:
          modifyStanceSteps(
            caster, 
            getAttributeInfo(
              ADD_STANCE_COUNT_PER_GLYPH, 
              caster, 
              level
            ) * glyphCount + rollPersistCount(caster)
          );
          break;
        
        // Count based mods
        case CAST_COUNT_AMP:
          dmgAmp = castCount;
          break;
          
        case GLYPH_COUNT_AMP:
          dmgAmp = glyphCount;
          break;
          
        // Action requirements
        case REQUIRES_GLYPH:
          if (AttributeSet != GLYPH_SET && glyphCount == 0) return false;
          break;
        
        // Misc
        case HIT_CHANCE_OVERRIDE:
          skillPacket.hitChance = getAttributeInfo(HIT_CHANCE_OVERRIDE, caster, level);
          break;
          
        case CUT_CASTER_LIFE_BY_PERCENT:
          casterMechanics.addMechanic(
            CUT_LIFE_BY_PERCENT, 
            getAttributeInfo(CUT_CASTER_LIFE_BY_PERCENT, caster, level)
          );
          break;
          
        case ADD_SELF_AS_TARGET:
          targetMechanics.addMechanic(
            ADD_TARGET, 
            getAttributeInfo(ADD_SELF_AS_TARGET, caster, level)
          );
          break;
        
        case PAUSE_TUNA:
          caster.pauseTuna();
          break;
        
        case UNPAUSE_TUNA:
          caster.unpauseTuna();
          break;
        
        case AUTO_ATTACK_MODE:
          if (bNegateValues) {
            // Force attack mode off
            caster.forceAttackMode(false);
            
            // Reset target
            caster.autoTargetedUnit = none;
          } else {
            // Force attack mode on
            caster.forceAttackMode(true);
          }
          break;
        
        case TARGET_CASTER:
          if (caster.autoTargetedUnit == none) {
            caster.autoTargetedUnit = caster.lastAttacker;
          }
          break;
        
        case RANDOM_TARGET:
          selectRandomTarget(targets);
          break;
        
        case ATMOSPHERIC_TAG:
          skillPacket.bAtmospheric = true;
          break;
        
        case QUEUED_MULTISTRIKE_COUNT:
          caster.queueAction(
            targets,
            getAttributeInfo(QUEUED_MULTISTRIKE_COUNT, caster, level),
            getAttributeInfo(QUEUED_MULTISTRIKE_DELAY, caster, level),
            self
          );
          // Note: We clear targets so that the combat action does not hit
          // Anything you may want on the combat action, should instead be queued. Do not mix.
          targets.length = 0;
          break;
        
        case QUEUED_SECONDARY_EFFECT:
          // Check for secondary script
          ///if (secondaryScriptIndex == none) { 
          ///  yellowLog("Warning (!) Empty secondary script field.");
          ///  break;
          ///}
          // Queue up secondary effects
          caster.queueAction(
            targets,
            1,   // strike count
            0.6, // delay
            ROTT_Descriptor_Hero_Skill(caster.getSkillScript(secondaryScriptIndex)),
            true
          );
          // Note: We clear targets so that the combat action does not hit
          // Anything you may want on the combat action, should instead be queued. Do not mix.
          ///targets.length = 0;
          break;
        
        case OVERRIDE_ATTACK_TIME:
          if (bNegateValues) {
            caster.removeTunaOverride();
          } else {
            caster.overrideTuna(getAttributeInfo(OVERRIDE_ATTACK_TIME, caster, level));
          }
          break;
        
        // Misc UI
        case STORM_INTENSITY_NOTIFICATION:
          gameInfo.getCombatScene().combatPage.showCombatNotification("Storm Intensity " $ castCount + 1);
          break;
        
        case ALT_ACTION_ANIMATION:
          bAltAnim = true;
          break;
        
        case TRACK_ACTION:
          skillPacket.bTrackActionStatistics = true;
          break;
        
        /**= unsorted =**/
        case STARBOLT_AMPLIFIER_MIN:
          targetMechanics.addMechanic(
            ELEMENTAL_DAMAGE, 
            getAttributeInfo(STARBOLT_AMPLIFIER_MIN, caster, level) * castCount, 
            getAttributeInfo(STARBOLT_AMPLIFIER_MAX, caster, level) * castCount
          );
          break;
          
        case MANA_SHIELD_PERCENT:
          targetMechanics.addMechanic(
            ADD_MANA_SHIELD, 
            getAttributeInfo(MANA_SHIELD_PERCENT, caster, level)
          );
          break;
          
        // Extra entries
        case PHYSICAL_DAMAGE_MAX:
        case ELEMENTAL_DAMAGE_MAX:
        case ATMOSPHERIC_DAMAGE_MAX:
        case PASSIVE_ADD_PHYSICAL_MAX:
        case GLYPH_MAX_HEALTH_BOOST:
        case GLYPH_MAX_MANA_BOOST:
        case STARBOLT_AMPLIFIER_MAX:
        case GLYPH_SPAWN_CHANCE:
        case MANA_TRANSFER_RATE:
        case QUEUED_MULTISTRIKE_DELAY:
        case TEMP_MANA_DRAIN_TIME:
          // No actions
          break;
        default:
          yellowLog("Warning (!) Unhandled skill mechanic " 
          $ string(GetEnum(enum'AttributeTypes', skillAttributes[i].mechanicType)));
          break;
        
      }
    }
  }
  
  // Get post processing mechanics
  dmgAmpElemental += caster.statBoosts[AMPLIFY_NEXT_DAMAGE] / 100.0;
  dmgAmpElemental += caster.statBoosts[ELEMENTAL_MULTIPLIER] / 100.0;
  dmgAmpElemental += caster.heldItemStat(ITEM_MULTIPLY_ELEMENTAL) / 100.0;
  dmgAmpPhysical += caster.statBoosts[AMPLIFY_NEXT_DAMAGE] / 100.0;
  dmgAmpPhysical += caster.statBoosts[PHYSICAL_MULTIPLIER] / 100.0;
  if (bNegateValues) {
    targetMechanics.negateValues();
    casterMechanics.negateValues();
  }
  
  // Post process target mechanics
  targetMechanics.multiplyMechanic(PHYSICAL_DAMAGE, dmgAmpPhysical * dmgAmp);
  targetMechanics.multiplyMechanic(ELEMENTAL_DAMAGE, dmgAmpElemental * dmgAmp);
  
  // Check for laceration, item ability
  handleLacerations(caster);
  
  // Add laceration DPS
  /// to do...
  
  // Check for persistence, item ability
  if (attributeSet == COMBAT_ACTION_SET) {
    if (ROTT_Descriptor_Skill_Valkyrie_Volt_Retaliation(self) != none || caster.bForceAttack) {
      
    } else {
      handlePersistence(caster);
    }
  }
  
  // Apply skill mechanics to caster 
  caster.parseMechanics(casterMechanics, caster);
  
  // Reset time until next attack
  switch (attributeSet) {
    case COMBAT_ACTION_SET:  
      caster.resetTuna();
      break;
  }
  
  // Set chance to hit overrides
  switch (targetingLabel) { 
    case MULTI_TARGET_ATTACK: 
    case SINGLE_TARGET_ATTACK: 
      // Default chance to hit
      break;
    case MULTI_TARGET_DEBUFF: 
    case SINGLE_TARGET_DEBUFF: 
      // Override hit chance of debuffs
      skillPacket.hitChance = DEBUFF_CHANCE;
      skillPacket.bDebuff = true;
      break;
    default:
      // Override hit chance of buffs and misc skills
      skillPacket.hitChance = BUFF_CHANCE;
      break;
  }
  
  // Apply target mechanics
  skillPacket.skillAnim = (!bAltAnim) ? skillAnim : altSkillAnim;
  skillPacket.mechanics = targetMechanics;
  for (i = 0; i < targets.length; i++) {
    bHit = targets[i].parsePacket(skillPacket, caster) || bHit;
  }
  
  // Action statistics
  if (skillPacket.bTrackActionStatistics) {
    caster.battleStatistics[OUTGOING_ACTIONS] += 1;
  }
  
  // Change targets to heroes
  ///targets.length = 0;
  ///for (i = 0; i < gameInfo.getActiveParty().getPartySize(); i++) {
  ///  targets.addItem(gameInfo.getActiveParty().getHero(i));
  ///}
  
  // Increment counters
  switch (attributeSet) {
    case COMBAT_ACTION_SET: castCount++; break;
    case GLYPH_SET: glyphCount++; break;
  }
  
  // Report false if no targets hit, true if one or more are hit
  return bHit;
}

/*============================================================================= 
 * handleLacerations()
 *
 * Implements lacerations, 25% damage dealt as dps
 *===========================================================================*/
protected function handleLacerations(ROTT_Combat_Hero heroCaster) {
  local int lacerationChance;
  
  // Prevent laceration stacking
  if (heroCaster.lacerationCount > 0) return;
  
  // Set chance from item
  lacerationChance = heroCaster.heldItemStat(ITEM_LACERATIONS);
  
  // Iterate through percent chance to persist
  while (lacerationChance > 0) {
    // Check chance to persist up to 80 at a time
    if (lacerationChance > LACERATION_LIMIT) {
      if (rand(100) < LACERATION_LIMIT) {
        // Enable laceration
        heroCaster.lacerationCount++;
        lacerationChance -= LACERATION_LIMIT;
      }
    } else {
      if (rand(100) < lacerationChance) {
        // Enable laceration
        heroCaster.lacerationCount++;
        lacerationChance = 0;
      }
    }
  }
  
}

/*============================================================================= 
 * handlePersistence()
 *
 * Implements persistence, repeats actions with half attack time
 *===========================================================================*/
protected function handlePersistence
(
  ROTT_Combat_Hero heroCaster
) 
{
  // Prevent stacking
  if (heroCaster.bPersisting) return;
  
  // Roll to count number of persisted actions
  heroCaster.persistenceCount = rollPersistCount(heroCaster);
  
  // Exit if no actions rolled
  if (heroCaster.persistenceCount == 0) return;
  
  // Change state to persisting on hero
  heroCaster.bPersisting = true;
  
  // Apply time mod for faster persisting strikes
  if (heroCaster.persistenceCount != 0) {
    heroCaster.addTunaAmp(
      0.5,
      "Persistence",
      heroCaster.persistenceCount
    );
  }
}

/*============================================================================= 
 * rollPersistCount()
 *
 * Returns the number of persisted actions.  Uses 80% Roll cap.
 *===========================================================================*/
protected function int rollPersistCount
(
  ROTT_Combat_Hero heroCaster
) 
{
  local int persistenceChance;
  local int count;
  local int roll;
  
  // Set chance from item
  persistenceChance = heroCaster.heldItemStat(ITEM_PERSISTENCE);
  if (persistenceChance == 0) return 0;
  
  // Iterate through percent chance to persist
  while (persistenceChance > 0) {
    roll = rand(100);
    
    // Check chance to persist up to 80 at a time
    if (persistenceChance >= PERSISTENCE_LIMIT) {
      if (roll < PERSISTENCE_LIMIT) {
        // Add to persistence
        count++;
      }
      // Consume chance per roll
      persistenceChance -= PERSISTENCE_LIMIT;
    } else {
      if (roll < persistenceChance) {
        // Add to persistence
        count++;
      }
      // Roll chance depleted
      persistenceChance = 0;
    }
  }
  return count;
}

/*============================================================================= 
 * getManaEquation()
 *
 * This equation is used for mana, and is balanced in excel
 *===========================================================================*/
protected function int getManaEquation
(
  int skillLevel, 
  float A, float B, float C, float D, float E
) 
{
  return round(round(A ** (skillLevel ** B)) + (skillLevel ** C) + (D * skillLevel) + E);
}

/*============================================================================= 
 * getHeader()
 *
 * This provides a string label based on targeting classifcation
 *===========================================================================*/
protected function string getHeader(TargetingClassification targetClass) {
  switch (targetClass) {
    case PASSIVE_PARTY_BUFF:   return "(Passive Party Buff)";
    case COLLECTIBLE_GLYPH:    return "(Collectible Glyph)";
    
    case MULTI_TARGET_ATTACK:  return "(Multi Target Attack)";
    case MULTI_TARGET_DEBUFF:  return "(Multi Target Debuff)";
    case MULTI_TARGET_BUFF:    return "(Multi Target Buff)";
    case MULTI_TARGET_AURA:    return "(Multi Target Aura)";
    
    case SINGLE_TARGET_ATTACK: return "(Single Target Attack)";
    case SINGLE_TARGET_BUFF:   return "(Single Target Buff)";
    case SINGLE_TARGET_DEBUFF: return "(Single Target Debuff)";
    
    case SELF_TARGET_BUFF:     return "(Self Target Buff)";
    
    case PASSIVE_ATTACK_PERK:  return "(Attack Perk)";
    case PASSIVE_DEFEND_PERK:  return "(Defence Perk)";
  }
  
  yellowLog("Warning (!) No header found for " $ targetClass);
}

/*============================================================================= 
 * statReqCheck()
 *
 * Returns true if stat requirement check passes 
 *===========================================================================*/
public function bool statReqCheck(ROTT_Combat_Hero hero) {
  local float reqVit, reqStr, reqCrg, reqFoc;
  
  reqVit = getAttributeInfo(MASTERY_REQ_VITALITY, hero, getSkillLevel(hero) + 1);
  reqStr = getAttributeInfo(MASTERY_REQ_STRENGTH, hero, getSkillLevel(hero) + 1);
  reqCrg = getAttributeInfo(MASTERY_REQ_COURAGE, hero, getSkillLevel(hero) + 1);
  reqFoc = getAttributeInfo(MASTERY_REQ_FOCUS, hero, getSkillLevel(hero) + 1);
  
  if (hero.getPrimaryStat(PRIMARY_VITALITY) < reqVit) return false;
  if (hero.getPrimaryStat(PRIMARY_STRENGTH) < reqStr) return false;
  if (hero.getPrimaryStat(PRIMARY_COURAGE) < reqCrg) return false;
  if (hero.getPrimaryStat(PRIMARY_FOCUS) < reqFoc) return false;
  
  return true;
}

/*============================================================================= 
 * getSkillLevel()
 *
 * This fetches the skill level from the hero provided, including(?) bonuses
 *===========================================================================*/
public function int getSkillLevel
(
  ROTT_Combat_Hero hero, 
  optional bool bIgnoreBoost = false
) 
{
  // Check for valid skill index
  if (skillIndex == -1) {
    yellowLog("Warning (!) skill index not set for skill");
    return 0;
  }
  
  // Check for valid hero unit
  if (hero == none) {
    yellowLog("Warning (!) No hero.");
    scriptTrace();
  }
  
  // Get skill info from skill trees
  switch (parentTree) {
    case CLASS_TREE:   return hero.getClassLevel(skillIndex); ///+ boost;
    case GLYPH_TREE:   return hero.getGlyphLevel(skillIndex); ///+ boost;
    case MASTERY_TREE: return hero.getMasteryLevel(skillIndex);
    case HYPER_TREE:   return gameInfo.playerProfile.getHyperGlyphLevel(skillIndex);
  }
}

/*============================================================================= 
 * selectRandomTarget()
 *
 * Given a set of targets, this modifies it to be a single target
 *===========================================================================*/
private function selectRandomTarget(out array<ROTT_Combat_Unit> targets) {
  while (targets.length > 1) {
    targets.remove(rand(targets.length), 1);
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  skillIndex=-1
  combatSfx=NO_SFX
  secondarySfx=NO_SFX
  
  // Default status color
  statusColor=COMBAT_SMALL_TAN
}










