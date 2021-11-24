/*=============================================================================
 * ROTT_Descriptor_Skill_Wizard_Black_Hole
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the wizards skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Wizard_Black_Hole extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Black Hole"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "Consumes mana at an accelerating pace",
    "until no mana remains, dealing",
    "atmospheric damage per mana point"
  );
  
  // Set skill information for p2 and p3
  skillInfo(
    "%mana Mana / sec, per second",
    "%dmg damage per Mana Point",
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
    // Combat action attributes
    case ADD_STANCE_COUNT:
      attribute = 1;
      break;
      
    // Stance attributes
    case ACCELERATED_MANA_DRAIN:
      attribute = 1 + (2 * level / 3);
      break;
    case MANA_DRAIN_ATMOSPHERIC_DAMAGE:
      attribute = level * 0.03;
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
  local float manaAccel;
  local float manaBurn;
  local bool bShowDamage;
  local int level;
  
  super.onTick(hero, deltaTime); /* may not be necessary */
  
  // Ignore if black hole has not been cast
  if (stanceCount == 0) {
    gameInfo.enemyEncounter.bBlackHoleActive = false;
    return;
  } else {
    gameInfo.enemyEncounter.bBlackHoleActive = true;
  }
  
  level = getSkillLevel(hero);
  
  // Set the delta for mana acceleration
  manaAccel = getAttributeInfo(ACCELERATED_MANA_DRAIN, hero, level);
  manaAccel *= deltaTime;
  
  // Accelerate mana cost in hero stats
  hero.improveStat(manaAccel, MANA_BURN_ALL_ENEMIES, true);
  
  // Set burn rate
  manaBurn = hero.statBoosts[MANA_BURN_ALL_ENEMIES];
  
  // Check if sufficient mana
  bShowDamage = (hero.subStats[CURRENT_MANA] < manaBurn);
  if (hero.subStats[CURRENT_MANA] < manaBurn) {
    // Cap burn value
    manaBurn = hero.subStats[CURRENT_MANA];
    
    // Reset burn rate
    hero.resetStatBoost(MANA_BURN_ALL_ENEMIES);
    
    // Unpause and disable stance
    hero.unpauseTuna();
    resetStance();
  }
  
  // Drain mana
  hero.drainMana(manaBurn);
  
  // Burn all enemies
  gameInfo.enemyEncounter.drainMobLife(
    manaBurn * getAttributeInfo(MANA_DRAIN_ATMOSPHERIC_DAMAGE, hero, level),
    true
  );
  
  // Show damage
  if (bShowDamage) gameInfo.enemyEncounter.showBhDamage(hero);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  targetingLabel=MULTI_TARGET_ATTACK
  
  // Level lookup info
  skillIndex=WIZARD_BLACK_HOLE
  parentTree=CLASS_TREE

  // Sfx
  combatSfx=SFX_COMBAT_BUFF
  
  // Combat action attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ADD_STANCE_COUNT,tag="%stance",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PAUSE_TUNA,tag="%pause",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=TRACK_ACTION,tag="%none",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ATMOSPHERIC_TAG,tag="%none",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Stance attributes
  skillAttributes.add((attributeSet=ON_TICK_SET,mechanicType=ACCELERATED_MANA_DRAIN,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MANA_DRAIN_ATMOSPHERIC_DAMAGE,tag="%dmg",font=DEFAULT_SMALL_ORANGE,returnType=DECIMAL));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Black_Hole
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Black_Hole')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Black_Hole
  end object
  skillIcon=Skill_Icon_Container
  
}





















