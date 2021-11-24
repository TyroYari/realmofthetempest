/*============================================================================= 
 * ROTT_Inventory_Item_Paintbrush
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Equipment
 *===========================================================================*/
 
class ROTT_Inventory_Item_Paintbrush extends ROTT_Inventory_Item;

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
    // Better skill point rolls
    case CATEGORY_ADD_SKILL_POINTS:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 4);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 4;
      
      // Randomly select a skill
      randomSkillType();
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_SKILL_POINTS, 25 + rand(25)));
      
    // Better health regeneration
    case CATEGORY_ADD_HEALTH_REGEN:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 2;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_HEALTH_REGEN));
      
    // Better mana regen
    case CATEGORY_ADD_MANA_REGEN:
      // Randomly select how much of the items drop levels to use
      usedLevels = rand(dropLevel - 5) + 5;
      
      // Cap max level usage
      usedLevels = minCap(usedLevels, itemLevel / 5);
      
      // Set number of drop levels required per attribute point
      costPerPoint = 1;
      
      // Attempt to set attribute
      return (setAttribute(dropLevel, usedLevels, costPerPoint, ITEM_ADD_MANA_REGEN));
      
    default:
      return super.generateItemStat(attributeCategory, dropLevel);
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
  itemName="Paintbrush"
  
  // Item texture
  ///itemTexture=Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Red'
  
  // Item Textures
  itemClanTextures(CLAN_BLUE)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Blue'
  itemClanTextures(CLAN_CYAN)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Cyan'
  itemClanTextures(CLAN_GREEN)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Green'
  itemClanTextures(CLAN_GOLD)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Gold'
  itemClanTextures(CLAN_ORANGE)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Orange'
  itemClanTextures(CLAN_RED)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Red'
  itemClanTextures(CLAN_VIOLET)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Violet'
  itemClanTextures(CLAN_PURPLE)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Purple'
  itemClanTextures(CLAN_BLACK)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Black'
  itemClanTextures(CLAN_WHITE)=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_White'
  
  // Item text color
  itemFont=DEFAULT_SMALL_GREEN
}


