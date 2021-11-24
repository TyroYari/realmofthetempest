/*=============================================================================
 * ROTT_UI_Page_Equip_Select
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Allows player to choose where equipment goes.
 *===========================================================================*/
 
class ROTT_UI_Page_Equip_Select extends ROTT_UI_Page;

// Parent scene information
var protected ROTT_UI_Displayer_Item equipmentPreview;
var protected UI_Selector selector;
var protected UI_Texture_Info itemGraphic;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Initialize links to assets
  equipmentPreview = ROTT_UI_Displayer_Item(findComp("Hero_Equipment_Preview"));
  selector = UI_Selector(findComp("Selector_Sprite"));
  
  itemGraphic = new class'UI_Texture_Info';
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  local ROTT_Inventory_Item selectedItem;
  selectedItem = ROTT_UI_Scene_Game_Menu(parentScene).inventoryPage.getSelectedItem();
  
  itemGraphic.componentTextures[0] = selectedItem.getSpriteTexture();
  itemGraphic.initializeInfo(); 
  selector.findSprite("Selector_Sprite").modifyTexture(itemGraphic);
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
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
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  local ROTT_Combat_Hero selectedHero;
  
  // Move extra sprite graphic
  selector.findSprite("Selector_Sprite_2").setOffset(
    selector.selectionOffset.x * selector.getSelection(),
    selector.selectionOffset.y * selector.getSelection()
  );
  
  selectedHero = gameInfo.getActiveParty().getHero(selector.getSelection());
  
  // Update item replacement preview window
  if (selectedHero != none) {
    if (selectedHero.heldItem != none) {
      ROTT_UI_Scene_Game_Menu(parentScene).updateItemWindow(
        selectedHero.heldItem.getItemDescriptor(
          selectedHero.heldItem
        )
      );
    }
  }
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
  // Check input event
  if (Event == IE_Pressed) { 
    // Check input keys
    switch (inputName) {
      case 'Tilde': 
      case 'XBoxTypeS_Y': 
        // Show item information
        ROTT_UI_Scene_Game_Menu(parentScene).toggleSideItemWindow(
          gameInfo.getActiveParty().getHero(selector.getSelection()).heldItem.getItemDescriptor(
            gameInfo.getActiveParty().getHero(selector.getSelection()).heldItem
          ),
          720
        );
        break;
    }
  }
  
  return super.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateUp();
public function onNavigateDown();
public function onNavigateLeft() {
  refresh();
}
public function onNavigateRight() {
  refresh();
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local ROTT_Inventory_Item selectedItem;
  local ROTT_Inventory_Item removedItem;
  
  // Check if selected hero exists
  if (gameInfo.getActiveParty().getHero(selector.getSelection()) == none) {
    gameInfo.sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
    return;
  }
  
  // Take the item out of inventory
	selectedItem = ROTT_UI_Scene_Game_Menu(parentScene).inventoryPage.moveSelectedItem(1);
  
  // Equip item to selected hero
  removedItem = gameInfo.getActiveParty().getHero(selector.getSelection()).equipItem(selectedItem);
  
  // Move the previously held item back to inventory
  if (removedItem != none) {
    gameInfo.playerProfile.playerInventory.addItem(removedItem);
  }
  
  // Navigate back to inventory
  parentScene.popPage("Preview_Window_Item");
  parentScene.popPage(tag);
  ROTT_UI_Scene_Game_Menu(parentScene).pushMenu(MGMT_WINDOW_ITEM);
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
}

protected function navigationRoutineB() {
  // Navigate back to item inspection window
  parentScene.popPage("Preview_Window_Item");
  parentScene.popPage(tag);
  ROTT_UI_Scene_Game_Menu(parentScene).pushMenu(MGMT_WINDOW_ITEM);
  parentScene.focusTop();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
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
  
  /** ===== Textures ===== **/
  // Equip box
  begin object class=UI_Texture_Info Name=Equip_Box_Texture
    componentTextures.add(Texture2D'GUI.Equip_Box')
  end object
  
  /** ===== UI Components ===== **/
  // Equip box
  begin object class=UI_Sprite Name=Equip_Box_1
    tag="Equip_Box_1"
    posX=77
    posY=646
    images(0)=Equip_Box_Texture
  end object
  componentList.add(Equip_Box_1)
  
  // Equip box
  begin object class=UI_Sprite Name=Equip_Box_2
    tag="Equip_Box_2"
    posX=277
    posY=646
    images(0)=Equip_Box_Texture
  end object
  componentList.add(Equip_Box_2)
  
  // Equip box
  begin object class=UI_Sprite Name=Equip_Box_3
    tag="Equip_Box_3"
    posX=477
    posY=646
    images(0)=Equip_Box_Texture
  end object
  componentList.add(Equip_Box_3)
  
  // Selector sprite
  begin object class=UI_Selector Name=Selector_Sprite
    tag="Selector_Sprite"
    bEnabled=true
    bActive=true
    posX=94
    posY=663
    selectionOffset=(x=200,y=0)
    numberOfMenuOptions=3
    navigationType=SELECTION_HORIZONTAL
    hoverCoords(0)=(xStart=64,yStart=546,xEnd=254,yEnd=837)
    hoverCoords(1)=(xStart=264,yStart=546,xEnd=454,yEnd=837)
    hoverCoords(2)=(xStart=464,yStart=546,xEnd=654,yEnd=837)
    
    // Item texture (placeholder)
    begin object class=UI_Texture_Info Name=Item_Graphic
      componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Blue')
    end object
    
    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      drawLayer=TOP_LAYER
      images(0)=Item_Graphic
      activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=1.0, min=235, max=255))
    end object
    componentList.add(Selector_Sprite)
  
    // Inventory Selection Box
    begin object class=UI_Texture_Info Name=Inventory_Selection_Texture
      componentTextures.add(Texture2D'GUI.Inventory_Selector')
    end object
    
    // Extra Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite_2
      tag="Selector_Sprite_2"
      drawLayer=TOP_LAYER
      images(0)=Inventory_Selection_Texture
      posX=-6
      posY=-6
      // Selector effect
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite_2)
    
  end object
  componentList.add(Selector_Sprite)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  