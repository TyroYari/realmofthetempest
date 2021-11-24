/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Barter
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This management window show an item's stats, and allows the 
 * player to purchase the item from the merchant's bartering service
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Barter extends ROTT_UI_Page_Mgmt_Window;

var privatewrite ROTT_UI_Scene_Service_Barter barterScene;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Fit attributes on page with no gaps
  closeParagraphGaps();
  
  // Get game info link
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  
  // Change background to no shadow version
  findSprite("Mgmt_Window_Background").setDrawIndex(1);
  
  // Store link to barter scene
  barterScene = ROTT_UI_Scene_Service_Barter(outer);
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
  // Check if player has sufficient currencies
  if (gameInfo.playerProfile.canDeductItems(barterScene.selectedItemCost())) {
    // Deduct costs
    gameInfo.playerProfile.deductItems(barterScene.selectedItemCost());
    
    // Obtain item
    barterScene.purchasedItem();
      
    // Pass focus down to previous page in the stack
    parentScene.focusBack();
    
    // Show changes on user interface
    barterScene.refresh();
    return true;
  } else {
    // Play insuffucient sfx
    gameInfo.sfxBox.playSfx(SFX_MENU_INSUFFICIENT);
    return false;
  }
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  
}

protected function navigationRoutineB() {
  // Pass focus down to previous page in the stack
  parentScene.focusBack();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Number of menu options
  selectOptionsCount=1
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Buttons
  begin object class=UI_Texture_Info Name=Button_1
    componentTextures.add(Texture2D'GUI.Button_Purchase')
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
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  