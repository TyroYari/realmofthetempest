/*=============================================================================
 * ROTT_Descriptor_Skill_Glyph_Armor
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a glyph skill, collected in combat to provide armor boost.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Glyph_Armor extends ROTT_Descriptor_Hero_Skill;
 
/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Armor",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Collect this glyph during",
    "combat to increase armor rating.",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Chance to spawn: %spawn%",
    "+%armor Armor rating per Glyph",
    ""
  );
}


/*=============================================================================
 * attributeInfo()
 *
 * This function should hold all equations pertaining to the skill's behavior.
 *===========================================================================*/
protected function float attributeInfo
(
  AttributeTypes type, 
  ROTT_Combat_Hero hero, 
  int level
) 
{
  local float attribute; attribute = 0; 
  
  if (level == 0) return 0;
  
  switch (type) {
    case GLYPH_SPAWN_CHANCE:
      attribute = 80;
      break;
    case GLYPH_ARMOR_BOOST:
      attribute = level;
      if (level > 20) attribute += (level - 20);
      if (level > 40) attribute += (level - 40) * 2;
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * addManaOverflow()
 *
 * Called to track mana that overflows beyond a combat unit's max mana value
 *===========================================================================*/
public function addManaOverflow(float manaOverflow);

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Level lookup info
  skillIndex=GLYPH_TREE_ARMOR
  parentTree=GLYPH_TREE
  
  // Glyph Attributes
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%spawn",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_ARMOR_BOOST,tag="%armor",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
}













