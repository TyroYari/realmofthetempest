/*=============================================================================
 * ROTT_Descriptor_Skill_Attack
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Attack ability for hero units
 *===========================================================================*/

class ROTT_Descriptor_Skill_Attack extends ROTT_Descriptor_Hero_Skill;

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
  ROTT_Combat_Hero hero, 
  int level
)
{
  local float attribute; 
  
  // Define mechanics
  switch (type) {
    case MANA_COST:
      attribute = 0;
      break;
      
    case PHYSICAL_DAMAGE_MIN:
      attribute = hero.subStats[MIN_PHYSICAL_DAMAGE];
      break;
    case PHYSICAL_DAMAGE_MAX:
      attribute = hero.subStats[MAX_PHYSICAL_DAMAGE];
      break;
  }
  
  return attribute;
}

/*============================================================================= 
 * getSkillLevel()
 *
 * This fetches the skill level from the hero provided
 *===========================================================================*/
public function int getSkillLevel
(
  ROTT_Combat_Hero hero, 
  optional bool bIgnoreBoost = false
) 
{
  return 1;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  parentTree=NO_TREE
  
  // Targeting
  targetingLabel=SINGLE_TARGET_ATTACK
  
  // Sound effect
  combatSfx=SFX_COMBAT_ATTACK
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_A1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_A1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_A2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_A2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_A3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_A3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_A4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_A4')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Attack_A1
    images(1)=SkillAnim_Attack_A2
    images(2)=SkillAnim_Attack_A3
    images(3)=SkillAnim_Attack_A4
  end object
  skillAnim=Skill_Animation_Container
  
  
}





















