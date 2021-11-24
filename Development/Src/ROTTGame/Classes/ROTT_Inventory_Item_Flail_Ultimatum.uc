/*============================================================================= 
 * ROTT_Inventory_Item_Flail_Ultimatum
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Rare equipable item
 *===========================================================================*/
 
class ROTT_Inventory_Item_Flail_Ultimatum extends ROTT_Inventory_Item_Ritual_Base;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  local float dropChance;
  
  // Cut until minimum drop level
  if (dropLevel < 25) return 0;
  
  // Linear scaling by drop level
  dropChance = 0.05f + (dropLevel * 0.001f);
  
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
  itemName="Ultimatum"
  
  // Hard attributes
  itemStats(ITEM_ADD_HEALTH)=800
  itemStats(ITEM_ADD_HEALTH_REGEN)=20
  itemStats(ITEM_MULTIPLY_HEALTH)=10
  itemStats(ITEM_ADD_MANA)=1200
  itemStats(ITEM_ADD_MANA_REGEN)=45
  itemStats(ITEM_MULTIPLY_MANA)=25
  itemStats(ITEM_ADD_ALL_STATS)=10
  itemStats(ITEM_ADD_GLYPH_LUCK)=40
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Flails.Flail_Ultimatum'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TEAL
}


