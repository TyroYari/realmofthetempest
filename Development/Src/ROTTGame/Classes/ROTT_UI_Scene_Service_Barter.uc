/*=============================================================================
 * ROTT_UI_Scene_Service_Barter
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene manages the interface for the Merchant's bartering
 * service.  Items can be bought and sold here in exchange for gold and gems.
 *===========================================================================*/

class ROTT_UI_Scene_Service_Barter extends ROTT_UI_Scene;

// Pages
var privatewrite ROTT_UI_Page_Bartering_Menu barterMenu;
var privatewrite ROTT_UI_Page_Mgmt_Window_Barter barterItemInfo;

// Stores a link to a resource providing item types sold by the triggered NPC
var privatewrite ROTT_Resource_Bartering_Seed barterContent;

// Stores whether the barter inventory has been loaded
var privatewrite bool bInventoryLoaded;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Game reference
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  
  // Internal references
  barterMenu = ROTT_UI_Page_Bartering_Menu(findComp("Page_Bartering_Menu"));
  barterItemInfo = ROTT_UI_Page_Mgmt_Window_Barter(findComp("Bartering_Item_Info"));
  
}

/*============================================================================= 
 * setMgmtDescriptor()
 *
 * This assigns a descriptor to the mgmt window, updating the text displayed
 * by it
 *===========================================================================*/
public function setMgmtDescriptor(ROTT_Descriptor descriptor) {
  // Assignment
  if (ROTT_Descriptor_Item(descriptor) != none) {
    barterItemInfo.setDescriptor(descriptor);
    return;
  }
}

/*=============================================================================
 * loadBartering()
 *
 * Transfers a list of item classes provided via editor for bartering
 *===========================================================================*/
public function loadBartering(ROTT_Resource_Bartering_Seed barterInfo) {
  // Check if already loaded content
  if (bInventoryLoaded) return;
  
  // Mark content has been loaded
  bInventoryLoaded = true;
  
  // Store content
  barterContent = barterInfo;
  
  // Reload inventory from given content
  barterMenu.generateBarterInventory(barterContent.itemClasses);
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  // Push menu without focus
  pushPage(barterItemInfo, false);
}

/*=============================================================================
 * unloadScene()
 * 
 * Called when this scene will no longer be rendered.  Each page receives
 * a call for the onSceneDeactivation() event
 *===========================================================================*/
event unloadScene() {
  super.unloadScene();
}

/*=============================================================================
 * getSelectedItem()
 *
 * Returns selected item
 *===========================================================================*/
public function ROTT_Inventory_Item getSelectedItem() {
  return barterMenu.getSelectedItem();
}

/*=============================================================================
 * selectedItemCost()
 *
 * Returns cost of selected item
 *===========================================================================*/
public function array<ItemCost> selectedItemCost() {
  return barterMenu.selectedItemCost();
}

/*=============================================================================
 * purchasedItem()
 *
 * Moves the selected item to inventory
 *===========================================================================*/
public function purchasedItem() {
  barterMenu.purchasedItem();
}

/*=============================================================================
 * refresh()
 *
 * Should be called when any changes occur to the UI.
 *===========================================================================*/
public function refresh() {
  barterMenu.refresh();
  barterItemInfo.refresh();
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties 
{
  bResetOnLoad=true
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  /** ===== Pages ===== **/
  // Bartering Menu
  begin object class=ROTT_UI_Page_Bartering_Menu Name=Page_Bartering_Menu
    tag="Page_Bartering_Menu"
    bInitialPage=true
  end object
  pageComponents.add(Page_Bartering_Menu)
  
  // Item info
  begin object class=ROTT_UI_Page_Mgmt_Window_Barter Name=Bartering_Item_Info
    tag="Bartering_Item_Info"
    posX=0
    posY=0
  end object
  pageComponents.add(Bartering_Item_Info)
  
}









