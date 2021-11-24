class ROTT_Combat_Object extends ROTT_Object;

const MANA_SUFFICIENT = true;
const MANA_INSUFFICIENT = false;

const IGNORE_ARMOR_RATING = true;

enum ChosenTargetEnum {
  TARGET_HERO_1,        // I am not a fan of having these numbers hard coded
  TARGET_HERO_2,        // hoping to think of something cleaner without adding parameters
  TARGET_HERO_3,
  TARGET_ALL_HEROES,
  TARGET_ENEMY_1,
  TARGET_ENEMY_2,
  TARGET_ENEMY_3,
  TARGET_ALL_ENEMIES,
  TARGET_LAST_ATTACKER,
  TARGET_ARENA,
  TARGET_NONE
};

enum StatAffinity {
  WEAK_BENEFIT,
  AVERAGE_BENEFIT,
  STRONG_BENEFIT
};
 
enum StanceType {
  NORMAL,
  DEFENDING,
  RETALIATION,
  SWIFT_STANCE
};

enum GlyphEnum {
  NO_GLYPH,
  
  GLYPH_ARMOR,
  GLYPH_HEALTH,
  GLYPH_MANA,
  GLYPH_DAMAGE,
  GLYPH_SPEED,
  GLYPH_MANA_REGAIN,
  GLYPH_ACCURACY,
  GLYPH_DODGE,
  
  GLYPH_GOLIATH_COUNTER,
  GLYPH_WIZARD_SPECTRAL_SURGE,
  GLYPH_VALKYRIE_RETALIATION,
  GLYPH_TITAN_STORM
  
};

enum MechanicTypes {
  // Mana cost
  REDUCE_MANA,
  
  // Damage
  PHYSICAL_DAMAGE,
  ELEMENTAL_DAMAGE,
  ATMOSPHERIC_DAMAGE,
  
  // Damage boosts
  AMPLIFY_NEXT_DAMAGE,
  ELEMENTAL_DAMAGE_IF_DEMORALIZED,
  ELEMENTAL_MULTIPLIER,
  PHYSICAL_MULTIPLIER,
  TARGET_DEMORALIZED_AMP,
  
  // Stat recovery
  RECOVER_HEALTH,
  RECOVER_MANA,
  ADD_MANA_REGEN,
  ADD_MANA_REGEN_ON_DEFEND,
  MANA_REGEN_FROM_DAMAGE_RATIO,
  ADD_EXTRA_MANA_REGEN,
  ADD_HEALTH_REGEN,
  REGEN_HEALTH_WHILE_DEFENDING,
  REGEN_MANA_WHILE_DEFENDING,
  
  // Stat draining
  ADD_HEALTH_DRAIN,
  MANA_TRANSFER_DRAIN,
  MANA_BURN_ALL_ENEMIES,
  
  // Demoralization
  DEMORALIZE_POWER,
  DEMORALIZE_POWER_NO_STACK,
  
  // Leech
  LEECH_HEALTH, 
  LEECH_MANA,
  
  // Misc
  ADD_STUN,
  ADD_NEXT_CRIT_CHANCE,
  ADD_TARGET,
  CUT_LIFE_BY_PERCENT,
  ADD_ATTACK_TIME_PERCENT,
  OVERRIDDEN_ATTACK_TIME,
  ADD_MANA_SHIELD,
  MEDITATION_REGEN,
  
  // Temporary Drains
  MANA_DRAIN_OVER_TIME,
  
  // Stat reducers
  REDUCE_VITALITY,
  REDUCE_STRENGTH,
  REDUCE_COURAGE,
  REDUCE_FOCUS,
  
  REDUCE_SPEED,
  REDUCE_ACCURACY,
  REDUCE_DODGE,
  REDUCE_ARMOR,
  
  // Stat increasers
  ADD_VITALITY,
  ADD_STRENGTH,
  ADD_COURAGE,
  ADD_FOCUS,
  ADD_ALL_STATS,
  
  ADD_SPEED,
  ADD_ACCURACY,
  ADD_DODGE,
  ADD_ARMOR,
  
  ADD_STRENGTH_PERCENT,
  ADD_COURAGE_PERCENT,
  
  ADD_MAX_HEALTH,
  ADD_MAX_MANA,
  
  ADD_MIN_PHYS_DAMAGE,
  ADD_MAX_PHYS_DAMAGE,
  
};
 
// Substats
enum SubStatTypes {
  CURRENT_HEALTH,
  MAX_HEALTH,
  
  MIN_PHYSICAL_DAMAGE,
  MAX_PHYSICAL_DAMAGE,
  
  ELAPSED_ATK_TIME,
  TOTAL_ATK_INTERVAL,
  CRIT_CHANCE,
  CRIT_MULTIPLIER,
  ACCURACY_RATING,
  
  CURRENT_MANA,
  MAX_MANA,
  DODGE_RATING,
  MORALE_THRESHOLD,
  
  RESURRECTION_CURRENT,
  RESURRECTION_LIMIT,
  
  HEALTH_REGEN,
  MANA_REGEN,
  
  ARMOR_RATING
};

// A list of all skills in the glyph tree
enum GlyphSkills {
  GLYPH_TREE_ARMOR,
  GLYPH_TREE_HEALTH,
  GLYPH_TREE_MANA,
  GLYPH_TREE_DAMAGE,
  GLYPH_TREE_SPEED,
  GLYPH_TREE_MP_REGEN,
  GLYPH_TREE_ACCURACY,
  GLYPH_TREE_DODGE
};

// Range used for combat mechanics
struct MechanicRange {
  var float min;
  var float max;
  var bool enabled;
};

// Combat packet info
/*
struct CombatMechanic {
  var MechanicTypes packetType;
  var float value;
  var FloatRange range;
};
*/

// This is what combat actions produce, it carries all the skill mechanics info
struct ActionPacket {
  var int hitChance;
  var bool bTrackActionStatistics;
  var bool bDebuff;
  var bool bAtmospheric;
  var UI_Texture_Storage skillAnim;
  var ROTT_Combat_Mechanics mechanics;
  
  structdefaultproperties
  {
    hitChance=-1
  }
};

public static function int getGlyphSkillCount() {
  return GlyphEnum.enumCount;
}

defaultProperties
{
  
}


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

