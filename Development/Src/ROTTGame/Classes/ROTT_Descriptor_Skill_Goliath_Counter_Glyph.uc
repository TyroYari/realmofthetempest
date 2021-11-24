/*=============================================================================
 * ROTT_Descriptor_Skill_Goliath_Counter_Glyph
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/
 
class ROTT_Descriptor_Skill_Goliath_Counter_Glyph extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Counter Glyph"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "A glyph that enables counter attacks",
    "with physical damage to the attacker",
    "regardless of accuracy and enemy dodge."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Chance to spawn: %spawn%",
    "%min to %max damage, per Glyph",
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
  local float dmgAmp;
  local int i;
  
  switch (type) {
    case GLYPH_SPAWN_CHANCE:
      attribute = 40 + ((level + 1) % 2) * 20;  // {40, 60}
      break;
      
    case PHYSICAL_DAMAGE_MIN:
      dmgAmp = 10;
      for (i = 0; i < (level + 1) / 2; i++) {
        dmgAmp = round(dmgAmp * 4.0 / 3.0);
      }
      
      attribute = int(hero.subStats[MIN_PHYSICAL_DAMAGE] * (dmgAmp / 100.f));
      break;
    case PHYSICAL_DAMAGE_MAX:
      dmgAmp = 10;
      for (i = 0; i < (level + 1) / 2; i++) {
        dmgAmp = round(dmgAmp * 4.0 / 3.0);
      }
      
      attribute = int(hero.subStats[MAX_PHYSICAL_DAMAGE] * (dmgAmp / 100.f));
      break;
  }
  
  return attribute;
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
  targetingLabel=COLLECTIBLE_GLYPH
  
  // Level lookup info
  skillIndex=GOLIATH_COUNTER_GLYPHS
  parentTree=CLASS_TREE

  // Sound effect
  secondarySfx=SFX_COMBAT_ATTACK
  
  // Glyph Attributes
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%spawn",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  // Counter attributes
  skillAttributes.add((attributeSet=TAKE_DAMAGE_SET,mechanicType=PHYSICAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=TAKE_DAMAGE_SET,mechanicType=PHYSICAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=TAKE_DAMAGE_SET,mechanicType=GLYPH_COUNT_AMP,tag="%amp",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=TAKE_DAMAGE_SET,mechanicType=REQUIRES_GLYPH,tag="%req",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F5')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F6
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F6')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Avalanche_F1
    images(1)=SkillAnim_Avalanche_F2
    images(2)=SkillAnim_Avalanche_F3
    images(3)=SkillAnim_Avalanche_F4
    images(4)=SkillAnim_Avalanche_F5
    images(5)=SkillAnim_Avalanche_F6
  end object
  skillAnim=Skill_Animation_Container
  
}



