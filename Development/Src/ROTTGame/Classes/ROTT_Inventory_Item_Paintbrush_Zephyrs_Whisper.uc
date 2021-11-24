/*============================================================================= 
 * ROTT_Inventory_Item_Paintbrush_Zephyrs_Whisper
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Rare equipable item
 *===========================================================================*/
 
class ROTT_Inventory_Item_Paintbrush_Zephyrs_Whisper extends ROTT_Inventory_Item_Ritual_Base;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel, bool bBestiaryDrop) {
  local float dropChance;
  
  // Cut until minimum drop level
  if (dropLevel < 35) return 0;
  
  // Linear scaling by drop level
  dropChance = 0.02f + (dropLevel * 0.001f);
  
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
  itemName="Zephyr's Whisper"
  
  // Hard attributes
  itemStats(ITEM_ADD_GLYPH_SKILLS)=12
  itemStats(ITEM_ADD_HEALTH)=45
  itemStats(ITEM_MULTIPLY_MANA)=300
  itemStats(ITEM_MULTIPLY_EXPERIENCE)=65
  
  // Item texture
  itemTexture=Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Rainbow'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TEAL
}


