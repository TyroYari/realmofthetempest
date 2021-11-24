/*============================================================================= 
 * ROTT_Inventory_Item_Bottle_Faerie_Bones
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Bottle_Faerie_Bones extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Faerie Bones"
  
  // Hard attributes
  itemStats(ITEM_ADD_HEALTH_REGEN)=4
  itemStats(ITEM_ADD_VITALITY)=10
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Bottles.Item_Bottle_Pink'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


