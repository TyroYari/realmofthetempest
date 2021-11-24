/*=============================================================================
 * ROTT_Descriptor_Skill_Goliath_Intimidation
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Goliath_Intimidation extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Intimidation"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "An ability that reduces the strength",
    "of all enemies.",
    ""
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "-%str Strength",
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
    case MANA_COST:
      attribute = getManaEquation(level, 1.15, 0.82, 2.36, 14.0, 30.0);
      break;
      
    case DECREASE_STRENGTH_RATING:
      attribute = ((level - 1) / 2) * (level - 2) + level + 1;
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  targetingLabel=MULTI_TARGET_DEBUFF
  
  // Level lookup info
  skillIndex=GOLIATH_INTIMIDATION
  parentTree=CLASS_TREE

  // Sound effect
  combatSfx=SFX_COMBAT_DEBUFF
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=DECREASE_STRENGTH_RATING,tag="%str",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Intimidation
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Intimidation'
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Intimidation
  end object
  skillIcon=Skill_Icon_Container
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F5')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F6
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F6')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F7
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F7')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Debuff_Red_F1
    images(1)=SkillAnim_Debuff_Red_F2
    images(2)=SkillAnim_Debuff_Red_F3
    images(3)=SkillAnim_Debuff_Red_F4
    images(4)=SkillAnim_Debuff_Red_F5
    images(5)=SkillAnim_Debuff_Red_F6
    images(6)=SkillAnim_Debuff_Red_F7
  end object
  skillAnim=Skill_Animation_Container
  
}





















