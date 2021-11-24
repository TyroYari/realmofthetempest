/*============================================================================= 
 * ROTT_Inventory_Item_Charm_Zogis_Anchor
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Rare equipable item
 *===========================================================================*/
 
class ROTT_Inventory_Item_Charm_Zogis_Anchor extends ROTT_Inventory_Item;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  local float dropChance;
  
  // Cut until minimum drop level
  if (dropLevel < 25) return 0;
  
  // Linear scaling by drop level
  dropChance = 0.05f + (dropLevel * 0.001f);
  
  // Cap
  if (dropChance > 2.f) dropChance = 2.f; 
  
  return dropChance;
}

/*=============================================================================
 * getMinQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMinQuantity(int dropLevel) {
  return 1;
}

/*=============================================================================
 * getMaxQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMaxQuantity(int dropLevel) {
  return 1;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_SPECIAL
  
  // Display name
  itemName="Zogi's Anchor"
  
  // Hard attributes
  itemStats(ITEM_ADD_CLASS_SKILLS)=3
  itemStats(ITEM_ADD_GLYPH_SKILLS)=5
  itemStats(ITEM_MULTIPLY_MANA)=75
  itemStats(ITEM_ADD_HEALTH_REGEN)=10
  itemStats(ITEM_ADD_MANA_REGEN)=100
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Charms.Item_Charm_Pink'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TEAL
}


