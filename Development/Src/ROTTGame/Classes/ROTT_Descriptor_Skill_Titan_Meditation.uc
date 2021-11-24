/*=============================================================================
 * ROTT_Descriptor_Skill_Titan_Meditation
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Titan_Meditation extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Meditation"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "Any hero that hasn't taken damage for",
    "more than five seconds will start",
    "to regenerate health over time."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "%rejuv HP / sec",
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
    case MEDITATION_RATING:
      attribute = level;
      break;
  }
  
  return attribute;
}

/**=============================================================================
 * onTakeDamage()
 *
 * Called when the owner of this skill takes damage
 *===========================================================================
public function onTakeDamage() {
  timeWithoutDamage = 0;
  bStatusEnabled = false;
  hero.removeStatus(self);
}
*/
/**============================================================================= 
 * skillReset()
 *
 * Called to reset skill data at the start of a new battle
 *===========================================================================
public function skillReset() {
  super.skillReset();
  timeWithoutDamage = 0;
  bStatusEnabled = false;
  hero.removeStatus(self);
}
*/
/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  targetingLabel=PASSIVE_PARTY_BUFF
  
  // Status info
  statusTag="Meditation"
  statusColor=COMBAT_SMALL_BLUE
  
  // Level lookup info
  skillIndex=TITAN_MEDITATION
  parentTree=CLASS_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=PASSIVE_PARTY_SET,mechanicType=MEDITATION_RATING,tag="%rejuv",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}





















