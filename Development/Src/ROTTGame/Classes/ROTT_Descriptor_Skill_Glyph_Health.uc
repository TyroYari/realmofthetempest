/*=============================================================================
 * ROTT_Descriptor_Skill_Glyph_Health
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a glyph skill, collected in combat to provide Health boost.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Glyph_Health extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Health",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Collect this glyph during",
    "combat to recover hit points.",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Chance to spawn: %spawn%",
    "Recovers %min to %max HP per Glyph",
    ""
  );
}

/*=============================================================================
 * addManaOverflow()
 *
 * Called to track mana that overflows beyond a combat unit's max mana value
 *===========================================================================*/
public function addManaOverflow(float manaOverflow);

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
  local float attribute; 
  local int i, j; j = 0;
  
  if (level == 0) return 0;
  
  switch (type) {
    case GLYPH_SPAWN_CHANCE:
      attribute = 100;
      break;
    case GLYPH_MIN_HEALTH_BOOST:
      attribute = 6;
      for (i = 0; i < level; i++) {
        attribute = attribute + 6 + j;
        
        if (i % 2 == 0 && i != 0) {
          j = j + 4;
        } else {
          j = j + 2;
        }
      }
      attribute += (level / 3) * 12 * (level - 2);
      break;
    case GLYPH_MAX_HEALTH_BOOST:
      attribute = 12;
      for (i = 0; i < level; i++) {
        attribute = attribute + 8 + j;
        
        if (i % 2 == 0 && i != 0) {
          j = j + 6;
        } else {
          j = j + 4;
        }
      }
      attribute += (level / 3) * 15 * (level - 2);
      if (attribute % 2 != 0) attribute += 1;
      break;
  }
  
  return attribute;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Level lookup info
  skillIndex=GLYPH_TREE_HEALTH
  parentTree=GLYPH_TREE

  // Glyph Attributes
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%spawn",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_MIN_HEALTH_BOOST,tag="%min",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_MAX_HEALTH_BOOST,tag="%max",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
}
















