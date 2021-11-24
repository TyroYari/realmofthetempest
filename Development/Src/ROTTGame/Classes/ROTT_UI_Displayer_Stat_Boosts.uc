/*=============================================================================
 * ROTT_UI_Displayer_Stat_Boosts
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displayer shows all stat boost icons for a hero on the 
 * stat inspection page.
 *===========================================================================*/

class ROTT_UI_Displayer_Stat_Boosts extends ROTT_UI_Displayer;

// Internal references
var private ROTT_UI_Stat_Boost_Container uiBoostVitality;
var private ROTT_UI_Stat_Boost_Container uiBoostStrength;
var private ROTT_UI_Stat_Boost_Container uiBoostCourage;
var private ROTT_UI_Stat_Boost_Container uiBoostFocus;

var private ROTT_UI_Stat_Boost_Container uiBoostHealth;

var private ROTT_UI_Stat_Boost_Container uiBoostDamage;

var private ROTT_UI_Stat_Boost_Container uiBoostSpeed;
var private ROTT_UI_Stat_Boost_Container uiBoostAccuracy;

var private ROTT_UI_Stat_Boost_Container uiBoostMana;
var private ROTT_UI_Stat_Boost_Container uiBoostDodge;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Set internal references
  uiBoostVitality = ROTT_UI_Stat_Boost_Container(findComp("Vitality_Boost_Icons"));
  uiBoostStrength = ROTT_UI_Stat_Boost_Container(findComp("Strength_Boost_Icons"));
  uiBoostCourage = ROTT_UI_Stat_Boost_Container(findComp("Courage_Boost_Icons"));
  uiBoostFocus = ROTT_UI_Stat_Boost_Container(findComp("Focus_Boost_Icons"));
  
  uiBoostHealth = ROTT_UI_Stat_Boost_Container(findComp("Health_Boost_Icons"));
  
  uiBoostDamage = ROTT_UI_Stat_Boost_Container(findComp("Damage_Boost_Icons"));
  
  uiBoostSpeed = ROTT_UI_Stat_Boost_Container(findComp("Speed_Boost_Icons"));
  uiBoostAccuracy = ROTT_UI_Stat_Boost_Container(findComp("Accuracy_Boost_Icons"));
  
  uiBoostMana = ROTT_UI_Stat_Boost_Container(findComp("Mana_Boost_Icons"));
  uiBoostDodge = ROTT_UI_Stat_Boost_Container(findComp("Dodge_Boost_Icons"));
}

/*=============================================================================
 * validAttachment()
 *
 * Called to check if the displayer attachment is valid. Returns true if it is.
 *===========================================================================*/
protected function bool validAttachment() {
  // This displayer requires a hero attachment
  return (hero != none);
}

/*=============================================================================
 * updateDisplay()
 *
 * This updates the UI with the info of the attached combat unit.  
 * Returns true when there actually exists a unit to display, false otherwise.
 *===========================================================================*/
public function bool updateDisplay() {
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Clear info
  uiBoostVitality.resetDisplay();
  uiBoostStrength.resetDisplay();
  uiBoostCourage.resetDisplay();
  uiBoostFocus.resetDisplay();
  
  uiBoostHealth.resetDisplay();
  
  uiBoostDamage.resetDisplay();
  
  uiBoostSpeed.resetDisplay();
  uiBoostAccuracy.resetDisplay();
  
  uiBoostMana.resetDisplay();
  uiBoostDodge.resetDisplay();
  
  // Display all stats enchantment
  if (gameInfo.playerProfile.getEnchantBoost(INFINITY_JEWEL) > 0) {
    uiBoostVitality.enableIcon(STAT_BOOST_BLUE_CROSS);
    uiBoostStrength.enableIcon(STAT_BOOST_BLUE_CROSS);
    uiBoostCourage.enableIcon(STAT_BOOST_BLUE_CROSS);
    uiBoostFocus.enableIcon(STAT_BOOST_BLUE_CROSS);
  }
  
  // Display item boosts to primary stats
  if (hero.heldItemStat(ITEM_ADD_VITALITY) + hero.heldItemStat(ITEM_ADD_ALL_STATS) > 0) {
    uiBoostVitality.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  if (hero.heldItemStat(ITEM_ADD_STRENGTH) + hero.heldItemStat(ITEM_ADD_ALL_STATS) > 0) {
    uiBoostStrength.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  if (hero.heldItemStat(ITEM_ADD_COURAGE) + hero.heldItemStat(ITEM_ADD_ALL_STATS) > 0) {
    uiBoostCourage.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  if (hero.heldItemStat(ITEM_ADD_FOCUS) + hero.heldItemStat(ITEM_ADD_ALL_STATS) > 0) {
    uiBoostFocus.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  
  // Display health enchantment
  if (gameInfo.playerProfile.getEnchantBoost(ARCANE_BLOODPRISM) > 0) {
    uiBoostHealth.enableIcon(STAT_BOOST_BLUE_CROSS);
  }
  if (gameInfo.playerProfile.getEnchantBoost(ROSEWOOD_PENDANT) > 0) {
    uiBoostHealth.enableIcon(STAT_BOOST_BLUE_CHEVRON);
  }
  
  // Display item health boost
  if (hero.heldItemStat(ITEM_ADD_HEALTH) + hero.heldItemStat(ITEM_MULTIPLY_HEALTH) > 0) {
    uiBoostHealth.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  if (hero.heldItemStat(ITEM_ADD_HEALTH_REGEN) > 0) {
    uiBoostHealth.enableIcon(STAT_BOOST_GREEN_CHEVRON);
  }
  
  // Display ritual and mastery boosts health
  if (hero.getRitualAmp(RITUAL_HEALTH_BOOST) + hero.getMasteryLevel(MASTERY_LIFE) > 0) {
    uiBoostHealth.enableIcon(STAT_BOOST_ORANGE_CROSS);
  }
  if (hero.getRitualAmp(RITUAL_HEALTH_REGEN) + hero.getMasteryLevel(MASTERY_REJUV) > 0) {
    uiBoostHealth.enableIcon(STAT_BOOST_ORANGE_CHEVRON);
  }
  
  // Display enchantment physical damage
  if (gameInfo.playerProfile.getEnchantBoost(SCORPION_TALON) > 0) {
    uiBoostDamage.enableIcon(STAT_BOOST_BLUE_CROSS);
  }
  
  // Display item physical damage
  if (hero.heldItemStat(ITEM_ADD_PHYSICAL_MIN) + hero.heldItemStat(ITEM_ADD_PHYSICAL_MAX) > 0) {
    uiBoostDamage.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  
  // Display ritual and mastery physical damage
  if (hero.getMasteryLevel(MASTERY_DAMAGE) + hero.getRitualAmp(RITUAL_PHYSICAL_DAMAGE) > 0) {
    uiBoostDamage.enableIcon(STAT_BOOST_ORANGE_CROSS);
  }
  
  // Display item speed
  if (hero.heldItemStat(ITEM_ADD_SPEED) > 0) {
    uiBoostSpeed.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  
  // Display ritual and mastery speed
  if (hero.getRitualAmp(RITUAL_SPEED_POINTS) + hero.getMasteryLevel(MASTERY_SPEED) > 0) {
    uiBoostSpeed.enableIcon(STAT_BOOST_ORANGE_CROSS);
  }
  
  // Display enchantment accuracy
  if (gameInfo.playerProfile.getEnchantBoost(GRIFFINS_TRINKET) > 0) {
    uiBoostAccuracy.enableIcon(STAT_BOOST_BLUE_CROSS);
  }
  
  // Display item accuracy
  if (hero.heldItemStat(ITEM_ADD_ACCURACY) > 0) {
    uiBoostAccuracy.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  
  // Display ritual and mastery accuracy
  if (hero.getRitualAmp(RITUAL_ACCURACY) + hero.getMasteryLevel(MASTERY_ACCURACY) > 0) {
    uiBoostAccuracy.enableIcon(STAT_BOOST_ORANGE_CROSS);
  }
  
  // Display enchantment mana
  if (gameInfo.playerProfile.getEnchantBoost(MYSTIC_MARBLE) > 0) {
    uiBoostMana.enableIcon(STAT_BOOST_BLUE_CROSS);
  }
  
  // Display enchantment mana regen
  if (gameInfo.playerProfile.getEnchantBoost(ETERNAL_SPELLSTONE) > 0) {
    uiBoostMana.enableIcon(STAT_BOOST_BLUE_CHEVRON);
  }
  
  // Display item mana
  if (hero.heldItemStat(ITEM_MULTIPLY_MANA) + hero.heldItemStat(ITEM_ADD_MANA) > 0) {
    uiBoostMana.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  
  // Display item mana regen
  if (hero.heldItemStat(ITEM_ADD_MANA_REGEN) > 0) {
    uiBoostMana.enableIcon(STAT_BOOST_GREEN_CHEVRON);
  }
  
  // Display ritual and mastery boosts mana
  if (hero.getRitualAmp(RITUAL_MANA_BOOST) + hero.getMasteryLevel(MASTERY_MANA) > 0) {
    uiBoostMana.enableIcon(STAT_BOOST_ORANGE_CROSS);
  }
  if (hero.getRitualAmp(RITUAL_MANA_REGEN) > 0) {
    uiBoostMana.enableIcon(STAT_BOOST_ORANGE_CHEVRON);
  }
  
  // Display enchantment dodge
  if (gameInfo.playerProfile.getEnchantBoost(GRIFFINS_TRINKET) > 0) {
    uiBoostDodge.enableIcon(STAT_BOOST_BLUE_CROSS);
  }
  
  // Display item dodge
  if (hero.heldItemStat(ITEM_ADD_DODGE) > 0) {
    uiBoostDodge.enableIcon(STAT_BOOST_GREEN_CROSS);
  }
  
  // Display ritual and mastery boosts dodge
  if (hero.getRitualAmp(RITUAL_DODGE) + hero.getMasteryLevel(MASTERY_DODGE) > 0) {
    uiBoostDodge.enableIcon(STAT_BOOST_ORANGE_CROSS);
  }
  
  // Successfully drew hero information
  return true;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  /** ===== UI Components ===== **/
  // Vitality Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Vitality_Boost_Icons
    tag="Vitality_Boost_Icons"
    posX=888
    posY=208
  end object
  componentList.add(Vitality_Boost_Icons)
  
  // Health Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Health_Boost_Icons
    tag="Health_Boost_Icons"
    posX=1131
    posY=208
  end object
  componentList.add(Health_Boost_Icons)
  
  // Strength Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Strength_Boost_Icons
    tag="Strength_Boost_Icons"
    posX=901
    posY=268
  end object
  componentList.add(Strength_Boost_Icons)
  
  // Damage Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Damage_Boost_Icons
    tag="Damage_Boost_Icons"
    posX=1148
    posY=268
  end object
  componentList.add(Damage_Boost_Icons)
  
  // Courage Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Courage_Boost_Icons
    tag="Courage_Boost_Icons"
    posX=893
    posY=352
  end object
  componentList.add(Courage_Boost_Icons)
  
  // Speed Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Speed_Boost_Icons
    tag="Speed_Boost_Icons"
    posX=1257
    posY=352
  end object
  componentList.add(Speed_Boost_Icons)
  
  // Accuracy Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Accuracy_Boost_Icons
    tag="Accuracy_Boost_Icons"
    posX=1170
    posY=526
  end object
  componentList.add(Accuracy_Boost_Icons)
  
  // Focus Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Focus_Boost_Icons
    tag="Focus_Boost_Icons"
    posX=850
    posY=582
  end object
  componentList.add(Focus_Boost_Icons)
  
  // Dodge Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Dodge_Boost_Icons
    tag="Dodge_Boost_Icons"
    posX=1123
    posY=639
  end object
  componentList.add(Dodge_Boost_Icons)
  
  // Mana Boost Icons
  begin object class=ROTT_UI_Stat_Boost_Container Name=Mana_Boost_Icons
    tag="Mana_Boost_Icons"
    posX=1114
    posY=582
  end object
  componentList.add(Mana_Boost_Icons)
  
}










/**

// Enchantment icon macros
`DEFINE ENCHANT_ICON(X, Y, N) \
  begin object class=UI_Sprite Name=Enchant_Boost_Icon_`N                                                             \n \
    tag="Enchant_Boost_Icon_`N"                                                                                       \n \
    posX=`X                                                                                                           \n \
    posY=`Y                                                                                                           \n \
    images(0)=Enchantment_Boost_Icon_1                                                                              \n \
  end object                                                                                                          \n \
  componentList.add(Enchant_Boost_Icon_`N)                                                                            \n \
  begin object class=UI_Sprite Name=Enchant_Boost_Upper_Icon_`N                                                       \n \
    tag="Enchant_Boost_Upper_Icon_`N"                                                                                 \n \
    posX=`X                                                                                                           \n \
    posY=`Y                                                                                                           \n \
    images(0)=Enchantment_Boost_Icon_2                                                                              \n \
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255)) \n \
  end object                                                                                                          \n \
  componentList.add(Enchant_Boost_Upper_Icon_`N)                                                                      \n \

`DEFINE ENCHANT_CHEV_ICON(X, Y, N) \
  begin object class=UI_Sprite Name=Enchant_Boost_Icon_`N                                                              \n \
    tag="Enchant_Boost_Icon_`N"                                                                                        \n \
    posX=`X                                                                                                            \n \
    posY=`Y                                                                                                            \n \
    images(0)=Enchantment_Chevron_Icon_1                                                                             \n \
  end object                                                                                                           \n \
  componentList.add(Enchant_Boost_Icon_`N)                                                                             \n \
  begin object class=UI_Sprite Name=Enchant_Boost_Upper_Icon_`N                                                        \n \
    tag="Enchant_Boost_Upper_Icon_`N"                                                                                  \n \
    posX=`X                                                                                                            \n \
    posY=`Y                                                                                                            \n \
    images(0)=Enchantment_Chevron_Icon_2                                                                             \n \
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255))  \n \
  end object                                                                                                           \n \
  componentList.add(Enchant_Boost_Upper_Icon_`N)                                                                       \n \

  
  **/









