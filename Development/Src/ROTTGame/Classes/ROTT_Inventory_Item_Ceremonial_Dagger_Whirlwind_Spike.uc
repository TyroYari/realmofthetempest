/*============================================================================= 
 * ROTT_Inventory_Item_Ceremonial_Dagger_Whirlwind_Spike
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Rare equipable item
 *===========================================================================*/
 
class ROTT_Inventory_Item_Ceremonial_Dagger_Whirlwind_Spike extends ROTT_Inventory_Item_Ritual_Base;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  local float dropChance;
  
  // Cut until minimum drop level
  if (dropLevel < 35) return 0;
  
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
  itemName="Whirlwind Spike"
  
  // Hard attributes
  itemStats(ITEM_ADD_ACCURACY)=945
  itemStats(ITEM_ADD_DODGE)=3000
  itemStats(ITEM_ADD_STRENGTH)=40
  itemStats(ITEM_ADD_COURAGE)=40
  itemStats(ITEM_ADD_FOCUS)=40
  itemStats(ITEM_PERSISTENCE)=100
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Whirlwind_Spike'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TEAL
}


