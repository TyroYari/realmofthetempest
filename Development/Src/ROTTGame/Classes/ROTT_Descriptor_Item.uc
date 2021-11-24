/*=============================================================================
 * ROTT_Descriptor_Item
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Given an item, this class formats display information.
 *===========================================================================*/

class ROTT_Descriptor_Item extends ROTT_Descriptor;

// Store item for formatting
var private ROTT_Inventory_Item formatTarget;

/*=============================================================================
 * formatItem()
 *
 * Given an item, this calls the format process.
 *===========================================================================*/
public function formatItem(ROTT_Inventory_Item item) {
  formatTarget = item;
  setUI();
}

/*=============================================================================
 * setUI()
 *
 * Assigns display information
 *===========================================================================*/
public function setUI() {
  local string itemCategory;
  local FontStyles headerFont;
  local int i;
  
  // Set header
  switch (formatTarget.itemFont) {
    case DEFAULT_SMALL_TAN:      headerFont = DEFAULT_MEDIUM_GOLD;    break;
    case DEFAULT_SMALL_ORANGE:   headerFont = DEFAULT_MEDIUM_ORANGE;  break;
    case DEFAULT_SMALL_CYAN:     headerFont = DEFAULT_MEDIUM_CYAN;    break;
    case DEFAULT_SMALL_TEAL:     headerFont = DEFAULT_MEDIUM_TEAL;    break;
    case DEFAULT_SMALL_PURPLE:   headerFont = DEFAULT_MEDIUM_PURPLE;  break;
    case DEFAULT_SMALL_GREEN:    headerFont = DEFAULT_MEDIUM_GREEN;   break;
  }
  
  h1(
    formatTarget.itemName,
    headerFont
  );
  
  // Set sub-heading
  switch (formatTarget.category) {
    case ITEM_CATEGORY_CURRENCY:   
      itemCategory = "(Currency)";          
      break;
    case ITEM_CATEGORY_CONSUMABLE: 
      itemCategory = "(Ritual Ingredient)"; 
      break;
    case ITEM_CATEGORY_EQUIPABLE:  
      itemCategory = "(Equipment :: Drop Lvl " $ formatTarget.itemLevel $ ")";         
      break;
    case ITEM_CATEGORY_SPECIAL:  
      itemCategory = "(Special Equipment)";         
      break;
    case ITEM_CATEGORY_QUEST:  
      itemCategory = "(Quest Item)";         
      break;
  }
  
  h2(
    itemCategory
  );
  
  // Display item attribute
  for (i = 0; i <= 8; i++) {
    displayInfo[i+2].labelText = formatTarget.getAttributeText(i);
    displayInfo[i+2].labelFont = formatTarget.getAttributeFont(i);
  }
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  
}















