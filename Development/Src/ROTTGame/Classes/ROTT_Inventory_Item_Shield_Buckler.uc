/*============================================================================= 
 * ROTT_Inventory_Item_Shield_Buckler
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Equipment
 *===========================================================================*/
 
class ROTT_Inventory_Item_Shield_Buckler extends ROTT_Inventory_Item;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  local float dropChance;
  
  // Linear scaling by drop level
  dropChance = 0.5f + (dropLevel * 0.1f);
  
  // Cap
  if (dropChance > 10.f) dropChance = 10.f; 
  
  return dropChance;
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
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMaxQuantity(int dropLevel) {
  return 1;
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
    // Better glyph roll
    case CATEGORY_ADD_GLYPH_SKILLS:  
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 4);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 6;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_GLYPH_SKILLS, 30 + rand(11)));
      
    default:
      return super.generateItemStat(attributeCategory, dropLevel);
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
      costPerPoint = 3;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_ALL_STATS));
      
    case 1: // Strength
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 2;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_STRENGTH));
      
    case 2: // Vitality
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 2;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_VITALITY));
      
    case 3: // Courage
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 2;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_COURAGE));
      
    case 4: // Focus
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 2;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_FOCUS));
  }
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_EQUIPABLE
  bDoesNotStack=true
  bUseClanColor=true
  
  // Display name
  itemName="Buckler Shield"
  
  // Item texture
  ///itemTexture=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Shield_Red'
  
  // Item Textures
  itemClanTextures(CLAN_BLUE)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Blue'
  itemClanTextures(CLAN_CYAN)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Cyan'
  itemClanTextures(CLAN_GREEN)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Green'
  itemClanTextures(CLAN_GOLD)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Gold'
  itemClanTextures(CLAN_ORANGE)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Orange'
  itemClanTextures(CLAN_RED)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Red'
  itemClanTextures(CLAN_VIOLET)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Violet'
  itemClanTextures(CLAN_PURPLE)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Purple'
  itemClanTextures(CLAN_BLACK)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Black'
  itemClanTextures(CLAN_WHITE)=Texture2D'ROTT_Items.Buckler_Shields.Buckler_White'
  
  // Item text color
  itemFont=DEFAULT_SMALL_GREEN
}


