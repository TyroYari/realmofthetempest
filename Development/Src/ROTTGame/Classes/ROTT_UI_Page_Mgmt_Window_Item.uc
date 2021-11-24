/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Item
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This management window show an item's stats, and allows the 
 * player to choose to equip an item.
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Item extends ROTT_UI_Page_Mgmt_Window;

enum StatsMenuOptions {
  ITEM_EQUIP,
  ITEM_DISCARD,
};

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  closeParagraphGaps();
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  selectionBox.resetSelection();
  selectionBox.setEnabled(true);
  selectionBox.setActive(true);
}


/*=============================================================================
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu() {
  // Check if control components exist, if not stop here
  if (selectOptionsCount == 0) return;
  
  // Graphic update
  selectionBox.clearSelection();
}

/*=============================================================================
 * Requirements
 *===========================================================================*/
protected function bool requirementRoutineA() { 
  local ROTT_Inventory_Item selectedItem;
  selectedItem = ROTT_UI_Scene_Game_Menu(parentScene).inventoryPage.getSelectedItem();
  
  // Check if player is discarding
  switch (selectionBox.getSelection()) {
    case ITEM_EQUIP: 
      // Check for valid discardable item
      if (
        ROTT_Inventory_Item_Gold(selectedItem) != none || 
        ROTT_Inventory_Item_Gem(selectedItem) != none
      ) {
        // Ignore currencies, not equippable
        gameInfo.sfxBox.playSfx(SFX_MENU_INSUFFICIENT);
        return false;
      }
    break;
  }
  return true;
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  // Check player's selection
  switch (selectionBox.getSelection()) {
    case ITEM_EQUIP: 
      // Transition to hero selection
      ROTT_UI_Scene_Game_Menu(parentScene).popPage();
      ROTT_UI_Scene_Game_Menu(parentScene).pushPage(
        ROTT_UI_Scene_Game_Menu(parentScene).equipSelectPage
      );
      
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case ITEM_DISCARD: 
      // Remove item
      ROTT_UI_Scene_Game_Menu(parentScene).inventoryPage.discardItem();
      
      // Navigate back automatically
      parentScene.focusBack();
      
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_UNINVEST_STAT);
      break;
  }
  
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Number of menu options
  selectOptionsCount=2
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Buttons
  begin object class=UI_Texture_Info Name=Button_1
    componentTextures.add(Texture2D'GUI.Button_Equip')
  end object
  begin object class=UI_Texture_Info Name=Button_2
    componentTextures.add(Texture2D'GUI.Button_Discard')
  end object
  
  /** ===== UI Components ===== **/
  // Buttons
  begin object class=UI_Sprite Name=Button_1_Sprite
    tag="Button_1_Sprite"
    posX=132
    posY=544
    images(0)=Button_1
  end object
  componentList.add(Button_1_Sprite)
  
  // Buttons
  begin object class=UI_Sprite Name=Button_2_Sprite
    tag="Button_2_Sprite"
    posX=132
    posY=624
    images(0)=Button_2
  end object
  componentList.add(Button_2_Sprite)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  