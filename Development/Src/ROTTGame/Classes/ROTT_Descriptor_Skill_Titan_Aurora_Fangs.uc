/*=============================================================================
 * ROTT_Descriptor_Skill_Titan_Aurora_Fangs
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Titan_Aurora_Fangs extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Aurora Fangs"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "This physical attack deals damage three",
    "times, targetting a random enemy on",
    "each strike."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "%min to %max damage",
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
      attribute = getManaEquation(level, 1.135, 0.775, 2.375, 42.0, 0.0);
      break;
    case QUEUED_MULTISTRIKE_COUNT:
      attribute = 3;
      break;
    case QUEUED_MULTISTRIKE_DELAY:
      attribute = 0.25;
      break;
      
    case PHYSICAL_DAMAGE_MIN:
      attribute = level + hero.subStats[MIN_PHYSICAL_DAMAGE] / 2.0 * (1 + (0.275 * level));
      //attribute = level + hero.subStats[MIN_PHYSICAL_DAMAGE] / 2.5 * (1 + (0.125 * level));
      //attribute = level + hero.subStats[MIN_PHYSICAL_DAMAGE] / 3.0 * (1 + (0.125 * level));
      break;
    case PHYSICAL_DAMAGE_MAX:
      attribute = 3 * level + hero.subStats[MAX_PHYSICAL_DAMAGE] * (0.50 * level + 0.5);
      //attribute = 3 * level + (hero.subStats[MAX_PHYSICAL_DAMAGE] / 2.5 * (1 + (0.275 * level)));
      //attribute = 3 * level + (hero.subStats[MAX_PHYSICAL_DAMAGE] / 2.5 * (1 + (0.125 * level)));
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  targetingLabel=MULTI_TARGET_ATTACK
  
  // Sound effect
  combatSfx=NO_SFX
  secondarySfx=SFX_COMBAT_ATTACK
  
  // Level lookup info
  skillIndex=TITAN_AURORA_FANGS
  parentTree=CLASS_TREE

  // Combat Action Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=QUEUED_MULTISTRIKE_COUNT,tag="%hits",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=QUEUED_MULTISTRIKE_DELAY,tag="%delay",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Queued Action Attributes
  skillAttributes.add((attributeSet=QUEUED_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=QUEUED_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=QUEUED_ACTION_SET,mechanicType=RANDOM_TARGET,tag="%rand",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Aurora_Fangs
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Aurora_Fangs')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Aurora_Fangs
  end object
  skillIcon=Skill_Icon_Container
  
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F5')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_SpiritNova_F1
    images(1)=SkillAnim_SpiritNova_F2
    images(2)=SkillAnim_SpiritNova_F3
    images(3)=SkillAnim_SpiritNova_F4
    images(4)=SkillAnim_SpiritNova_F5
  end object
  skillAnim=Skill_Animation_Container
  
}





















