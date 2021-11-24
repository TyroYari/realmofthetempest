/*============================================================================= 
 * ROTT_Inventory_Item_Charm_Kamita
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Charm_Kamita extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Kamita Charm"
  
  // Hard stats
  itemStats(ITEM_ADD_FOCUS)=5
  itemStats(ITEM_ADD_ARMOR)=10
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Charms.Item_Charm_Teal'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


