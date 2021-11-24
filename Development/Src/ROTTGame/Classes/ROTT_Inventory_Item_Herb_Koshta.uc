/*============================================================================= 
 * ROTT_Inventory_Item_Herb_Koshta
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Consumed at the Etzland shrine for experience
 *===========================================================================*/
 
class ROTT_Inventory_Item_Herb_Koshta extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Koshta Petal"
  
  // Hard attributes
  itemStats(ITEM_ADD_HEALTH)=40
  itemStats(ITEM_ADD_LOOT_LUCK)=5
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Herbs.Item_Herb_Violet'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


