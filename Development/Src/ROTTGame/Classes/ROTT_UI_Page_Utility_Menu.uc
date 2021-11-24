/*=============================================================================
 * ROTT_UI_Page_Utility_Menu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The utilities menu is accessed through ROTT_UI_Scene_Game_Menu
 *===========================================================================*/
 
class ROTT_UI_Page_Utility_Menu extends ROTT_UI_Page;

// Menu items
enum UtilityMenuItems {
  UTILITY_PROFILE,
  UTILITY_TEAM_MANAGER,
  UTILITY_INVENTORY,
  UTILITY_RESET_STATS,
  UTILITY_RESET_SKILLS,
  UTILITY_GUIDE,
  UTILITY_HYPER_GLYPHS
};

// Internal references
var private UI_Sprite utilityMenuBackground;
var private UI_Selector utilitySelector;
var private UI_Sprite hyperGlyphLabelGraphic;

// External UI references
///var public ROTT_UI_Scene_Game_Menu gameMenuPage;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Get internal references
  utilityMenuBackground = findSprite("Utility_Menu_Background");
  utilitySelector = UI_Selector(findComp("Utility_Selector"));
  hyperGlyphLabelGraphic = findSprite("Utility_Hyper_Label");
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  // Enable display and navigation graphics
  utilityMenuBackground.setEnabled(true);
  utilitySelector.setActive(true);
  hyperGlyphLabelGraphic.setEnabled(true);
  
  hyperGlyphLabelGraphic.setDrawIndex((gameInfo.playerProfile.hyperUnlocked) ? 1 : 0);
  
  // Enable graphics for party manager if in town
  ///partyMgmtMenuGraphic.setDrawIndex((gameInfo.isInTown()) ? 0 : 1);
}

/*=============================================================================
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu() {
  utilitySelector.setActive(false);
}

/*=============================================================================
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  switch (UtilityMenuItems(utilitySelector.getSelection())) {
    case UTILITY_PROFILE:
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      
      // Push profile
      parentScene.pushPageByTag("Page_Profile");
      break;
    case UTILITY_TEAM_MANAGER:
      if (gameInfo.isInTown()) {
        /** delegate me **/
        sceneManager.switchScene(SCENE_PARTY_MANAGER);
        
        // Sfx
        gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      } else {
        sfxBox.playSFX(SFX_MENU_INSUFFICIENT); 
      }
      break;
    case UTILITY_INVENTORY:
      /** delegate me **/
      ROTT_UI_Scene_Game_Menu(parentScene).pushMenu(INVENTORY_MENU);
      ROTT_UI_Scene_Game_Menu(parentScene).pushMenu(MGMT_WINDOW_ITEM);
      
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case UTILITY_RESET_STATS:
      /** delegate me **/
      ROTT_UI_Scene_Game_Menu(parentScene).pushMenu(REINVEST_STAT_MENU);
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case UTILITY_RESET_SKILLS:
      /** delegate me **/
      ROTT_UI_Scene_Game_Menu(parentScene).pushMenu(REINVEST_SKILL_MENU);
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case UTILITY_GUIDE:
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      
      // Push Guide Page
      parentScene.pushPageByTag("Page_Guide");
      break;
    case UTILITY_HYPER_GLYPHS:
      if (gameInfo.playerProfile.hyperUnlocked) {
        /** delegate me **/
        ROTT_UI_Scene_Game_Menu(parentScene).pushMenu(HYPER_SKILLTREE);
        // Sfx
        gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      } else {
        sfxBox.playSFX(SFX_MENU_INSUFFICIENT); 
      }
      break;
  }
}

protected function navigationRoutineB() {
  utilityMenuBackground.setEnabled(false);
  utilitySelector.resetSelection();
  hyperGlyphLabelGraphic.setEnabled(false);
  
  parentScene.popPage();
  
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
  // Utility Background
  begin object class=UI_Texture_Info Name=Utility_Background_Texture
    componentTextures.add(Texture2D'GUI.Utilities.Utility_List_Background')
  end object
  
  // Hyper Glyphs Label Graphics
  begin object class=UI_Texture_Info Name=Utilities_Secret_Texture
    componentTextures.add(Texture2D'GUI.Utilities.Utilities_Mystery_Option')
  end object
  begin object class=UI_Texture_Info Name=Utilities_Hyper_Lit_Texture
    componentTextures.add(Texture2D'GUI.Utilities.Utilities_Mystery_Option_Hyper_Glyph')
  end object
  
  /** ===== UI Components ===== **/
  // Utility menu background
  begin object class=UI_Sprite Name=Utility_Menu_Background
    tag="Utility_Menu_Background"
    bEnabled=false
    posX=720
    posY=0
    images(0)=Utility_Background_Texture
  end object
  componentList.add(Utility_Menu_Background)
  
  // Utility Selection Arrow
  begin object class=UI_Selector Name=Utility_Selector
    tag="Utility_Selector"
    bEnabled=true
    posX=737
    posY=50
    selectionOffset=(x=0,y=100)
    numberOfMenuOptions=7
    hoverCoords(0)=(xStart=737,yStart=50,xEnd=1423,yEnd=140)
    hoverCoords(1)=(xStart=737,yStart=150,xEnd=1423,yEnd=240)
    hoverCoords(2)=(xStart=737,yStart=250,xEnd=1423,yEnd=340)
    hoverCoords(3)=(xStart=737,yStart=350,xEnd=1423,yEnd=440)
    hoverCoords(4)=(xStart=737,yStart=450,xEnd=1423,yEnd=540)
    hoverCoords(5)=(xStart=737,yStart=550,xEnd=1423,yEnd=640)
    hoverCoords(6)=(xStart=737,yStart=650,xEnd=1423,yEnd=740)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Utilities_Selection_Box')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      posX=34
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=170, max=255))
    end object
    componentList.add(Selector_Sprite)
    
    // Inactive arrow
    begin object class=UI_Texture_Info Name=Inactive_Selection_Arrow
      componentTextures.add(Texture2D'GUI.Menu_Selection_Arrow')
    end object
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Inactive_Selection_Arrow
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Utility_Selector)
  
  // Hyper Glyph Label
  begin object class=UI_Sprite Name=Utility_Hyper_Label
    tag="Utility_Hyper_Label"
    bEnabled=false
    posX=726
    posY=658
    images(0)=Utilities_Secret_Texture
    images(1)=Utilities_Hyper_Lit_Texture
  end object
  componentList.add(Utility_Hyper_Label)
  
}













