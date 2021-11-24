/*=============================================================================
 * ROTT_Descriptor_List
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is the data structure responsible for providing stat/skill information 
 * to the game for a combat unit's behavior, as well as the UI for hero info.
 *
 * The mgmt window uses this to render the info. 
 *===========================================================================*/
  
class ROTT_Descriptor_List extends ROTT_Object
abstract;

// A list of all skills in this set
// This should be filled out for child classes
/**
enum SkillSetEnum {
  SKILL_1,
  SKILL_2,
  SKILL_3
};
**/

// Stores the information for glyph skills
var protected array<ROTT_Descriptor> scriptList;
var protected array<class<ROTT_Descriptor> > scriptClasses;

/*=============================================================================
 * initialize()
 *
 * this function should be called when the descriptor list is instantiated
 *===========================================================================*/
public function initialize() {
  local ROTT_Descriptor script;
  local int i;
  
  linkReferences();
  
  // Add skills based on scriptClasses, specified in defaultProperties
  for (i = 0; i < scriptClasses.length; i++) {
    if (scriptClasses[i] != none) {
      script = new(self) scriptClasses[i];
      script.initialize();
      
      // Initialize UI for skill descriptors
      if (ROTT_Descriptor_Hero_Skill(script) != none) {
        ROTT_Descriptor_Hero_Skill(script).initUI();
      }
      
      scriptList.addItem(script);
    }
  }
}

/*=============================================================================
 * getScriptCount()
 *
 * Returns script count
 *===========================================================================*/
public function int getScriptCount() {
  return scriptList.length;
}

/*=============================================================================
 * getScript()
 *
 * this function accesses a descriptor (which formats itself for the UI.)
 *===========================================================================*/
public function ROTT_Descriptor getScript(int index, ROTT_Combat_Hero hero) {
  // Prepare replacement codes and font colors based on hero info
  scriptList[index].formatScript(hero);
  
  return scriptList[index];
}

/*=============================================================================
 * skillReset()
 *
 * Clears all battle variable info for this unit's skill sets.
 * Should be called before each battle.
 *===========================================================================*/
public function skillReset() {
  local int i;
  
  for (i = 0; i < scriptList.length; i++) {
    ROTT_Descriptor_Hero_Skill(scriptList[i]).skillReset();
  }
}

/*=============================================================================
 * decrementSteps()
 *
 * Called after performing each combat action, to track stance effects
 *===========================================================================*/
public function decrementSteps(ROTT_Combat_Hero hero) {
  local ROTT_Descriptor_Hero_Skill heroScript;
  local int i;
  
  for (i = 0; i < scriptList.length; i++) {
    heroScript = ROTT_Descriptor_Hero_Skill(scriptList[i]);
    if (heroScript.stanceCount > 0) heroScript.modifyStanceSteps(hero, -1);
  }
}

/*=============================================================================
 * onDefend()
 *
 * Called when the defend ability has been executed
 *===========================================================================*/
public function onDefend(ROTT_Combat_Unit target, ROTT_Combat_Hero caster) {
  local ROTT_Descriptor_Hero_Skill heroScript;
  local array<ROTT_Combat_Unit> targets;
  local array<ROTT_Combat_Unit> allHeroes;
  local int i;
  
  // Set target as the defended unit
  targets.addItem(target);
  
  // Set target as the defended unit
  for (i = 0; i < gameInfo.getActiveParty().getPartySize(); i++) { /* lets move this function somewhere */
    allHeroes.addItem(gameInfo.getActiveParty().getHero(i));
  }
  
  for (i = 0; i < scriptList.length; i++) {
    heroScript = ROTT_Descriptor_Hero_Skill(scriptList[i]);
    if (heroScript.getSkillLevel(caster) != 0) {
      heroScript.skillAction(
        allHeroes,
        caster,
        ON_DEFEND_PARTY_SET
      );
      heroScript.skillAction(
        targets,
        caster,
        ON_DEFEND_SET
      );
    }
  }
}

/*=============================================================================
 * onAttack()
 *
 * Called when the attack ability has been executed (Only if it hit)
 *===========================================================================*/
public function onAttack(ROTT_Combat_Unit target, ROTT_Combat_Hero caster) {
  local ROTT_Descriptor_Hero_Skill heroScript;
  local array<ROTT_Combat_Unit> targets;
  local int i;
  
  targets.addItem(target);
  
  for (i = 0; i < scriptList.length; i++) {
    heroScript = ROTT_Descriptor_Hero_Skill(scriptList[i]);
    if (heroScript.getSkillLevel(caster) != 0) {
      heroScript.skillAction(
        targets,
        caster,
        ON_ATTACK_SET
      );
    }
  }
}

/*=============================================================================
 * onTakeDamage()
 *
 * Called when the combat unit takes damage
 *===========================================================================*/
public function onTakeDamage(ROTT_Combat_Unit target, ROTT_Combat_Hero caster) {
  local ROTT_Descriptor_Hero_Skill heroScript;
  local array<ROTT_Combat_Unit> targets;
  local int i;
  
  targets.addItem(target);
  
  for (i = 0; i < scriptList.length; i++) {
    heroScript = ROTT_Descriptor_Hero_Skill(scriptList[i]);
    if (heroScript.getSkillLevel(caster) != 0) {
      // Call damage event
      heroScript.onTakeDamage();
      
      // Activate 'take damage' attribute set
      if (
        heroScript.skillAction(
          targets,
          caster,
          TAKE_DAMAGE_SET
        )
      ) gameInfo.sfxBox.playSfx(heroScript.secondarySfx);
    }
  }
}

/*=============================================================================
 * onTargeted()
 *
 * Called when the combat unit has been targeted by an action, even if miss
 *===========================================================================*/
public function onTargeted(ROTT_Combat_Unit target, ROTT_Combat_Hero caster) {
  local ROTT_Descriptor_Hero_Skill heroScript;
  local array<ROTT_Combat_Unit> targets;
  local int i;
  
  targets.addItem(target);
  
  for (i = 0; i < scriptList.length; i++) {
    heroScript = ROTT_Descriptor_Hero_Skill(scriptList[i]);
    if (heroScript.getSkillLevel(caster) != 0) {
      // Call damage event
      ///heroScript.onDodge();
      
      // Activate 'take damage' attribute set
      if (
        heroScript.skillAction(
          targets,
          caster,
          TARGETED_SET
        )
      ) gameInfo.sfxBox.playSfx(heroScript.secondarySfx);
    }
  }
}

/*=============================================================================
 * onBattlePrep()
 *
 * Called when a battle starts
 *===========================================================================*/
public function onBattlePrep(ROTT_Combat_Hero hero) {
  local ROTT_Descriptor_Hero_Skill heroScript;
  local int i;
  
  for (i = 0; i < scriptList.length; i++) {
    heroScript = ROTT_Descriptor_Hero_Skill(scriptList[i]);
    if (heroScript.getSkillLevel(hero) != 0) {
      heroScript.onBattlePrep(hero);
    }
  }
}

/*=============================================================================
 * onDeadTick()
 *
 * Called each tick only when dead
 *===========================================================================*/
public function onDeadTick(ROTT_Combat_Hero hero, float deltaTime) {
  local ROTT_Descriptor_Hero_Skill heroScript;
  local int i;
  
  for (i = 0; i < scriptList.length; i++) {
    heroScript = ROTT_Descriptor_Hero_Skill(scriptList[i]);
    
    if (heroScript.getSkillLevel(hero) != 0) {
      heroScript.onDeadTick(hero, deltaTime);
    }
  }
}

/*=============================================================================
 * onTick()
 *
 * Called each tick
 *===========================================================================*/
public function onTick(ROTT_Combat_Hero hero, float deltaTime) {
  local ROTT_Descriptor_Hero_Skill heroScript;
  local int i;
  
  for (i = 0; i < scriptList.length; i++) {
    heroScript = ROTT_Descriptor_Hero_Skill(scriptList[i]);
    
    if (heroScript.getSkillLevel(hero) != 0) {
      heroScript.onTick(hero, deltaTime);
    }
  }
}

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  // List of skills in this set
  // This section should be filled out in the child classes
  /**
  scriptClasses(SKILL_1)=class'ROTT_Descriptor_Skill_1'
  scriptClasses(SKILL_2)=class'ROTT_Descriptor_Skill_2'
  scriptClasses(SKILL_3)=class'ROTT_Descriptor_Skill_3'
  **/
  
  /** ================================================================
  Do not attach static objects here, they need to know gameInfo, which
  makes garbage collection a nightmare if they arent dynamic objects
  **===============================================================**/
}







