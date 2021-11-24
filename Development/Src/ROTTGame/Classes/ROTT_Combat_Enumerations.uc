/*=============================================================================
 * ROTT_Combat_Enumerations
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This file hosts combat enumerations for organized dependency purposes
 *===========================================================================*/
class ROTT_Combat_Enumerations extends Object
abstract;

/// more enumerations in ROTT_Combat_Object, possibly worth migrating over

// Clan Colors
enum ClanColors {
  CLAN_BLACK,
  CLAN_BLUE,
  CLAN_CYAN,
  CLAN_GOLD,
  CLAN_GREEN,
  CLAN_ORANGE, // May contain brown variations
  CLAN_PURPLE,
  CLAN_RED,
  CLAN_VIOLET,
  CLAN_WHITE,
};

// Item attributes for equiped usage
enum EquipmentAttributes {
  // Skills
  ITEM_ADD_CLASS_SKILLS,
  ITEM_ADD_GLYPH_SKILLS,
  ITEM_ADD_SKILL_POINTS,
  
  // Armor
  ITEM_ADD_ARMOR,
  
  // Damage
  ITEM_ADD_PHYSICAL_MIN,
  ITEM_ADD_PHYSICAL_MAX,
  ITEM_MULTIPLY_ELEMENTAL,
  
  // Health
  ITEM_ADD_HEALTH,
  ITEM_ADD_HEALTH_REGEN,
  ITEM_MULTIPLY_HEALTH,
  
  // Mana
  ITEM_ADD_MANA,
  ITEM_ADD_MANA_REGEN,
  ITEM_MULTIPLY_MANA,
  
  // Accuracy and dodge
  ITEM_ADD_ACCURACY,
  ITEM_ADD_DODGE,
  
  // Speed
  ITEM_ADD_SPEED,
  ITEM_REDUCE_ENEMY_SPEED,
  
  // Stats
  ITEM_ADD_ALL_STATS, 
  ITEM_ADD_VITALITY, 
  ITEM_ADD_STRENGTH, 
  ITEM_ADD_COURAGE, 
  ITEM_ADD_FOCUS, 
  
  // Enchantments (Carries from inactive teams too)
  ITEM_ADD_ENCHANTMENT_LEVEL, 
  
  // Misc
  ITEM_ADD_GLYPH_LUCK,
  ITEM_ADD_LOOT_LUCK,
  ITEM_MULTIPLY_EXPERIENCE,
  ITEM_FASTER_AURA_STRIKES,
  ITEM_LACERATIONS, /// ... DPS drain of constant 25% dmg dealt, x% chance?
  ITEM_PERSISTENCE, /// ... Chance to strike again in half time?
  ITEM_MULTIPLY_PRAYER, 
  ITEM_MULTIPLY_HOARD_SIZE, 
};

// Even distribution categories for equipment attribution generation
enum GenerationCategories {
  // Skills
  CATEGORY_ADD_CLASS_SKILLS,
  CATEGORY_ADD_GLYPH_SKILLS,
  CATEGORY_ADD_SKILL_POINTS,
  
  // Armor
  CATEGORY_ADD_ARMOR,
  
  // Damage
  CATEGORY_ADD_PHYSICAL_MIN,
  CATEGORY_ADD_PHYSICAL_MAX,
  CATEGORY_MULTIPLY_ELEMENTAL,
  
  // Health
  CATEGORY_ADD_HEALTH,
  CATEGORY_ADD_HEALTH_REGEN,
  CATEGORY_MULTIPLY_HEALTH,
  
  // Mana
  CATEGORY_ADD_MANA,
  CATEGORY_ADD_MANA_REGEN,
  CATEGORY_MULTIPLY_MANA,
  
  // Accuracy and dodge
  CATEGORY_ADD_ACCURACY,
  CATEGORY_ADD_DODGE,
  
  // Speed
  CATEGORY_ADD_SPEED,
  CATEGORY_REDUCE_ENEMY_SPEED,
  
  // Limit 1 or 2 primary stat boosts
  CATEGORY_PRIMARY_STATS_1, 
  CATEGORY_PRIMARY_STATS_2, 
  
  // Enchantments (Carries from inactive teams too)
  CATEGORY_ADD_ENCHANTMENT_LEVEL, 
  
  // Limit one misc stat boost
  CATEGORY_MISC,
};

// Combat mechanic types
enum AttributeTypes {
  // Mana
  MANA_COST,
  MANA_OVERFLOW_COST,
  MANA_TRANSFER_RATE,
  
  // Prime stat mods
  INCREASE_ALL_STATS,
  INCREASE_VITALITY,
  INCREASE_STRENGTH,
  INCREASE_STRENGTH_PERCENT,
  INCREASE_COURAGE,
  INCREASE_COURAGE_PERCENT,
  
  DECREASE_STRENGTH_RATING,
  
  // Substat mods
  INCREASE_SPEED_RATING,
  INCREASE_DODGE_RATING,
  INCREASE_ACCURACY_RATING,
  INCREASED_CRIT_CHANCE,
  
  INCREASE_MAX_HEALTH_MAX_MANA,
  
  DECREASE_SPEED_RATING,
  DECREASE_DODGE_RATING,
  DECREASE_ACCURACY_RATING,

  // Armor
  INCREASE_ARMOR,
  
  // Glyph mods
  GLYPH_ARMOR_BOOST,
  GLYPH_MIN_HEALTH_BOOST,
  GLYPH_MAX_HEALTH_BOOST,
  GLYPH_MIN_MANA_BOOST,
  GLYPH_MAX_MANA_BOOST,
  GLYPH_MANA_REGEN,
  GLYPH_DODGE_BOOST,
  GLYPH_ACCURACY_BOOST,
  GLYPH_DAMAGE_BOOST,
  GLYPH_SPEED_BOOST,
  GLYPH_SPAWN_CHANCE,
  
  // Hyper mods
  HYPER_SPAWN_CHANCE,
  PERM_ARMOR_BOOST,
  PERM_DODGE_BOOST,
  PERM_ACCURACY_BOOST,
  PERM_SLOW_ENEMIES,
  PERM_PHYSICAL_DAMAGE_PERCENT,
  PERM_ELEMENTAL_DAMAGE_PERCENT,
  HYPER_MAX_HEALTH_BOOST,
  PERM_MANA_REGEN,
  PERM_MAX_MANA,
  PERM_HEALTH_REGEN,
  HYPER_MANA_BOOST,
  HYPER_DAMAGE_REDUCTION,
  HYPER_DODGE_PERCENT,
  HYPER_ACCURACY_PERCENT,
  HYPER_MULTISTRIKE_CHANCE,
  
  // Damage
  PHYSICAL_DAMAGE_MIN,
  PHYSICAL_DAMAGE_MAX,
  ELEMENTAL_DAMAGE_MIN,
  ELEMENTAL_DAMAGE_MAX,
  ATMOSPHERIC_DAMAGE_MIN,
  ATMOSPHERIC_DAMAGE_MAX,
  
  // Damage amplifiers
  ELEMENTAL_AMPLIFIER,
  PHYSICAL_AMPLIFIER,
  PARTY_ELEMENTAL_AMPLIFIER,
  PARTY_PHYSICAL_AMPLIFIER,
  DEMORALIZED_ELEMENTAL_AMP,
  
  // Time mods
  ATTACK_TIME_AMPLIFIER,
  OVERRIDE_ATTACK_TIME,
  STUN_RATING,
  
  // Over-time mods
  HEALTH_GAIN_OVER_TIME,
  HEALTH_LOSS_OVER_TIME,
  ADD_HEALTH_WHILE_DEFENDING,
  ADD_MANA_WHILE_DEFENDING,
  MEDITATION_RATING,
  ACCELERATED_MANA_DRAIN,
  MANA_DRAIN_ATMOSPHERIC_DAMAGE,
  TEMP_MANA_DRAIN_AMOUNT,
  TEMP_MANA_DRAIN_TIME,
  FUSION_RATE,
  
  // On defend
  MANA_REGEN_ADDED_ON_DEFEND, /// THIS IS THE BUFF, SENT OUT ON START
  ADD_MANA_REGENERATION,      /// THIS IS THE PERK, APPLIED EACH DEFEND
  MANA_REGENERATION,          /// THIS IS THE STAT, APPLIED EACH TICK
  
  // Demoralization
  DEMORALIZE_RATING_NO_STACKING,
  DEMORALIZE_RATING,
  SELF_DEMORALIZE_RATING,
  
  // Leech
  HEALTH_LEECH,
  MANA_LEECH,
  
  // Stance mods
  ADD_STANCE_COUNT,
  ADD_STANCE_COUNT_PER_GLYPH,
  
  // Count based mods
  CAST_COUNT_AMP,
  GLYPH_COUNT_AMP,
  STARBOLT_AMPLIFIER_MIN,
  STARBOLT_AMPLIFIER_MAX,
  
  // Action requirements
  REQUIRES_GLYPH,
  REQUIRES_CAST_COUNT,
  
  // Misc
  HIT_CHANCE_OVERRIDE,
  CUT_CASTER_LIFE_BY_PERCENT,
  ADD_SELF_AS_TARGET,
  MANA_SHIELD_PERCENT,
  PAUSE_TUNA,
  UNPAUSE_TUNA,
  AUTO_ATTACK_MODE,
  TARGET_CASTER,
  RANDOM_TARGET,
  ATMOSPHERIC_TAG,
  QUEUED_MULTISTRIKE_COUNT,
  QUEUED_MULTISTRIKE_DELAY,
  QUEUED_SECONDARY_EFFECT,
  OMNI_SEEKER_HARDCORE,
  
  // Misc UI
  STORM_INTENSITY_NOTIFICATION,
  ALT_ACTION_ANIMATION,
  TRACK_ACTION,
  
  // Passive Requirements
  MASTERY_REQ_VITALITY,
  MASTERY_REQ_STRENGTH,
  MASTERY_REQ_COURAGE,
  MASTERY_REQ_FOCUS,
  
  // Passive
  PASSIVE_ARMOR_BOOST,
  PASSIVE_HEALTH_BOOST,
  PASSIVE_MANA_BOOST,
  PASSIVE_SPEED_BOOST,
  PASSIVE_DODGE_BOOST,
  PASSIVE_ACCURACY_BOOST,
  PASSIVE_HEALTH_REGEN,
  PASSIVE_ADD_PHYSICAL_MIN,
  PASSIVE_ADD_PHYSICAL_MAX,
  
  RESURRECTION_HEALTH,
  
};

/*============================================================================= 
 * getClanColorCount()
 *
 * Returns total number of clan colors
 *===========================================================================*/
static function int getClanColorCount() {
  return ClanColors.enumCount;
}

/*============================================================================= 
 * getEquipmentAttributesCount()
 *
 * Returns total number of equipment attributes
 *===========================================================================*/
static function int getEquipmentAttributesCount() {
  return EquipmentAttributes.enumCount;
}

/*============================================================================= 
 * getGenerationCategoriesCount()
 *
 * Returns total number of attributes generation categories
 *===========================================================================*/
static function int getGenerationCategoriesCount() {
  return GenerationCategories.enumCount;
}

defaultProperties 
{
  
}

















