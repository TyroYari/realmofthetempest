/*============================================================================= 
 * ROTT_Inventory_Item_Herb_Jengsu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Consumed at the Etzland shrine for experience
 *===========================================================================*/
 
class ROTT_Inventory_Item_Herb_Jengsu extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Jengsu Leaf"
  
  // Hard attributes
  itemStats(ITEM_ADD_COURAGE)=10
  itemStats(ITEM_REDUCE_ENEMY_SPEED)=15
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Herbs.Item_Herb_Orange'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


