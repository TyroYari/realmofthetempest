/*============================================================================= 
 * ROTT_Inventory_Item
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * An item that the player can obtain in their inventory
 *===========================================================================*/
 
class ROTT_Inventory_Item extends ROTT_Object 
dependsOn(ROTT_Combat_Enumerations)
abstract;

// Item categories
enum ItemCategory {
  ITEM_CATEGORY_CURRENCY,
  ITEM_CATEGORY_CONSUMABLE,
  ITEM_CATEGORY_EQUIPABLE,
  ITEM_CATEGORY_SPECIAL,
  ITEM_CATEGORY_QUEST,
};

var privatewrite ItemCategory category;

// Display information
var privatewrite string itemName;
var privatewrite FontStyles itemFont;
var privatewrite int itemLevel;

// Quantity
var privatewrite int quantity;
var privatewrite bool bDoesNotStack;

// Inventory graphic
var public instanced UI_Texture_Storage itemSprite;
var privatewrite Texture2D itemTexture;

// Optional clan color
var privatewrite Texture2D itemClanTextures[10];
var protectedwrite ClanColors clanColor;
var protectedwrite bool bUseClanColor;

// Store item attributes
var protectedwrite int itemStats[EquipmentAttributes]; 

// Store which skill ID to boost for ADD_SKILL_POINTS
var protectedwrite HeroClassEnum heroSkillType; 
var protectedwrite int heroSkillID; 

// Store which enchantment to boost
var protectedwrite EnchantmentEnum enchantmentType; 

// Linked list type storage system
var public class<ROTT_Inventory_Item> nextSavedItemType;

/*=============================================================================
 * initialize()
 *
 * This needs to be called when the item is created
 *===========================================================================*/
public function initialize() {
  linkReferences();

  // Set up texture storage
  itemSprite = new class'UI_Texture_Storage';
  itemSprite.initializeComponent("Inventory_Sprite");
  itemSprite.addTexture(getItemTexture(), 0);
  
  // Initialize each UI component
  itemSprite.initializeComponent();
}

/*=============================================================================
 * getItemTexture()
 *
 * Returns texture information for the item
 *===========================================================================*/
private function UI_Texture_Info getItemTexture() {
  local UI_Texture_Info textureInfo;
  
  // Set up texture info
  textureInfo = new class'UI_Texture_Info';
  
  // Texture assignment 
  if (bUseClanColor) {
    // Clan color assignment
    textureInfo.componentTextures.addItem(itemClanTextures[clanColor]);
  } else {
    // Default assignment
    textureInfo.componentTextures.addItem(itemTexture);
  }
  textureInfo.initializeInfo();

  // Check for valid item texture
  if (textureInfo == none) {
    yellowLog("Warning (!) No texture specified for item: " $ self);
    return none;
  }
  
  return textureInfo;
}
  
/*=============================================================================
 * setQuantity()
 *
 * Sets the quantity
 *===========================================================================*/
public function setQuantity(int q) {
  quantity = q;
}

/*=============================================================================
 * addQuantity()
 *
 * Adds the quantity
 *===========================================================================*/
public function addQuantity(int a) {
  if (bDoesNotStack) {
    yellowLog("Warning (!) Item does not stack");
    scriptTrace();
    return;
  }
  quantity += a;
}

/*=============================================================================
 * subtract()
 *
 * Removes a quantity.  Returns true if sufficient quantity.
 *===========================================================================*/
public function bool subtract(int s) {
  // Check for sufficient quantity
  if (quantity < s) {
    return false;
  }
  
  // Subtract and report success
  quantity -= s;
  return true;
}

/*=============================================================================
 * onTake()
 *
 * Called on items in the chest inventory to transfer them to the player
 *===========================================================================*/
public function onTake() {
  // Add Notification to screen
  gameInfo.showGameplayNotification("+" $ quantity $ " " $ itemName);
}

/*=============================================================================
 * initializeAttributes()
 *
 * Called after item generation for values dependent on instanced variables.
 *===========================================================================*/
public function initializeAttributes() {
  // Check for clan color usage
  if (bUseClanColor) {
    // Randomize clan color
    clanColor = ClanColors(
      rand(class'ROTT_Combat_Enumerations'.static.getClanColorCount())
    );
    
    // Set up texture storage
    itemSprite.resetDrawInfo();
    itemSprite.addTexture(getItemTexture(), 0);
  }
  
  // Cap quantity if no stack
  if (bDoesNotStack) setQuantity(1);
  
  // Check if item is equipment
  if (category == ITEM_CATEGORY_EQUIPABLE) {
    // Generate equipment attributes
    generateAttributes();
  }
}

/*=============================================================================
 * getItemDescriptor()
 *
 * Provides a formatted descriptor for item inspection window.
 *===========================================================================*/
public static function ROTT_Descriptor getItemDescriptor(ROTT_Inventory_Item target) 
{
  local ROTT_Descriptor_Item itemDescriptor;
  
  itemDescriptor = new class'ROTT_Descriptor_Item';
  itemDescriptor.formatItem(target);

  return itemDescriptor;
}
  
/*=============================================================================
 * generateItem()
 *
 * Given a drop level, and optionally a drop mod, this handles chance to drop,
 * drop quantity, and drop qualities like attributes, if any.
 *===========================================================================*/
public static function ROTT_Inventory_Item generateItem
(
  class<ROTT_Inventory_Item> lootType,
  int dropLevel,
  ItemDropMod dropMod,
  optional bool bBestiaryDrop = false
) 
{
  local ROTT_Inventory_Item item;
  local float minQuantity, maxQuantity;
  local float dropChance;
  local float itemCount;
  
  // Create item
  item = new lootType;
  item.initialize();
  item.itemLevel = dropLevel;
  
  // Quest item skip
  if (
    item.category == ITEM_CATEGORY_QUEST && item.getMaxQuantity(dropLevel) == 0
  ) return none;
  
  // Get default drop info
  dropChance = item.getDropChance(dropLevel, bBestiaryDrop);
  minQuantity = item.getMinQuantity(dropLevel);
  maxQuantity = item.getMaxQuantity(dropLevel);
  
  // Drop rate amplifier for Bestiary summons
  if (bBestiaryDrop) {
    dropChance *= 5;
  }
  
  // Overrides
  if (dropMod.chanceOverride != -1) dropChance = dropMod.chanceOverride;
  if (dropMod.minOverride != -1) minQuantity = dropMod.minOverride;
  if (dropMod.maxOverride != -1) maxQuantity = dropMod.maxOverride;
  
  // Multipliers
  dropChance *= dropMod.chanceAmp;
  minQuantity *= dropMod.quantityAmp;
  maxQuantity *= dropMod.quantityAmp;
  
  // Calculate chance to drop
  if (fRand() * 100 < dropChance) {
    item.darkGreenLog(
      "Random range: " $ minQuantity $ " - " $ maxQuantity $ " for " $ item,
      DEBUG_LOOT
    );
    
    // Roll random quantity
    itemCount = minQuantity + rand(maxQuantity - minQuantity + 1);
    if (itemCount < 1) itemCount = 1;
    item.setQuantity(itemCount);
    
    // Return result
    return item;
  }
  
  // Item did not drop
  return none;
}

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  return 100;
}

/*=============================================================================
 * getMinQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMinQuantity(int dropLevel) {
  return 1;
}

/*=============================================================================
 * getMaxQuantity()
 *
 * Implemented in each item subclass
 *===========================================================================*/
protected function float getMaxQuantity(int dropLevel) {
  return 1;
}

/*=============================================================================
 * getSpriteTexture()
 *
 * Returns the sprite texture for display
 *===========================================================================*/
public function Texture2D getSpriteTexture() {
  if (bUseClanColor) return itemClanTextures[clanColor];
  return itemTexture;
}

/*=============================================================================
 * getAttributeIndex()
 *
 * Given a display list index, this skips empty fields to find stored index.
 *===========================================================================*/
protected function int getAttributeIndex(int targetIndex) {
  local int attributeIndex;
  local int attributeMax;
  attributeIndex = 0;
  
  attributeMax = class'ROTT_Combat_Enumerations'.static.getEquipmentAttributesCount();
  
  // Scan for target index
  do {
    // Skip empty fields
    while (itemStats[attributeIndex] == 0) {
      attributeIndex++;
      if (attributeIndex >= attributeMax) return -1;
    }
    
    // Count down fields
    targetIndex--;
    if (targetIndex != -1) attributeIndex++;
    
    // Check if count down complete
  } until (targetIndex == -1);
  
  return attributeIndex;
}

/*=============================================================================
 * getAttributeText()
 *
 * Returns text for an attribute at a given index
 *===========================================================================*/
public function string getAttributeText(int targetIndex) {
  local int attributeIndex;
  local int x;
  
  // Get stored index from display index
  attributeIndex = getAttributeIndex(targetIndex);
  if (attributeIndex == -1) return "";
  
  // Set attribute value for display
  x = itemStats[attributeIndex];
  
  // Check attribute index
  switch (attributeIndex) {
    // Skills
    case ITEM_ADD_CLASS_SKILLS:   return "+" $ x $ " to Class Skills";
    case ITEM_ADD_GLYPH_SKILLS:   return "+" $ x $ " to Glyph Skills";
    case ITEM_ADD_SKILL_POINTS:   return "+" $ x $ " to " $ getSkillName() $ " Skill";
    
    // Armor
    case ITEM_ADD_ARMOR:          return "+" $ x $ " to Armor";
    
    // Damage
    case ITEM_ADD_PHYSICAL_MIN:   return "+" $ x $ " to Min Physical Damage";
    case ITEM_ADD_PHYSICAL_MAX:   return "+" $ x $ " to Max Physical Damage";
    case ITEM_MULTIPLY_ELEMENTAL: return "+" $ x $ "% to Elemental Damage";
    
    // Health
    case ITEM_ADD_HEALTH:         return "+" $ x $ " to Max Health";
    case ITEM_ADD_HEALTH_REGEN:   return "+" $ x $ " to Health Regeneration";
    case ITEM_MULTIPLY_HEALTH:    return "+" $ x $ "% Health";
    
    // Mana
    case ITEM_ADD_MANA:           return "+" $ x $ " to Max Mana";
    case ITEM_ADD_MANA_REGEN:     return "+" $ x $ " to Mana Regeneration";
    case ITEM_MULTIPLY_MANA:      return "+" $ x $ "% Mana";
    
    // Accuracy and dodge
    case ITEM_ADD_ACCURACY:       return "+" $ x $ " to Accuracy";
    case ITEM_ADD_DODGE:          return "+" $ x $ " to Dodge";
    
    // Speed
    case ITEM_ADD_SPEED:          return "+" $ x $ " to Speed Points";
    case ITEM_REDUCE_ENEMY_SPEED: return "-" $ x $ " to Enemy Speed Points";
    
    // Stats
    case ITEM_ADD_ALL_STATS:      return "+" $ x $ " to All Stats";
    case ITEM_ADD_VITALITY:       return "+" $ x $ " to Vitality";
    case ITEM_ADD_STRENGTH:       return "+" $ x $ " to Strength";
    case ITEM_ADD_COURAGE:        return "+" $ x $ " to Courage";
    case ITEM_ADD_FOCUS:          return "+" $ x $ " to Focus";
    
    // Enchantments
    case ITEM_ADD_ENCHANTMENT_LEVEL: return "+" $ x $ " to " $ getEnchantmentName();
    
    // Misc
    case ITEM_ADD_GLYPH_LUCK: return "+" $ x $ "% to Glyph Spawn Chance";
    case ITEM_ADD_LOOT_LUCK: return "+" $ x $ "% to Luck";
    case ITEM_MULTIPLY_EXPERIENCE: return "+" $ x $ "% to Experience Gained";
    case ITEM_FASTER_AURA_STRIKES: return "+" $ x $ "% Faster Aura Strikes";
    case ITEM_LACERATIONS: return "+" $ x $ "% Chance of Lacerations";
    case ITEM_PERSISTENCE: return "+" $ x $ "% Chance of Persistence";
    case ITEM_MULTIPLY_PRAYER: return "+" $ x $ "% Prayer Boost";
    case ITEM_MULTIPLY_HOARD_SIZE: return "+" $ x $ " to Hoard Size";
    
  }
  
  yellowLog(
    "Warning (!) Unhandled item attribute for display: " $ attributeIndex
  );
  
  return "";
}

/*=============================================================================
 * getAttributeFont()
 *
 * Returns font color info for an attribute at a given index
 *===========================================================================*/
public function FontStyles getAttributeFont(int targetIndex) {
  local int attributeIndex;
  
  // Get stored index from display index
  attributeIndex = getAttributeIndex(targetIndex);
  if (attributeIndex == -1) return DEFAULT_SMALL_WHITE;
  
  // Check attribute index
  switch (attributeIndex) {
    // Skills
    case ITEM_ADD_CLASS_SKILLS:   return DEFAULT_SMALL_TAN;
    case ITEM_ADD_GLYPH_SKILLS:   return DEFAULT_SMALL_TAN;
    case ITEM_ADD_SKILL_POINTS:   return DEFAULT_SMALL_TAN;
    
    // Armor
    case ITEM_ADD_ARMOR:          return DEFAULT_SMALL_GREEN;
    
    // Damage
    case ITEM_ADD_PHYSICAL_MIN:   return DEFAULT_SMALL_ORANGE;
    case ITEM_ADD_PHYSICAL_MAX:   return DEFAULT_SMALL_ORANGE;
    case ITEM_MULTIPLY_ELEMENTAL: return DEFAULT_SMALL_ORANGE;
    
    // Health
    case ITEM_ADD_HEALTH:         return DEFAULT_SMALL_PINK;
    case ITEM_ADD_HEALTH_REGEN:   return DEFAULT_SMALL_PINK;
    case ITEM_MULTIPLY_HEALTH:    return DEFAULT_SMALL_PINK;
    
    // Mana
    case ITEM_ADD_MANA:           return DEFAULT_SMALL_BLUE;
    case ITEM_ADD_MANA_REGEN:     return DEFAULT_SMALL_BLUE;
    case ITEM_MULTIPLY_MANA:      return DEFAULT_SMALL_BLUE;
    
    // Accuracy and dodge
    case ITEM_ADD_ACCURACY:       return DEFAULT_SMALL_GREEN;
    case ITEM_ADD_DODGE:          return DEFAULT_SMALL_GREEN;
    
    // Speed
    case ITEM_ADD_SPEED:          return DEFAULT_SMALL_YELLOW;
    case ITEM_REDUCE_ENEMY_SPEED: return DEFAULT_SMALL_YELLOW;
    
    // Stats
    case ITEM_ADD_ALL_STATS:      return DEFAULT_SMALL_TAN;
    case ITEM_ADD_VITALITY:       return DEFAULT_SMALL_TAN;
    case ITEM_ADD_STRENGTH:       return DEFAULT_SMALL_TAN;
    case ITEM_ADD_COURAGE:        return DEFAULT_SMALL_TAN;
    case ITEM_ADD_FOCUS:          return DEFAULT_SMALL_TAN;
    
    // Enchantments
    case ITEM_ADD_ENCHANTMENT_LEVEL: return DEFAULT_SMALL_CYAN;
    
    // Misc
    case ITEM_ADD_GLYPH_LUCK:       return DEFAULT_SMALL_ORANGE;
    case ITEM_ADD_LOOT_LUCK:        return DEFAULT_SMALL_ORANGE;
    case ITEM_MULTIPLY_EXPERIENCE:  return DEFAULT_SMALL_ORANGE;
    case ITEM_FASTER_AURA_STRIKES:  return DEFAULT_SMALL_ORANGE;
    case ITEM_LACERATIONS:          return DEFAULT_SMALL_ORANGE;
    case ITEM_PERSISTENCE:          return DEFAULT_SMALL_ORANGE;
    case ITEM_MULTIPLY_PRAYER:      return DEFAULT_SMALL_ORANGE;
    case ITEM_MULTIPLY_HOARD_SIZE:  return DEFAULT_SMALL_ORANGE;
    
  }
}

/*=============================================================================
 * generateAttributes()
 *
 * Randomly generates item attributes based on drop level (item level)
 *===========================================================================*/
public function generateAttributes() {
  local array<GenerationCategories> pendingAttributes;
  local int attributeCount;
  local int attributeTotal;
  local int randomIndex;
  local int dropLevel;
  local int i;
  
  // Copy the item level for generating attributes
  dropLevel = itemLevel;
  
  // Decide number of attributes to generate (about nine for lvl 225)
  attributeTotal = itemLevel / 25 + 1;
  
  // Min and max attribute count
  if (attributeTotal < 1) attributeTotal = 1;
  if (attributeTotal > 9) attributeTotal = 9;
  
  // Initialize attribute categories
  for (i = 0; i < class'ROTT_Combat_Enumerations'.static.getGenerationCategoriesCount(); i++) {
    pendingAttributes.addItem(GenerationCategories(i));
  }
  
  // Attribute distribution
  while (attributeCount < attributeTotal && pendingAttributes.length > 0) {
    // Randomly select an attribute
    randomIndex = rand(pendingAttributes.length);
    
    // Attempt to roll attributes
    if (generateItemStat(GenerationCategories(pendingAttributes[randomIndex]), dropLevel)) {
      // Count if successfully rolled
      attributeCount++;
      
      // Check if remaining generation levels depleted
      if (dropLevel <= 0) return;
    }
    
    // Remove attribute from list
    pendingAttributes.remove(randomIndex, 1);
  }
  
}

/*=============================================================================
 * generateItemStat()
 *
 * Attempts to generate stat attributes, and set them on the item if successful
 * - Can roll zero
 * - Can specify generation requirements (e.g. minimum item level)
 * - Can override in subclasses (e.g. double mana for wands)
 * - Returns false if no attribute was set
 *===========================================================================*/
public function bool generateItemStat
(
  GenerationCategories attributeCategory,
  out int dropLevel
) 
{
  local float costPerPoint;
  local int usedLevels;
  
  /// Note: This process starts with a high likelyhood to roll max attributes
  /// and declines in probability with each use
  
  // Randomly select a chunk of the item level to use
  switch (attributeCategory) {
    // Skills
    case CATEGORY_ADD_CLASS_SKILLS:   
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 2);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 15;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_CLASS_SKILLS, 20 + rand(6)));
      
    case CATEGORY_ADD_GLYPH_SKILLS:  
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 4);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 8;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_GLYPH_SKILLS, 30 + rand(11)));
      
    case CATEGORY_ADD_SKILL_POINTS:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 4);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 10;
      
      // Randomly select a skill
      randomSkillType();
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_SKILL_POINTS, 25 + rand(25)));
      
    // Armor
    case CATEGORY_ADD_ARMOR:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 2;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ARMOR));
      
    // Damage
    case CATEGORY_ADD_PHYSICAL_MIN:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_PHYSICAL_MIN));
      
    case CATEGORY_ADD_PHYSICAL_MAX:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_PHYSICAL_MAX));
      
    case CATEGORY_MULTIPLY_ELEMENTAL:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_MULTIPLY_ELEMENTAL));
      
    // Health
    case CATEGORY_ADD_HEALTH:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_HEALTH));
      
    case CATEGORY_ADD_HEALTH_REGEN:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 5;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_HEALTH_REGEN));
      
    case CATEGORY_MULTIPLY_HEALTH:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 5;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_MULTIPLY_HEALTH));
      
    // Mana
    case CATEGORY_ADD_MANA:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_MANA));
      
    case CATEGORY_ADD_MANA_REGEN:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_MANA_REGEN));
      
    case CATEGORY_MULTIPLY_MANA: 
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 4;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_MULTIPLY_MANA));
      
    // Accuracy and dodge
    case CATEGORY_ADD_ACCURACY:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 6);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.5;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ACCURACY));
      
    case CATEGORY_ADD_DODGE:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 6);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.5;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_DODGE));
    // Speed
    case CATEGORY_ADD_SPEED:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_SPEED));
      
    case CATEGORY_REDUCE_ENEMY_SPEED:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_REDUCE_ENEMY_SPEED));
      
    // Stats
    case CATEGORY_PRIMARY_STATS_1:
    case CATEGORY_PRIMARY_STATS_2:
      return generateStatCategory(dropLevel);
      
    // Enchantments
    case CATEGORY_ADD_ENCHANTMENT_LEVEL:
      return (generateEnchantmentIndex(dropLevel));
    // Misc
    case CATEGORY_MISC:
      return (generateMiscCategory(dropLevel));
    
  }
}

/*=============================================================================
 * generateStatCategory()
 *
 * Randomly selects a primary stat boost attribute
 *===========================================================================*/
public function bool generateStatCategory(out int dropLevel) {
  local float costPerPoint;
  local int usedLevels;
  local int randomStat;
  
  randomStat = rand(5);
  
  switch (randomStat) {
    case 0: // All stats
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 6;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ALL_STATS));
      
    case 1: // Strength
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_STRENGTH));
      
    case 2: // Vitality
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_VITALITY));
      
    case 3: // Courage
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_COURAGE));
      
    case 4: // Focus
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_FOCUS));
  }
}

/*=============================================================================
 * randomSkillType()
 *
 * Randomly selects a skill to boost
 *===========================================================================*/
public function randomSkillType() {
  // Random hero class
  switch (rand(4)) {
    case 0: heroSkillType = VALKYRIE; break;
    case 1: heroSkillType = GOLIATH;  break;
    case 2: heroSkillType = WIZARD;   break;
    case 3: heroSkillType = TITAN;    break;
  }
  
  // Random skill
  heroSkillID = rand(8);
}

/*=============================================================================
 * getEnchantmentName()
 *
 * Returns the name of the enchantment boosted by this item
 *===========================================================================*/
public function string getEnchantmentName() {
  local EnchantmentDescriptor script;
  script = class'ROTT_Descriptor_Enchantment_List'.static.getEnchantment(enchantmentType);
  return script.displayText[ENCHANTMENT_NAME];
}

/*=============================================================================
 * generateEnchantmentIndex()
 *
 * Randomly selects an enchantment to boost
 *===========================================================================*/
public function bool generateEnchantmentIndex(out int dropLevel) {
  local float costPerPoint;
  local int usedLevels;
  
  // Random enchantment selection
  enchantmentType = EnchantmentEnum(rand(14));
  
  switch (enchantmentType) {
    case OMNI_SEEKER:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case SERPENTS_ANCHOR:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8, itemLevel / 2);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.4;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
  
    case GRIFFINS_TRINKET:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case GHOSTKINGS_BRANCH:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case OATH_PENDANT:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 5;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case ETERNAL_SPELLSTONE:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8, itemLevel / 2);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.4;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case MYSTIC_MARBLE:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8, itemLevel / 2);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case ARCANE_BLOODPRISM:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8, itemLevel / 2);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case ROSEWOOD_PENDANT:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8, itemLevel / 2);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.5;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case INFINITY_JEWEL:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 3.0;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case EMPERORS_TALISMAN:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 2;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case SCORPION_TALON:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8, itemLevel / 2);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1.25;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case SOLAR_CHARM:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8, itemLevel / 2);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
    case DREAMFIRE_RELIC:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8, itemLevel / 2);
      if (usedLevels > 500) usedLevels = 500;
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1.25;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ENCHANTMENT_LEVEL));
      
  }
  
}

/*=============================================================================
 * generateMiscCategory()
 *
 * Randomly selects an attribute from the misc category
 *===========================================================================*/
public function bool generateMiscCategory(out int dropLevel) {
  local float costPerPoint;
  local int usedLevels;
  local int index;
  
  index = rand(8);
  
  switch (index) {
    // Glyph luck
    case 0:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 4;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_GLYPH_LUCK));
      
    // Luck
    case 0:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 0.5;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_LOOT_LUCK));
      
    // Experience
    case 0:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 8);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_MULTIPLY_EXPERIENCE));
      
    // Faster aura strikes
    case 0:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 4);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 15;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_FASTER_AURA_STRIKES));
  }
  
  yellowLog("Warning (!) Unhandled misc attribute " $ index);
  return false;
}

/*=============================================================================
 * setAttribute()
 *
 * Sets an attribute field based on item level information.
 *
 * -- dropLevel: The number of item levels remaining through the generation 
 *     process
 *
 * -- usedLevels: The chunk of drop levels designated to rolling this attribute
 *
 * -- attributeCost: The number of drop levels per attribute point
 *
 * Return true if an attribute value has been set, false if no change.
 *===========================================================================*/
public function bool setAttribute
(
  out int dropLevel,
  int usedLevels,
  float attributeCost,
  EquipmentAttributes itemField,
  optional int maxLevel = -1
) 
{
  local int attributeLevel;
  
  // Prevent duplicate hits
  if (itemStats[itemField] != 0) {
    yellowLog("Warning (!) Item field hit twice: " $ itemField @ "of" @ int(itemField));
    return false;
  }
  
  // Clamp level usage
  if (usedLevels > dropLevel) {
    /// This is ok if there are less than 5 levels involved... but sloppy
    yellowLog("Warning (!) Using too many item levels: " $ usedLevels @ "of" @ dropLevel);
    usedLevels = dropLevel;
  }
  
  // Set attribute boost based on used levels and cost 
  attributeLevel = usedLevels / attributeCost;
  
  // Cap attribute level
  if (maxLevel != -1) {
    if (attributeLevel > maxLevel) attributeLevel = maxLevel;
  }
  
  // Clamp used levels based on cost per attribute
  usedLevels = attributeCost * (attributeLevel);
  
  // Track levels used on this attribute (returned by reference)
  dropLevel -= usedLevels;
  
  // Store attribute
  itemStats[itemField] += attributeLevel;
  
  return (attributeLevel != 0);
}

/*=============================================================================
 * getSkillName()
 *
 * Returns name of the single skill boosted by this item
 *===========================================================================*/
public function string getSkillName() {
  switch (heroSkillType) {
    case VALKYRIE:
      switch (heroSkillID) {
        case 0: return "Valor Strike";
        case 1: return "Thunder Slash";
        case 2: return "Swift Step";
        case 3: return "Spark Field";
        case 4: return "Vermeil Stitching";
        case 5: return "Electric Sigil";
        case 6: return "Solar Shock";
        case 7: return "Volt Retaliation";
      }
      break;
    case GOLIATH:
      switch (heroSkillID) {
        case 0: return "Stone Strike";
        case 1: return "Intimidate";
        case 2: return "Earthquake";
        case 3: return "Demolish";
        case 4: return "Obsidian Spirit";
        case 5: return "Counter Glyph";
        case 6: return "Marble Spirit";
        case 7: return "Avalanche";
      }
      break;
    case TITAN:
      switch (heroSkillID) {
        case 0: return "Siphon Strike";
        case 1: return "Iron Thrasher";
        case 2: return "Ice Storm";
        case 3: return "Blizzard";
        case 4: return "Oath";
        case 5: return "Meditation";
        case 6: return "Aurora Fangs";
        case 7: return "Fusion";
      }
      break;
    case WIZARD:
      switch (heroSkillID) {
        case 0: return "Starbolt";
        case 1: return "Stardust";
        case 2: return "Spectral Surge";
        case 3: return "Arcane Sigil";
        case 4: return "Devotion";
        case 5: return "Plasma Shroud";
        case 6: return "Black Hole";
        case 7: return "Astral Fire";
      }
      break;
  }
  yellowLog("Warning (!) Unhandled skill name for held item");
  yellowLog("--- heroSkillType : " $ heroSkillType);
  yellowLog("--- heroSkillID : " $ heroSkillID);
  return "";
}

/*=============================================================================
 * minCap()
 *
 * returns the minimum of the two values if the item level is high enough for
 * appropriate splitting of attributes
 *===========================================================================*/
public function float minCap(float a, float b, optional float c = -1.f) {
  // Minimum drop level usage capped for level 40+ (for even distribution)
  if (itemLevel > 40) return min(a, b);
  
  // Minimum drop level optional cap for under level 40
  if (c != -1.f) return min(a, c);
  
  // No cap
  return a;
}

/*=============================================================================
 * getItemCost()
 * 
 * returns the price for purchasing an item through bartering
 *===========================================================================*/
public function array<ItemCost> getItemCost() {
  local array<ItemCost> costList;
  local ItemCost costInfo;
  local int goldCost, gemCost, attributeCount;
  local int i;
  
  attributeCount = class'ROTT_Combat_Enumerations'.static.getEquipmentAttributesCount();
  
  // Sum gold & gem cost
  for (i = 0; i < attributeCount; i++) {
    gemCost += getGemValue(EquipmentAttributes(i)) * quantity;
    goldCost += getGoldValue(EquipmentAttributes(i)) * quantity;
  }
  
  // Set gold cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gold';
  costInfo.quantity = goldCost;
  
  // Add to list
  costList.addItem(costInfo);
  
  // Set gems cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gem';
  costInfo.quantity = gemCost;
  
  // Add to list
  costList.addItem(costInfo);
  
  // Return list
  return costList;
}

/*=============================================================================
 * getGoldValue()
 *
 * returns gold value of the given attribute
 *===========================================================================*/
public function int getGoldValue(EquipmentAttributes attributeIndex) {
  local int attributeLevel;
  
  // Store level of attribute
  attributeLevel = itemStats[attributeIndex];
  
  // Set gold price by attribute type
  switch (attributeIndex) {
    // Skills
    case ITEM_ADD_CLASS_SKILLS:
      return attributeLevel * 1000 * (1.150 ** (attributeLevel - 1));
    case ITEM_ADD_GLYPH_SKILLS:
      return attributeLevel * 650 * (1.115 ** (attributeLevel - 1));
    case ITEM_ADD_SKILL_POINTS:
      return attributeLevel * 400 * (1.100 ** (attributeLevel - 1));
      
    // Armor
    case ITEM_ADD_ARMOR:
      return attributeLevel * 200 * (1.010 ** (attributeLevel / 10));
      
    // Damage
    case ITEM_ADD_PHYSICAL_MIN:
      return attributeLevel * 75 * (1.010 ** (attributeLevel / 25));
    case ITEM_ADD_PHYSICAL_MAX:
      return attributeLevel * 50 * (1.010 ** (attributeLevel / 25));
    case ITEM_MULTIPLY_ELEMENTAL:
      return attributeLevel * 100 * (1.015 ** (attributeLevel / 10));
      
    // Health
    case ITEM_ADD_HEALTH:
      return attributeLevel * 50 * (1.010 ** (attributeLevel / 10));
    case ITEM_ADD_HEALTH_REGEN:
      return attributeLevel * 450 * (1.015 ** (attributeLevel / 10));
    case ITEM_MULTIPLY_HEALTH:
      return attributeLevel * 300 * (1.100 ** (attributeLevel / 5));
      
    // Mana
    case ITEM_ADD_MANA:
      return attributeLevel * 20 * (1.010 ** (attributeLevel / 25));
    case ITEM_ADD_MANA_REGEN:
      return attributeLevel * 125 * (1.010 ** (attributeLevel / 10));
    case ITEM_MULTIPLY_MANA:
      return attributeLevel * 125 * (1.100 ** (attributeLevel / 10));
      
    // Accuracy and dodge
    case ITEM_ADD_ACCURACY:
      return attributeLevel * 20 * (1.001 ** (attributeLevel / 75));
    case ITEM_ADD_DODGE:
      return attributeLevel * 15 * (1.001 ** (attributeLevel / 75));
    
    // Speed
    case ITEM_ADD_SPEED:
      return attributeLevel * 15 * (1.001 ** (attributeLevel / 50));
    case ITEM_REDUCE_ENEMY_SPEED:
      return attributeLevel * 10 * (1.001 ** (attributeLevel / 50));
    
    // Stats
    case ITEM_ADD_ALL_STATS:
      return attributeLevel * 875 * (1.025 ** (attributeLevel / 5));
    case ITEM_ADD_VITALITY:
      return attributeLevel * 500 * (1.025 ** (attributeLevel / 10));
    case ITEM_ADD_STRENGTH:
      return attributeLevel * 200 * (1.025 ** (attributeLevel / 10));
    case ITEM_ADD_COURAGE:
      return attributeLevel * 100 * (1.025 ** (attributeLevel / 10));
    case ITEM_ADD_FOCUS:
      return attributeLevel * 150 * (1.025 ** (attributeLevel / 10));
    
    // Enchantments
    case ITEM_ADD_ENCHANTMENT_LEVEL:
      return getEnchantmentGoldValue();
      
    // Misc
    case ITEM_ADD_GLYPH_LUCK:
      return attributeLevel;
    case ITEM_ADD_LOOT_LUCK:
      return attributeLevel;
    case ITEM_MULTIPLY_EXPERIENCE:
      return attributeLevel;
    case ITEM_FASTER_AURA_STRIKES:
      return attributeLevel;
    case ITEM_LACERATIONS:
      return attributeLevel;
    case ITEM_PERSISTENCE:
      return attributeLevel;
    case ITEM_MULTIPLY_PRAYER:
      return attributeLevel;
    case ITEM_MULTIPLY_HOARD_SIZE:
      return attributeLevel;
  }
}

/*=============================================================================
 * getGemValue()
 *
 * returns gold value of the given attribute
 *===========================================================================*/
public function int getGemValue(EquipmentAttributes attributeIndex) {
  local int attributeLevel;
  
  // Store level of attribute
  attributeLevel = itemStats[attributeIndex];
  
  // Set gem price by attribute type
  switch (attributeIndex) {
    // Skills
    case ITEM_ADD_CLASS_SKILLS:
      return attributeLevel * 5 * (1.125 ** (attributeLevel - 1));
    case ITEM_ADD_GLYPH_SKILLS:
      return attributeLevel * 2 * (1.100 ** (attributeLevel - 1));
    case ITEM_ADD_SKILL_POINTS:
      return attributeLevel * 1 * (1.025 ** (attributeLevel - 1));
      
    // Armor
    case ITEM_ADD_ARMOR:
      return 0;
      
    // Damage
    case ITEM_ADD_PHYSICAL_MIN:
      return 0;
    case ITEM_ADD_PHYSICAL_MAX:
      return 0;
    case ITEM_MULTIPLY_ELEMENTAL:
      return 0;
      
    // Health
    case ITEM_ADD_HEALTH:
      return attributeLevel / 100;
    case ITEM_ADD_HEALTH_REGEN:
      return attributeLevel / 25;
    case ITEM_MULTIPLY_HEALTH:
      return attributeLevel / 10;
      
    // Mana
    case ITEM_ADD_MANA:
      return 0;
    case ITEM_ADD_MANA_REGEN:
      return 0;
    case ITEM_MULTIPLY_MANA:
      return 0;
      
    // Accuracy and dodge
    case ITEM_ADD_ACCURACY:
      return 0;
    case ITEM_ADD_DODGE:
      return 0;
    
    // Speed
    case ITEM_ADD_SPEED:
      return 0;
    case ITEM_REDUCE_ENEMY_SPEED:
      return 0;
    
    // Stats
    case ITEM_ADD_ALL_STATS:
      return 0;
    case ITEM_ADD_VITALITY:
      return 0;
    case ITEM_ADD_STRENGTH:
      return 0;
    case ITEM_ADD_COURAGE:
      return 0;
    case ITEM_ADD_FOCUS:
      return 0;
    
    // Enchantments
    case ITEM_ADD_ENCHANTMENT_LEVEL:
      return getEnchantmentGemValue();
      
    // Misc
    case ITEM_ADD_GLYPH_LUCK:
      return attributeLevel / 2;
    case ITEM_ADD_LOOT_LUCK:
      return attributeLevel / 5;
    case ITEM_MULTIPLY_EXPERIENCE:
      return attributeLevel / 5;
    case ITEM_FASTER_AURA_STRIKES:
      return 0;
    case ITEM_LACERATIONS:
      return 0;
    case ITEM_PERSISTENCE:
      return attributeLevel / 2;
    case ITEM_MULTIPLY_PRAYER:
      return 0;
    case ITEM_MULTIPLY_HOARD_SIZE:
      return 0;
  }
}

/*=============================================================================
 * getEnchantmentGoldValue()
 *
 * returns gold value for the enchantment on this item
 *===========================================================================*/
public function int getEnchantmentGoldValue() {
  local int level;
  
  // Store the attribute level for enchantment boost
  level = itemStats[ITEM_ADD_ENCHANTMENT_LEVEL];
  
  switch (enchantmentType) {
    // Enchantments
    case OMNI_SEEKER:
      return level * 1000 * (1.025 ** (level - 1));
    
    case SERPENTS_ANCHOR:
      return level * 250 * (1.005 ** (level - 1));
    
    case GRIFFINS_TRINKET:
      return level * 200 * (1.004 ** (level - 1));
    
    case GHOSTKINGS_BRANCH:
      return level * 150 * (1.002 ** (level - 1));
    
    case OATH_PENDANT:
      return level * 5000 * (1.125 ** (level - 1));
    
    case ETERNAL_SPELLSTONE:
      return level * 1200 * (1.007 ** (level - 1));
    
    case MYSTIC_MARBLE:
      return level * 800 * (1.006 ** (level - 1));
    
    case ARCANE_BLOODPRISM:
      return level * 1200 * (1.010 ** (level - 1));
    
    case ROSEWOOD_PENDANT:
      return level * 1450 * (1.008 ** (level - 1));
    
    case INFINITY_JEWEL:
      return level * 950 * (1.005 ** (level - 1));
    
    case EMPERORS_TALISMAN:
      return level * 1450 * (1.050 ** (level - 1));
    
    case SCORPION_TALON:
      return level * 650 * (1.002 ** (level - 1));
    
    case SOLAR_CHARM:
      return level * 750 * (1.005 ** (level - 1));
    
    case DREAMFIRE_RELIC:
      return level * 550 * (1.005 ** (level - 1));
    
  }
}

/*=============================================================================
 * getEnchantmentGemValue()
 *
 * returns gem value for the enchantment on this item
 *===========================================================================*/
public function int getEnchantmentGemValue() {
  local int level;
  
  // Store the attribute level for enchantment boost
  level = itemStats[ITEM_ADD_ENCHANTMENT_LEVEL];
  
  switch (enchantmentType) {
    // Enchantments
    case OMNI_SEEKER:
      return level * 2 * (1.005 ** (level - 1));
    
    case SERPENTS_ANCHOR:
      return level * 1;
    
    case GRIFFINS_TRINKET:
      return level * 1;
    
    case GHOSTKINGS_BRANCH:
      return level * 1;
    
    case OATH_PENDANT:
      return level * 8 * (1.0250 ** (level - 1));
    
    case ETERNAL_SPELLSTONE:
      return level * 1 * (1.0008 ** (level - 1));
    
    case MYSTIC_MARBLE:
      return level * 1 * (1.0012 ** (level - 1));
    
    case ARCANE_BLOODPRISM:
      return level * 2 * (1.0020 ** (level - 1));
    
    case ROSEWOOD_PENDANT:
      return level * 2 * (1.0010 ** (level - 1));
    
    case INFINITY_JEWEL:
      return level * 2 * (1.0005 ** (level - 1));
    
    case EMPERORS_TALISMAN:
      return level * 4 * (1.0050 ** (level - 1));
    
    case SCORPION_TALON:
      return level * 1;
    
    case SOLAR_CHARM:
      return level * 2;
    
    case DREAMFIRE_RELIC:
      return level * 1;
    
  }
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  quantity=1
  
  // Default color
  itemFont=DEFAULT_SMALL_WHITE
  
}



































