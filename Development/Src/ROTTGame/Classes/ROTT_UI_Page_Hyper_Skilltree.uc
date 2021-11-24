/*=============================================================================
 * ROTT_UI_Page_Hyper_Skilltree
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This skill tree has information on special glyph glyphs
 * available to all parties.
 *===========================================================================*/
 
class ROTT_UI_Page_Hyper_Skilltree extends ROTT_UI_Page;

// Parent scene information
var private ROTT_UI_Scene_Game_Menu someScene;

// Internal references
var private ROTT_UI_Character_Sheet_Header header;
var private UI_Sprite hyperSkillsBackground;
var private UI_Selector_2D treeSelector;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Scene info
  someScene = ROTT_UI_Scene_Game_Menu(outer);
  
  // Internal references
  header = ROTT_UI_Character_Sheet_Header(findComp("Character_Sheet_Header"));
  hyperSkillsBackground = findSprite("Hyper_Skilltree_Background");
  treeSelector = UI_Selector_2D(findComp("Hyper_Selection_Box"));
  
  // Header
  header.setDisplayInfo
  (
    "Hyper",
    "Glyph glyphs",
    "",
    "",
    ""
  );
}

/*=============================================================================
 * onPushPageEvent()
 *
 * Called when this page is pushed to the screen.
 *===========================================================================*/
event onPushPageEvent() {
  super.onPushPageEvent();
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  // Enable display and navigation graphics
  hyperSkillsBackground.setEnabled(true);
  treeSelector.resetSelection();
  treeSelector.setEnabled(true);
  refresh();
}

/*=============================================================================
 * refresh()
 *
 * Called to update the gold and gems
 *===========================================================================*/
public function refresh() {
  local ROTT_Descriptor descriptor;
  local ROTT_Combat_Hero hero;
  
  // Pick out a hero, not relevant to display info
  hero = gameInfo.playerProfile.getActiveParty().getHero(0);
  
  switch (treeSelector.getSelection()) {
    case 0:
      descriptor = gameInfo.playerProfile.hyperSkills.getScript(GLYPH_TREE_HEALTH, hero);
      ROTT_UI_Scene_Game_Menu(parentScene).setMgmtDescriptor(descriptor);
      break;
    case 1:
      descriptor = gameInfo.playerProfile.hyperSkills.getScript(GLYPH_TREE_ARMOR, hero);
      ROTT_UI_Scene_Game_Menu(parentScene).setMgmtDescriptor(descriptor);
      break;
    case 2:
      descriptor = gameInfo.playerProfile.hyperSkills.getScript(GLYPH_TREE_MANA, hero);
      ROTT_UI_Scene_Game_Menu(parentScene).setMgmtDescriptor(descriptor);
      break;
    case 3:
      descriptor = gameInfo.playerProfile.hyperSkills.getScript(GLYPH_TREE_SPEED, hero);
      ROTT_UI_Scene_Game_Menu(parentScene).setMgmtDescriptor(descriptor);
      break;
    case 5:
      descriptor = gameInfo.playerProfile.hyperSkills.getScript(GLYPH_TREE_MP_REGEN, hero);
      ROTT_UI_Scene_Game_Menu(parentScene).setMgmtDescriptor(descriptor);
      break;
    case 6:
      descriptor = gameInfo.playerProfile.hyperSkills.getScript(GLYPH_TREE_ACCURACY, hero);
      ROTT_UI_Scene_Game_Menu(parentScene).setMgmtDescriptor(descriptor);
      break;
    case 4:
    case 7:
      descriptor = gameInfo.playerProfile.hyperSkills.getScript(GLYPH_TREE_DAMAGE, hero);
      ROTT_UI_Scene_Game_Menu(parentScene).setMgmtDescriptor(descriptor);
      break;
    case 8:
      descriptor = gameInfo.playerProfile.hyperSkills.getScript(GLYPH_TREE_DODGE, hero);
      ROTT_UI_Scene_Game_Menu(parentScene).setMgmtDescriptor(descriptor);
      break;
    default:
      yellowLog("Warning (!) Unhandled index " $ treeSelector.getSelection());
  }
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateUp() {
  treeSelector.moveUp();
  refresh();
}

public function onNavigateDown() {
  treeSelector.moveDown();
  refresh();
}

public function onNavigateLeft() {
  treeSelector.moveLeft();
  refresh();
}

public function onNavigateRight() {
  treeSelector.moveRight();
  refresh();
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  /**
  
  Probably do nothing here, we dont plan to modify hyper glyph stats in menu
  
  **/
}

protected function navigationRoutineB() {
  // Close the management window
  parentScene.popPage();
  // Close the hyperglyph menu 
  parentScene.popPage();
  
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
  // Mastery Skill Tree Background
  begin object class=UI_Texture_Info Name=Hyper_Glyph_Tree_Texture
    componentTextures.add(Texture2D'GUI.Hyper_Glyph_Tree')
  end object
  begin object class=UI_Texture_Info Name=Hyper_Selection_Box_Texture
    componentTextures.add(Texture2D'GUI.Skill_Selection_Box')
  end object
  
  /** ===== UI Components ===== **/
  // Glyph Skilltree background
  begin object class=UI_Sprite Name=Mastery_Skilltree_Background
    tag="Hyper_Skilltree_Background"
    bEnabled=false
    posX=720
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Hyper_Glyph_Tree_Texture
  end object
  componentList.add(Mastery_Skilltree_Background)
  
  // Header
  begin object class=ROTT_UI_Character_Sheet_Header Name=Character_Sheet_Header
    tag="Character_Sheet_Header"
  end object
  componentList.add(Character_Sheet_Header)
  
  // Listener hack
  begin object class=UI_Selector Name=Input_Listener
    tag="Input_Listener"
    navigationType=SELECTION_2D
    bEnabled=true
    bActive=true
  end object
  componentList.add(Input_Listener)
  
  // Hyper Selector
  begin object class=UI_Selector_2D Name=Hyper_Selection_Box
    tag="Hyper_Selection_Box"
    bEnabled=true
    posX=803
    posY=171
    selectOffset=(x=216,y=216)  // Distance from neighboring spaces
    homeCoords=(x=1,y=0)        // The default space for the selector to start
    gridSize=(x=3,y=3)          // Total size of 2d selection space
    
    // Visual offsets
    renderOffsets(0)=(xCoord=1,yCoord=0,xOffset=0,yOffset=-108)
    renderOffsets(1)=(xCoord=1,yCoord=1,xOffset=0,yOffset=108)
    renderOffsets(2)=(xCoord=1,yCoord=2,xOffset=0,yOffset=-108)
    
    // Navigation skips
    navSkips(3)=(xCoord=1,yCoord=2,skipDirection=NAV_UP)
    
    // Draw Textures
    images(0)=Hyper_Selection_Box_Texture
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    
  end object
  componentList.add(Hyper_Selection_Box)
  
}



/**
.
.                Armor: 
.                 DR%
.
.  Health:                           Mana:
.    regen?                            life leech % 
.                                      mana leech % 
.               Damage:
.                 damage% (perm)
.
.  Speed:                            Regen:
.    multistrike                       max%? 
.    damage to enemy tuna%             mp%?
.
.
.  Accuracy:                         Dodge:
.    accuracy%                         reflect damage%
.    dodge%
.
.
**/





/*

class ROTT_Skill_Info_HyperGlyphs extends ROTT_Skill_Info_Container;

function Initialize_Data()
{
  SkillNode.length = 10;

  SkillNode[0].SkillInfo.addItem("Hyper Armor"); 
  SkillNode[0].SkillInfo.addItem("(Collectible Glyph)");
  SkillNode[0].SkillInfo.addItem("This collectible hyper glyph's bonus");  
  SkillNode[0].SkillInfo.addItem("combines with the collector's original");
  SkillNode[0].SkillInfo.addItem("tactical enhancement, if it exists.");
  SkillNode[0].SkillInfo.addItem("Production Level: [%HyperLvl]");
  SkillNode[0].SkillInfo.addItem("");
  SkillNode[0].SkillInfo.addItem("");  
  SkillNode[0].SkillInfo.addItem("");  
  SkillNode[0].SkillInfo.addItem("Production Info");
  SkillNode[0].SkillInfo.addItem("Highest Level: [%HyperHigh]");
  SkillNode[0].SkillInfo.addItem("Average Level: [%HyperAvg]");  
  SkillNode[0].SkillInfo.addItem("Total Inventory: [%HyperTotal]");
  
  SkillNode[1].SkillInfo.addItem("Hyper Health"); 
  SkillNode[1].SkillInfo.addItem("(Collectible Glyph)");
  SkillNode[1].SkillInfo.addItem("This collectible hyper glyph's bonus");  
  SkillNode[1].SkillInfo.addItem("combines with the collector's original");
  SkillNode[1].SkillInfo.addItem("tactical enhancement, if it exists.");
  SkillNode[1].SkillInfo.addItem("Production Level: [%HyperLvl]");
  SkillNode[1].SkillInfo.addItem("");
  SkillNode[1].SkillInfo.addItem("");  
  SkillNode[1].SkillInfo.addItem("");
  SkillNode[1].SkillInfo.addItem("Production Info");
  SkillNode[1].SkillInfo.addItem("Highest Level Owned: [%HyperHigh]");
  SkillNode[1].SkillInfo.addItem("Average Level Owned: [%HyperAvg]");  
  SkillNode[1].SkillInfo.addItem("Total Inventory: [%HyperTotal]");
  
  SkillNode[2].SkillInfo.addItem("Hyper Speed"); 
  SkillNode[2].SkillInfo.addItem("(Collectible Glyph)");
  SkillNode[2].SkillInfo.addItem("This collectible hyper glyph's bonus");  
  SkillNode[2].SkillInfo.addItem("combines with the collector's original");
  SkillNode[2].SkillInfo.addItem("tactical enhancement, if it exists.");
  SkillNode[2].SkillInfo.addItem("Production Level: [%HyperLvl]");
  SkillNode[2].SkillInfo.addItem("");
  SkillNode[2].SkillInfo.addItem("");  
  SkillNode[2].SkillInfo.addItem("");
  SkillNode[2].SkillInfo.addItem("Production Info");
  SkillNode[2].SkillInfo.addItem("Highest Level Owned: [%HyperHigh]");
  SkillNode[2].SkillInfo.addItem("Average Level Owned: [%HyperAvg]");  
  SkillNode[2].SkillInfo.addItem("Total Inventory: [%HyperTotal]");
  
  SkillNode[3].SkillInfo.addItem("Hyper Accuracy"); 
  SkillNode[3].SkillInfo.addItem("(Collectible Glyph)");
  SkillNode[3].SkillInfo.addItem("This collectible hyper glyph's bonus");  
  SkillNode[3].SkillInfo.addItem("combines with the collector's original");
  SkillNode[3].SkillInfo.addItem("tactical enhancement, if it exists.");
  SkillNode[3].SkillInfo.addItem("Production Level: [%HyperLvl]");
  SkillNode[3].SkillInfo.addItem("");
  SkillNode[3].SkillInfo.addItem("");  
  SkillNode[3].SkillInfo.addItem("");
  SkillNode[3].SkillInfo.addItem("Production Info");
  SkillNode[3].SkillInfo.addItem("Highest Level Owned: [%HyperHigh]");
  SkillNode[3].SkillInfo.addItem("Average Level Owned: [%HyperAvg]");  
  SkillNode[3].SkillInfo.addItem("Total Inventory: [%HyperTotal]");
  
  SkillNode[5].SkillInfo.addItem("Hyper Damage"); 
  SkillNode[5].SkillInfo.addItem("(Collectible Glyph)");
  SkillNode[5].SkillInfo.addItem("This collectible hyper glyph's bonus");  
  SkillNode[5].SkillInfo.addItem("combines with the collector's original");
  SkillNode[5].SkillInfo.addItem("tactical enhancement, if it exists.");
  SkillNode[5].SkillInfo.addItem("Production Level: [%HyperLvl]");
  SkillNode[5].SkillInfo.addItem("");
  SkillNode[5].SkillInfo.addItem("");  
  SkillNode[5].SkillInfo.addItem("");
  SkillNode[5].SkillInfo.addItem("Production Info");
  SkillNode[5].SkillInfo.addItem("Highest Level Owned: [%HyperHigh]");
  SkillNode[5].SkillInfo.addItem("Average Level Owned: [%HyperAvg]");  
  SkillNode[5].SkillInfo.addItem("Total Inventory: [%HyperTotal]");
  
  SkillNode[7].SkillInfo.addItem("Hyper Mana"); 
  SkillNode[7].SkillInfo.addItem("(Collectible Glyph)");
  SkillNode[7].SkillInfo.addItem("This collectible hyper glyph's bonus");  
  SkillNode[7].SkillInfo.addItem("combines with the collector's original");
  SkillNode[7].SkillInfo.addItem("tactical enhancement, if it exists.");
  SkillNode[7].SkillInfo.addItem("Production Level: [%HyperLvl]");
  SkillNode[7].SkillInfo.addItem("");
  SkillNode[7].SkillInfo.addItem("");  
  SkillNode[7].SkillInfo.addItem("");
  SkillNode[7].SkillInfo.addItem("Production Info");
  SkillNode[7].SkillInfo.addItem("Highest Level Owned: [%HyperHigh]");
  SkillNode[7].SkillInfo.addItem("Average Level Owned: [%HyperAvg]");  
  SkillNode[7].SkillInfo.addItem("Total Inventory: [%HyperTotal]");
  
  SkillNode[8].SkillInfo.addItem("Hyper Shield"); 
  SkillNode[8].SkillInfo.addItem("(Collectible Glyph)");
  SkillNode[8].SkillInfo.addItem("This collectible hyper glyph's bonus");  
  SkillNode[8].SkillInfo.addItem("combines with the collector's original");
  SkillNode[8].SkillInfo.addItem("tactical enhancement, if it exists.");
  SkillNode[8].SkillInfo.addItem("Production Level: [%HyperLvl]");
  SkillNode[8].SkillInfo.addItem("");
  SkillNode[8].SkillInfo.addItem("");  
  SkillNode[8].SkillInfo.addItem("");
  SkillNode[8].SkillInfo.addItem("Production Info");
  SkillNode[8].SkillInfo.addItem("Highest Level Owned: [%HyperHigh]");
  SkillNode[8].SkillInfo.addItem("Average Level Owned: [%HyperAvg]");  
  SkillNode[8].SkillInfo.addItem("Total Inventory: [%HyperTotal]");
  
  SkillNode[9].SkillInfo.addItem("Hyper Reflection"); 
  SkillNode[9].SkillInfo.addItem("(Collectible Glyph)");
  SkillNode[9].SkillInfo.addItem("This collectible hyper glyph's bonus");  
  SkillNode[9].SkillInfo.addItem("combines with the collector's original");
  SkillNode[9].SkillInfo.addItem("tactical enhancement, if it exists.");
  SkillNode[9].SkillInfo.addItem("Production Level: [%HyperLvl]");
  SkillNode[9].SkillInfo.addItem("");
  SkillNode[9].SkillInfo.addItem("");  
  SkillNode[9].SkillInfo.addItem("");
  SkillNode[9].SkillInfo.addItem("Production Info");
  SkillNode[9].SkillInfo.addItem("Highest Level Owned: [%HyperHigh]");
  SkillNode[9].SkillInfo.addItem("Average Level Owned: [%HyperAvg]");  
  SkillNode[9].SkillInfo.addItem("Total Inventory: [%HyperTotal]");
  
  
}

defaultProperties
{

}

*/



























