/*=============================================================================
 * ROTT_Descriptor_Skill_Wizard_Plasma_Shroud
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the wizards skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Wizard_Plasma_Shroud extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Plasma Shroud"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "An ability that increases elemental",
    "damage, and uses mana to absorb",
    "50% of incoming damage."
  );
  
  // Set skill information for p2 and p3
  skillInfo(
    "Mana Cost: %mana",
    "Shield lasts %steps combat actions",
    "+%amp% Elemental damage"
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
    // Combat action attributes
    case MANA_COST:
      attribute = getManaEquation(level, 1.148, 0.795, 2.45, 53.0, 5.0);
      break;
    case ADD_STANCE_COUNT:
      attribute = (level - 1) / 3 + 3;
      break;
    case ELEMENTAL_AMPLIFIER:
      attribute = level * 15 + 5;
      break;
    
    // Stance properties
    case MANA_SHIELD_PERCENT:
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
  targetingLabel=SELF_TARGET_BUFF
  
  // Status info
  statusTag="Shroud"
  statusColor=COMBAT_SMALL_PURPLE
  
  // Sound effect
  combatSfx=SFX_COMBAT_BUFF
  
  // Level lookup info
  skillIndex=WIZARD_PLASMA_SHROUD
  parentTree=CLASS_TREE

  // Combat action properties
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ADD_STANCE_COUNT,tag="%steps",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_AMPLIFIER,tag="%amp",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // Stance properties
  skillAttributes.add((attributeSet=ADD_STANCE_SET,mechanicType=MANA_SHIELD_PERCENT,tag="%shield",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Plasma_Barrier
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Plasma_Barrier')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Plasma_Barrier
  end object
  skillIcon=Skill_Icon_Container
  
  
}





















