/*============================================================================= 
 * ROTT_Inventory_Item_Charm_Cerok
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Charm_Cerok extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Cerok Charm"
  
  // Hard stats
  itemStats(ITEM_ADD_STRENGTH)=5
  itemStats(ITEM_MULTIPLY_HEALTH)=5
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Charms.Item_Charm_Red'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


