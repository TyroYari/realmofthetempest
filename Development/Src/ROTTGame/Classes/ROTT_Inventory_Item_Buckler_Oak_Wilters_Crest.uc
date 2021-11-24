/*============================================================================= 
 * ROTT_Inventory_Item_Buckler_Oak_Wilters_Crest
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Rare equipable item
 *===========================================================================*/
 
class ROTT_Inventory_Item_Buckler_Oak_Wilters_Crest extends ROTT_Inventory_Item_Ritual_Base;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  local float dropChance;
  
  // Cut until minimum drop level
  if (dropLevel < 50) return 0;
  
  // Linear scaling by drop level
  dropChance = 0.015f + (dropLevel * 0.001f);
  
  // Cap
  if (dropChance > 2.f) dropChance = 2.f; 
  
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
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_SPECIAL
  
  // Display name
  itemName="Oak Wilter's Crest"
  
  // Hard attributes
  itemStats(ITEM_ADD_GLYPH_SKILLS)=4
  itemStats(ITEM_ADD_ARMOR)=240
  itemStats(ITEM_ADD_PHYSICAL_MAX)=85
  itemStats(ITEM_ADD_HEALTH_REGEN)=10
  itemStats(ITEM_ADD_ALL_STATS)=10
  itemStats(ITEM_ADD_STRENGTH)=25
  itemStats(ITEM_ADD_COURAGE)=25
  itemStats(ITEM_REDUCE_ENEMY_SPEED)=1000
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Special'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TEAL
}


