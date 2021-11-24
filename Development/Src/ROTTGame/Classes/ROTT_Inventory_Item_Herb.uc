/*============================================================================= 
 * ROTT_Inventory_Item_Herb
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Consumed at the Etzland shrine for experience
 *===========================================================================*/
 
class ROTT_Inventory_Item_Herb extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Herb"
  
  // Hard attributes
  itemStats(ITEM_MULTIPLY_EXPERIENCE)=5
  itemStats(ITEM_ADD_ACCURACY)=25
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Herbs.Item_Herb_Green'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


