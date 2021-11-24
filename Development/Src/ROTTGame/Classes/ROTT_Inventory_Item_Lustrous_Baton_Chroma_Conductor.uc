/*============================================================================= 
 * ROTT_Inventory_Item_Lustrous_Baton_Chroma_Conductor
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Rare equipable item
 *===========================================================================*/
 
class ROTT_Inventory_Item_Lustrous_Baton_Chroma_Conductor extends ROTT_Inventory_Item_Ritual_Base;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  local float dropChance;
  
  // Cut until minimum drop level
  if (dropLevel < 30) return 0;
  
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
  itemName="Chroma Conductor"
  
  // Hard attributes
  itemStats(ITEM_ADD_GLYPH_SKILLS)=5
  itemStats(ITEM_ADD_ALL_STATS)=25
  itemStats(ITEM_MULTIPLY_ELEMENTAL)=350
  itemStats(ITEM_ADD_MANA)=750
  itemStats(ITEM_ADD_ACCURACY)=1000
  itemStats(ITEM_ADD_DODGE)=800
  itemStats(ITEM_ADD_LOOT_LUCK)=100
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Rainbow'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TEAL
}


