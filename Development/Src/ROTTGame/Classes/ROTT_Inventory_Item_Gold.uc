/*============================================================================= 
 * ROTT_Inventory_Item_Gold
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Currency for gold
 *===========================================================================*/
 
class ROTT_Inventory_Item_Gold extends ROTT_Inventory_Item;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  if (bBestiaryDrop) return 0;
  return 100.f;
}

/*=============================================================================
 * getMinQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMinQuantity(int dropLevel) {
  return 5 + 20 * dropLevel;
  ///return 50 * dropLevel;
}

/*=============================================================================
 * getMaxQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMaxQuantity(int dropLevel) {
  return 25 + 40 * dropLevel;
  ///return 75 * dropLevel;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CURRENCY
  
  // Display name
  itemName="Gold"
  
  // Item texture
  itemTexture=Texture2D'GUI.Item_Currency_Gold'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TAN
}


