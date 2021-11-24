/*============================================================================= 
 * ROTT_Inventory_Item_Charm_Myroka
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Charm_Myroka extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Myroka Charm"
  
  // Hard stats
  itemStats(ITEM_FASTER_AURA_STRIKES)=5
  itemStats(ITEM_ADD_MANA)=60
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Charms.Item_Charm_Blue'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


