/*=============================================================================
 * ROTT_Descriptor_Hyper_Shrine_List
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class holds all design data for the hyper shrine system
 *===========================================================================*/

class ROTT_Descriptor_Hyper_Shrine_List extends object
dependsOn(ROTT_Game_Info);

// Shrine activities --- [Move to shrine activity descriptor]
enum PassiveShrineActivies {
  NO_SHRINE_ACTIVITY,
  
  CLERICS_SHRINE,
  COBALT_SANCTUM,
  THE_ROSETTE_PILLARS,
  LOCKSPIRE_SHRINE,
  
  THE_UNDEAD,
  THE_DEMONIC,
  THE_SERPENTINE,
  THE_BEASTS,
  
  HAWKSPIRE_MEADOW,
  LACEROOT_SHRINE,
  FATEWOOD_GROVE,
  MYRRHIAN_THICKET
  
};

// Rewards
enum ShrineRewards {
  REWARD_HYPER_ARMOR,
  REWARD_HYPER_HEALTH,
  REWARD_HYPER_MANA,
  REWARD_HYPER_MANA_REGEN,
  
  REWARD_HYPER_SPEED,
  REWARD_HYPER_DAMAGE,
  REWARD_HYPER_ACCURACY,
  REWARD_HYPER_DODGE,
  
  REWARD_BOTTLES,
  REWARD_CHARMS,
  REWARD_HERBS,
  REWARD_GOLD,
  REWARD_GEMS,
  
  REWARD_FLAILS,
  REWARD_KITE_SHIELDS,
  REWARD_BUCKLER_SHIELDS,
  REWARD_PAINTBRUSHES,
  REWARD_CEREMONIAL_DAGGERS,
  REWARD_LUSTROUS_BATONS,
  
};

// Hyper Shrine data
struct HyperShrineDescriptor {
  // Rewards
  var ShrineRewards firstReward; 
  var ShrineRewards secondReward; 
  
};

// Store array of reward info
var privatewrite HyperShrineDescriptor hyperShrines[PassiveShrineActivies];

`include(ROTTColorLogs.h)

/*============================================================================= 
 * getShrineRewards()
 *
 * Returns the rewards for a hyper shrine
 *===========================================================================*/
public static function HyperShrineDescriptor getShrineRewards
(
  coerce byte shrineIndex
) 
{
  local HyperShrineDescriptor hyperRewards;
  
  switch (shrineIndex) {
    // Worship shrines
    case CLERICS_SHRINE:
      hyperRewards.firstReward = REWARD_HYPER_HEALTH;
      hyperRewards.secondReward = REWARD_BOTTLES;
      return hyperRewards;
    case COBALT_SANCTUM:
      hyperRewards.firstReward = REWARD_HYPER_ARMOR;
      hyperRewards.secondReward = REWARD_CEREMONIAL_DAGGERS;
      return hyperRewards;
    case THE_ROSETTE_PILLARS:
      hyperRewards.firstReward = REWARD_HYPER_DODGE;
      hyperRewards.secondReward = REWARD_GEMS;
      return hyperRewards;
    case LOCKSPIRE_SHRINE:
      hyperRewards.firstReward = REWARD_HYPER_MANA_REGEN;
      hyperRewards.secondReward = REWARD_LUSTROUS_BATONS;
      return hyperRewards;
      
    // Hunting Grounds
    case THE_UNDEAD:
      hyperRewards.firstReward = REWARD_HYPER_DAMAGE;
      hyperRewards.secondReward = REWARD_GOLD;
      return hyperRewards;
    case THE_DEMONIC:
      hyperRewards.firstReward = REWARD_CHARMS;
      hyperRewards.secondReward = REWARD_GOLD;
      return hyperRewards;
    case THE_SERPENTINE:
      hyperRewards.firstReward = REWARD_FLAILS;
      hyperRewards.secondReward = REWARD_GEMS;
      return hyperRewards;
    case THE_BEASTS:
      hyperRewards.firstReward = REWARD_BUCKLER_SHIELDS;
      hyperRewards.secondReward = REWARD_GEMS;
      return hyperRewards;
    
    // Botanical Gardens
    case HAWKSPIRE_MEADOW:
      hyperRewards.firstReward = REWARD_HYPER_ACCURACY;
      hyperRewards.secondReward = REWARD_PAINTBRUSHES;
      return hyperRewards;
    case LACEROOT_SHRINE:
      hyperRewards.firstReward = REWARD_HYPER_SPEED;
      hyperRewards.secondReward = REWARD_HERBS;
      return hyperRewards;
    case FATEWOOD_GROVE:
      hyperRewards.firstReward = REWARD_HYPER_MANA;
      hyperRewards.secondReward = REWARD_HERBS;
      return hyperRewards;
    case MYRRHIAN_THICKET:
      hyperRewards.firstReward = REWARD_KITE_SHIELDS;
      hyperRewards.secondReward = REWARD_CEREMONIAL_DAGGERS;
      return hyperRewards;
  }
}

/// /*============================================================================= 
///  * countEnchantmentEnum()
///  *
///  * Returns length of enumeration
///  *===========================================================================*/
/// public static function int countEnchantmentEnum() {
///   return EnchantmentEnum.enumCount;
/// }

/*============================================================================= 
 * Enchantments
 *===========================================================================*/
defaultProperties 
{
  
}


















