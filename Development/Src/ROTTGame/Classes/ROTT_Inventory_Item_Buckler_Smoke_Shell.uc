/*============================================================================= 
 * ROTT_Inventory_Item_Buckler_Smoke_Shell
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Rare equipable item
 *===========================================================================*/
 
class ROTT_Inventory_Item_Buckler_Smoke_Shell extends ROTT_Inventory_Item_Ritual_Base;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  local float dropChance;
  
  // Cut until minimum drop level
  if (dropLevel < 40) return 0;
  
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
  itemName="Smoke Shell"
  
  // Hard attributes
  itemStats(ITEM_ADD_CLASS_SKILLS)=4
  itemStats(ITEM_ADD_ARMOR)=180
  itemStats(ITEM_ADD_MANA_REGEN)=10
  itemStats(ITEM_ADD_MANA)=200
  itemStats(ITEM_MULTIPLY_MANA)=10
  itemStats(ITEM_ADD_FOCUS)=25
  itemStats(ITEM_ADD_DODGE)=1250
  itemStats(ITEM_ADD_LOOT_LUCK)=100
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Buckler_Shields.Buckler_Rainbow'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TEAL
}


