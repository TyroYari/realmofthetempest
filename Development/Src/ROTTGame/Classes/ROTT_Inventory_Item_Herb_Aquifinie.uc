/*============================================================================= 
 * ROTT_Inventory_Item_Herb_Aquifinie
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Consumed at the Etzland shrine for experience
 *===========================================================================*/
 
class ROTT_Inventory_Item_Herb_Aquifinie extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Aquifinie Petal"
  
  // Hard attributes
  itemStats(ITEM_MULTIPLY_MANA)=5
  itemStats(ITEM_ADD_FOCUS)=10
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Herbs.Item_Herb_Blue'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


