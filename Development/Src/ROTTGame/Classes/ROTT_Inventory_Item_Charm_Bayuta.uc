/*============================================================================= 
 * ROTT_Inventory_Item_Charm_Bayuta
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Charm_Bayuta extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Bayuta Charm"
  
  // Hard attributes
  itemStats(ITEM_ADD_DODGE)=45
  itemStats(ITEM_MULTIPLY_MANA)=5
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Charms.Item_Charm_Purple'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}

