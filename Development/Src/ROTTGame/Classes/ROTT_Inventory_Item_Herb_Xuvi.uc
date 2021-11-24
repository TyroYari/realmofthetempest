/*============================================================================= 
 * ROTT_Inventory_Item_Herb_Xuvi
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Consumed at the Etzland shrine for experience
 *===========================================================================*/
 
class ROTT_Inventory_Item_Herb_Xuvi extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Xuvi Herb"
  
  // Hard attributes
  itemStats(ITEM_ADD_STRENGTH)=10
  itemStats(ITEM_LACERATIONS)=5
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Herbs.Item_Herb_Red'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


