/*=============================================================================
 * ROTT_Descriptor_Skill_Valkyrie_Swift_Step
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Valkyrie_Swift_Step extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Swift Step"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "An ability that cuts attack interval",
    "in half for several turns, and increases",
    "dodge permanently."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "Effect lasts %steps combat actions",
    "+%dodge Dodge rating"
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
    case MANA_COST:
      attribute = GetManaEquation(level, 1.3, 0.92, 2.5, 8.5, 31.0);
      break;
      
    case ATTACK_TIME_AMPLIFIER:
      attribute = 0.5;
      break;
    case ADD_STANCE_COUNT:
      attribute = ((level - 1) / 3) + 3;
      break;
    case INCREASE_DODGE_RATING:
      attribute = level * 8;
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  targetingLabel=SELF_TARGET_BUFF
  
  // Status info
  statusTag="Swift"
  statusColor=COMBAT_SMALL_GOLD
  
  // Sound effect
  combatSfx=SFX_COMBAT_BUFF
  
  // Level lookup info
  skillIndex=VALKYRIE_SWIFT_STEP
  parentTree=CLASS_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=ADD_STANCE_SET,mechanicType=ATTACK_TIME_AMPLIFIER,tag="%tuna",font=DEFAULT_SMALL_WHITE,returnType=DECIMAL));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ADD_STANCE_COUNT,tag="%steps",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=INCREASE_DODGE_RATING,tag="%dodge",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Swift_Step
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Swift_Step')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Swift_Step
  end object
  skillIcon=Skill_Icon_Container
  
}





















