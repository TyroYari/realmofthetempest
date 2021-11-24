/*=============================================================================
 * ROTT_Descriptor_Skill_Glyph_Damage
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a glyph skill, collected in combat to provide Damage boost.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Glyph_Damage extends ROTT_Descriptor_Hero_Skill;
 
/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Damage",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Collect this glyph during",
    "combat to increase the damage of your",
    "next elemental or physical attack.",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Chance to spawn: %spawn%",
    "+%damage% damage per Glyph",
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
      attribute = 10;
      break;
    case GLYPH_DAMAGE_BOOST:
      attribute = 25 + (75 * level) - 25 * ((level - 1) / 2);
      //attribute = level * 8;
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
  skillIndex=GLYPH_TREE_DAMAGE
  parentTree=GLYPH_TREE

  // Glyph Attributes
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%spawn",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_DAMAGE_BOOST,tag="%damage",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
}


















