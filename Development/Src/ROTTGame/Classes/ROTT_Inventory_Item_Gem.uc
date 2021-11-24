/*============================================================================= 
 * ROTT_Inventory_Item_Gem
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Currency for gems
 *===========================================================================*/
 
class ROTT_Inventory_Item_Gem extends ROTT_Inventory_Item;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  if (bBestiaryDrop) return 0;
  if (dropLevel >= 150) return 50.f;
  return 20.f;
}

/*=============================================================================
 * getMinQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMinQuantity(int dropLevel) {
  local float min;
  
  // Min gem growth ... Θ(n) + Θ(n / logn) = Θ(n)
  min = 0.01 * dropLevel;
  min += 0.2 * dropLevel / (1 + logn(dropLevel, 5));
  
  // Cap
  if (min > 45) min = 45;
  
  return min; 
}
  
/*=============================================================================
 * logn()
 *
 * Logarithm base n.
 *===========================================================================*/
public static function float logn(float input, float n) {
  return loge(input) / (loge(n)); 
}

/*=============================================================================
 * getMaxQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMaxQuantity(int dropLevel) {
  local float max;
  
  // Max gem growth is Θ(nlogn)
  max = getMinQuantity(dropLevel);
  max += 0.05 * dropLevel * (1 + int((logn(dropLevel, 5))) / 5.f) / 100.f;
  
  // Cap
  if (max > 100) max = 100;
  
  return max;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CURRENCY
  
  // Display name
  itemName="Gems"
  
  // Item texture
  itemTexture=Texture2D'GUI.Item_Currency_Gem'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TAN
}










