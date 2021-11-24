/*=============================================================================
 * ROTT_Descriptor_Skill_Goliath_Obsidian_Spirit
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Goliath_Obsidian_Spirit extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Obsidian Spirit"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "With each defend cast, half your life is",
    "lost, enemies target you more often, and",
    "you gain health regeneration."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "+%rejuv HP / sec",
    "",
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
  local float attribute; 
  
  switch (type) {
    case HEALTH_GAIN_OVER_TIME:
      attribute = level; // ((level - 1) / 2) + level;
      break;
      
    case ADD_SELF_AS_TARGET: 
      attribute = 1; // Creates another reference of this hero in the target list for enemies
                   // which is like a limit that approaches 100% chance to hit but never actually reaches it.
      break;
      
    case CUT_CASTER_LIFE_BY_PERCENT: 
      attribute = 50; 
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  targetingLabel=PASSIVE_DEFEND_PERK
  
  // Level lookup info
  skillIndex=GOLIATH_OBSIDIAN_SPIRIT
  parentTree=CLASS_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=ON_DEFEND_SET,mechanicType=HEALTH_GAIN_OVER_TIME,tag="%rejuv",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=ON_DEFEND_SET,mechanicType=ADD_SELF_AS_TARGET,tag="%target",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=ON_DEFEND_SET,mechanicType=CUT_CASTER_LIFE_BY_PERCENT,tag="%cut",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  

}


















