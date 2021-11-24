/*=============================================================================
 * ROTT_Descriptor_Skill_Valkyrie_Volt_Retaliation
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Valkyrie_Volt_Retaliation extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Volt Retaliation"
  );
  
  // Set header
  h2(
    "(Single Target Attack)" // Fake targeting mode though
  );
  
  // Set paragraph information
  p1(
    "This ability first changes the caster's",
    "stance.  Being attacked in this stance",
    "triggers glyph based counter attacks."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "Chance to spawn glyph: %chance%",
    "%strikes counter attack%plural per glyph"
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
    // Casting requirements
    case MANA_COST:
      attribute = getManaEquation(level, 1.15, 0.8, 2.0, 8.0, 34.0);
      break;
    case REQUIRES_GLYPH:
      attribute = 1;
      break;
      
    // Combat action attributes
    case ADD_STANCE_COUNT_PER_GLYPH:
      attribute = (level - 1) / 3 + 1;
      break;
    
    // Glyph attributes
    case GLYPH_SPAWN_CHANCE:
      attribute = (((level - 1) % 3) + 1) * 25;
      break;
      
    // Stance attributes
    case OVERRIDE_ATTACK_TIME: 
      attribute = 0.5;
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * onTick()
 *
 * Called each tick
 *===========================================================================*/
public function onTick(ROTT_Combat_Hero hero, float deltaTime) {
  super.onTick(hero, deltaTime);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  targetingLabel=SELF_TARGET_BUFF // hacky hidden target mode
  
  // Level lookup info
  skillIndex=VALKYRIE_VOLT_RETALIATION
  parentTree=CLASS_TREE

  // Sfx
  combatSfx=SFX_COMBAT_BUFF
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ADD_STANCE_COUNT_PER_GLYPH,tag="%strikes",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PAUSE_TUNA,tag="%pause",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=REQUIRES_GLYPH,tag="%req",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Glyph attributes
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%chance",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  // Stance attributes
  skillAttributes.add((attributeSet=ADD_STANCE_SET,mechanicType=OVERRIDE_ATTACK_TIME,tag="%tuna",font=DEFAULT_SMALL_WHITE,returnType=DECIMAL));
  skillAttributes.add((attributeSet=ADD_STANCE_SET,mechanicType=AUTO_ATTACK_MODE,tag="%auto",font=DEFAULT_SMALL_WHITE,returnType=DECIMAL));
  
  // Take damage attributes
  skillAttributes.add((attributeSet=TARGETED_SET,mechanicType=UNPAUSE_TUNA,tag="%unpause",font=DEFAULT_SMALL_WHITE,returnType=DECIMAL));
  skillAttributes.add((attributeSet=TARGETED_SET,mechanicType=TARGET_CASTER,tag="%target",font=DEFAULT_SMALL_WHITE,returnType=DECIMAL));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Retaliation
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Retaliation')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Retaliation
  end object
  skillIcon=Skill_Icon_Container
  
}









