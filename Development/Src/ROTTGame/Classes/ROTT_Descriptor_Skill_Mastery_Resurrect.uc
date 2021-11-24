/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Resurrect
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Resurrect extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Resurrection",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "So long as other heroes survive, this",
    "hero may be brought back to life.",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Resurrection rate: %health hp / sec",
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
  local float attribute; attribute = 0; 
  
  switch (type) {
    case RESURRECTION_HEALTH:
      attribute = (2 ** (level - 1)) * 5;
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * onDeadTick()
 *
 * Called each tick only while dead
 *===========================================================================*/
public function onDeadTick(ROTT_Combat_Hero hero, float deltaTime) {
  local int level;
  
  // Get skill level
  level = getSkillLevel(hero);
  
  // Ignore if no skill points
  if (level == 0) return;
  
  // Track resurrection time
  hero.addResPoints(deltaTime * getAttributeInfo(RESURRECTION_HEALTH, hero, level));
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
  // Status info
  statusTag="Resurrecting"
  statusColor=COMBAT_SMALL_RED
  
  // Skill attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=RESURRECTION_HEALTH,tag="%health",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
  // Level lookup info
  skillIndex=MASTERY_RESURRECT
  parentTree=MASTERY_TREE

}















