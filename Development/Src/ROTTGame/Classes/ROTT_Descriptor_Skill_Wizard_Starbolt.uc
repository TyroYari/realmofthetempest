/*=============================================================================
 * ROTT_Descriptor_Skill_Wizard_Starbolt
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the wizards skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Wizard_Starbolt extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Starbolt"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "Deals Elemental Damage, amplified by skill",
    "level, increasing with each cast.",
    ""
  );
  
  // Set skill information for p2 and p3
  skillInfo(
    "Mana Cost: %mana",
    "%min1 to %max1 damage",
    "%min2 to %max2 extra damage per cast"
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
      attribute = int(Round(1.165 ** (level ** 0.825)) + (level ** 2.65) + (10.0 * level) + 24.0);
      break;
      
    case ELEMENTAL_DAMAGE_MIN:
      attribute = 4 + (level * 4);
      //attribute = 6 + (2 * level);
      break;
    case ELEMENTAL_DAMAGE_MAX:
      attribute = 12 + (level * 10);
      //attribute = round(14 + (level * 8) * (1.065 ** (level - 2)));
      break;
      
    case STARBOLT_AMPLIFIER_MIN:
      attribute = 2 * level;
      break;
    case STARBOLT_AMPLIFIER_MAX:
      attribute = 2 + (3 * level);
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  targetingLabel=SINGLE_TARGET_ATTACK
  
  // Level lookup info
  skillIndex=WIZARD_STARBOLT
  parentTree=CLASS_TREE

  // Sound effect
  combatSfx=SFX_COMBAT_ATTACK
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MIN,tag="%min1",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MAX,tag="%max1",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=STARBOLT_AMPLIFIER_MIN,tag="%min2",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=STARBOLT_AMPLIFIER_MAX,tag="%max2",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Starbolt
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Starbolt')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Starbolt
  end object
  skillIcon=Skill_Icon_Container
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F5')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Starbolt_F1
    images(1)=SkillAnim_Starbolt_F2
    images(2)=SkillAnim_Starbolt_F3
    images(3)=SkillAnim_Starbolt_F4
    images(4)=SkillAnim_Starbolt_F5
  end object
  skillAnim=Skill_Animation_Container
  
  
}





















