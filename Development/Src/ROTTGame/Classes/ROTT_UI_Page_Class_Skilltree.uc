/*=============================================================================
 * ROTT_UI_Page_Class_Skilltree
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *===========================================================================*/
 
class ROTT_UI_Page_Class_Skilltree extends ROTT_UI_Page_Hero_Tree_Info;

// Internal references
var private ROTT_UI_Character_Sheet_Header header;
var private ROTT_UI_Tree_Highlights highlights;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  header = ROTT_UI_Character_Sheet_Header(findComp("Character_Sheet_Header"));
  skilltreeBackground = findSprite("Class_Skilltree_Background");
  treeSelectionBox = UI_Tree_Selector(findComp("Skill_Selector"));
  highlights = ROTT_UI_Tree_Highlights(findComp("Skill_Highlights"));
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  super.onPushPageEvent();
  
  // Update skill tree navigation
  updateSelector();
}

/*============================================================================= 
 * refresh()
 *
 *
 *===========================================================================*/
public function refresh() {
  super.refresh();
  
  // Update skill tree navigation
  updateSelector();
}

/*============================================================================= 
 * updateSelector()
 *
 * Sets the navigation for the skill tree based on the hero class
 *===========================================================================*/
public function updateSelector() {
  // Set tree selector for this hero
  switch (parentScene.getSelectedHero().myClass) {
    case VALKYRIE:  treeSelectionBox.switchTreeType(VALKYRIE_TREE);  break;
    case WIZARD:    treeSelectionBox.switchTreeType(WIZARD_TREE);    break;
    case TITAN:     treeSelectionBox.switchTreeType(TITAN_TREE);     break;
    case GOLIATH:   treeSelectionBox.switchTreeType(GOLIATH_TREE);   break;
  }
}

/*============================================================================= 
 * renderHeroData()
 *
 * Given a hero, this displays all of its information to the screen
 *===========================================================================*/
protected function renderHeroData(ROTT_Combat_Hero hero) {
  // Header
  header.setDisplayInfo
  (
    pCase(hero.myClass),
    "class skills",
    "",
    (hero.unspentSkillPoints != 0) ? "Skill Points" : "",
    (hero.unspentSkillPoints != 0) ? string(hero.unspentSkillPoints) : ""
  );

  // Draw highlights
  highlights.setClassHighlights(hero);
  
  // Update tree background
  skilltreeBackground.setDrawIndex(hero.myClass);
  
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft() {
  super.onNavigateLeft();
  
  switch (controlState) {
    case VIEW_MODE:
      // Change view to stats page
      gameMenuScene.switchPage(STATS_INSPECTION);
      break;
    case RESET_VIEW_MODE:
      // Change view to stats page
      gameMenuScene.switchPage(MASTERY_SKILLTREE);
      break;
  }
}

public function onNavigateRight() {
  super.onNavigateRight();
  
  switch (controlState) {
    case VIEW_MODE:
    case RESET_VIEW_MODE:
      // Change view to glyph tree
      gameMenuScene.switchPage(GLYPH_SKILLTREE);
      break;
  }
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  /** ===== Textures ===== **/
  // class Skill Tree Backgrounds
  begin object class=UI_Texture_Info Name=Class_Skill_Tree_Valkyrie
    componentTextures.add(Texture2D'GUI.Class_Skill_Tree_Valkyrie')
  end object
  begin object class=UI_Texture_Info Name=Class_Skill_Tree_Goliath
    componentTextures.add(Texture2D'GUI.Class_Skill_Tree_Goliath')
  end object
  begin object class=UI_Texture_Info Name=Class_Skill_Tree_Titan
    componentTextures.add(Texture2D'GUI.Class_Skill_Tree_Titan')
  end object
  begin object class=UI_Texture_Info Name=Class_Skill_Tree_Wizard
    componentTextures.add(Texture2D'GUI.Class_Skill_Tree_Wizard')
  end object
  begin object class=UI_Texture_Info Name=Class_Skill_Tree_Assassin
    componentTextures.add(Texture2D'GUI.Class_Skill_Tree_Assassin')
  end object
  
  // Skill Selection Box
  begin object class=UI_Texture_Info Name=Skill_Selection_Box
    componentTextures.add(Texture2D'GUI.Skill_Selection_Box')
  end object
  begin object class=UI_Texture_Info Name=Skill_Selection_Box_Red
    componentTextures.add(Texture2D'GUI.Skill_Selection_Box_Red')
  end object
  
  /** ===== UI Components ===== **/
  // Right background
  begin object class=UI_Sprite Name=Class_Skilltree_Background
    tag="Class_Skilltree_Background"
    bEnabled=false
    posX=720
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Class_Skill_Tree_Valkyrie
    images(VALKYRIE)=Class_Skill_Tree_Valkyrie
    images(GOLIATH)=Class_Skill_Tree_Goliath
    images(TITAN)=Class_Skill_Tree_Titan
    images(WIZARD)=Class_Skill_Tree_Wizard
    images(ASSASSIN)=Class_Skill_Tree_Assassin
  end object
  componentList.add(Class_Skilltree_Background)
  
  // Header
  begin object class=ROTT_UI_Character_Sheet_Header Name=Character_Sheet_Header
    tag="Character_Sheet_Header"
  end object
  componentList.add(Character_Sheet_Header)
  
  // Skill Highlights
  begin object class=ROTT_UI_Tree_Highlights Name=Skill_Highlights
    tag="Skill_Highlights"
  end object
  componentList.add(Skill_Highlights)
  
  // Skill Selector
  begin object class=UI_Tree_Selector Name=Skill_Selector
    tag="Skill_Selector"
    bEnabled=false
    posX=803
    posY=63
    
    // Tree type
    treeType=WIZARD_TREE
    
    // Draw Textures
    images(0)=Skill_Selection_Box
    images(1)=Skill_Selection_Box_Red
    
  end object
  componentList.add(Skill_Selector)
  
}




















