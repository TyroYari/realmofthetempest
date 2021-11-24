/*============================================================================= 
 * ROTT_Inventory_Item_Bottle_Nettle_Roots
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * 
 *===========================================================================*/
 
class ROTT_Inventory_Item_Bottle_Nettle_Roots extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Nettle Roots"
  
  // Hard attributes
  itemStats(ITEM_ADD_ACCURACY)=60
  itemStats(ITEM_ADD_PHYSICAL_MIN)=10
  itemStats(ITEM_ADD_PHYSICAL_MAX)=35
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Bottles.Item_Bottle_Green'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


