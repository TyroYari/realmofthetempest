/*============================================================================= 
 * ROTT_Inventory_Item_Bottle_Norkiva_Chips
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Recipe ingredient.
 *===========================================================================*/
 
class ROTT_Inventory_Item_Bottle_Norkiva_Chips extends ROTT_Inventory_Item_Ritual_Base;

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CONSUMABLE
  
  // Display name
  itemName="Norkiva Chips"
  
  // Hard attributes
  itemStats(ITEM_ADD_GLYPH_SKILLS)=1
  itemStats(ITEM_ADD_ARMOR)=5
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Bottles.Item_Bottle_Orange'
  
  // Item text color
  itemFont=DEFAULT_SMALL_ORANGE
}


