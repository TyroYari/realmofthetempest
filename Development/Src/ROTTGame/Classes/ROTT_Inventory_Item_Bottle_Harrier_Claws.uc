/*============================================================================= 
 * ROTT_Inventory_Item_Bottle_Harrier_Claws
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Bottle_Harrier_Claws extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Harrier Claws"
  
  // Hard stats
  itemStats(ITEM_MULTIPLY_ELEMENTAL)=15
  itemStats(ITEM_ADD_MANA)=25
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Bottles.Item_Bottle_Blue'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


