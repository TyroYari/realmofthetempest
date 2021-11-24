/*============================================================================= 
 * ROTT_Inventory_Item_Bottle_Swamp_Husks
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Bottle_Swamp_Husks extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Swamp Husks"
  
  // Hard stats
  itemStats(ITEM_ADD_LOOT_LUCK)=5
  itemStats(ITEM_MULTIPLY_ELEMENTAL)=10
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Bottles.Item_Bottle_Purple'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


