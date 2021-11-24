/*=============================================================================
 * ROTT_Descriptor_Enemy_Skill_Attack
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Attack ability for enemy units
 *===========================================================================*/

class ROTT_Descriptor_Enemy_Skill_Attack extends ROTT_Descriptor_Enemy_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function initialize() {
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
  ROTT_Combat_Enemy enemy, 
  int level
)
{
  local float attribute; 
  local int strength;
  
  strength = enemy.getPrimaryStat(PRIMARY_STRENGTH);
  
  switch (type) {
    case MANA_COST:
      attribute = 0;
      break;
      
    case PHYSICAL_DAMAGE_MIN:
      attribute = strength / 2 + enemy.baseMinDamage;
      break;
    case PHYSICAL_DAMAGE_MAX:
      attribute = (1 + (strength * 3) / 4) + enemy.baseMaxDamage;
      break;
  }
  
  return attribute;
}

/*============================================================================= 
 * Combat Action : skillAction()
 *
 * This combat action is the default hero "attack" ability
 *===========================================================================*/
public function bool skillAction
(
  ROTT_Combat_Unit target,
  ROTT_Combat_Enemy caster
) 
{  
  local ROTT_Combat_Mechanics mechanicList;
  local int min, max;
  local bool bHit;
  
  // Check validity of target
  if (target == none) { 
    yellowLog("Warning (!) Empty target on attack");
    return false;
  }
  
  mechanicList = new class'ROTT_Combat_Mechanics';
  
  // Get range for physical damage
  min = attributeInfo(PHYSICAL_DAMAGE_MIN, caster, -1);
  max = attributeInfo(PHYSICAL_DAMAGE_MAX, caster, -1);
  
  // Assemble a list of combat mechanisms
  mechanicList.addMechanic(
    PHYSICAL_DAMAGE, 
    min,
    max
  );
  
  // Induce combat mechanics on target
  if (caster.getChanceToHit(target)) {
    // Hit target
    bHit = true;
    
    // Deliver combat mechanics
    target.parseMechanics(mechanicList, caster);
  } else {
    bHit = false;
  }
  
  // Reset time until next attack
  caster.resetTuna();
  
  return bHit;
}

defaultProperties 
{
  
}





















