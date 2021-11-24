/*============================================================================= 
 * ROTT_Inventory_Item_Quest_Goblet
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Quest item, Ornament of Chaos, held by the Haxlyn Citadel boss
 *===========================================================================*/
 
class ROTT_Inventory_Item_Quest_Goblet extends ROTT_Inventory_Item;

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
  itemName="Chaos Goblet"
  
  // Hard attributes
  itemStats(ITEM_ADD_MANA_REGEN)=13
  itemStats(ITEM_ADD_HEALTH_REGEN)=18
  itemStats(ITEM_ADD_LOOT_LUCK)=45
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Quest_Items.Ornament_Of_Chaos_Goblet'
  
  // Item text color
  itemFont=DEFAULT_SMALL_PURPLE
}


