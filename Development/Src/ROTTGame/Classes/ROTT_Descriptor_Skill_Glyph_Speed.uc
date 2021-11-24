/*=============================================================================
 * ROTT_Descriptor_Skill_Glyph_Speed
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a glyph skill, collected in combat to provide Speed boost.
 *===========================================================================*/
 
class ROTT_Descriptor_Skill_Glyph_Speed extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Speed",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Collect this glyph during",
    "combat to increase speed rating.",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Chance to spawn: %spawn%",
    "+%speed to speed rating per Glyph",
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
      attribute = 40;
      break;
    case GLYPH_SPEED_BOOST:
      attribute = speedRating(level);
      break;
  }
  
  return attribute;
}

private function int speedRating(int level) {
  local int speed, i, delta;
  
  speed = 4;
  delta = 2;
  
  for (i = 0; i < level; i++) {
    speed = speed + delta;
    
    if (i%2 == 0 && i != 0) {
      delta = delta + 3;
    } else {
      delta = delta + 2;
    }
  } 
  return speed;
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
  skillIndex=GLYPH_TREE_SPEED
  parentTree=GLYPH_TREE
  
  // Glyph Attributes
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%spawn",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPEED_BOOST,tag="%speed",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
}

















