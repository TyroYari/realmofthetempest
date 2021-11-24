/*============================================================================= 
 * ROTT_UI_Page_Chest
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Shows the inventory of a chest from the over world
 *===========================================================================*/
 
class ROTT_UI_Page_Chest extends ROTT_UI_Page;

// Parent scene
var private ROTT_UI_Scene_Over_World someScene;

// Internal references
var private UI_Selector chestSelector;
var private UI_Sprite chestBackground;
var private UI_Sprite selectGoToInventory;
var private UI_Sprite selectTakeAll;
var private UI_Label itemNameLabel;

// Selection types
enum ChestSelections {
  CHEST_SLOT,
  CHEST_TO_INVENTORY,
  CHEST_TAKE_ALL
};

// Inventory items
var privatewrite ROTT_Inventory_Package chestInventory;

// Item slot graphics
var privatewrite ROTT_UI_Displayer_Item chestSlot[8];

// Visibility delay
var privatewrite float showItemsDelay;
var privatewrite float showSelectorDelay;

// Selector delay
var privatewrite bool bDelaySelector;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  // Draw each component
  super.initializeComponent(newTag);
  
  // Parent scene
  someScene = ROTT_UI_Scene_Over_World(outer);
  
  // UI references
  chestBackground = findSprite("Chest_Background");
  chestSelector = UI_Selector(findComp("Chest_Selection_Box"));
  selectGoToInventory = findSprite("Chest_Selection_Go_To_Inventory");
  selectTakeAll = findSprite("Chest_Selection_Take");
  itemNameLabel = findLabel("Item_Name_Label");
  
  // Setup inventory slots
  for (i = 0; i < 8; i++) {
    chestSlot[i] = new class'ROTT_UI_Displayer_Item';
    componentList.addItem(chestSlot[i]);
    chestSlot[i].initializeComponent();
    chestSlot[i].updatePosition(
      421 + ((i%4) * 157), 
      270 + (i/4) * 157,
      421 + ((i%4) * 157) + 128, 
      270 + (i/4) * 157 + 128
    );
  }
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Hide selector until delay completes
  chestSelector.setEnabled(false);
  chestSelector.setActive(false);
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  gameInfo.unpauseGame();
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  local ROTT_Inventory_Item item;
  
  // Show inventory
  updateDisplayedInventory();
  
  // Render item name
  if (chestSelector.getSelection() < chestInventory.itemList.length) {
    // Get selected item
    item = chestInventory.itemList[chestSelector.getSelection()];
    
    // Display item name
    itemNameLabel.setText(item.itemName);
    itemNameLabel.setFont(item.itemFont);
  } else {
    itemNameLabel.setText("- Item Info -");
    itemNameLabel.setFont(DEFAULT_MEDIUM_GRAY);
  }
  
  // Initialize as hidden
  selectGoToInventory.setEnabled(false);
  selectTakeAll.setEnabled(false);
  
  // Skip drawing if delay is present
  if (showItemsDelay > 0) return;
  
  // Render selection
  switch (getSelectionType()) {
    case CHEST_SLOT:
      chestSelector.setDrawIndex(0);
      break;
      
    case CHEST_TO_INVENTORY:
      selectGoToInventory.setEnabled(true);
      chestSelector.setDrawIndex(1);
      break;
      
    case CHEST_TAKE_ALL:
      selectTakeAll.setEnabled(true);
      chestSelector.setDrawIndex(1);
      break;
  }
}

/*============================================================================= 
 * setItems()
 *
 * This sets the contents of the inventory to a set of items
 *===========================================================================*/
public function setItems
(
  ROTT_Inventory_Package itemPackage,
  optional float lootDelay = 0.f
)
{
  // Set contents
  chestInventory = itemPackage;
  
  // Delay selector activation
  showSelectorDelay = 0.5;
  
  // Hide the menu until the animation is ready
  if (lootDelay > 0) {
    // Set delay
    showItemsDelay = lootDelay;
    
    // Hide UI
    chestBackground.setEnabled(false);
    chestSelector.setEnabled(false);
    itemNameLabel.setEnabled(false);
    refresh();
    return;
  } else {
    // Delay selector
    bDelaySelector = true;

    // Sets initial selection box and draws items on screen
    showInterface();
  }
  
}

/*============================================================================= 
 * showInterface()
 *
 * Sets initial selection box and draws items on screen
 *===========================================================================*/
public function showInterface() {
  // Show everything
  chestBackground.setEnabled(true);
  itemNameLabel.setEnabled(true);
  
  // Change UI to select 'Take all' by default
  chestSelector.forceSelection(11);
  chestSelector.setEnabled(true);

  // Draw inventory
  refresh();
}

/*============================================================================= 
 * onSceneActivation()
 *
 * This event is called every time the parent scene is activated
 *===========================================================================*/
public function onSceneActivation() {
  if (someScene.pageIsUp(self)) {
    gameInfo.pauseGame();
  }
}

/*============================================================================= 
 * onSceneDeactivation()
 *
 * This event is called every time the parent scene is deactivated
 *===========================================================================*/
public function onSceneDeactivation() {
  
}

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  // Check for visibility delay
  if (showItemsDelay > 0) {
    showItemsDelay -= deltaTime;
    if (showItemsDelay <= 0) {
      // Delay selector
      bDelaySelector = true;
      
      showInterface();
    }
  }
  
  // Check for activation delay
  if (bDelaySelector) {
    showSelectorDelay -= deltaTime;
    if (showSelectorDelay <= 0) {
      chestSelector.setActive(true);
      bDelaySelector = false;
    }
  }
}

public function onNavigateLeft() {
  refresh();
}

public function onNavigateRight() {
  refresh();
}

public function onNavigateUp() {
  refresh();
}

public function onNavigateDown() {
  refresh();
}

/*============================================================================*
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  // Check selected menu option
  switch (getSelectionType()) {
    case CHEST_SLOT:
      // Inspect slot
      
      /// Here we could have a takeItem() call
      break;
      
    case CHEST_TO_INVENTORY:
      // Take all from chest inventory to player inventory
      gameInfo.playerProfile.playerInventory.takeInventory(chestInventory);
      
      // Sfx
      sfxBox.playSfx(SFX_WORLD_GAIN_LOOT);
      
      // Close window
      parentScene.popPage();
      
      // Move to inventory view
      gameInfo.sceneManager.switchScene(SCENE_GAME_MENU);
      gameInfo.sceneManager.sceneGameMenu.pushMenu(UTILITY_MENU);
      gameInfo.sceneManager.sceneGameMenu.pushMenu(INVENTORY_MENU);
      gameInfo.sceneManager.sceneGameMenu.pushMenu(MGMT_WINDOW_ITEM);
      gameInfo.sceneManager.sceneGameMenu.inventoryPage.goToLastPageWithItems();
      break;
      
    case CHEST_TAKE_ALL:
      // Take all from chest inventory to player inventory
      gameInfo.playerProfile.playerInventory.takeInventory(chestInventory);
      
      // Sfx
      sfxBox.playSfx(SFX_WORLD_GAIN_LOOT);
      
      // Close window
      parentScene.popPage();
      break;
  }
}

/*=============================================================================
 * requirementRoutineA()
 *
 * Returns true if input is valid for a button.  This function must be 
 * delegated to a button, because each button has different requirements.
 *===========================================================================*/
protected function bool requirementRoutineA() {
  return (showSelectorDelay <= 0 && !bDelaySelector);
  /// Hacky, why are we checking if selector is active? shouldnt it know? its not working
}


protected function navigationRoutineB() {
  // If empty, close interface?
}

/*============================================================================= 
 * getSelectionType()
 *
 * Used to check the selection type
 *===========================================================================*/
public function ChestSelections getSelectionType() {
  switch (chestSelector.getSelection()) {
    case 8:
    case 9:
      return CHEST_TO_INVENTORY;
    case 10:
    case 11:
      return CHEST_TAKE_ALL;
    default:
      return CHEST_SLOT;
  }
}

/*============================================================================= 
 * updateDisplayedInventory()
 *
 * Called to draw content of a chest
 *===========================================================================*/
public function updateDisplayedInventory() {
  local int i;
  
  for (i = 0; i < 8; i++) {
    if (i < chestInventory.count() && !(showItemsDelay > 0)) {
      chestSlot[i].updateDisplay(chestInventory.itemList[i]);
    } else {
      chestSlot[i].updateDisplay(none);
    }
  }
}

/*============================================================================= 
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  super.deleteComp();
  
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bPauseGameWhenUp=true
  
  // Force mouse as visible, if keyboard is active
  bPageForcesCursorOn=true
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Chest background
  begin object class=UI_Texture_Info Name=Chest_Interface
    componentTextures.add(Texture2D'GUI.Chest_Interface')
  end object
  
  // Chest background 
  begin object class=UI_Sprite Name=Chest_Background
    tag="Chest_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Chest_Interface
  end object
  componentList.add(Chest_Background)
  
  // Item name label
  begin object class=UI_Label Name=Item_Name_Label
    tag="Item_Name_Label"
    posX=513
    posY=186
    posXEnd=959
    posYEnd=241
    AlignX=CENTER
    AlignY=CENTER
    labelText=""
  end object
  componentList.add(Item_Name_Label)
  
  // Inventory Selector
  begin object class=UI_Selector Name=Chest_Selection_Box
    tag="Chest_Selection_Box"
    bEnabled=true
    bActive=false
    bWrapAround=false
    posX=415
    posY=264
    navigationType=SELECTION_2D
    selectionOffset=(x=157,y=157)  // Distance from neighboring spaces
    gridSize=(x=4,y=3)             // Total size of 2d selection space
    hoverCoords(0)=(xStart=417,yStart=265,xEnd=561,yEnd=408)
    hoverCoords(1)=(xStart=574,yStart=265,xEnd=718,yEnd=408)
    hoverCoords(2)=(xStart=731,yStart=265,xEnd=875,yEnd=408)
    hoverCoords(3)=(xStart=888,yStart=265,xEnd=1032,yEnd=408)
    
    hoverCoords(4)=(xStart=417,yStart=422,xEnd=561,yEnd=565)
    hoverCoords(5)=(xStart=574,yStart=422,xEnd=718,yEnd=565)
    hoverCoords(6)=(xStart=731,yStart=422,xEnd=875,yEnd=565)
    hoverCoords(7)=(xStart=888,yStart=422,xEnd=1032,yEnd=565)
    
    hoverCoords(8)=(xStart=417,yStart=579,xEnd=718,yEnd=722)
    ///hoverCoords(9)=(xStart=417,yStart=579,xEnd=718,yEnd=722)
    hoverCoords(10)=(xStart=731,yStart=579,xEnd=1032,yEnd=722)
    ///hoverCoords(9)=(xStart=731,yStart=579,xEnd=1032,yEnd=722)
    
    // Navigation skips
    navSkips(0)=(xCoord=0,yCoord=2,skipDirection=NAV_RIGHT)
    navSkips(1)=(xCoord=3,yCoord=2,skipDirection=NAV_LEFT)
    
    // Inventory selection box
    begin object class=UI_Texture_Info Name=Chest_Slot_Selector
      componentTextures.add(Texture2D'GUI.Inventory_Selector')
    end object
    
    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Chest_Slot_Selector
      images(1)=none
      
      // Selector effect
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Chest_Selection_Box)
  
  // Large selector
  begin object class=UI_Texture_Info Name=Chest_Selector_Large
    componentTextures.add(Texture2D'GUI.Chest_Selector_Large')
  end object
  
  // Take all selector 
  begin object class=UI_Sprite Name=Chest_Selection_Go_To_Inventory
    tag="Chest_Selection_Go_To_Inventory"
    posX=420
    posY=582
    images(0)=Chest_Selector_Large
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
  end object
  componentList.add(Chest_Selection_Go_To_Inventory)
  
  // Take all selector 
  begin object class=UI_Sprite Name=Chest_Selection_Take
    tag="Chest_Selection_Take"
    posX=734
    posY=582
    images(0)=Chest_Selector_Large
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
  end object
  componentList.add(Chest_Selection_Take)
  
  
}








