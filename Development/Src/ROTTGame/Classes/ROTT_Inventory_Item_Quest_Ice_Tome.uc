/*============================================================================= 
 * ROTT_Inventory_Item_Quest_Ice_Tome
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Quest item, Ornament of Chaos, held by the Haxlyn Citadel boss
 *===========================================================================*/
 
class ROTT_Inventory_Item_Quest_Ice_Tome extends ROTT_Inventory_Item;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  return 0;
}

/*=============================================================================
 * getMinQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMinQuantity(int dropLevel) {
  if (gameInfo.playerProfile.findItem(self.class) != none) return 0;
  return 1;
}

/*=============================================================================
 * getMaxQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMaxQuantity(int dropLevel) {
  if (gameInfo.playerProfile.findItem(self.class) != none) return 0;
  return 1;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_QUEST
  
  // Display name
  itemName="Ice Tome"
  
  // Hard attributes
  itemStats(ITEM_ADD_CLASS_SKILLS)=1
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Quest_Items.Ornament_Of_Chaos_Ice_Tome'
  
  // Item text color
  itemFont=DEFAULT_SMALL_PURPLE
}


