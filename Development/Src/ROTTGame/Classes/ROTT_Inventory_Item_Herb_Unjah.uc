/*============================================================================= 
 * ROTT_Inventory_Item_Herb_Unjah
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Consumed at the Etzland shrine for experience
 *===========================================================================*/
 
class ROTT_Inventory_Item_Herb_Unjah extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Unjah Petal"
  
  // Hard attributes
  itemStats(ITEM_ADD_MANA_REGEN)=10
  itemStats(ITEM_ADD_HEALTH)=25
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Herbs.Item_Herb_Cyan'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


