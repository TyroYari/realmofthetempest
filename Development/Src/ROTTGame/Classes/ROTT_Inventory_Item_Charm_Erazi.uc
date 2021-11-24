/*============================================================================= 
 * ROTT_Inventory_Item_Charm_Erazi
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Charm_Erazi extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Erazi Charm"
  
  // Hard stats
  itemStats(ITEM_ADD_SPEED)=25
  itemStats(ITEM_PERSISTENCE)=80///10
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Charms.Item_Charm_Gold'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


