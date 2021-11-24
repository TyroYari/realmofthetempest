/*=============================================================================
 * ROTT_UI_Page_Preview_Window_Item
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This management window show an item's stats only, no mgmt.
 *===========================================================================*/
 
class ROTT_UI_Page_Preview_Window_Item extends ROTT_UI_Page_Mgmt_Window;

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
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu() {
  
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  