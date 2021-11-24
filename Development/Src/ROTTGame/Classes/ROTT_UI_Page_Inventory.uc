/*=============================================================================
 * ROTT_UI_Page_Inventory
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class is the interface for the players items 
 *===========================================================================*/
 
class ROTT_UI_Page_Inventory extends ROTT_UI_Page;

const INVENTORY_SLOT_COUNT = 16;

// Internal references
var private UI_Sprite inventoryBackground;
var private UI_Label inventoryPageLabel;
///var private UI_Label itemLabel;
var private UI_Label navigationTooltipLabel;
var private UI_Selector inventorySelector;

// Inventory Navigation
var private int pageIndex;

// Item slot graphics
var privatewrite ROTT_UI_Displayer_Item inventorySlots[INVENTORY_SLOT_COUNT];

// External references
var privatewrite UI_Player_Input rottInput;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i, j;
  
  super.initializeComponent(newTag);
  
  // Get internal references
  inventoryBackground = findSprite("Inventory_Background");
  inventoryPageLabel = findLabel("Inventory_Page_Label");
  ///itemLabel = findLabel("Item_Name_Label");
  inventorySelector = UI_Selector(findComp("Inventory_Selector_Box"));
  navigationTooltipLabel = findLabel("Keyboard_Navigation_Tooltip");
  
  // Initialize item displayers
  for (i = 0; i < 4; i++) {
    for (j = 0; j < 4; j++) {
      inventorySlots[i * 4 + j] = new(self) class'ROTT_UI_Displayer_Item';
      componentList.addItem(inventorySlots[i * 4 + j]);
      inventorySlots[i * 4 + j].initializeComponent();
      inventorySlots[i * 4 + j].updatePosition(
        782 + 157 * j,
        165 + 157 * i,
        782 + 157 * j + 128,
        165 + 157 * i + 128
      );
    }
  }
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  super.onPushPageEvent();
  
  // Initialize navigation
  pageIndex = 0;
}
 
/*============================================================================= 
 * discardItem()
 *
 * Called to throw an item away
 *===========================================================================*/
public function discardItem() {
  local int index;
  
  // Get index for deletion
  index = inventorySelector.getSelection() + pageIndex * INVENTORY_SLOT_COUNT;
  
  // Check index validity
  if (!(index < gameInfo.playerProfile.playerInventory.itemList.length))
    return;
  
  // Perform deletion
  gameInfo.playerProfile.playerInventory.discardItem(index);
}

/*============================================================================= 
 * refresh()
 *
 * Called when item info changes
 *===========================================================================*/
public function refresh() {
  local ROTT_Inventory_Item selectedItem;
  local int i;
  
  super.refresh();
  
  // Get selected item
  selectedItem = getSelectedItem();
  
  // Show a page of the player's inventory
  for (i = 0; i < INVENTORY_SLOT_COUNT; i++) {
    inventorySlots[i].updateDisplay(getItem(i + pageIndex * INVENTORY_SLOT_COUNT));
  }
  
  // Update inspector window
  if (selectedItem != none) {
    ROTT_UI_Scene_Game_Menu(Outer).setMgmtDescriptor(
      selectedItem.getItemDescriptor(selectedItem)
    );
  } else {
    ROTT_UI_Scene_Game_Menu(Outer).mgmtWindowItem.clearDescriptor();
  }
  
  // Footer page numbers
  inventoryPageLabel.setText("Page " $ pageIndex+1 $ " of " $ getPageCount());
  
  // Keyboard navigation tooltip
  navigationTooltipLabel.setEnabled(!rottInput.bGamepadActive);
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  // Changes to graphics
  inventoryBackground.setEnabled(true);
  
  // Selector focus
  inventorySelector.setEnabled(true);
  inventorySelector.setActive(true);
  
  // Get player input
  rottInput = UI_Player_Input(getPlayerInput());
  
  // Show items
  refresh();
}

/*=============================================================================
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu() {

}

/*=============================================================================
 * moveSelectedItem()
 *
 * Removes a given quantity from the currently selected index.
 *===========================================================================*/
public function ROTT_Inventory_Item moveSelectedItem(int quantity) { 
  local int index;
  
  // Get currently selected index
  index = inventorySelector.getSelection() + pageIndex * INVENTORY_SLOT_COUNT;
  
  return gameInfo.playerProfile.playerInventory.removeItem(index, 1);
}

/*=============================================================================
 * getItem()
 *
 * Used to access an item from the player's inventory at the given index.
 *===========================================================================*/
public function ROTT_Inventory_Item getItem(int index) {
  if (!(index < gameInfo.playerProfile.playerInventory.itemList.length))
    return none;
  
  return gameInfo.playerProfile.playerInventory.itemList[index];
}
 
/*=============================================================================
 * getSelectedItem()
 *
 * Returns the selected item
 *===========================================================================*/
public function ROTT_Inventory_Item getSelectedItem() { 
  local int index;
  
  // Get selection index
  index = inventorySelector.getSelection() + pageIndex * INVENTORY_SLOT_COUNT;
  
  // Return item
  return getItem(index); 
}

/*=============================================================================
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * inputName        the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
( 
  int ControllerId, 
  name inputName, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
)
{
  switch (inputName) {
    case 'Z': inputName = 'XboxTypeS_LeftShoulder';  break;
    case 'C': inputName = 'XboxTypeS_RightShoulder'; break;
  }
  
  return super.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
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
 * goToLastPageWithItems()
 *
 * Navigates to the last page with items.
 *===========================================================================*/
public function goToLastPageWithItems() {
  local int linearIndex;
  
  linearIndex = gameInfo.playerProfile.playerInventory.itemList.length - 1 % INVENTORY_SLOT_COUNT;
  
  // Go to last page
  pageIndex = getPageCount() - 1;
  
  // Go back another page if last page is the empty page
  if (gameInfo.playerProfile.playerInventory.itemList.length % INVENTORY_SLOT_COUNT == 0) {
    pageIndex--;
  }
  
  inventorySelector.forceSelection(
    linearIndex % 4,
    linearIndex / 4
  );
  
  // Update visuals
  refresh();
}

/*=============================================================================
 * pageLeft()
 *
 * Navigates a page to the left.
 *===========================================================================*/
public function pageLeft() {
  // Navigate to next page
  pageIndex--;
  
  // Loop around
  if (pageIndex < 0) pageIndex = getPageCount() - 1;
  
  // Update visuals
  refresh();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_NAVIGATE);
}
 
/*=============================================================================
 * pageRight()
 *
 * Navigates a page to the right.
 *===========================================================================*/
public function pageRight() {
  // Navigate to previous page
  pageIndex++;
  
  // Loop around
  if (pageIndex >= getPageCount()) pageIndex = 0;
  
  // Update visuals
  refresh();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_NAVIGATE);
}
 
/*=============================================================================
 * Bumper inputs
 *===========================================================================*/
protected function navigationRoutineLB() {
  pageLeft();
}
 
protected function navigationRoutineRB() {
  pageRight();
}

/*=============================================================================
 * Requirements
 *===========================================================================*/
protected function bool requirementRoutineA() { 
  local int index;
  
  // Get selected item
  index = inventorySelector.getSelection() + pageIndex * INVENTORY_SLOT_COUNT;
  
  // Check if item exists
  return (getItem(index) != none); 
}

/*=============================================================================
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  // Load item inspection
  ROTT_UI_Scene_Game_Menu(Outer).focusTop();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
}

protected function navigationRoutineB() {
  inventorySelector.resetSelection();
  inventoryBackground.setEnabled(false);
  inventoryPageLabel.setText("");
  
  // Pop both inventory and inspection
  parentScene.popPage();
  parentScene.popPage();
  
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * getPageCount
 *
 * Returns the index of the last page with items on it. 
 *===========================================================================*/
private function byte getPageCount() {
  return gameInfo.playerProfile.playerInventory.itemList.length / INVENTORY_SLOT_COUNT + 1;
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
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
  
  begin object class=ROTT_Input_Handler Name=Input_LB
    inputName="XboxTypeS_LeftShoulder"
    buttonComponent=none
  end object
  inputList.add(Input_LB)
  
  begin object class=ROTT_Input_Handler Name=Input_RB
    inputName="XboxTypeS_RightShoulder"
    buttonComponent=none
  end object
  inputList.add(Input_RB)
  
  /** ===== Textures ===== **/
  // Inventory Background
  begin object class=UI_Texture_Info Name=Inventory_Page
    componentTextures.add(Texture2D'GUI.Inventory_Page')
  end object
  
  /** ===== UI Components ===== **/
  // Inventory Background
  begin object class=UI_Sprite Name=Inventory_Background
    tag="Inventory_Background"
    bEnabled=false
    posX=720
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Inventory_Page
  end object
  componentList.add(Inventory_Background)
  
  // Page Label
  begin object class=UI_Label Name=Inventory_Page_Label
    tag="Inventory_Page_Label"
    posX=720
    posY=826
    posXEnd=NATIVE_WIDTH
    posYEnd=866
    AlignX=CENTER
    AlignY=CENTER
    fontStyle=DEFAULT_SMALL_WHITE
    labelText=""
  end object
  componentList.add(Inventory_Page_Label)
  
  // Keyboard navigation tooltip
  begin object class=UI_Label Name=Keyboard_Navigation_Tooltip
    tag="Keyboard_Navigation_Tooltip"
    posX=720
    posY=826
    posXEnd=NATIVE_WIDTH
    posYEnd=866
    AlignX=CENTER
    AlignY=CENTER
    fontStyle=DEFAULT_SMALL_TAN
    labelText="[Z]                                                                         [C]"
    
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.6, min = 200, max = 255))
  end object
  componentList.add(Keyboard_Navigation_Tooltip)
  
  // Item name label
  begin object class=UI_Label Name=Item_Name_Label
    tag="Item_Name_Label"
    posX=720
    posY=58
    posXEnd=NATIVE_WIDTH
    posYEnd=124
    AlignX=CENTER
    AlignY=CENTER
    fontStyle=DEFAULT_MEDIUM_GOLD
    labelText="Inventory"
  end object
  componentList.add(Item_Name_Label)
  
  // Page navigation arrows
  begin object class=UI_Texture_Info Name=Menu_Navigation_Arrows_LR
    componentTextures.add(Texture2D'GUI.Menu_Navigation_Arrows_LR')
  end object
  
  // Page Navigation Graphics
  begin object class=UI_Sprite Name=Page_Navigation_Arrow_Sprite
    tag="Page_Navigation_Arrow_Sprite"
    bEnabled=true
    posX=755
    posY=826
    images(0)=Menu_Navigation_Arrows_LR
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.6, min = 200, max = 255))
    
  end object
  componentList.add(Page_Navigation_Arrow_Sprite)
  
  // Inventory Selection Box
  begin object class=UI_Selector Name=Inventory_Selector_Box
    tag="Inventory_Selector_Box"
    bEnabled=false
    posX=775
    posY=159
    navigationType=SELECTION_2D
    selectionOffset=(x=157,y=157)  // Distance from neighboring spaces
    selectionCoords=(x=0,y=0)      // The space which this selector occupies
    gridSize=(x=4,y=4)             // Total size of 2d selection space
    hoverCoords(0)=(xStart=770,yStart=154,xEnd=921,yEnd=306)
    hoverCoords(1)=(xStart=927,yStart=154,xEnd=1078,yEnd=306)
    hoverCoords(2)=(xStart=1084,yStart=154,xEnd=1235,yEnd=306)
    hoverCoords(3)=(xStart=1241,yStart=154,xEnd=1392,yEnd=306)
    
    hoverCoords(4)=(xStart=770,yStart=311,xEnd=921,yEnd=463)
    hoverCoords(5)=(xStart=927,yStart=311,xEnd=1078,yEnd=463)
    hoverCoords(6)=(xStart=1084,yStart=311,xEnd=1235,yEnd=463)
    hoverCoords(7)=(xStart=1241,yStart=311,xEnd=1392,yEnd=463)
    
    hoverCoords(8)=(xStart=770,yStart=468,xEnd=921,yEnd=620)
    hoverCoords(9)=(xStart=927,yStart=468,xEnd=1078,yEnd=620)
    hoverCoords(10)=(xStart=1084,yStart=468,xEnd=1235,yEnd=620)
    hoverCoords(11)=(xStart=1241,yStart=468,xEnd=1392,yEnd=620)
    
    hoverCoords(12)=(xStart=770,yStart=625,xEnd=921,yEnd=777)
    hoverCoords(13)=(xStart=927,yStart=625,xEnd=1078,yEnd=777)
    hoverCoords(14)=(xStart=1084,yStart=625,xEnd=1235,yEnd=777)
    hoverCoords(15)=(xStart=1241,yStart=625,xEnd=1392,yEnd=777)
    
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













