/*=============================================================================
 * ROTT_Descriptor_Skill_Defend
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Attack ability for hero units
 *===========================================================================*/

class ROTT_Descriptor_Skill_Defend extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // No UI display info
}

/*=============================================================================
 * attributeInfo()
 *
 * This function should hold all equations pertaining to the skill's behavior.
 *===========================================================================*/
protected function float attributeInfo
(
  AttributeTypes type, 
  ROTT_Combat_Hero caster, 
  int level
)
{
  local float attribute; attribute = 0; 
  
  switch (type) {
    case MANA_COST:
      attribute = 0;
      break;
    
    // Combat action attributes
    case ADD_STANCE_COUNT:
      attribute = 1; // Step count
      break;
    case ATTACK_TIME_AMPLIFIER:
      attribute = 2;
      break;
    case ADD_MANA_REGENERATION:
      attribute = caster.statBoosts[ADD_MANA_REGEN_ON_DEFEND];
      break;
    
    // Stance attributes
    case INCREASE_ARMOR:
      attribute = caster.level * 2;
      break;
    case HEALTH_GAIN_OVER_TIME:
      attribute = caster.statBoosts[REGEN_HEALTH_WHILE_DEFENDING];
      break;
    case GLYPH_MANA_REGEN:
      attribute = caster.statBoosts[REGEN_MANA_WHILE_DEFENDING];
      break;
  }
  
  return attribute;
}

/*============================================================================= 
 * getSkillLevel()
 *
 * This fetches the skill level from the unit provided
 *===========================================================================*/
public function int getSkillLevel
(
  ROTT_Combat_Hero hero, 
  optional bool bIgnoreBoost = false
) 
{
  // Override: always level 1
  return 1;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  targetingLabel=SELF_TARGET_BUFF
  parentTree=NO_TREE
  
  // Status info
  statusTag="Defending"
  statusColor=COMBAT_SMALL_GREEN
  
  // Sound effect
  combatSfx=SFX_COMBAT_BUFF
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ADD_STANCE_COUNT,tag="%stance",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ADD_MANA_REGENERATION,tag="%addregen",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Stance Attributes
  skillAttributes.add((attributeSet=ADD_STANCE_SET,mechanicType=ATTACK_TIME_AMPLIFIER,tag="%tuna",font=DEFAULT_SMALL_WHITE,returnType=DECIMAL));
  skillAttributes.add((attributeSet=ADD_STANCE_SET,mechanicType=INCREASE_ARMOR,tag="%armor",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=ADD_STANCE_SET,mechanicType=GLYPH_MANA_REGEN,tag="%mpregen",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=ADD_STANCE_SET,mechanicType=HEALTH_GAIN_OVER_TIME,tag="%hpregen",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
}





















