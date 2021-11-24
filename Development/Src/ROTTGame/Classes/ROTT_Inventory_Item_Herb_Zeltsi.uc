/*============================================================================= 
 * ROTT_Inventory_Item_Herb_Zeltsi
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Consumed at the Etzland shrine for experience
 *===========================================================================*/
 
class ROTT_Inventory_Item_Herb_Zeltsi extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Zeltsi Leaf"
  
  // Hard attributes
  itemStats(ITEM_ADD_ALL_STATS)=1
  itemStats(ITEM_ADD_GLYPH_LUCK)=5
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Herbs.Item_Herb_Gold'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


