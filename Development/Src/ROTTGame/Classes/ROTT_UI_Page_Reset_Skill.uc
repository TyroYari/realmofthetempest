/*=============================================================================
 * ROTT_UI_Page_Reset_Skill
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Users are shown reset skill information through this interface.
 *===========================================================================*/

class ROTT_UI_Page_Reset_Skill extends ROTT_UI_Page;

// Parent scene
var private ROTT_UI_Scene_Game_Menu someScene;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Parent scene
  someScene = ROTT_UI_Scene_Game_Menu(outer);
}

/*=============================================================================
 * refresh()
 *
 * Called to update the gold and gems
 *===========================================================================*/
public function refresh() {
  // Give cost display info to the displayer
  ///setCostValues(gameInfo.getResetSkillCost());
  /// this must have been copied code, its suposed to belong to the reset manager not the service info
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * 
 *===========================================================================*/
event onPopPageEvent() {
  // This is coupled with party selection, so we pop that too
  someScene.queuePop();
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  parentScene.focusBack();
  /// hacky 
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA(); 
protected function navigationRoutineB();

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Culling
  cullTags.add("Game_Menu_Selector")
  
  /** ===== Textures ===== **/
  // Reset panel
  begin object class=UI_Texture_Info Name=Reset_Cost_Window
    componentTextures.add(Texture2D'GUI.Reset_Cost_Window')
  end object
  begin object class=UI_Texture_Info Name=Reset_Cost_Window_With_Skill
    componentTextures.add(Texture2D'GUI.Reset_Cost_Window_With_Skill')
  end object
  
  /** ===== UI Components ===== **/
  // Reset panel
  begin object class=UI_Sprite Name=Reset_Cost_Panel
    tag="Reset_Cost_Panel"
    posX=0
    posY=0
    images(0)=Reset_Cost_Window
  end object
  componentList.add(Reset_Cost_Panel)
  
  // Header label
  begin object class=UI_Label Name=Header_Label
    tag="Header_Label"
    posX=0
    posY=74
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_LARGE_TAN
    AlignX=CENTER
    AlignY=TOP
    labelText="Reset Skill Service"
  end object
  componentList.add(Header_Label)
  
  // Mgmt Window - Title Label
  begin object class=UI_Label Name=Mgmt_Window_Label_0
    tag="Mgmt_Window_Label_0"
    posX=0
    posY=112
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="(Utility service)"
    fontStyle=DEFAULT_SMALL_GRAY
  end object
  componentList.add(Mgmt_Window_Label_0)
  
  // Mgmt Window - Description Labels
  begin object class=UI_Label Name=Mgmt_Window_Label_1
    tag="Mgmt_Window_Label_1"
    posX=0
    posY=151
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Select a skill to reset points from."
  end object
  componentList.add(Mgmt_Window_Label_1)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_2
    tag="Mgmt_Window_Label_2"
    posX=0
    posY=189
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_2)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_3
    tag="Mgmt_Window_Label_3"
    posX=0
    posY=216
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_3)
  
  /**
  
  // Header label
  begin object class=UI_Label Name=Header_Label
    tag="Header_Label"
    posX=0
    posY=74
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_LARGE_WHITE
    AlignX=CENTER
    AlignY=TOP
    labelText="Reset A Skill Point"
  end object
  componentList.add(Header_Label)
  
  // Gold Gost Displayer
  begin object class=ROTT_UI_Displayer_Cost Name=Gold_Cost
    tag="Gold_Cost"
    posX=0
    posY=130
    currencyType=class'ROTT_Inventory_Item_Gold'
    costDescriptionText="Gold cost per point:"
    costValue=100
  end object
  componentList.add(Gold_Cost)
  
  */
  
  /*
  // Skill Previewer
  begin object class=ROTT_UI_Displayer_Skill_Preview Name=Skill_Previewer
    tag="Skill_Previewer"
  end object
  componentList.add(Skill_Previewer)
  */
}













