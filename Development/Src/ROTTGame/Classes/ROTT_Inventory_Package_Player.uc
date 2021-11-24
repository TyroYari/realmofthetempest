/*============================================================================= 
 * ROTT_Inventory_Package_Player
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A container that manages an inventory of items, specifically for the
 * player's main inventory
 *===========================================================================*/
 
class ROTT_Inventory_Package_Player extends ROTT_Inventory_Package;

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
  switch (newItem.class) {
    // Track total earned gold
    case class'ROTT_Inventory_Item_Gold': 
      gameInfo.playerProfile.totalGoldEarned += newItem.quantity; 
      break;
    // Track total earned gems
    case class'ROTT_Inventory_Item_Gem': 
      gameInfo.playerProfile.totalGemsEarned += newItem.quantity; 
      break;
  }
  
  super.addItem(newItem);
}

/*=============================================================================
 * loadItem()
 *
 * Adds the item to the inventory list, without profile tracking updates.
 *===========================================================================*/
public function loadItem(ROTT_Inventory_Item newItem, optional bool bSort = true) {
  super.addItem(newItem, true);
  
  if (bSort) sort();
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{

}


















