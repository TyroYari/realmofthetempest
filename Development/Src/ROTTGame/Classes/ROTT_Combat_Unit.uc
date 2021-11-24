/*=============================================================================
 * ROTT_Combat_Unit
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is a base class for all characters that can participate
 * in combat.  (e.g. ROTT_Hero_Unit, ROTT_Combat_Enemy)
 *===========================================================================*/
 
class ROTT_Combat_Unit extends ROTT_Combat_Object
dependsOn(ROTT_Descriptor_Hero_Skill)
dependsOn(ROTT_Descriptor_Rituals)
abstract;

// Some constants for reporting mana
const REPORT_STAT = true;
const NO_REPORT = false;
const REPORT_MANA = false;
const REPORT_REGEN = true;
const REPORT_HEALTH = true;

// When crit chance exceeds this threshold, then multiple rolls occur
const CRIT_THRESHOLD = 60;
  
// Primary stats
enum StatTypes {
  PRIMARY_VITALITY,
  PRIMARY_STRENGTH,
  PRIMARY_COURAGE,
  PRIMARY_FOCUS
};

// Primary stat affinity types
enum AffinityEnum {
  MINOR,
  AVERAGE,
  MAJOR
};

enum TemporaryCombatEnum {
  STARBOLT_COUNT, // encapsulate this into the script? would be nice
  STORM_INTENSITY
};

// Character level, based on experience
var protectedwrite int level;                

// Stores stat points invested in primary stats (exludes ALL bonuses)
var protected int hardStats[StatTypes];  

// Primary stat affinities determine how primary stats effect substats
var protectedwrite AffinityEnum statAffinities[StatTypes];

// Stores sub stats resulting from primary stats
var protectedwrite float subStats[SubStatTypes]; 

// Store count of rituals player performs
var protectedwrite float ritualStatBoosts[RitualTypes];

// Stores a copy of the current interval, so changes in speed rating dont effect the current bar
var protectedwrite float currentAtkInterval; 
var protectedwrite float firstAtkInterval; 

// Stores stat boosts accumulated from combat activity (e.g. skills and glyphs)
var protectedwrite float statBoosts[MechanicTypes];

// Stance boost info
struct StanceBoost {
  // How long the stance lasts
  var int turns;
  
  // Instigating skill type
  var class<ROTT_Descriptor_Hero_Skill> skillSource;
  
  // Stores stat boosts gained from this stance
  var float statBoosts[MechanicTypes];
};

// Stores stance boosts
var protectedwrite array<StanceBoost> stanceBoosts;

// Stores the current stance (changed by skill actions)
var public StanceType currentStance;

// Substat calculation data
struct AffinityInfo {
  var float amp[AffinityEnum];
};

// Substat calculation constants
var protectedwrite AffinityInfo affinity[SubStatTypes];

// Base health and mana values
var protected float baseHealth;
var protected float baseMana;

// Baseline armor rating, calculated per level and rounded down
var protectedwrite float armorPerLvl; 

// Baseline substats
var protectedwrite int baseMaxDamage; 
var protectedwrite int baseMinDamage; 
var protectedwrite int baseCritChance; 

// Action handling
var protectedwrite bool bActionReady;

// Stutus effects from skills
enum TimeEffects {
  DEMORALIZE,
  STUN,
};
var protectedwrite float timedEffect[TimeEffects];

// Time delayed skill mechanics
struct PendingMechanics {
  var ROTT_Combat_Mechanics mechanics;
  var ROTT_Combat_Unit caster;
  var float delay;
};
var protectedwrite array<PendingMechanics> pendingMechs;

// Damage over time trackers
/* we should generalize this to an enumeration and array */
var protectedwrite float blackHoleDamage; 

// Tracks if the last black hole cast was defended
var protectedwrite bool bResistingBlackHole; 

// List of all active attachable unit modifiers
var protectedwrite array<ROTT_Descriptor_Hero_Skill> activeMods; 
/* the type here should be able to include items, and possibly enchantments */

// List of all temporary attachable status modifiers
var protectedwrite array<ROTT_Descriptor_Hero_Skill> statusMods; 
/* the type here should be the same as above */

// Last unit to attack this unit
var protectedwrite ROTT_Combat_Unit lastAttacker;

// Unit to target if there is no target selection (e.g. forced attack mode)
var public ROTT_Combat_Unit autoTargetedUnit;

// Queued action information
struct QueuedActionInfo {
  // Countdown delay until action is triggered
  var float delay;
  
  // Targets
  var array<ROTT_Combat_Unit> targets;
  
  // Skill script
  var ROTT_Descriptor_Hero_Skill queuedSkill;
};

// Stores the amount of time elapsed since damage was taken
var protectedwrite float timeWithoutDamage;
var public ROTT_Descriptor_Hero_Skill meditationInfo;

// A queue of actions that will trigger over time
var protectedwrite array<QueuedActionInfo> queuedActions;

// Store a temporary ailment
struct AilmentInfo {
  var MechanicTypes ailmentMechanic;
  var float ailmentAmp;
  var float remainingTime;
};

// Store timed ailments
var protectedwrite array<AilmentInfo> temporaryAilments;

// Status of unit (dead or alive)
var protectedwrite bool bDead;

// Misc combat mechanic for pausing TUNA progress
var protectedwrite bool bPauseTuna;

// Misc combat mechanic for forcing attack ability instead of action selection
var protectedwrite bool bForceAttack;

// Temporary status storage until new status system is implemented
var protectedwrite bool bDemoralizedStatus;

// Laceration and persistence settings
var public int lacerationCount;
var public int persistenceCount;
var public bool bPersisting;

// Store information for modifying attack times
struct TimeMod {
  var float timeMultiplier;
  var string tag;
  var int lifeSteps;
};

var protectedwrite array<TimeMod> tunaMultipliers;

// Display component
var public ROTT_UI_Displayer_Combat uiComponent;

/*=============================================================================
 * battleInit()
 *
 * This function is called when a new battle starts, followed by battlePrep().
 * All temporary stats should be cleared here.
 *===========================================================================*/
public function battleInit() {
  // Reset combat stats
  clearTemporaryInfo();
}

/*=============================================================================
 * battlePrep()
 *
 * This function is called after stats have been reset by battleInit().
 * Passive buffs and other combat settings are initialized here.
 *===========================================================================*/
public function battlePrep() {
  
}

/*=============================================================================
 * battleEnd()
 *
 * This function is called after a battle is done, when the transition out is
 * complete.
 *===========================================================================*/
public function battleEnd() {
  // Reset UI
  uiComponent.battleEnd();
}

/*=============================================================================
 * onAnalysisComplete()
 *
 * This function is called after a battle, when the analysis page has been
 * passed.
 *===========================================================================*/
public function onAnalysisComplete() {
  // Reset combat stats
  clearTemporaryInfo();
}

/*=============================================================================
 * clearTemporaryInfo()
 *
 * This resets all battle statistics and temporary stat boosts
 *===========================================================================*/
protected function clearTemporaryInfo() {
  local int i;
  
  // Reset persistence and lacerations
  persistenceCount = 0;
  lacerationCount = 0;
  
  // Reset time mods
  tunaMultipliers.length = 0;
  
  // Reset queued actions and mechanics
  queuedActions.length = 0;
  pendingMechs.length = 0;
  
  // Reset all temporary stat boosts before battle
  for (i = 0; i < MechanicTypes.enumCount; i++) {
    statBoosts[i] = 0;
  }
  for (i = 0; i < TimeEffects.enumCount; i++) {
    timedEffect[i] = 0;
  } 
  
  // Clear temporary ailments
  temporaryAilments.length = 0;
  
  // Reset tuna modifier
  bPauseTuna = false;
  bForceAttack = false;
  autoTargetedUnit = none;
  
  updateSubStats();
}

/**=============================================================================
 * populateSkillMods()
 *
 * This function initializes the list of all active stat modifying skills,
 * items, enchantments. 
 *===========================================================================*/
protected function populateSkillMods();

/**=============================================================================
 * getPassiveBoost()
 *
 * Retrieves a total for a given type of passive boost
 *===========================================================================*/
protected function float getPassiveBoost(AttributeTypes type) {
  local float value;
  local int i;
  
  if (activeMods.length == 0) return 0;
  
  // Sum the modifiers
  for (i = 0; i < activeMods.length; i++) {
    value += activeMods[i].getAttributeInfo(type, ROTT_Combat_Hero(self)); /// type here is a hack
  }
  
  return value;
}

/*============================================================================= 
 * parsePacket()
 *
 * This is used to recieve combat action info from an executed skill 
 *===========================================================================*/
public function bool parsePacket
(
  ActionPacket combatPacket, 
  ROTT_Combat_Unit caster
) 
{
  local bool bHit;
  
  // Check if the action missed
  if (combatPacket.hitChance == -1) {
    bHit = caster.getChanceToHit(self);
  } else {
    bHit = rand(100) < combatPacket.hitChance;
    
    // Statistics tracking
    if (ROTT_Combat_Hero(caster) != none && combatPacket.bTrackActionStatistics) {
      ROTT_Combat_Hero(caster).battleStatistics[OUTGOING_HITS] += 1;
    }
  }
  
  // Track black hole resistance
  if (combatPacket.bAtmospheric) {
    // Cut damage in half
    bResistingBlackHole = !bHit;
  }
  
  // Handle missed action mechanics
  if (!bHit) {
    // Check if ability is atmospheric
    if (combatPacket.bAtmospheric) {
      // Show atmospheric resistance feedback through displayer
      if (uiComponent != none) uiComponent.onResisted();
    } else {
      // Check if ability is a debuff
      if (combatPacket.bDebuff) {
        // Show resistance
        if (uiComponent != none) uiComponent.onResisted();
      } else {
        // Show attack missed
        if (uiComponent != none) uiComponent.onMissed();
      }
      // Ignore applying combat mechanics
      return false;
    }
  }
  
  // Check for skill animations
  if (combatPacket.skillAnim != none) {
    if (ROTT_Combat_Enemy(self) != none) {
      ROTT_Combat_Enemy(self).setAnimation(combatPacket.skillAnim);
    }
  }
  
  // Setup mechanic parsing on delay, to hit after animations
  addPendingPacket(combatPacket.mechanics, caster, 0.15); 
  return true;
}

/*============================================================================= 
 * parseMechanics()
 *
 * This is used to apply mechanic effects from an executed skill
 *===========================================================================*/
public function parseMechanics
(
  ROTT_Combat_Mechanics mechanics, 
  ROTT_Combat_Unit caster
) 
{
  local float atbAmp;
  local float randRange;
  local float critAmp;
  local float value;
  local float demoraleValue;
  local int i;
  
  if (mechanics == none ) { /*scriptTrace();*/ return; }
  
  // Ignore packets for dead units
  if (bDead) return;
  
  // Iterate through packets that target living units
  for (i = 0; i < MechanicTypes.enumCount; i++) {
    // Roll range (if range exists)
    randRange = rand(int(mechanics.list[i].max) - int(mechanics.list[i].min) + 1);
    value = mechanics.list[i].min + randRange;
    demoraleValue = mechanics.list[i].min + randRange / 3;
    
    // Check if mechanic is enabled
    if (mechanics.list[i].enabled) {
      // Parse mechanic by type
      switch (MechanicTypes(i)) {
        case REDUCE_MANA:
          // Bypass for persistence
          if (persistenceCount > 0) break;
          
          // Subtract mana
          subStats[CURRENT_MANA] -= value;
          break;
        case PHYSICAL_DAMAGE:
          // Check for demoralized caster
          if (caster.isDemoralized()) value = demoraleValue;
          
          // Roll and add critical damage
          critAmp = caster.rollCritAmp();
          value = float(int(value * critAmp));
          
          // Deal physical damage
          takeDamage(value, caster, critAmp);
          
          // Track damage dealt
          if (ROTT_Combat_Hero(caster) != none) {
            ROTT_Combat_Hero(caster).persistentStatistics[TRACK_PHYSICAL_DAMAGE] += value;
          }
          break;
        case ELEMENTAL_DAMAGE:
          // Check for demoralized caster
          if (caster.isDemoralized()) value = demoraleValue;
          
          // Check for demoralized target
          if (isDemoralized()) value *= mechanics.list[TARGET_DEMORALIZED_AMP].min / 100;
          
          // Deal elemental damage
          takeDamage(value, caster);
          
          // Track damage dealt
          if (ROTT_Combat_Hero(caster) != none) {
            ROTT_Combat_Hero(caster).persistentStatistics[TRACK_ELEMENTAL_DAMAGE] += value;
          }
          break;
        case ATMOSPHERIC_DAMAGE:
          // Deal atmospheric damage
          takeDamage(value, caster, , IGNORE_ARMOR_RATING);
          
          // Track damage dealt
          if (ROTT_Combat_Hero(caster) != none) {
            ROTT_Combat_Hero(caster).persistentStatistics[TRACK_ATMOSPHERIC_DAMAGE] += value;
          }
          break;
        case RECOVER_HEALTH:
          // Heal
          recoverHealth(value, REPORT_HEALTH);
          break;
        case RECOVER_MANA:
          // Mana recovery
          /* this is glyph, right? */
          recoverMana(
            value,
            REPORT_STAT,
            REPORT_MANA
          );
          break;
        case ADD_STUN:
          // Stall time until next attack
          timedEffect[STUN] += value / 20.f;
          break;
        case ADD_ATTACK_TIME_PERCENT:
          // Scale attack time with percent
          atbAmp = (statBoosts[ADD_ATTACK_TIME_PERCENT] + 100) / 100; 
          statBoosts[ADD_ATTACK_TIME_PERCENT] = (atbAmp * value) * 100 - 100;
          updateSpeedAmp();
          break;
        case CUT_LIFE_BY_PERCENT:
          // Multiply life by percent (regardless of other stats)
          subStats[CURRENT_HEALTH] *= value / 100;
          break;
        case DEMORALIZE_POWER:
          addDemoralization(value);
          break;
        case DEMORALIZE_POWER_NO_STACK:
          if (!isDemoralized()) addDemoralization(value);
          break;
        case REDUCE_VITALITY:
        case REDUCE_STRENGTH:
        case REDUCE_COURAGE:
        case REDUCE_FOCUS:
        case REDUCE_SPEED:
        case REDUCE_ACCURACY:
        case REDUCE_DODGE:
        case REDUCE_ARMOR:
        case ADD_HEALTH_DRAIN:
          // Diminish a stat
          diminishStat(value, MechanicTypes(i));
          break;
        case ADD_ALL_STATS:
        case ADD_VITALITY:
        case ADD_STRENGTH:
        case ADD_COURAGE:
        case ADD_ARMOR:
        case ADD_ACCURACY:
        case ADD_DODGE:
        case ADD_MANA_REGEN:
        case ADD_HEALTH_REGEN:
        case ADD_SPEED:
        case AMPLIFY_NEXT_DAMAGE:
        case ADD_STRENGTH_PERCENT:
        case ADD_COURAGE_PERCENT:
        case ELEMENTAL_MULTIPLIER:
        case PHYSICAL_MULTIPLIER: 
          // Add a stat boost
          improveStat(value, MechanicTypes(i));
          break;
        case REGEN_HEALTH_WHILE_DEFENDING: 
        case REGEN_MANA_WHILE_DEFENDING: 
        case ADD_MANA_SHIELD: 
        case ADD_MIN_PHYS_DAMAGE:  // these could have ui messages maybe
        case ADD_MAX_PHYS_DAMAGE:  // these could have ui messages maybe
        case ADD_MAX_MANA:         // these could have ui messages maybe
        case ADD_MAX_HEALTH:       // these could have ui messages maybe
        case ADD_MANA_REGEN_ON_DEFEND: 
        case MEDITATION_REGEN: 
        case LEECH_HEALTH: 
        case LEECH_MANA: 
        case ADD_NEXT_CRIT_CHANCE: 
        case MANA_TRANSFER_DRAIN:
        case ADD_TARGET:
          // No ui message when stat is improved here
          statBoosts[i] += value;
          break;
        case ADD_TARGET:
          /// deprecated?
          break; 
        case TARGET_DEMORALIZED_AMP:
          // This attribute is applied in another case above
          break;
        default:
          if (mechanics.list[i].max != 0) {
            yellowLog("Warning (!) Unhandled parse mechanic: "
            $ string(GetEnum(enum'MechanicTypes', i)));
          }
          break;
      }
    }
  }
  
  // Run new stat calculations for this unit
  updateSubStats();
}

/*=============================================================================
 * resetStatBoost()
 *
 * Used to reset a stat
 *===========================================================================*/
public function resetStatBoost(int statIndex) {
  statBoosts[statIndex] = 0;
  updateSubStats();
}

/*=============================================================================
 * addTunaAmp()
 *
 * Adds an attack time multiplier
 *===========================================================================*/
public function addTunaAmp
(
  float timeMultiplier,
  string tag,
  int lifeSteps
) 
{
  local TimeMod newMod;
  local int i;
  
  // Check for existing tags
  for (i = 0; i < tunaMultipliers.length; i++) {
    if (tunaMultipliers[i].tag == tag) {
      tunaMultipliers[i].lifeSteps += lifeSteps;
      return;
    }
  }
  // Check for valid life steps
  if (lifeSteps == 0) {
    yellowLog("Warning (!) Zero life steps on multiplier.  For infinity, use -1");
    return;
  }
  
  // Set time mod information
  newMod.timeMultiplier = timeMultiplier;
  newMod.tag = tag;
  newMod.lifeSteps = lifeSteps;
  
  // Add time mod to the list
  tunaMultipliers.addItem(newMod);
  
  // Update UI display
  updateSpeedAmp();
  
  // Show persistence status
  if (newMod.tag == "Persistence") {
    uiComponent.addManualStatus("Persisting", COMBAT_SMALL_GOLD);
  }
}

/*=============================================================================
 * getTunaAmp()
 *
 * Used to find the product of time mods
 *===========================================================================*/
public function float getTunaAmp() {
  local float atbAmp;
  local int i;
  
  // Initialize as product identity element
  atbAmp = 1.0;
  
  // Find product of multipliers
  for (i = 0; i < tunaMultipliers.length; i++) {
    atbAmp *= tunaMultipliers[i].timeMultiplier;
  }
  
  /// Multiply on combat mechanics
  atbAmp *= ((statBoosts[ADD_ATTACK_TIME_PERCENT] + 100) / 100) ** -1;
  
  // Check for valid multiplier
  if (atbAmp == 0.f) {
    yellowLog("Warning (!) Attack time multiplier must never be zero");
    return 1.0;
  }
  
  return atbAmp;
}

/*=============================================================================
 * checkTunaAmpTag()
 *
 * Returns true if the tag is found in the time mod list
 *===========================================================================*/
public function bool checkTunaAmpTag(string tag) {
  local int i;
  
  // Scan through time multipliers
  for (i = 0; i < tunaMultipliers.length; i++) {
    if (tunaMultipliers[i].tag == tag) return true;
  }
  return false;
}

/*=============================================================================
 * decrementTunaAmpSteps()
 *
 * Used countdown the steps for how long attack time mods apply for.
 *===========================================================================*/
public function decrementTunaAmpSteps() {
  local int i;
  
  // Scan through time multipliers
  for (i = tunaMultipliers.length - 1; i >= 0; i--) {
    // Check if life steps is not infinite
    if (tunaMultipliers[i].lifeSteps != -1) {
      // Count down life steps
      tunaMultipliers[i].lifeSteps--;
      
      // Check if life steps hit zero
      if (tunaMultipliers[i].lifeSteps == 0) {
        // Remove multiplifer
        tunaMultipliers.remove(i, 1);
      }
    }
  }
}

/*=============================================================================
 * drainMana()
 *
 * Drains mana directly, used for mana over time situations only
 *===========================================================================*/
public function drainMana(float mana) {
  subStats[CURRENT_MANA] -= mana;
  updateSubStats();
}

/*=============================================================================
 * pauseTuna()
 *
 * 
 *===========================================================================*/
public function pauseTuna() {
  bPauseTuna = true;
}

/*=============================================================================
 * unpauseTuna()
 *
 * 
 *===========================================================================*/
public function unpauseTuna() {
  bPauseTuna = false;
}

/*=============================================================================
 * overrideTuna()
 *
 * 
 *===========================================================================*/
public function overrideTuna(float attackTime) {
  statBoosts[OVERRIDDEN_ATTACK_TIME] = attackTime;
}

/*=============================================================================
 * removeTunaOverride()
 *
 * 
 *===========================================================================*/
public function removeTunaOverride() {
  statBoosts[OVERRIDDEN_ATTACK_TIME] = 0;
}

/*=============================================================================
 * forceAttackMode()
 *
 * Called to force the unit to attack instead of selecting a skill
 *===========================================================================*/
public function forceAttackMode(bool bForce) {
  bForceAttack = bForce;
}

/*=============================================================================
 * queueAction()
 *
 * Called queue actions from skills, like multistrike abilities
 *===========================================================================*/
public function queueAction
(
  array<ROTT_Combat_Unit> targets,
  int count,
  float delay,
  ROTT_Descriptor_Hero_Skill skillScript,
  optional bool bForceDelay = false
) 
{
  local QueuedActionInfo nextAction;
  local int i;
  
  // Set up queued action info
  nextAction.targets = targets;
  nextAction.queuedSkill = skillScript;
  
  // Queue actions
  for (i = 0; i < count; i++) {
    // Use delay if forced or queue in use
    if (bForceDelay || (queuedActions.length > 0)) {
      nextAction.delay = delay;
    } else {
      delay = 0.f;
    }
    
    // Add to queue
    queuedActions.addItem(nextAction);
  }
}

/*=============================================================================
 * processActionQueue()
 *
 * Handles triggering skill executions from the action queue 
 *===========================================================================*/
private function processActionQueue(float deltaTime) {
  // Check for queued actions
  if (queuedActions.length > 0) {
    // Track time until next action
    queuedActions[0].delay -= deltaTime;
    
    if (queuedActions[0].delay <= 0) {
      // Execute the skill
      if (
        queuedActions[0].queuedSkill.skillAction(
          queuedActions[0].targets,
          ROTT_Combat_Hero(self),
          QUEUED_ACTION_SET
        )
      ) sfxBox.playSFX(queuedActions[0].queuedSkill.secondarySfx);
      
      // Remove skill from queue
      queuedActions.remove(0, 1);
    }
  }
}

/*=============================================================================
 * recoverHealth()
 *
 * This is called to heal a unit, from glyphs or items, etc
 *===========================================================================*/
public function recoverHealth(float healValue, optional bool bReport = true) {
  // Cap the heal value
  if (healValue > subStats[MAX_HEALTH] - subStats[CURRENT_HEALTH]) {
    healValue = subStats[MAX_HEALTH] - subStats[CURRENT_HEALTH];
  }
  
  if (healValue == 0) return;
  
  // Heal the unit
  subStats[CURRENT_HEALTH] += healValue;
  
  // UI and statistics
  uiComponent.onHealthRecovered(healValue);
  if (bReport) reportHealthIncrease(healValue);
}

/*=============================================================================
 * reportHealthIncrease()
 *
 * This is called to report statistics for a health increase
 *===========================================================================*/
protected function reportHealthIncrease(float healValue);

/*=============================================================================
 * recoverMana()
 *
 * This is called to heal a units mana, from glyphs or items, etc
 *===========================================================================*/
public function recoverMana
(
  float healMana, 
  bool bReport,
  optional bool bManaRegen = false
) 
{
  local float manaOverflow;
  local int i;
  
  // Calculate overflow value
  manaOverflow = subStats[CURRENT_MANA] + healMana - subStats[MAX_MANA];
  if (manaOverflow < 0) manaOverflow = 0;
  
  // Cap the heal value
  if (healMana > subStats[MAX_MANA] - subStats[CURRENT_MANA]) {
    healMana = subStats[MAX_MANA] - subStats[CURRENT_MANA];
  }
  
  // Distribute overflow to active mods
  for (i = 0; i < activeMods.length; i++) {
    activeMods[i].addManaOverflow(manaOverflow);
  }
  
  // Heal the units mana
  if (healMana == 0) return;
  subStats[CURRENT_MANA] += healMana;
  
  // UI and statistics
  if (!bManaRegen) uiComponent.onManaRecovered(healMana);
  if (bReport) reportManaIncrease(healMana, bManaRegen);
}

/*=============================================================================
 * reportManaIncrease()
 *
 * This is called to report statistics for a mana increase
 *===========================================================================*/
protected function reportManaIncrease(float healMana, bool bManaRegen);

/*=============================================================================
 * diminishStat()
 *
 * This is called to reduce stat points, caused by various combat mechanics
 *===========================================================================*/
public function diminishStat(float value, MechanicTypes targetStat) {
  if (value == 0) return;
  
  // Dimish the stat (subtraction occurs in updateSubStats()
  statBoosts[targetStat] += value;
  
  // Show UI feedback
  if (uiComponent != none) uiComponent.onStatDiminished(value, targetStat);
}

/*=============================================================================
 * setLifePercent()
 *
 * Used by traps before combat to alter the unit's life
 *===========================================================================*/
public function setLifePercent(float percent) {
  subStats[CURRENT_HEALTH] = subStats[MAX_HEALTH] * percent;
}

/*=============================================================================
 * drainLife()
 *
 * This is called to directly drain life regardless of armor
 *===========================================================================*/
public function drainLife(float lifeDrain, optional bool bTrackBlackHoleDamage = false) {
  // Check resist state
  if (bTrackBlackHoleDamage && bResistingBlackHole) {
    // Cut damage by half
    lifeDrain /= 2;
  }
  
  // Track damage for UI number
  if (bTrackBlackHoleDamage) blackHoleDamage += lifeDrain; 
  
  // Drain life
  subStats[CURRENT_HEALTH] -= lifeDrain;
  updateSubStats();
}

/*=============================================================================
 * addResPoints()
 *
 * This is called from the resurrection skill to track res time
 *===========================================================================*/
public function addResPoints(float resPoints) {
  // Track res points
  subStats[RESURRECTION_CURRENT] += resPoints;
  
  // Resurrect on completion
  if (subStats[RESURRECTION_CURRENT] >= subStats[RESURRECTION_LIMIT]) {
    bDead = false;
    
    if (ROTT_Combat_Hero(self) != none) {
      setLifePercent(ROTT_Combat_Hero(self).const.RESURRECTION_PERCENT);
      uiComponent.removeStatus(ROTT_Descriptor_Hero_Skill(ROTT_Combat_Hero(self).getMasteryScript(MASTERY_RESURRECT)));
    }
    
    // Reset res points
    subStats[RESURRECTION_CURRENT] = 0;
  }
  
  updateSubStats();
}

/*=============================================================================
 * showBhDamage()
 *
 * This is called to display the black hole damage on screen
 *===========================================================================*/
public function showBhDamage(ROTT_Combat_Unit caster);

/*=============================================================================
 * improveStat()
 *
 * This is called to add bonus points to a stat
 *===========================================================================*/
public function improveStat(float value, MechanicTypes targetStat, optional bool bHideUI = false) {
  // Ignore zero change
  if (value == 0) return;
  
  // Provide the stat boost
  statBoosts[targetStat] += value;
  
  // Exit if no UI
  if (bHideUI) return;
  
  // Notify combat interface
  if (uiComponent != none) {
    uiComponent.improveStat(value, statBoosts[targetStat], targetStat);
  }
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
  local float dmgToMana;
  
  // Damage glyph statistic tracking
  caster.trackDamageGlyph(
    damage - damage * (100.0 / (100.0 + caster.statBoosts[AMPLIFY_NEXT_DAMAGE]))
  );
  
  // Reduce damage with armor if not atmospheric
  if (!bAtmosphericDamage) {
    damage -= subStats[ARMOR_RATING];
  }
  
  // Cap minimum damage between 2 and 3
  if (damage < 2) damage = 2 + rand(2); 
  
  // Damage to stat boost conversions
  ///improveStat(damage * statBoosts[ADD_MANA_REGEN_ON_DEFEND] / 100, ADD_EXTRA_MANA_REGEN);
  
  // Split damage for mana shield
  dmgToMana = damage * (statBoosts[ADD_MANA_SHIELD] / 100);
  if (subStats[CURRENT_MANA] < dmgToMana) dmgToMana = subStats[CURRENT_MANA];
  damage -= dmgToMana;
  
  // Deal damage
  subStats[CURRENT_HEALTH] -= damage;
  subStats[CURRENT_MANA] -= dmgToMana;
  if (meditationInfo != none) removeStatus(meditationInfo);
  timeWithoutDamage = 0;
  
  // Battle statistics tracking
  if (ROTT_Combat_Hero(self) != none) {
    ROTT_Combat_Hero(self).battleStatistics[INCOMING_DAMAGE] += damage;
  }
  
  // Animations
  uiComponent.takeDamageEffect();
  
  // Store attacking unit as last attacker
  lastAttacker = caster;
  
  // Show damage on the UI
  showDamageOnUI(damage, critAmp);
  showDamageOnUI(dmgToMana, critAmp, true);
  
  // Send feedback to caster
  caster.damageFeedback(damage, bAtmosphericDamage);
}

/*=============================================================================
 * trackDamageGlyph()
 *
 * Used to track how much damage has been added from damage glyphs
 *===========================================================================*/
public function trackDamageGlyph(float damage);

/*=============================================================================
 * updateSpeedAmp()
 *
 * Displays the speed to the UI
 *===========================================================================*/
protected function updateSpeedAmp() {
  if (uiComponent != none) uiComponent.updateSpeedAmp(getTunaAmp());
}

/*=============================================================================
 * damageFeedback()
 *
 * This is invoked by the target to tell the caster how much damage was dealt
 *===========================================================================*/
public function damageFeedback(int damage, optional bool bNoLeechNoAmp = false) {
  if (damage > 0) {
    if (!bNoLeechNoAmp) {
      // Reset temp damage amplifiers
      statBoosts[AMPLIFY_NEXT_DAMAGE] = 0;
      
      // Leech life and mana
      recoverHealth(
        damage * statBoosts[LEECH_HEALTH] / 100,
        NO_REPORT
      );
      recoverMana(
        damage * statBoosts[LEECH_MANA] / 100,
        NO_REPORT
      );
    }
    
    // Battle statistic tracking
    if (ROTT_Combat_Hero(self) != none) {
      ROTT_Combat_Hero(self).battleStatistics[OUTGOING_DAMAGE] += damage;
    }
  }
}

/*=============================================================================
 * showDamageOnUI()
 *
 * Makes a label with the damage info on screen
 *===========================================================================*/
protected function showDamageOnUI
(
  int damage, 
  float critAmp, 
  optional bool bDamageToMana = false
) 
{
  local bool bCrit;
  
  // Skip empty messages
  if (damage == 0) return;
  
  // Color code
  bCrit = (critAmp > 1.f);
  
  if (bDamageToMana) {
    // Damage to mana
    if (uiComponent != none) uiComponent.showDamageToMana(damage, bCrit);
  } else { 
    // Show damage to health
    if (uiComponent != none) uiComponent.showDamage(damage, bCrit);
  }
}

/*=============================================================================
 * sendAction()
 *
 * Returns: MANA_SUFFICIENT if sufficient mana, MANA_INSUFFICIENT otherwise
 *===========================================================================*/
public function bool sendAction(ChosenTargetEnum target);

/*============================================================================= 
 * Primary Stat Accessor
 *
 * This accessor provides vitality/strength/courage/focus values, with bonuses
 *===========================================================================*/
public function int getPrimaryStat(StatTypes statType) {
  local int stat;
  
  if (gameInfo.playerProfile == none) { scripttrace(); return 0; }
  
  stat = hardStats[statType];
  
  // Additive stat boosts
  switch (statType) {
    case PRIMARY_VITALITY: 
      stat += statBoosts[ADD_VITALITY]; 
      stat -= statBoosts[REDUCE_VITALITY]; 
      stat += heldItemStat(ITEM_ADD_VITALITY);
      break;
    case PRIMARY_STRENGTH: 
      stat += statBoosts[ADD_STRENGTH]; 
      stat -= statBoosts[REDUCE_STRENGTH]; 
      stat += heldItemStat(ITEM_ADD_STRENGTH);
      break;
    case PRIMARY_COURAGE:  
      stat += statBoosts[ADD_COURAGE]; 
      stat -= statBoosts[REDUCE_COURAGE]; 
      stat += heldItemStat(ITEM_ADD_COURAGE);
      break;
    case PRIMARY_FOCUS:    
      stat += statBoosts[ADD_FOCUS]; 
      stat -= statBoosts[REDUCE_FOCUS]; 
      stat += heldItemStat(ITEM_ADD_FOCUS);
      break;
  }
  
  // All stats modifier
  stat += statBoosts[ADD_ALL_STATS];
  
  // All stats Enchantment addition
  if (ROTT_Combat_Hero(self) != none) {
    stat += gameInfo.playerProfile.getEnchantBoost(INFINITY_JEWEL);
  }
  
  // All stats held item boost
  stat += heldItemStat(ITEM_ADD_ALL_STATS);
  
  // Multiplicative stat boosts
  switch (statType) {
    case PRIMARY_STRENGTH: 
      stat *= 1.0 + statBoosts[ADD_STRENGTH_PERCENT] / 100.f;
      break;
    case PRIMARY_COURAGE:  
      stat *= 1.0 + statBoosts[ADD_COURAGE_PERCENT] / 100.f;
      break;
  }
  
  // Clamp
  if (stat < 1) stat = 1;
  
  return stat;
}

/*============================================================================= 
 * heldItemStat()
 *
 * Returns an attribute boost value from held item
 *===========================================================================*/
public function float heldItemStat(EquipmentAttributes attributeIndex) {
  return 0;
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
  local float oldMaxHP, oldMaxMP;
  
  // Ignore dead units except for resurrection display update
  if (bDead) {
    if (uiComponent != none) uiComponent.updateDisplay();
    return;
  }
  
  // Get max health and mana, prior to update
  oldMaxHP = subStats[MAX_HEALTH];
  oldMaxMP = subStats[MAX_MANA];
  
  // Call update subroutines for primary stats and corresponding substats
  updateVitality(
    // Fetch vitality
    getPrimaryStat(PRIMARY_VITALITY),
    
    // Fetch affinity amplifier
    affinity[MAX_HEALTH].amp[statAffinities[PRIMARY_VITALITY]],
    
    // Health enchantment from arcane blood prism 
    gameInfo.playerProfile.getEnchantBoost(ARCANE_BLOODPRISM) / 100.f
  );
  updateStrength(
    // Fetch strength
    getPrimaryStat(PRIMARY_STRENGTH),
  
    // Fetch affinity damage amplifier
    affinity[MIN_PHYSICAL_DAMAGE].amp[statAffinities[PRIMARY_STRENGTH]],
    
    // Physical damage enchantment
    gameInfo.playerProfile.getEnchantBoost(SCORPION_TALON) / 100.f
  );
  updateCourage(
    // Fetch courage
    getPrimaryStat(PRIMARY_COURAGE),
    
    // Fetch attack interval amplifier
    affinity[TOTAL_ATK_INTERVAL].amp[statAffinities[PRIMARY_COURAGE]],
    
    // Fetch critical amplifiers
    affinity[CRIT_MULTIPLIER].amp[statAffinities[PRIMARY_COURAGE]],
    affinity[CRIT_CHANCE].amp[statAffinities[PRIMARY_COURAGE]],
    
    // Fetch accuracy amplifiers
    affinity[ACCURACY_RATING].amp[statAffinities[PRIMARY_COURAGE]]
  );
  updateFocus(
    // Fetch focus
    getPrimaryStat(PRIMARY_FOCUS),
    
    // Fetch max mana amplifier
    affinity[MAX_MANA].amp[statAffinities[PRIMARY_FOCUS]],
    
    // Fetch dodge amplifier
    affinity[DODGE_RATING].amp[statAffinities[PRIMARY_FOCUS]],
    
    // Fetch spiritual burden amplifier
    affinity[MORALE_THRESHOLD].amp[statAffinities[PRIMARY_FOCUS]],
    
    // Mana enchantment from mystic marble
    gameInfo.playerProfile.getEnchantBoost(MYSTIC_MARBLE) / 100.f
  );
  
  // Catch all update to various other stats
  updateMiscStats(
    // Armor enchantment from mystic marble
    gameInfo.playerProfile.getEnchantBoost(SERPENTS_ANCHOR)
  );
  
  // Cap minimum and maximum values
  updateStatCaps(
    oldMaxHP,
    oldMaxMP
  );
  
  // Update display
  if (uiComponent != none) uiComponent.updateDisplay();
  
  // Check if unit has become demoralized during this routine
  if (bDemoralizedStatus == false && isDemoralized()) {
    setStatusDemoralized(true);
  }
  if (bDemoralizedStatus == true && !isDemoralized()) {
    setStatusDemoralized(false);
  }
}

/*============================================================================= 
 * updateVitality()
 *
 * Updates vitality, and related substats
 *===========================================================================*/
public function updateVitality(int vit, float hpAmp, float bloodPrism) {
  local float hpMultiplier;
  
  // Calculate max health
  subStats[MAX_HEALTH] = baseHealth + vit * hpAmp;
  
  // Copy max res limit before enhancements
  subStats[RESURRECTION_LIMIT] = subStats[MAX_HEALTH]; 
  
  // Apply boosts
  subStats[MAX_HEALTH] += statBoosts[ADD_MAX_HEALTH];
  subStats[MAX_HEALTH] += getPassiveBoost(PASSIVE_HEALTH_BOOST);
  subStats[MAX_HEALTH] += heldItemStat(ITEM_ADD_HEALTH);
  
  // Set up health multiplier
  hpMultiplier = heldItemStat(ITEM_MULTIPLY_HEALTH) / 100;
  
  // Enchantment
  if (ROTT_Combat_Hero(self) != none) {
    hpMultiplier += bloodPrism;
  }
  
  // Apply health multiplier
  subStats[MAX_HEALTH] += subStats[MAX_HEALTH] * hpMultiplier;
}

/*============================================================================= 
 * updateStrength()
 *
 * Updates Strength, and related substats
 *===========================================================================*/
public function updateStrength(int strength, int affinityCut, float scorpionTalon);

/*============================================================================= 
 * updateCourage()
 *
 * Updates courage, and related substats
 *===========================================================================*/
public function updateCourage
(
  int crg, 
  float speedAmp, 
  float critDmgAmp, 
  float critChanceAmp, 
  float accAmp
) 
{
  
  // Calculate attack interval
  subStats[TOTAL_ATK_INTERVAL] = getAtkInterval(crg, speedAmp);
  
  // Calculate critical hit
  subStats[CRIT_CHANCE] = float(int((crg / critChanceAmp) + baseCritChance));
  subStats[CRIT_MULTIPLIER] = critDmgAmp;
  
  // Calculate accuracy rating
  subStats[ACCURACY_RATING] = 40 + (crg * accAmp) + (level * 5.0);
  subStats[ACCURACY_RATING] += statBoosts[ADD_ACCURACY];
  subStats[ACCURACY_RATING] -= statBoosts[REDUCE_ACCURACY];
  subStats[ACCURACY_RATING] += getPassiveBoost(PASSIVE_ACCURACY_BOOST);
  
  // Add accuracy enchantment
  if (ROTT_Combat_Hero(self) != none) {
    subStats[ACCURACY_RATING] += gameInfo.playerProfile.getEnchantBoost(GRIFFINS_TRINKET);
  }
  
  // Add accuracy boost from held item
  subStats[ACCURACY_RATING] += heldItemStat(ITEM_ADD_ACCURACY);
  
}

/*============================================================================= 
 * updateFocus()
 *
 * Updates focus, and related substats
 *===========================================================================*/
public function updateFocus
(
  int foc, 
  float mpAmp, 
  float dodgeAmp,  
  float moraleAmp,
  float mysticMarble
) 
{
  // Calculate max mana
  subStats[MAX_MANA] = baseMana + foc * mpAmp;
  subStats[MAX_MANA] += statBoosts[ADD_MAX_MANA];
  subStats[MAX_MANA] += getPassiveBoost(PASSIVE_MANA_BOOST);
  
  // Add mana boost from held item
  subStats[MAX_MANA] += heldItemStat(ITEM_ADD_MANA);
  
  // Apply enchantment related mana increase
  if (ROTT_Combat_Hero(self) != none) {
    subStats[MAX_MANA] += subStats[MAX_MANA] * mysticMarble;
  }
  
  // Multiply mana boost from held item
  subStats[MAX_MANA] *= 1 + heldItemStat(ITEM_MULTIPLY_MANA) / 100.f;
  
  // Calculate dodge rating
  subStats[DODGE_RATING] = 5 + (foc * dodgeAmp) + (level * 4); 
  subStats[DODGE_RATING] += statBoosts[ADD_DODGE];
  subStats[DODGE_RATING] -= statBoosts[REDUCE_DODGE];
  subStats[DODGE_RATING] += getPassiveBoost(PASSIVE_DODGE_BOOST);
  
  // Add dodge enchantment
  if (ROTT_Combat_Hero(self) != none) {
    subStats[DODGE_RATING] += gameInfo.playerProfile.getEnchantBoost(GRIFFINS_TRINKET);
  }
  
  // Add dodge boost from held item
  subStats[DODGE_RATING] += heldItemStat(ITEM_ADD_DODGE);
  
  // Cap dodge
  if (subStats[DODGE_RATING] < 5) {
    subStats[DODGE_RATING] = 5;
  }
  
  // Calculate morale threshold
  subStats[MORALE_THRESHOLD] = 500 / (5 + 10 ** (4 / (3 + level) + (foc * moraleAmp / 3) / (3 + level)));
  
}

/*============================================================================= 
 * updateMiscStats()
 *
 * Updates various stats
 *===========================================================================*/
public function updateMiscStats
(
  float serpentsAnchor
) 
{
  // Baseline armor
  subStats[ARMOR_RATING] = armorPerLvl * level; 
  
  // Add armor boosts
  subStats[ARMOR_RATING] += getPassiveBoost(PASSIVE_ARMOR_BOOST);
  subStats[ARMOR_RATING] += statBoosts[ADD_ARMOR];
  
  // Add enchantment boosts
  if (ROTT_Combat_Hero(self) != none) {
    // Apply enchantment related armor increase
    subStats[ARMOR_RATING] += serpentsAnchor;
  }
  
  // Add armor boost from held item
  subStats[ARMOR_RATING] += heldItemStat(ITEM_ADD_ARMOR);
  
  // Add ritual boosts
  addRitualBoosts();
  
  // Subtract armor debuffs
  subStats[ARMOR_RATING] -= statBoosts[REDUCE_ARMOR];
}

/*============================================================================= 
 * updateStatCaps()
 *
 * Applies a cap to minimum and maximum stat values
 *===========================================================================*/
public function updateStatCaps
(
  float oldMaxHP, float oldMaxMP
) 
{
  // Cap max health
  if (subStats[CURRENT_HEALTH] > subStats[MAX_HEALTH]) {
    subStats[CURRENT_HEALTH] = subStats[MAX_HEALTH];
  }
  
  // Cap max mana
  if (subStats[CURRENT_MANA] > subStats[MAX_MANA]) {
    subStats[CURRENT_MANA] = subStats[MAX_MANA];
  }
  
  // Cap attack interval
  if (subStats[ELAPSED_ATK_TIME] > currentAtkInterval) {
    subStats[ELAPSED_ATK_TIME] = currentAtkInterval;
  }
  
  // Check for death, and cap minimum health
  if (subStats[CURRENT_HEALTH] <= 0) {
    // Cap value
    subStats[CURRENT_HEALTH] = 0;
    
    // Call unit death sequence
    onDeath();
  }
  
  // Minimum mana cap
  if (subStats[CURRENT_MANA] < 0) {
    subStats[CURRENT_MANA] = 0;
  }
  
  // Maximum mana shield cap
  if (statBoosts[ADD_MANA_SHIELD] > 100) {
    statBoosts[ADD_MANA_SHIELD] = 100;
  }
  
  // Cap accuracy
  if (subStats[ACCURACY_RATING] < 5) {
    subStats[ACCURACY_RATING] = 5;
  }
  
  // Cap minimum armor
  if (subStats[ARMOR_RATING] < 0) {
    subStats[ARMOR_RATING] = 0;
  }
  
  // Scale up health and mana if max values have increased
  if (subStats[MAX_HEALTH] - oldMaxHP > 0) {
    subStats[CURRENT_HEALTH] += subStats[MAX_HEALTH] - oldMaxHP;
  }
  if (subStats[MAX_MANA] - oldMaxMP > 0) {
    subStats[CURRENT_MANA] += subStats[MAX_MANA] - oldMaxMP;
  }
}

/*============================================================================= 
 * addRitualBoosts()
 *
 * Provides boosts from rituals
 *===========================================================================*/
public function addRitualBoosts();
  
/*=============================================================================
 * addStatus()
 *
 * Called to add a status to be displayed in by this label
 *===========================================================================*/
public function addStatus(ROTT_Descriptor_Hero_Skill skillInfo) {
  if (uiComponent != none) uiComponent.addStatus(skillInfo);
}

/*=============================================================================
 * removeStatus()
 *
 * Called to remove a status from being displayed by this label
 *===========================================================================*/
public function removeStatus(ROTT_Descriptor_Hero_Skill skillInfo) {
  if (skillInfo == none) scripttrace();
  if (uiComponent != none) uiComponent.removeStatus(skillInfo);
}

/*=============================================================================
 * setStatusDemoralized()
 *
 * Called to set the demoralized status
 *===========================================================================*/
public function setStatusDemoralized(bool bEnabled) {
  // Store status
  bDemoralizedStatus = bEnabled;
  
  if (uiComponent != none) uiComponent.setStatusDemoralized(bEnabled);
}

/*=============================================================================
 * onDeath()
 *
 * This function is called when the unit dies
 *===========================================================================*/
protected function onDeath() {
  if (bDead == true) {
    yellowLog("Warning (!) Attempt to call onDeath() on dead unit");
    return;
  }
  
  bDead = true;
  
  subStats[ELAPSED_ATK_TIME] = 0;
  subStats[CURRENT_HEALTH] = 0;
  subStats[CURRENT_MANA] = 0;
  
  bActionReady = false;
  
  // Reset time scalar
  statBoosts[ADD_ATTACK_TIME_PERCENT] = 0;
  updateSpeedAmp();
  
  // Clear demoralization
  if (uiComponent != none) {
    uiComponent.setStatusDemoralized(false);
  }
  
  // Show death on displayer
  uiComponent.onDeath();
}

/*=============================================================================
 * addDemoralization()
 *
 * Adds demoralization effect based on input power
 *===========================================================================*/
public function addDemoralization(int power) {
  local float time;
  
  // Reduce power by resistance per level
  power -= level * 20;
  
  // Calculate time
  time = power / 20.f;
  
  // Add demoralization time
  timedEffect[DEMORALIZE] += time;
}

/*=============================================================================
 * isDemoralized()
 *
 * Returns true if morality is broken through health loss or spell effects
 *===========================================================================*/
public function bool isDemoralized() {
  // Check override effects
  if (timedEffect[DEMORALIZE] > 0) return true;
  
  // Check if health is less than threshold
  if (getHealthRatio() < getMoraleRatio()) {
    return true;
  }
  
  return false;
}

/*=============================================================================
 * getMoraleRatio()
 *
 * Returns the morale ratio
 *===========================================================================*/
public function float getMoraleRatio() {
  return subStats[MORALE_THRESHOLD] / 100;
}

/*=============================================================================
 * getAtkInterval()
 *
 * Calculates attack interval (in seconds)
 *===========================================================================*/
private function float getAtkInterval(float crg, float affinityAmp, optional bool bSkipCheck = false) {
  local float speedPoints, atkInterval;
  
  // Initial speed points
  speedPoints = crg * affinityAmp + 10;
  
  // Add skill based speed points
  speedPoints += getPassiveBoost(PASSIVE_SPEED_BOOST);
  
  // Add speed points from item
  speedPoints += heldItemStat(ITEM_ADD_SPEED);
  
  // Speed points modifiers from skills and glyphs
  speedPoints += statBoosts[ADD_SPEED];
  speedPoints -= statBoosts[REDUCE_SPEED];
  
  // Subtract enchantment speed points for enemies
  if (ROTT_Combat_Enemy(self) != none) {
    speedPoints -= gameInfo.getActiveParty().getEnemySpeedReduction();
  }
  
  // Demoralized penalty
  if (isDemoralized() && !bSkipCheck) speedPoints = speedPoints * 2 / 3;
  
  // Safety net
  if (speedPoints < 2) speedPoints = 2;
  
  // Double horizontal asymptote equation bound from 2 to 10 seconds
  atkInterval = (1.0 / (level + 3));
  atkInterval *= (speedPoints - ((level + 3) * 4.0));
  atkInterval += 2;
  atkInterval = 2 ** atkInterval;
  atkInterval += 1;
  atkInterval = 1 / atkInterval;
  atkInterval *= 8;
  atkInterval += 2;
  
  return atkInterval;
}

/*=============================================================================
 * getSpeedImprovement()
 *
 * Reports the time improvement from first to last attack interval
 *===========================================================================*/
public function float getSpeedImprovement() {
  local float lastAtkInterval;
  
  // Calculate attack interval without demoralization penalty, for statistics
  lastAtkInterval = getAtkInterval(
    getPrimaryStat(PRIMARY_COURAGE), 
    affinity[TOTAL_ATK_INTERVAL].amp[statAffinities[PRIMARY_COURAGE]], 
    true
  );
  
  return firstAtkInterval - lastAtkInterval;
}

/*=============================================================================
 * onTargeted()
 *
 * Called when a combat action is being performed with this unit as target.
 *===========================================================================*/
public function onTargeted(ROTT_Combat_Unit caster);

/*=============================================================================
 * getChanceToHit()
 *
 * Given a target, this randomly rolls a hit chance and returns true if hit.
 *===========================================================================*/
public function bool getChanceToHit(ROTT_Combat_Unit target) {
  local float roll, hitChance;
  local float dodge, accuracy;
  
  roll = rand(100);
  
  // Call targeting trigger
  target.onTargeted(self);
  
  // Get accuracy and dodge
  accuracy = subStats[ACCURACY_RATING];
  dodge = target.subStats[DODGE_RATING];
  
  // Hit chance equation
  hitChance = 1.0 / (1.0 + (10.0 ** ((dodge - accuracy) / dodge - 0.35)));
  hitChance *= 0.80;
  hitChance += 0.20;
  hitChance *= 100;
  
  return (roll < hitChance);
}

/*=============================================================================
 * rollCritAmp()
 *
 * This is called in combat to perform critical strike rolls, and returns the
 * critical damage amp.
 *===========================================================================*/
public function float rollCritAmp() {
  local float critChance;
  local float critAmp;
  
  // Initial crit amplifier
  critAmp = 1.0;
  
  // Add and reset temp crit boost
  critChance = subStats[CRIT_CHANCE] + statBoosts[ADD_NEXT_CRIT_CHANCE];
  statBoosts[ADD_NEXT_CRIT_CHANCE] = 0;
  
  // Roll for increases in crit amp from crit chance until depleted
  while (critChance > 0) {
    if (critChance > CRIT_THRESHOLD) {
      if (rand(100) < CRIT_THRESHOLD) critAmp *= subStats[CRIT_MULTIPLIER];
      critChance -= CRIT_THRESHOLD;
    } else {
      if (rand(100) < critChance) critAmp *= subStats[CRIT_MULTIPLIER];
      critChance -= critChance;
    }
  }
  
  return critAmp;
}

/*=============================================================================
 * getCritRolls()
 *
 * This is called for the UI to display the number of crit rolls.  When crit
 * chance exceeds crit threshold, it allows the crit to be rolled again.
 *===========================================================================*/
public function int getCritRolls() {
  return 1 + subStats[CRIT_CHANCE] / CRIT_THRESHOLD;
}

/*=============================================================================
 * getHealthRatio()
 *
 * Returns a percentage to represent the units current health
 *===========================================================================*/
public function float getHealthRatio() {
  if (subStats[MAX_HEALTH] == 0) return 0;  // No division by zero
  
  return subStats[CURRENT_HEALTH] / subStats[MAX_HEALTH];
}

/*=============================================================================
 * getManaRatio()
 *
 * Returns a percentage to represent the units current mana
 *===========================================================================*/
public function float getManaRatio() {
  if (subStats[MAX_MANA] == 0) return 0;  // No division by zero
  
  return subStats[CURRENT_MANA] / subStats[MAX_MANA];
}

/*=============================================================================
 * getResurrectRatio()
 *
 * Returns the completion percent for the resurrection of this unit
 *===========================================================================*/
public function float getResurrectRatio() {
  if (subStats[RESURRECTION_LIMIT] == 0) return 0;  // No division by zero
  
  return subStats[RESURRECTION_CURRENT] / subStats[RESURRECTION_LIMIT];
}

/*=============================================================================
 * getTunaRatio()
 *
 * Returns a percentage to represent the time until next attack
 *===========================================================================*/
public function float getTunaRatio() {
  if (currentAtkInterval == 0) return 0;  // No division by zero
  
  return subStats[ELAPSED_ATK_TIME] / currentAtkInterval;
}

/*=============================================================================
 * resetTuna()
 *
 * This function resets the attack time bar after using a combat action
 *===========================================================================*/
public function resetTuna() {
  // Check TUNA modifiers from current stance
  updateSubStats();

  // Check for persistence
  if (!checkTunaAmpTag("Persistence")) {
    // Remove persistence from UI
    if (ROTT_UI_Displayer_Combat_Hero(uiComponent) != none) {
      ROTT_UI_Displayer_Combat_Hero(uiComponent).removeStatusManually("Persisting");
    }
  }
  
  // Assign current attack interval from the calculated interval
  if (statBoosts[OVERRIDDEN_ATTACK_TIME] == 0) {
    currentAtkInterval = subStats[TOTAL_ATK_INTERVAL] * getTunaAmp();
  } else {
    currentAtkInterval = statBoosts[OVERRIDDEN_ATTACK_TIME];
  }
  
  updateSpeedAmp();
  decrementTunaAmpSteps();
  
  // Reset TUNA
  subStats[ELAPSED_ATK_TIME] = 0;
  bActionReady = false;
}

/*=============================================================================
 * moraleRoll()
 *
 * This is a random roll that is zero when morality is broken
 *===========================================================================*/
public function int moraleRoll(coerce int range) {
  return rand(range);
}

/*=============================================================================
 * restore()
 *
 * This function restores both health and mana
 *===========================================================================*/
public function restore() {
  // Ignore on  hardcore mode
  if (bDead && gameInfo.playerProfile.gameMode == MODE_HARDCORE) return;
  
  // Revert death state
  bDead = false;
  
  // Update all stats (e.g. health and mana)
  subStats[CURRENT_HEALTH] = 1; // Prevent dead state
  updateSubStats();
  
  // Restore health and mana
  subStats[CURRENT_HEALTH] = subStats[MAX_HEALTH];
  subStats[CURRENT_MANA] = subStats[MAX_MANA];
}

/*=============================================================================
 * elapseTime()
 *
 * This function is called every tick while combat is active.
 *===========================================================================*/
public function elapseTime(float deltaTime) {
  local float h, d;
  local int i;
  
  // Track timed ailments
  trackTimedAilments(deltaTime);
  
  // Meditation UI feedback
  if (timeWithoutDamage < 5 && timeWithoutDamage + deltaTime >= 5) {
    if (statBoosts[MEDITATION_REGEN] > 0) {
      addStatus(meditationInfo);
    }
  }
  
  // Track time since last attack
  timeWithoutDamage += deltaTime;
  
  // Time delayed mechanics
  for (i = pendingMechs.length - 1; i >= 0; i--) {
    // Track delay time
    pendingMechs[i].delay -= deltaTime;
    
    // Parse skill mechanics after delay
    if (pendingMechs[i].delay <= 0) {
      parseMechanics(pendingMechs[i].mechanics, pendingMechs[i].caster);
      pendingMechs.remove(i, 1);
    }
  }
  
  // Timed effects
  for (i = 0; i < TimeEffects.enumCount; i++) {
    if (timedEffect[i] > 0) {
      timedEffect[i] -= deltaTime;
      if (timedEffect[i] < 0) timedEffect[i] = 0;
    }
  }
  
  // Check if ready to elapse time on TUNA
  if (!bActionReady && !bPauseTuna && !(timedEffect[STUN] > 0)) {
    
    // Elapse time on TUNA bar
    subStats[ELAPSED_ATK_TIME] += deltaTime;
    
    // Check if full TUNA
    if (subStats[ELAPSED_ATK_TIME] >= currentAtkInterval) {
      // Cap TUNA bar
      subStats[ELAPSED_ATK_TIME] = currentAtkInterval;
      
      // Call completion routine
      attackTimeComplete();
    }
  }
  
  // Mana regen
  recoverMana(
    statBoosts[ADD_MANA_REGEN] * deltaTime,
    REPORT_STAT,
    REPORT_REGEN
  );

  // Mana regen with no statistics tracking
  recoverMana(
    (statBoosts[ADD_EXTRA_MANA_REGEN] + heldItemStat(ITEM_ADD_MANA_REGEN)) * deltaTime,
    NO_REPORT,
    true /// hacky, true will hide the UI report
  );
  
  // Health drain
  subStats[CURRENT_HEALTH] -= statBoosts[ADD_HEALTH_DRAIN] * deltaTime; 
  
  // Health regen
  h = statBoosts[ADD_HEALTH_REGEN];
  if (timeWithoutDamage > 5) h += statBoosts[MEDITATION_REGEN];
  h += getPassiveBoost(PASSIVE_HEALTH_REGEN);
  h += heldItemStat(ITEM_ADD_HEALTH_REGEN);
  h -= getPassiveBoost(HEALTH_LOSS_OVER_TIME);
  h *= deltaTime;
  d = subStats[MAX_HEALTH] - subStats[CURRENT_HEALTH];
  if (h > d) h = d;
  subStats[CURRENT_HEALTH] += h;
  
  // Queued actions
  processActionQueue(deltaTime);
  
  // Update results from effects
  updateSubStats();
}

/*=============================================================================
 * trackTimedAilments()
 *
 * Called each tick to manage timed temporary ailments
 *===========================================================================*/
private function trackTimedAilments(float deltaTime) {
  local float effectTime;
  local int i;
  
  for (i = temporaryAilments.length - 1; i >= 0 ; i--) {
    // Track time
    temporaryAilments[i].remainingTime -= deltaTime;
    
    // Check if ailment time complete
    if (temporaryAilments[i].remainingTime <= 0) {
      // Get effect time
      effectTime = deltaTime + temporaryAilments[i].remainingTime;
      
      // Execute ailment mechanic
      executeAilmentEffect(temporaryAilments[i], effectTime);
      
      // remove effect
      temporaryAilments.remove(i, 1);
    } else {
      // Get effect time
      effectTime = deltaTime;
      
      // Execute ailment mechanic
      executeAilmentEffect(temporaryAilments[i], effectTime);
      
    }
  }
};

/*=============================================================================
 * executeAilmentEffect()
 *
 * Given an ailment and a time, this applies the ailment effects
 *===========================================================================*/
protected function executeAilmentEffect(AilmentInfo ailment, float time) {
  switch (ailment.ailmentMechanic) {
    case MANA_DRAIN_OVER_TIME:
      // Drain mana
      subStats[CURRENT_MANA] -= ailment.ailmentAmp * time;
      
      // Cap mana
      if (subStats[CURRENT_MANA] <= 0) subStats[CURRENT_MANA] = 0;
      break;
    default:
      yellowLog("Warning (!) Unhandled ailment mechanic: " $ ailment.ailmentMechanic);
      break;
  }
}

/*=============================================================================
 * addAilment()
 *
 * Adds an effect for a given period of time
 *===========================================================================*/
public function addAilment(MechanicTypes ailmentMechanic, float amp, float time) {
  local AilmentInfo newAilment;
  
  // Create ailment
  newAilment.ailmentMechanic = ailmentMechanic;
  newAilment.ailmentAmp = amp;
  newAilment.remainingTime = time;
  
  // Add ailment
  temporaryAilments.addItem(newAilment);
}

/*=============================================================================
 * attackTimeComplete
 *
 * Called when the attack time bar reaches its maximum
 *===========================================================================*/
protected function attackTimeComplete();

/*=============================================================================
 * setTUNA
 *
 * Used to set an initial time until next attack
 *===========================================================================*/
public function setTUNA(float tunaRatio) {
  // Skip for dead units
  if (bDead) return;
  updateSubStats();
  currentAtkInterval = subStats[TOTAL_ATK_INTERVAL];
  
  // Set elapsed time
  subStats[ELAPSED_ATK_TIME] = tunaRatio * currentAtkInterval;
  
  // Reset action ready state
  bActionReady = false;
}

/*=============================================================================
 * addPendingPacket
 *
 * Used to queue up some mechanics with a time delay
 *===========================================================================*/
public function addPendingPacket
(
  ROTT_Combat_Mechanics mechanics, 
  ROTT_Combat_Unit caster, 
  float delay
) 
{
  local PendingMechanics newMech;
  
  // Check validity of mechanics
  if (mechanics == none) { redlog("Error: Missing mechanics"); return; }
  
  // Setup the new entry item
  newMech.mechanics = mechanics;
  newMech.caster = caster;
  newMech.delay = delay;
  
  // Add the mechanics to the pending list
  pendingMechs.addItem(newMech);
}

/*=============================================================================
 * Debug hp/mp/tuna
 *===========================================================================*/
public function debugHpMpTuna(float deltaTime) {
  subStats[CURRENT_HEALTH] += 1 * deltaTime;
  subStats[CURRENT_MANA] += 1 * deltaTime;
  subStats[CURRENT_HEALTH] = subStats[CURRENT_HEALTH] % subStats[MAX_HEALTH];
  subStats[CURRENT_MANA] = subStats[CURRENT_MANA] % subStats[MAX_MANA];
  
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  currentStance=NORMAL
  
  // Vitality Affinity Amplifiers
  affinity(MAX_HEALTH)=(amp[MINOR]=8, amp[AVERAGE]=10, amp[MAJOR]=12)
  
  // Strength Affinity Amplifiers
  affinity(MIN_PHYSICAL_DAMAGE)=(amp[MINOR]=8, amp[AVERAGE]=6, amp[MAJOR]=5)
  affinity(MAX_PHYSICAL_DAMAGE)=(amp[MINOR]=8, amp[AVERAGE]=6, amp[MAJOR]=5)
  
  // Courage Affinity Amplifiers
  affinity(TOTAL_ATK_INTERVAL)=(amp[MINOR]=0.8, amp[AVERAGE]=1, amp[MAJOR]=1.15)
  affinity(CRIT_CHANCE)=(amp[MINOR]=5, amp[AVERAGE]=3, amp[MAJOR]=2)
  affinity(CRIT_MULTIPLIER)=(amp[MINOR]=1.2, amp[AVERAGE]=1.2, amp[MAJOR]=1.2) 
  affinity(ACCURACY_RATING)=(amp[MINOR]=1.5, amp[AVERAGE]=1.65, amp[MAJOR]=1.9)
  
  // Courage Affinity Amplifiers
  affinity(DODGE_RATING)=(amp[MINOR]=1.5, amp[AVERAGE]=1.65, amp[MAJOR]=1.9)
  affinity(MORALE_THRESHOLD)=(amp[MINOR]=1, amp[AVERAGE]=1.5, amp[MAJOR]=2)
  affinity(MAX_MANA)=(amp[MINOR]=5, amp[AVERAGE]=8, amp[MAJOR]=14)  
  
}


 
 



















