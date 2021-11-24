/*============================================================================= 
 * ROTT_Inventory_Item_Bottle_Yinras_Ore
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Bottle_Yinras_Ore extends ROTT_Inventory_Item_Ritual_Base;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  if (bBestiaryDrop) return 0;
  
  // Filter low level drops to nerf getting class skill boost early
  if (dropLevel < 20) return 0;
  dropLevel -= 20;
  
  // Linear climb until cap
  if (dropLevel < 25) return 2.5 - ((25 - dropLevel) * 0.1f);
  
  // Cap
  return 2.5;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Yinras Ore"
  
  // Hard attributes
  itemStats(ITEM_ADD_CLASS_SKILLS)=1
  itemStats(ITEM_ADD_SPEED)=10
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Bottles.Item_Bottle_Gold'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


