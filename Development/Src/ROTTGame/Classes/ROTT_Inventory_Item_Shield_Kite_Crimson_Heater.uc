/*============================================================================= 
 * ROTT_Inventory_Item_Shield_Kite_Crimson_Heater
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Rare equipable item
 *===========================================================================*/
 
class ROTT_Inventory_Item_Shield_Kite_Crimson_Heater extends ROTT_Inventory_Item_Ritual_Base;

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
  itemName="Crimson Heater" // Scorched
  
  // Hard attributes
  itemStats(ITEM_ADD_CLASS_SKILLS)=2
  itemStats(ITEM_ADD_ARMOR)=100
  itemStats(ITEM_ADD_PHYSICAL_MIN)=35
  itemStats(ITEM_ADD_PHYSICAL_MAX)=75
  itemStats(ITEM_MULTIPLY_ELEMENTAL)=25
  itemStats(ITEM_ADD_HEALTH)=40
  itemStats(ITEM_ADD_HEALTH_REGEN)=5
  itemStats(ITEM_MULTIPLY_HEALTH)=5
  itemStats(ITEM_ADD_SPEED)=50
  itemStats(ITEM_MULTIPLY_EXPERIENCE)=10
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Special'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TEAL
}


