/*============================================================================= 
 * ROTT_Inventory_Package
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A container that manages an inventory of items.
 *===========================================================================*/
 
class ROTT_Inventory_Package extends ROTT_Object;

// Linked list type storage system
var privatewrite array<ROTT_Inventory_Item> itemList;

/*=============================================================================
 * takeInventory()
 *
 * Combines the current inventory with the given inventory.
 *===========================================================================*/
public function takeInventory(ROTT_Inventory_Package otherInventory) {
  local int i;
  
  // Add each item one by one, combining with existing quantities
  for (i = otherInventory.count() - 1; i >= 0; i--) {
    // Add item to inventory
    addItem(otherInventory.itemList[i]);
    
    // Remove item from inventory
    otherInventory.itemList.remove(i, 1);
  }
  
  // Sort the items
  sortSpecials(sort());
}

/*=============================================================================
 * addItems()
 *
 * Combines the current item list with the given item list.
 *===========================================================================*/
public function addItems(array<ROTT_Inventory_Item> newItems) {
  local int i;
  
  // Add each item one by one, combining with existing quantities
  for (i = 0; i < newItems.length; i++) {
    addItem(newItems[i]);
  }
}

/*=============================================================================
 * addItem()
 *
 * Adds the item to the inventory list, while consolidating items by types.
 *===========================================================================*/
public function addItem
(
  ROTT_Inventory_Item newItem, 
  optional bool bSkipSort = false
) 
{
  local int i;

  // Look for the item already in the list
  for (i = 0; i < itemList.length; i++) {
    // Check by item type
    if (itemList[i].class == newItem.class && !itemList[i].bDoesNotStack) {
      // Combine quantities
      itemList[i].addQuantity(newItem.quantity);
      return;
    }
  }
  
  // Since the item is not already in the list, add it
  itemList.addItem(newItem);
  
  // Sort the items
  if (!bSkipSort) { sortSpecials(sort()); }
}

/*=============================================================================
 * findItem()
 *
 * Access an item by type
 *===========================================================================*/
public function ROTT_Inventory_Item findItem(class<ROTT_Inventory_Item> itemClass) {
  local int i;
  
  // Search fo ritem
  for (i = 0; i < itemList.length; i++) {
    if (itemList[i].class == itemClass) return itemList[i];
  }
  return none;
}

/*=============================================================================
 * discardItem()
 *
 * Deletes an item completely, removing entire quantity if stacked.
 *===========================================================================*/
public function discardItem(int index) {
  itemList.remove(index, 1);
}

/*=============================================================================
 * deductItem()
 *
 * Subtracts a quantity cost from the inventory if sufficient funds.
 * Returns true if sufficient funds, false if insufficient.
 *===========================================================================*/
public function bool deductItem(ItemCost cost) {
  local bool bSuccess;
  local int i;
  
  // Deduct item quantity
  bSuccess = findItem(cost.currencyType).subtract(cost.quantity);
  
  // Remove items that reach zero quantity
  for (i = count() - 1; i >= 0; i--) {
    if (itemList[i].quantity == 0) {
      itemList.remove(i, 1);
    }
  }
  
  // Deduction successful
  return bSuccess;
}

/*=============================================================================
 * removeItem()
 *
 * Removes an item from the list, and returns the removed item by reference.
 *===========================================================================*/
public function ROTT_Inventory_Item removeItem(int index, int quantity) {
  local ROTT_Inventory_Item targetItem;
  local ROTT_Inventory_Item separatedItem;
  
  // Create reference to targeted item
  targetItem = itemList[index];
  
  // Check item quantity
  if (targetItem.quantity == quantity) {
    // Remove item
    itemList.remove(index, 1);
    
    // Return removed item
    return targetItem;
  } else if (targetItem.quantity > quantity) {
    // Subtract from quantity
    itemList[index].subtract(quantity);
    
    // Create a separate copy of the item
    separatedItem = new targetItem.class;
    separatedItem.initialize();
    
    // Set the separated items quantity
    separatedItem.setQuantity(quantity);
    
    // Return targeted item
    return separatedItem;
  }
  
  // No quantity
  return none;
}

/*=============================================================================
 * takeItem()
 *
 * Takes a type of item from the list, and returns the removed item by reference.
 *===========================================================================*/
public function ROTT_Inventory_Item takeItem(class<ROTT_Inventory_Item> itemType) {
  local ROTT_Inventory_Item item;
  local int i;
  
  // Look for the item
  for (i = 0; i < itemList.length; i++) {
    // Check by item type
    if (itemList[i].class == itemType) {
      item = itemList[i];
      itemList.remove(i, 1);
      return item;
    }
  }
  
  return none;
}

/*=============================================================================
 * sort()
 *
 * Organizes the items in order of: Currency, Shrine items, Equipment
 *===========================================================================*/
public function int sort() {
  local array<class<ROTT_Inventory_Item> > orderedTypes;
  local ROTT_Inventory_Item sortedItem;
  local int targetIndex;
  local int i;
  
  // Set up order preferences (Currency, Shrine items, Equipment)
  orderedTypes.addItem(class'ROTT_Inventory_Item_Gold');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Gem');
  
  orderedTypes.addItem(class'ROTT_Inventory_Item_Quest_Ice_Tome');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Quest_Amulet');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Quest_Goblet');
  
  orderedTypes.addItem(class'ROTT_Inventory_Item_Herb');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Herb_Zeltsi');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Herb_Jengsu');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Herb_Xuvi');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Herb_Koshta');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Herb_Aquifinie');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Herb_Unjah');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Herb_Saripine');
  
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Bayuta');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Myroka');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Kamita');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Shukisu');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Erazi');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Eluvi');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Cerok');
  
  orderedTypes.addItem(class'ROTT_Inventory_Item_Bottle_Faerie_Bones');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Bottle_Norkiva_Chips');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Bottle_Yinras_Ore');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Bottle_Nettle_Roots');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Bottle_Harrier_Claws');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Bottle_Swamp_Husks');
  
  // Organize inventory for each ordered type
  for (i = 0; i < orderedTypes.length; i++) {
    // Remove the target item
    sortedItem = takeItem(orderedTypes[i]);
    
    // Check if the item exists
    if (sortedItem != none) {
      // Place item into list at desired index
      itemList.insertItem(targetIndex, sortedItem);
      
      // Increment to next index
      targetIndex++;
    }
  }
  
  return targetIndex;
}

/*=============================================================================
 * sortSpecials()
 *
 * Organizes the special items separetly (loop iteration count issue...)
 *===========================================================================*/
public function sortSpecials(int targetIndex) {
  local array<class<ROTT_Inventory_Item> > orderedTypes;
  local ROTT_Inventory_Item sortedItem;
  local int i;
  
  // Set up order preferences
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Zogis_Anchor');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Lustrous_Baton_Chroma_Conductor');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Buckler_Smoke_Shell');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Buckler_Oak_Wilters_Crest');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Paintbrush_Zephyrs_Whisper');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Flail_Ultimatum');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Ceremonial_Dagger_Whirlwind_Spike');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Shield_Kite_Crimson_Heater');
  
  // Organize inventory for each ordered type
  for (i = 0; i < orderedTypes.length; i++) {
    // Remove the target item
    sortedItem = takeItem(orderedTypes[i]);
    
    // Check if the item exists
    if (sortedItem != none) {
      // Place item into list at desired index
      itemList.insertItem(targetIndex, sortedItem);
      
      // Increment to next index
      targetIndex++;
    }
  }
}

/*=============================================================================
 * cullInventory()
 *
 * Removes items for 8 slot limit
 *===========================================================================*/
public function cullInventory() {
  local array<ROTT_Inventory_Item> ritualItems;
  local int i, k;
  
  // Scan through inventory for ritual items
  for (i = itemList.length - 1; i >= 0; i--) {
    // Check for ritual consumables
    if (itemList[i].category == ITEM_CATEGORY_CONSUMABLE) {
      // Move item to ritual list
      ritualItems.addItem(itemList[i]);
      itemList.remove(i, 1);
    }
  }
  
  // Cull randomly until suitable length
  while (ritualItems.length > 2) {
    // Generate random index
    k = rand(ritualItems.length);
    
    // Remove item
    ritualItems.remove(k, 1);
  }
  
  // Restock ritual items 
  for (i = ritualItems.length - 1; i >= 0; i--) {
    // Move item to ritual list
    addItem(ritualItems[i]);
    ritualItems.remove(i, 1);
  }
  
  // Cull package size to 8
  while (itemList.length > 8) {
    // Generate random index for bottom row (4,5,6,7)
    k = 3 + rand(4);
    
    // Remove item
    itemList.remove(k, 1);
  }
}

/*=============================================================================
 * count()
 *
 * Returns the number of different item types in this package.
 *===========================================================================*/
public function int count() {
  return itemList.length;
}

/*=============================================================================
 * clear()
 *
 * Removes all items.
 *===========================================================================*/
public function clear() {
  itemList.length = 0;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{

}


















