/*=============================================================================
 * ROTT_Descriptor_Skill_Titan_Fusion
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Titan_Fusion extends ROTT_Descriptor_Hero_Skill;

// How much combat time has passed since the last fusion
var private float elapsedFuseTime;

// How much time between fusion distributions
const TOTAL_FUSE_INTERVAL = 1.2f;

// How many points are pending fusion transfer
var private float pendingTransfer;
  
// Fancy interpolation variables
var private float elapsedEffectTime;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Fusion"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "Averages health and mana between",
    "the members of your team, and",
    "increases max health and mana."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "+%fuse transfer rate",
    "+%boost max health and mana"
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
      attribute = getManaEquation(level, 1.148, 0.795, 2.45, 55.0, 13.0);
      break;
      
    case INCREASE_MAX_HEALTH_MAX_MANA:
      attribute = (level / 2 * (level - 1)) + (level * 2) + 3;
      break;
    case FUSION_RATE:
      attribute = 20 * level; // This constant is just here for highlighting text green
      break;
  }
  
  return attribute;
}

/**
 t = fusion transfer total
 distribution = <hp/(hp+mp) * t, mp/(hp+mp) * t>
**/

/*=============================================================================
 * onTick()
 *
 * Called each tick
 *===========================================================================*/
public function onTick(ROTT_Combat_Hero hero, float deltaTime) {
  local float interpolationRatio;
  local int level;
  
  super.onTick(hero, deltaTime); /* may not be necessary */
  
  if (castCount == 0) return;
  
  // Track elapsed time
  elapsedFuseTime += deltaTime;
  
  // Execute fusion transfer
  if (elapsedFuseTime > getFuseInterval()) {
    // Remove interval time
    elapsedFuseTime -= getFuseInterval();
    
    // Get skill level
    level = getSkillLevel(hero);
    
    // Get transfer total
    pendingTransfer += getAttributeInfo(FUSION_RATE, hero, level) * castCount;
    
    // Reset transfer rate for special effects
    elapsedEffectTime = 0.0f;
    
  }
  
  // Smooth transfer effect
  if (pendingTransfer > 0) {
    // Track elapsed time for this effect
    elapsedEffectTime += deltaTime;
    
    interpolationRatio = (0.5 + elapsedEffectTime / 2);
    if (interpolationRatio > 1) interpolationRatio = 1;
    
    // Cap time scalar for lag spikes
    if (deltaTime > 1) deltaTime = 1;
    
    // Distribute to party
    gameInfo.getActiveParty().fuseTeamHpMp(interpolationRatio * pendingTransfer * deltaTime*10);
    pendingTransfer -= interpolationRatio * pendingTransfer * deltaTime*10;
  }
}

/*============================================================================= 
 * getFuseInterval()
 *
 * 
 *===========================================================================*/
public function float getFuseInterval() {
  local float intervalTime;
  
  intervalTime = TOTAL_FUSE_INTERVAL - (castCount * TOTAL_FUSE_INTERVAL / 12.f);
  if (intervalTime < 0.0125) intervalTime = 0.0125;
  
  return intervalTime;
}

/*============================================================================= 
 * skillReset()
 *
 * Called to reset skill data at the start of a new battle
 *===========================================================================*/
public function skillReset() {
  super.skillReset();
  
  pendingTransfer = 0;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  targetingLabel=MULTI_TARGET_BUFF
  
  // Level lookup info
  skillIndex=TITAN_FUSION
  parentTree=CLASS_TREE

  // Sfx
  combatSfx=SFX_COMBAT_BUFF
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=FUSION_RATE,tag="%fuse",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=INCREASE_MAX_HEALTH_MAX_MANA,tag="%boost",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Fusion
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Fusion')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Fusion
  end object
  skillIcon=Skill_Icon_Container
  
}





















