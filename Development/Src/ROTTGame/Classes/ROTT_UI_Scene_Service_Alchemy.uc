/*=============================================================================
 * ROTT_UI_Scene_Service_Alchemy
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene manages the enchantment minigame from the Alchemist
 *===========================================================================*/

class ROTT_UI_Scene_Service_Alchemy extends ROTT_UI_Scene;

var public EnchantmentEnum selectedEnchantment;
var public int enchantmentLevel;
var public int minigameMultiplier;

// Pages
var privatewrite ROTT_UI_Page_Alchemy_Menu alchemyMenu;
var privatewrite ROTT_UI_Page_Alchemy_Game alchemyGame;
var privatewrite ROTT_UI_Page_Alchemy_Game_Over alchemyGameOver;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal references
  alchemyMenu = ROTT_UI_Page_Alchemy_Menu(findComp("Page_Alchemy_Menu"));
  alchemyGame = ROTT_UI_Page_Alchemy_Game(findComp("Page_Alchemy_Game"));
  alchemyGameOver = ROTT_UI_Page_Alchemy_Game_Over(findComp("Page_Alchemy_Game_Over"));
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  
}

/*=============================================================================
 * unloadScene()
 * 
 * Called when this scene will no longer be rendered.  Each page receives
 * a call for the onSceneDeactivation() event
 *===========================================================================*/
event unloadScene() {
  super.unloadScene();
}

/*=============================================================================
 * submitAlchemyResult()
 * 
 * Called when the alchemy game results are complete and accepted by the player
 *===========================================================================*/
public function submitAlchemyResult() {
  // Increase enchantment level
  gameInfo.playerProfile.addEnchantBoost(
    selectedEnchantment, 
    enchantmentLevel * minigameMultiplier
  );
  
  // Sound effect
  gameInfo.sfxbox.playSfx(SFX_MENU_BLESS_STAT);
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties 
{
  bResetOnLoad=true
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  /** ===== Pages ===== **/
  // Alchemy Instructions
  begin object class=ROTT_UI_Page_Alchemy_Instructions Name=Page_Alchemy_Instructions
    tag="Page_Alchemy_Instructions"
    bInitialPage=true
  end object
  pageComponents.add(Page_Alchemy_Instructions)
  
  // Alchemy Menu
  begin object class=ROTT_UI_Page_Alchemy_Menu Name=Page_Alchemy_Menu
    tag="Page_Alchemy_Menu"
  end object
  pageComponents.add(Page_Alchemy_Menu)
  
  // Alchemy Game
  begin object class=ROTT_UI_Page_Alchemy_Game Name=Page_Alchemy_Game
    tag="Page_Alchemy_Game"
  end object
  pageComponents.add(Page_Alchemy_Game)
  
  // Alchemy Game Over
  begin object class=ROTT_UI_Page_Alchemy_Game_Over Name=Page_Alchemy_Game_Over
    tag="Page_Alchemy_Game_Over"
  end object
  pageComponents.add(Page_Alchemy_Game_Over)
  
}









