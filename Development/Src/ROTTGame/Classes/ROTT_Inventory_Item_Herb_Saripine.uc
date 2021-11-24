/*============================================================================= 
 * ROTT_Inventory_Item_Herb_Saripine
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Consumed at the Etzland shrine for experience
 *===========================================================================*/
 
class ROTT_Inventory_Item_Herb_Saripine extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Saripine Petal"
  
  // Hard attributes
  itemStats(ITEM_ADD_DODGE)=45
  itemStats(ITEM_PERSISTENCE)=5
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Herbs.Item_Herb_Purple'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


