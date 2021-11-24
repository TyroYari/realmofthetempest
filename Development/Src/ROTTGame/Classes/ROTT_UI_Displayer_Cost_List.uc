/*=============================================================================
 * ROTT_UI_Displayer_Cost_List
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Used to display cost for a single currency.
 *===========================================================================*/

class ROTT_UI_Displayer_Cost_List extends UI_Container;

// Display settings
var privatewrite array<ROTT_UI_Displayer_Cost_List> costDisplayers;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  for (i = 0; i < componentList.length; i++) {
    if (ROTT_UI_Displayer_Cost_List(findComp("Cost_Displayer_" $ i + 1)) == none) {
      yellowLog("Warning (!) Cost displayer components are not named properly.  Should be \"Cost_Displayer_" $ i + 1 $ "\"");
    }
    costDisplayers[i] == ROTT_UI_Displayer_Cost_List(findComp("Cost_Displayer_" $ i + 1));
  }
}


/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
}














