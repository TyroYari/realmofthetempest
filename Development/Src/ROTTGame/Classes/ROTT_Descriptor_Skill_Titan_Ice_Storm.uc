/*=============================================================================
 * ROTT_Descriptor_Skill_Titan_Ice_Storm
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Titan_Ice_Storm extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Ice Storm"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "This ability increases storm rating.",
    "Elemental damage based on storm rating",
    "is dealt when storm glyphs are collected."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "Chance to spawn: %chance%",
    "%min to %max damage per storm rating"
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
    // Combat action cost
    case MANA_COST:
      attribute = getManaEquation(level, 1.145, 0.79, 2.42, 39.0, 7.0);
      break;
      
    // Combat action always "hits"
    case HIT_CHANCE_OVERRIDE:
      attribute = 100;
      break;
    
    // Glyph attributes
    case GLYPH_SPAWN_CHANCE:
      attribute = 75;
      break;
    case REQUIRES_CAST_COUNT:
      attribute = 1;
      break;
      
    // On glyph collection, skill properties:
    case ELEMENTAL_DAMAGE_MIN:
      attribute = (3 * level) - 1;
      attribute += 10 * int(level / 2.f); 
      break;
    case ELEMENTAL_DAMAGE_MAX:
      attribute = (9 * level) + 1;
      attribute += 15 * int(level / 2.f + level * int(level / 5.f)); 
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
  
  // Level lookup info
  skillIndex=TITAN_ICE_STORM
  parentTree=CLASS_TREE

  // Sound effect
  secondarySfx=SFX_COMBAT_ATTACK
  combatSfx=SFX_COMBAT_BUFF
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ALT_ACTION_ANIMATION,tag="%skip",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=HIT_CHANCE_OVERRIDE,tag="%over",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Glyph attributes
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%chance",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // Glyph collection attributes
  skillAttributes.add((attributeSet=GLYPH_ACTION_SET,mechanicType=CAST_COUNT_AMP,tag="%amp",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // UI Notification
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=STORM_INTENSITY_NOTIFICATION,tag="%none",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Ice_Storm
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Ice_Storm')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Ice_Storm
  end object
  skillIcon=Skill_Icon_Container
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F1
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F1')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F2
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F2')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F3
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F3')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F4
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F4')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F5
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F5')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=Skill_Animation_Lightning_Vertical_F1
    images(1)=Skill_Animation_Lightning_Vertical_F2
    images(2)=Skill_Animation_Lightning_Vertical_F3
    images(3)=Skill_Animation_Lightning_Vertical_F4
    images(4)=Skill_Animation_Lightning_Vertical_F5
  end object
  skillAnim=Skill_Animation_Container
  
  // Alt Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F5')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Alt_Skill_Animation_Container
    tag="Alt_Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Ice_Storm_Intensity_F1
    images(1)=SkillAnim_Ice_Storm_Intensity_F2
    images(2)=SkillAnim_Ice_Storm_Intensity_F3
    images(3)=SkillAnim_Ice_Storm_Intensity_F4
    images(4)=SkillAnim_Ice_Storm_Intensity_F5
  end object
  altSkillAnim=Alt_Skill_Animation_Container
  
}





















