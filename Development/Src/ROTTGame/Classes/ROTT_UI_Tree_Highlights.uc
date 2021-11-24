/*=============================================================================
 * ROTT_UI_Tree_Highlights
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This container displays skill tree highlight boxes
 *===========================================================================*/
 
class ROTT_UI_Tree_Highlights extends UI_Container;

// Tree rendering types
enum TreeTypes {
  CLASS_TREE,
  GLYPH_TREE,
  MASTERY_TREE
};

// Internal references
var private UI_Sprite highlight[10];
var private UI_Texture_Storage highlightSprites;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i, j;
  
  super.initializeComponent(newTag);
  
  // Highlight colors
  highlightSprites = UI_Texture_Storage(findComp("Highlighter_Colors"));
  
  // Nodes names
  for (i = 0; i < 10; i++) {
    highlight[i] = findSprite("Skill_Highlight_" $ i);
  }
  
  // Nodes positions for 3 columns
  for (i = 0; i < 3; i++) {
    highlight[j].updatePosition(getX(), getY() + i * 216 + 108);
    j++;
  }
  for (i = 0; i < 4; i++) {
    highlight[j].updatePosition(getX() + 216, getY() + i * 216);
    j++;
  }
  for (i = 0; i < 3; i++) {
    highlight[j].updatePosition(getX() + 216 * 2, getY() + i * 216 + 108);
    j++;
  }
}

/*============================================================================= 
 * setClassHighlights()
 *
 * Provides the skill levels mapped to the proper skill tree indexes for
 * class skill tree highlighting
 *===========================================================================*/
private function getSkillColor
(
  int index,
  int skillId, 
  TreeTypes treeType,
  ROTT_Combat_Hero hero
)
{
  local int level;
  
  if (skillId == -1) { highlight[index].setEnabled(false); return; }
  
  // Get level from tree type
  switch (treeType) {
    case CLASS_TREE:
      level = hero.getClassLevel(skillId);
      break;
    case GLYPH_TREE:
      level = hero.getGlyphLevel(skillId);
      break;
    case MASTERY_TREE:
      level = hero.getMasteryLevel(skillId);
      break;
  }
  
  // Set highlights
  if (level > 0) {
    // on
    highlight[index].setEnabled(true);
    if (treeType == CLASS_TREE && (skillId == hero.primarySkill || skillId == hero.secondarySkill)) {
      highlight[index].copySprite(highlightSprites, hero.myClass);
    } else {
      highlight[index].copySprite(highlightSprites, 0);
    }
  } else {
    // off
    highlight[index].setEnabled(false);
  }
  
}

/*============================================================================= 
 * setClassHighlights()
 *
 * Provides the skill levels mapped to the proper skill tree indexes for
 * class skill tree highlighting
 *===========================================================================*/
public function setClassHighlights(ROTT_Combat_Hero hero) {
  
  switch (hero.myClass) {
    case VALKYRIE:
      getSkillColor(0, -1, -1, hero);
      getSkillColor(1, VALKYRIE_SPARK_FIELD, CLASS_TREE, hero);
      getSkillColor(2, VALKYRIE_SOLAR_SHOCK, CLASS_TREE, hero);
      getSkillColor(3, VALKYRIE_VALOR_STRIKE, CLASS_TREE, hero);
      getSkillColor(4, VALKYRIE_THUNDER_SLASH, CLASS_TREE, hero);
      getSkillColor(5, VALKYRIE_VERMEIL_STITCHING, CLASS_TREE, hero);
      getSkillColor(6, VALKYRIE_VOLT_RETALIATION, CLASS_TREE, hero);
      getSkillColor(7, VALKYRIE_SWIFT_STEP, CLASS_TREE, hero);
      getSkillColor(8, VALKYRIE_ELECTRIC_SIGIL, CLASS_TREE, hero);
      getSkillColor(9, -1, -1, hero);
      break;
    case WIZARD:
      getSkillColor(0, WIZARD_STARDUST, CLASS_TREE, hero);
      getSkillColor(1, -1, -1, hero);
      getSkillColor(2, WIZARD_PLASMA_SHROUD, CLASS_TREE, hero);
      getSkillColor(3, WIZARD_STARBOLT, CLASS_TREE, hero);
      getSkillColor(4, WIZARD_SPECTRAL_SURGE, CLASS_TREE, hero);
      getSkillColor(5, WIZARD_ARCANE_SIGIL, CLASS_TREE, hero);
      getSkillColor(6, WIZARD_BLACK_HOLE, CLASS_TREE, hero);
      getSkillColor(7, -1, -1, hero);
      getSkillColor(8, WIZARD_DEVOTION, CLASS_TREE, hero);
      getSkillColor(9, WIZARD_ASTRAL_FIRE, CLASS_TREE, hero);
      break;
    case GOLIATH:
      getSkillColor(0, -1, -1, hero);
      getSkillColor(1, GOLIATH_DEMOLISH, CLASS_TREE, hero);
      getSkillColor(2, -1, -1, hero);
      getSkillColor(3, GOLIATH_STONE_STRIKE, CLASS_TREE, hero);
      getSkillColor(4, GOLIATH_EARTHQUAKE, CLASS_TREE, hero);
      getSkillColor(5, GOLIATH_OBSIDIAN_SPIRIT, CLASS_TREE, hero);
      getSkillColor(6, GOLIATH_MARBLE_SPIRIT, CLASS_TREE, hero);
      getSkillColor(7, GOLIATH_INTIMIDATION, CLASS_TREE, hero);
      getSkillColor(8, GOLIATH_COUNTER_GLYPHS, CLASS_TREE, hero);
      getSkillColor(9, GOLIATH_AVALANCHE, CLASS_TREE, hero);
      break;
    case TITAN:
      getSkillColor(0, TITAN_THRASHER, CLASS_TREE, hero);
      getSkillColor(1, TITAN_BLIZZARD, CLASS_TREE, hero);
      getSkillColor(2, TITAN_MEDITATION, CLASS_TREE, hero);
      getSkillColor(3, TITAN_SIPHON, CLASS_TREE, hero);
      getSkillColor(4, TITAN_ICE_STORM, CLASS_TREE, hero);
      getSkillColor(5, -1, -1, hero);
      getSkillColor(6, TITAN_AURORA_FANGS, CLASS_TREE, hero);
      getSkillColor(7, -1, -1, hero);
      getSkillColor(8, TITAN_OATH, CLASS_TREE, hero);
      getSkillColor(9, TITAN_FUSION, CLASS_TREE, hero);
      break;
  }
}


/*============================================================================= 
 * getHighlights()
 *
 * Provides the skill levels mapped to the proper skill tree indexes for
 * highlighting
 *===========================================================================*/
public function setMasteryHighlights(ROTT_Combat_Hero hero) {
  getSkillColor(0, MASTERY_LIFE, MASTERY_TREE, hero);
  getSkillColor(1, MASTERY_REJUV, MASTERY_TREE, hero);
  getSkillColor(2, MASTERY_ACCURACY, MASTERY_TREE, hero);
  getSkillColor(3, MASTERY_ARMOR, MASTERY_TREE, hero);
  getSkillColor(4, MASTERY_DAMAGE, MASTERY_TREE, hero);
  getSkillColor(5, -1, -1, hero);
  
  if (ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game).playerProfile.gameMode == MODE_HARDCORE) {
    getSkillColor(6, MASTERY_OMNI_SEEKER, MASTERY_TREE, hero);
  } else {
    getSkillColor(6, MASTERY_RESURRECT, MASTERY_TREE, hero);
  }
  
  getSkillColor(7, MASTERY_MANA, MASTERY_TREE, hero);
  getSkillColor(8, MASTERY_SPEED, MASTERY_TREE, hero);
  getSkillColor(9, MASTERY_DODGE, MASTERY_TREE, hero);
}

/*============================================================================= 
 * getHighlights()
 *
 * Provides the skill levels mapped to the proper skill tree indexes for
 * glyph highlighting
 *===========================================================================*/
public function setGlyphHighlights(ROTT_Combat_Hero hero) {
  getSkillColor(0, GLYPH_TREE_HEALTH, GLYPH_TREE, hero);
  getSkillColor(1, GLYPH_TREE_SPEED, GLYPH_TREE, hero);
  getSkillColor(2, GLYPH_TREE_ACCURACY, GLYPH_TREE, hero);
  getSkillColor(3, GLYPH_TREE_ARMOR, GLYPH_TREE, hero);
  getSkillColor(4, -1, -1, hero);
  getSkillColor(5, GLYPH_TREE_DAMAGE, GLYPH_TREE, hero);
  getSkillColor(6, -1, -1, hero);
  getSkillColor(7, GLYPH_TREE_MANA, GLYPH_TREE, hero);
  getSkillColor(8, GLYPH_TREE_MP_REGEN, GLYPH_TREE, hero);
  getSkillColor(9, GLYPH_TREE_DODGE, GLYPH_TREE, hero);
}


/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Starting position
  posX=802
  posY=64
  
  /** ===== Textures ===== **/
  // Highlights
  begin object class=UI_Texture_Info Name=Skill_Highlight_White
    componentTextures.add(Texture2D'GUI.Skill_Highlight_White')
  end object
  begin object class=UI_Texture_Info Name=Skill_Highlight_Valkyrie
    componentTextures.add(Texture2D'GUI.Skill_Highlight_Valkyrie')
  end object
  begin object class=UI_Texture_Info Name=Skill_Highlight_Goliath
    componentTextures.add(Texture2D'GUI.Skill_Highlight_Goliath')
  end object
  begin object class=UI_Texture_Info Name=Skill_Highlight_Wizard
    componentTextures.add(Texture2D'GUI.Skill_Highlight_Wizard')
  end object
  begin object class=UI_Texture_Info Name=Skill_Highlight_Assassin
    componentTextures.add(Texture2D'GUI.Skill_Highlight_Assassin')
  end object
  begin object class=UI_Texture_Info Name=Skill_Highlight_Titan
    componentTextures.add(Texture2D'GUI.Skill_Highlight_Titan')
  end object
  
  // Highlight colors
  begin object class=UI_Texture_Storage Name=Highlighter_Colors
    tag="Highlighter_Colors"
    images(UNSPECIFIED)=Skill_Highlight_White
    images(VALKYRIE)=Skill_Highlight_Valkyrie
    images(WIZARD)=Skill_Highlight_Wizard
    images(GOLIATH)=Skill_Highlight_Goliath
    images(TITAN)=Skill_Highlight_Titan
    images(ASSASSIN)=Skill_Highlight_Assassin
    textureWidth=124
    textureHeight=124
  end object
  componentList.add(Highlighter_Colors)
  
  // Skill Highlights
  begin object class=UI_Sprite Name=Skill_Highlight_0
    tag="Skill_Highlight_0"
  end object
  componentList.add(Skill_Highlight_0)
  
  begin object class=UI_Sprite Name=Skill_Highlight_1
    tag="Skill_Highlight_1"
  end object
  componentList.add(Skill_Highlight_1)
  
  begin object class=UI_Sprite Name=Skill_Highlight_2
    tag="Skill_Highlight_2"
  end object
  componentList.add(Skill_Highlight_2)
  
  begin object class=UI_Sprite Name=Skill_Highlight_3
    tag="Skill_Highlight_3"
  end object
  componentList.add(Skill_Highlight_3)
  
  begin object class=UI_Sprite Name=Skill_Highlight_4
    tag="Skill_Highlight_4"
  end object
  componentList.add(Skill_Highlight_4)
  
  begin object class=UI_Sprite Name=Skill_Highlight_5
    tag="Skill_Highlight_5"
  end object
  componentList.add(Skill_Highlight_5)
  
  begin object class=UI_Sprite Name=Skill_Highlight_6
    tag="Skill_Highlight_6"
  end object
  componentList.add(Skill_Highlight_6)
  
  begin object class=UI_Sprite Name=Skill_Highlight_7
    tag="Skill_Highlight_7"
  end object
  componentList.add(Skill_Highlight_7)
  
  begin object class=UI_Sprite Name=Skill_Highlight_8
    tag="Skill_Highlight_8"
  end object
  componentList.add(Skill_Highlight_8)
  
  begin object class=UI_Sprite Name=Skill_Highlight_9
    tag="Skill_Highlight_9"
  end object
  componentList.add(Skill_Highlight_9)
  
}















