/*============================================================================= 
 * ROTT_Inventory_Item_Ritual_Base
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Ritual drops stem from here.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Ritual_Base extends ROTT_Inventory_Item abstract;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  if (bBestiaryDrop) return 0;
  
  // Linear climb until cap
  if (dropLevel < 25) return 2.5 - ((25 - dropLevel) * 0.1f);
  
  // Cap
  return 2.5;
}

/*=============================================================================
 * getMinQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMinQuantity(int dropLevel) {
  return dropLevel / 100 + 1;
}

/*=============================================================================
 * getMaxQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMaxQuantity(int dropLevel) {
  return dropLevel / 100 + 1;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


