/*=============================================================================
 * ROTT_Descriptor_Enchantment_List
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class holds all design data for the enchantments system
 *===========================================================================*/

class ROTT_Descriptor_Enchantment_List extends object
dependsOn(ROTT_Game_Info);

// Text Fields
enum EnchantmentTextFields {
  ENCHANTMENT_NAME,
  ENCHANTMENT_INFO_1,
  ENCHANTMENT_INFO_2,
  ENCHANTMENT_STATS,
  ENCHANTMENT_ROUND_BONUS,
  ENCHANTMENT_ADDED,
  ENCHANTMENT_TOTAL
};

// Enchantment data
struct EnchantmentDescriptor {
  // Alchemy price per minigame
  var int goldCost; 
  var int gemCost; 
  
  // Text fields for UI
  var string displayText[EnchantmentTextFields];
  
  // Enchantment info
  var int bonusPerLevel;
};
  
enum EnchantmentEnum {
  OMNI_SEEKER,
  SERPENTS_ANCHOR,
  GRIFFINS_TRINKET,
  GHOSTKINGS_BRANCH,
  OATH_PENDANT,
  ETERNAL_SPELLSTONE,
  MYSTIC_MARBLE,
  ARCANE_BLOODPRISM,
  ROSEWOOD_PENDANT,
  INFINITY_JEWEL,
  EMPERORS_TALISMAN,
  SCORPION_TALON,
  SOLAR_CHARM,
  DREAMFIRE_RELIC
};

//var privatewrite EnchantmentDescriptor enchantments[EnchantmentEnum];

`include(ROTTColorLogs.h)

/*============================================================================= 
 * getEnchantmentCost()
 *
 * Returns the cost of the given enchantment for the alchemy minigame
 *===========================================================================*/
public static function array<ItemCost> getEnchantmentCost
(
  coerce byte enchantmentIndex
) 
{
  return goldAndGems (
    getEnchantment(enchantmentIndex).goldCost,
    getEnchantment(enchantmentIndex).gemCost
  );
}

/*============================================================================= 
 * goldAndGems()
 *
 * Returns the cost of the given enchantment for the alchemy minigame
 *===========================================================================*/
public static function array<ItemCost> goldAndGems(int gold, int gems) {
  local array<ItemCost> costList;
  local ItemCost costInfo;
  
  // Set gold cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gold';
  costInfo.quantity = gold;
  
  // Add to list
  costList.addItem(costInfo);
  
  // Set gem cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gem';
  costInfo.quantity = gems;
  
  // Add to list
  costList.addItem(costInfo);
  
  return costList;
}

/*============================================================================= 
 * countEnchantmentEnum()
 *
 * Returns length of enumeration
 *===========================================================================*/
public static function int countEnchantmentEnum() {
  return EnchantmentEnum.enumCount;
}

/*============================================================================= 
 * getEnchantment()
 *
 * 
 *===========================================================================*/
public static function EnchantmentDescriptor getEnchantment
(
  coerce byte index
)
{
  local EnchantmentDescriptor script;
  
  switch (index) {
    case OMNI_SEEKER:
      setTextFields(script,
        "Omni Seeker",
        "Improves luck when obtaining loot",
        "for every team",
        "+%x% Luck"
      );
      setResultText(script,
        "+%bonus% Luck per round reached",
        "Adding +%add% Luck",
        "New Total: +%total% Luck"
      );
      setGoldGemCost(script, 25000, 25);
      setBonus(script, 5);
      
      return script;
      
    case SERPENTS_ANCHOR:
      setTextFields(script,
        "Serpent's Anchor",
        "Provides a boost in armor",
        "for every team",
        "Reduces %x Damage"
      );
      setResultText(script,
        "+%bonus Armor per round reached",
        "Adding +%add Armor",
        "New Total: +%total Armor"
      );
      setGoldGemCost(script, 20000, 20);
      setBonus(script, 2);
      
      return script;
      
    case GRIFFINS_TRINKET:
      setTextFields(script,
        "Griffin's Trinket",
        "Increases accuracy and dodge rating",
        "for every team",
        "+%x Accuracy, +%x Dodge"
      );
      setResultText(script,
        "+%bonus Accuracy, +%bonus Dodge per round reached",
        "Adding +%add Accuracy, +%add Dodge",
        "New Total: +%total Accuracy, +%total Dodge"
      );
      setGoldGemCost(script, 15000, 20);
      setBonus(script, 10);
      
      return script;
      
    case GHOSTKINGS_BRANCH:
      setTextFields(script,
        "Ghostking's Branch",
        "Reduces enemy speed for all combat",
        "scenarios",
        "-%x Enemy Speed Points"
      );
      setResultText(script,
        "-%bonus Speed Points per round reached",
        "Adding -%add Speed Points",
        "New Total: -%total Speed Points"
      );
      setGoldGemCost(script, 10000, 15);
      setBonus(script, 5);
      
      return script;
      
    case OATH_PENDANT:
      setTextFields(script,
        "Oath Pendant",
        "Increases class skill levels",
        "for every team",
        "+%x Class Skills"
      );
      setResultText(script,
        "+%bonus Class Skills per round reached",
        "Adding +%add Class Skills",
        "New Total: +%total Class Skills"
      );
      setGoldGemCost(script, 125000, 500);
      setBonus(script, 1);
      
      return script;
      
    case ETERNAL_SPELLSTONE:
      setTextFields(script,
        "Eternal Spellstone",
        "Regenerates mana over time",
        "for every team",
        "Regenerates %x mana per second"
      );
      setResultText(script,
        "+%bonus Mana Regen per round reached",
        "Adding +%add Mana Regen",
        "New Total: +%total Mana Regen"
      );
      setGoldGemCost(script, 7500, 75);
      setBonus(script, 1);
      
      return script;
      
    case MYSTIC_MARBLE:
      setTextFields(script,
        "Mystic Marble",
        "Increases maximum mana",
        "for every team",
        "+%x% Mana"
      );
      setResultText(script,
        "+%bonus% Mana per round reached",
        "Adding +%add% Mana",
        "New Total: +%total% Mana"
      );
      setGoldGemCost(script, 4000, 20);
      setBonus(script, 5);
      
      return script;
      
    case ARCANE_BLOODPRISM:
      setTextFields(script,
        "Arcane Bloodprism",
        "Increases maximum health",
        "for every team",
        "+%x% health"
      );
      setResultText(script,
        "+%bonus% Health per round reached",
        "Adding +%add% Health",
        "New Total: +%total% Health"
      );
      setGoldGemCost(script, 4000, 20);
      setBonus(script, 1);
      
      return script;
      
    case ROSEWOOD_PENDANT:
      setTextFields(script,
        "Rosewood Pendant",
        "Regenerates health over time",
        "for every team",
        "Regenerates %x health per second"
      );
      setResultText(script,
        "+%bonus Health Regen per round reached",
        "Adding +%add Health Regen",
        "New Total: +%total Health Regen"
      );
      setGoldGemCost(script, 10000, 100);
      setBonus(script, 1);
      
      return script;
      
    case INFINITY_JEWEL:
      setTextFields(script,
        "Inifinity Jewel",
        "Increases all primary stats",
        "for every team",
        "+%x All Stats"
      );
      setResultText(script,
        "+%bonus All Stats per round reached",
        "Adding +%add All Stats",
        "New Total: +%total All Stats"
      );
      setGoldGemCost(script, 5000, 50);
      setBonus(script, 1);
      
      return script;
      
    case EMPERORS_TALISMAN:
      setTextFields(script,
        "Emperor's Talisman",
        "Increases the skill level of all glyph",
        "skills for every team",
        "+%x Glyph Skills"
      );
      setResultText(script,
        "+%bonus Glyph Skills per round reached",
        "Adding +%add Glyph Skills",
        "New Total: +%total Glyph Skills"
      );
      setGoldGemCost(script, 17500, 125);
      setBonus(script, 1);
      
      return script;
      
    case SCORPION_TALON:
      setTextFields(script,
        "Scorpion Talon",
        "Increases physical damage dealt by",
        "every team",
        "+%x% Physical Damage"
      );
      setResultText(script,
        "+%bonus% Physical Damage per round reached",
        "Adding +%add% Physical Damage",
        "New Total: +%total% Physical Damage"
      );
      setGoldGemCost(script, 12500, 25);
      setBonus(script, 5);
      
      return script;
      
    case SOLAR_CHARM:
      setTextFields(script,
        "Solar Charm",
        "Increases experience gained",
        "by every team",
        "+%x% Experience"
      );
      setResultText(script,
        "+%bonus% Experience per round reached",
        "Adding +%add% Experience",
        "New Total: +%total% Experience"
      );
      setGoldGemCost(script, 12500, 50);
      setBonus(script, 2);
      
      return script;
      
    case DREAMFIRE_RELIC:
      setTextFields(script,
        "Dreamfire Relic",
        "Drains health from enemies over time",
        "",
        "%x Damage per second"
      );
      setResultText(script,
        "%bonus DPS per round reached",
        "Adding +%add DPS",
        "New Total: %total DPS"
      );
      setGoldGemCost(script, 50000, 100);
      setBonus(script, 1);
      
      return script;
      
  }
}

/*============================================================================= 
 * setTextFields()
 *
 * 
 *===========================================================================*/
public static function setTextFields
(
  out EnchantmentDescriptor script,
  string enchantmentName,
  string enchantmentInfo1,
  string enchantmentInfo2,
  string enchantmentStats
) 
{
  script.displayText[ENCHANTMENT_NAME] = enchantmentName;
  script.displayText[ENCHANTMENT_INFO_1] = enchantmentInfo1;
  script.displayText[ENCHANTMENT_INFO_2] = enchantmentInfo2;
  script.displayText[ENCHANTMENT_STATS] = enchantmentStats;
}

/*============================================================================= 
 * setGoldGemCost()
 *
 * 
 *===========================================================================*/
public static function setGoldGemCost
(
  out EnchantmentDescriptor script,
  int goldCost,
  int gemCost
) 
{
  script.goldCost = goldCost;
  script.gemCost = gemCost;
}

/*============================================================================= 
 * setBonus()
 *
 * 
 *===========================================================================*/
public static function setBonus
(
  out EnchantmentDescriptor script,
  int bonusPerLevel
) 
{
  script.bonusPerLevel = bonusPerLevel;
}

/*============================================================================= 
 * setResultText()
 *
 * 
 *===========================================================================*/
public static function setResultText
(
  out EnchantmentDescriptor script,
  string roundBonusText,
  string addedText,
  string totalText
) 
{
  script.displayText[ENCHANTMENT_ROUND_BONUS] = roundBonusText;
  script.displayText[ENCHANTMENT_ADDED] = addedText;
  script.displayText[ENCHANTMENT_TOTAL] = totalText;
}

/*============================================================================= 
 * Enchantments
 *===========================================================================*/
defaultProperties 
{
  
}


















