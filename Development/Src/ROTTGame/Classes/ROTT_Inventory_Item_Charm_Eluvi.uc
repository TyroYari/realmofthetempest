/*============================================================================= 
 * ROTT_Inventory_Item_Charm_Eluvi
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * 
 *===========================================================================*/
 
class ROTT_Inventory_Item_Charm_Eluvi extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Eluvi Charm"
  
  // Hard stats
  itemStats(ITEM_ADD_STRENGTH)=10
  itemStats(ITEM_ADD_PHYSICAL_MAX)=10
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Charms.Item_Charm_Orange'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


