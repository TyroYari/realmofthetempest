/*=============================================================================
 * ROTT_UI_Page_Bartering_Menu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The menu for using the Bartering service.
 *===========================================================================*/
 
class ROTT_UI_Page_Bartering_Menu extends ROTT_UI_Page;

// Store level amplifiers for equipment generation
var privatewrite array<int> itemLevelAmps;

// Internal references
var privatewrite UI_Selector selector;
var privatewrite ROTT_UI_Displayer_Cost gemCost;
var privatewrite ROTT_UI_Displayer_Cost goldCost;

// Item slot graphics
var privatewrite ROTT_UI_Displayer_Item inventorySlots[12];
var privatewrite array<ROTT_Inventory_Item> inventoryItems;

// External references
var privatewrite ROTT_UI_Scene_Service_Barter barterScene;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i, j;
  
  super.initializeComponent(newTag);
  
  // External references
  barterScene = ROTT_UI_Scene_Service_Barter(outer);
  
  // Internal references
  selector = UI_Selector(findComp("Inventory_Selector_Box"));
  goldCost = ROTT_UI_Displayer_Cost(findComp("Gold_Cost"));
  gemCost = ROTT_UI_Displayer_Cost(findComp("Gem_Cost"));
  
  // Initialize item displayers
  for (i = 0; i < 3; i++) {
    for (j = 0; j < 4; j++) {
      inventorySlots[i * 4 + j] = new(self) class'ROTT_UI_Displayer_Item';
      componentList.addItem(inventorySlots[i * 4 + j]);
      inventorySlots[i * 4 + j].initializeComponent();
      inventorySlots[i * 4 + j].setBackground(true);
      inventorySlots[i * 4 + j].updatePosition(
        771 + 157 * j,
        78 + 157 * i,
        771 + 157 * j + 128,
        78 + 157 * i + 128
      );
    }
  }
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  selector.setActive(true);
}
event onUnfocusMenu() {
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  refresh();
}

/*============================================================================= 
 * generateBarterInventory()
 *
 * Populates the inventory randomly with items
 *===========================================================================*/
public function generateBarterInventory(array<class<ROTT_Inventory_Item> > itemTypes) {
  local int partyLevelSum;
  local int i;
  
  // Get a sum of each character's level
  partyLevelSum = gameInfo.getActiveParty().getLevelSum();
  
  // Fill barter inventory slots
  for (i = 0; i < 12; i++) {
    // Create item from given item types
    inventoryItems.addItem(
      gameInfo.generateBarterItem(
        // Level based on party sum
        itemLevelAmps[i] * partyLevelSum + rand(5),
        itemTypes
      )
    );
    
    // Show item through user interface
    inventorySlots[i].updateDisplay(inventoryItems[i]);
  }
}

/*=============================================================================
 * refresh()
 *
 * Should be called when any changes occur to the UI.
 *===========================================================================*/
public function refresh() {
  local ROTT_Inventory_Item selectedItem;
  local array<ItemCost> noCost;
  local ItemCost emptyCost;
  local int i;
  
  // Get selected item
  selectedItem = getSelectedItem();
  
  // Update inspector window
  if (selectedItem != none) {
    // Show stats in window
    barterScene.setMgmtDescriptor(
      selectedItem.getItemDescriptor(selectedItem)
    );
    
    // Show price
    setCostValues(selectedItem.getItemCost());
    
  } else {
    // Hide item description
    barterScene.barterItemInfo.clearDescriptor();
    
    // Zero gold cost
    emptyCost.currencyType = class'ROTT_Inventory_Item_Gold';
    emptyCost.quantity = 0;
    noCost.addItem(emptyCost);
    emptyCost.currencyType = class'ROTT_Inventory_Item_Gem';
    emptyCost.quantity = 0;
    noCost.addItem(emptyCost);
    setCostValues(noCost);
  }
  
  // Fill barter inventory slots
  for (i = 0; i < 12; i++) {
    if (i < inventoryItems.length) {
      // Show item through user interface
      inventorySlots[i].updateDisplay(inventoryItems[i]);
    } else {
      // Hide slot
      inventorySlots[i].updateDisplay(none);
    }
  }
}

/*=============================================================================
 * getSelectedItem()
 *
 * Returns selected item
 *===========================================================================*/
public function ROTT_Inventory_Item getSelectedItem() {
  if (selector.getSelection() < inventoryItems.length) {
    return inventoryItems[selector.getSelection()];
  }
  return none;
}

/*=============================================================================
 * selectedItemCost()
 *
 * Returns cost of selected item
 *===========================================================================*/
public function array<ItemCost> selectedItemCost() {
  local ROTT_Inventory_Item selectedItem;
  local array<ItemCost> costList;
  local ItemCost costInfo;
  
  // Get selected item
  selectedItem = inventoryItems[selector.getSelection()];
  
  // Update inspector window
  if (selectedItem != none) {
    // Show stats in window
    return selectedItem.getItemCost();
  }
  
  // Set no cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gold';
  costInfo.quantity = 0;
  
  // Add to list
  costList.addItem(costInfo);
  
  return costList;
}

/*=============================================================================
 * purchasedItem()
 *
 * Moves the selected item to inventory
 *===========================================================================*/
public function purchasedItem() {
  // Add item to player inventory
  gameInfo.playerProfile.playerInventory.addItem(
    inventoryItems[selector.getSelection()]
  );
  
  inventoryItems.remove(selector.getSelection(), 1);
}

/*============================================================================*
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  parentScene.focusTop();
}

protected function navigationRoutineB() {
  // Navigate back to NPC
  parentScene.popPage();
  sceneManager.switchScene(SCENE_NPC_DIALOG);
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Requirements
 *===========================================================================*/
protected function bool requirementRoutineA() { 
  return getSelectedItem() != none;
}

/*============================================================================*
 * D-Pad controls
 *===========================================================================*/
public function onNavigateDown() {
  refresh();
}

public function onNavigateUp() {
  refresh();
}

public function onNavigateLeft() {
  refresh();
}

public function onNavigateRight() {
  refresh();
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item level amplifiers
  itemLevelAmps=(1,1,2,3,3,4,5,5,6,6,7,7)
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Menu_Background
    componentTextures.add(Texture2D'GUI.Bartering.Bartering_Service_Background')
  end object
  
  /** ===== Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Bartering_Menu_Background
    tag="Bartering_Menu_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Menu_Background
  end object
  componentList.add(Bartering_Menu_Background)
  
  // Gold Cost Displayer
  begin object class=ROTT_UI_Displayer_Cost Name=Gold_Cost
    tag="Gold_Cost"
    ///bAlwaysShow=true
    posX=720
    posY=561
    currencyType=class'ROTT_Inventory_Item_Gold'
    costDescriptionText="Gold cost for item:"
    costValue=100
  end object
  componentList.add(Gold_Cost)
  
  // Gem Gost Displayer
  begin object class=ROTT_UI_Displayer_Cost Name=Gem_Cost
    tag="Gem_Cost"
    ///bAlwaysShow=true
    posX=720
    posY=703
    currencyType=class'ROTT_Inventory_Item_Gem'
    costDescriptionText="Gem cost for item:"
    costValue=100
  end object
  componentList.add(Gem_Cost)
  
  // Inventory Selection Box
  begin object class=UI_Selector Name=Inventory_Selector_Box
    tag="Inventory_Selector_Box"
    bEnabled=true
    posX=766
    posY=73
    navigationType=SELECTION_2D
    selectionOffset=(x=157,y=157)  // Distance from neighboring spaces
    selectionCoords=(x=0,y=0)      // The space which this selector occupies
    gridSize=(x=4,y=3)             // Total size of 2d selection space
    
    hoverCoords(0)=(xStart=760,yStart=67,xEnd=888,yEnd=195)
    hoverCoords(1)=(xStart=917,yStart=67,xEnd=1045,yEnd=195)
    hoverCoords(2)=(xStart=1074,yStart=67,xEnd=1202,yEnd=195)
    hoverCoords(3)=(xStart=1231,yStart=67,xEnd=1359,yEnd=195)
    
    hoverCoords(4)=(xStart=760,yStart=224,xEnd=888,yEnd=352)
    hoverCoords(5)=(xStart=917,yStart=224,xEnd=1045,yEnd=352)
    hoverCoords(6)=(xStart=1074,yStart=224,xEnd=1202,yEnd=352)
    hoverCoords(7)=(xStart=1231,yStart=224,xEnd=1359,yEnd=352)
    
    hoverCoords(8)=(xStart=760,yStart=381,xEnd=888,yEnd=509)
    hoverCoords(9)=(xStart=917,yStart=381,xEnd=1045,yEnd=509)
    hoverCoords(10)=(xStart=1074,yStart=381,xEnd=1202,yEnd=509)
    hoverCoords(11)=(xStart=1231,yStart=381,xEnd=1359,yEnd=509)
    
    // Inventory Selection Box
    begin object class=UI_Texture_Info Name=Inventory_Selection_Texture
      componentTextures.add(Texture2D'GUI.Inventory_Selector')
    end object
    
    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Inventory_Selection_Texture
      
      // Selector effect
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
    // Inactive selector sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Inventory_Selection_Texture
      
      // Selector effect
      ///activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 2, min = 70, max = 205))
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=100, max=205))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Inventory_Selector_Box) 
  
}





