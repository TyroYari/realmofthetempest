/*=============================================================================
 * ROTT_UI_Statistic_Values
 *
 * Author: Otay
 * Bramble Gate Studios (All Downs reserved)
 *
 * Description: A collection of labels for displaying hero statistics.
 *===========================================================================*/
 
class ROTT_UI_Statistic_Values extends UI_Container;

// Internal references
var private UI_Label vitLabel;
var private UI_Label strLabel;
var private UI_Label crgLabel;
var private UI_Label focLabel;

var private UI_Label healthLabel;
var private UI_Label physDmgLabel;
var private UI_Label intervalLabel;
var private UI_Label critChanceLabel;
var private UI_Label critMultLabel;
var private UI_Label accuracyLabel;
var private UI_Label manaLabel;
var private UI_Label dodgeLabel;
var private UI_Label thresholdLabel;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Set internal references
  vitLabel = UI_Label(findComp("Primary_Stat_Vitality_Label"));
  strLabel = UI_Label(findComp("Primary_Stat_Strength_Label"));
  crgLabel = UI_Label(findComp("Primary_Stat_Courage_Label"));
  focLabel = UI_Label(findComp("Primary_Stat_Focus_Label"));
  
  healthLabel = UI_Label(findComp("Sub_Stat_Label_1"));
  physDmgLabel = UI_Label(findComp("Sub_Stat_Label_2"));
  intervalLabel = UI_Label(findComp("Sub_Stat_Label_3"));
  critChanceLabel = UI_Label(findComp("Sub_Stat_Label_4"));
  critMultLabel = UI_Label(findComp("Sub_Stat_Label_5"));
  accuracyLabel = UI_Label(findComp("Sub_Stat_Label_6"));
  manaLabel = UI_Label(findComp("Sub_Stat_Label_7"));
  dodgeLabel = UI_Label(findComp("Sub_Stat_Label_8"));
  thresholdLabel = UI_Label(findComp("Sub_Stat_Label_9"));
  
}

/*============================================================================= 
 * renderHeroData()
 *
 * Given a hero, this displays all of its primary and sub stats to the screen
 *===========================================================================*/
public function renderHeroData(ROTT_Combat_Hero hero) {
  local string hp, hpMax;
  local string dmgMin, dmgMax;
  local string atkInterval, critChance, critRolls, accuracy;
  local string mp, mpmax, dodge, threshold;
  
  hero.updateSubStats();
  
  // Get hero info
  hp = class'UI_Label'.static.abbreviate(string(int(hero.subStats[CURRENT_HEALTH])));
  hpMax = class'UI_Label'.static.abbreviate(string(int(hero.subStats[MAX_HEALTH])));
  
  dmgMin = class'UI_Label'.static.abbreviate(string(int(hero.subStats[MIN_PHYSICAL_DAMAGE])));
  dmgMax = class'UI_Label'.static.abbreviate(string(int(hero.subStats[MAX_PHYSICAL_DAMAGE])));
  
  atkInterval = string(hero.subStats[TOTAL_ATK_INTERVAL]);
  critChance = string(hero.subStats[CRIT_CHANCE]);
  critRolls = string(hero.getCritRolls());
  accuracy = class'UI_Label'.static.abbreviate(string(int(hero.subStats[ACCURACY_RATING])));
  
  mp = class'UI_Label'.static.abbreviate(string(int(hero.subStats[CURRENT_MANA])));
  mpMax = class'UI_Label'.static.abbreviate(string(int(hero.subStats[MAX_MANA])));
  dodge = class'UI_Label'.static.abbreviate(string(int(hero.subStats[DODGE_RATING])));
  threshold = string(hero.subStats[MORALE_THRESHOLD]);
  
  // Show primary stat values
  vitLabel.setText(hero.getPrimaryStat(PRIMARY_VITALITY));
  strLabel.setText(hero.getPrimaryStat(PRIMARY_STRENGTH));
  crgLabel.setText(hero.getPrimaryStat(PRIMARY_COURAGE));
  focLabel.setText(hero.getPrimaryStat(PRIMARY_FOCUS));
  
  // Show vitality substats
  if (int(hero.subStats[MAX_HEALTH]) < 1000) {
    healthLabel.setText(hp $ "/" $ hpMax);
  } else {
    healthLabel.setText(hpMax);
  }
  
  // Show strength substats
  physDmgLabel.setText(dmgMin $ " to " $ dmgMax);
  
  // Show courage substats
  intervalLabel.setText(decimal(atkInterval, 2) $ " s");
  critChanceLabel.setText(decimal(critChance, 1) $ "%");
  critMultLabel.setText(critRolls);
  accuracyLabel.setText(accuracy);
  
  // Show focus substats
  if (int(hero.subStats[MAX_MANA]) < 1000) {
    manaLabel.setText(mp $ "/" $ mpMax);
  } else {
    manaLabel.setText(mpMax);
  }
  dodgeLabel.setText(dodge);
  thresholdLabel.setText(decimal(threshold, 1) $ "%");
  
  
}

/*============================================================================*
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Container draw settings
  bDrawRelative=true
  
  /** ===== UI Components ===== **/
  // Primary stat - Vitality Label
  begin object class=UI_Label Name=Primary_Stat_Vitality_Label
    tag="Primary_Stat_Vitality_Label"
    bRelativeEnd=true
    posY=201
    posXEnd=-403
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="10"
  end object
  componentList.add(Primary_Stat_Vitality_Label)
  
  // Primary stat - Strength Label
  begin object class=UI_Label Name=Primary_Stat_Strength_Label
    tag="Primary_Stat_Strength_Label"
    bRelativeEnd=true
    posY=261
    posXEnd=-403
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="20"
  end object
  componentList.add(Primary_Stat_Strength_Label)
  
  // Primary stat - Courage Label
  begin object class=UI_Label Name=Primary_Stat_Courage_Label
    tag="Primary_Stat_Courage_Label"
    bRelativeEnd=true
    posY=345
    posXEnd=-403
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="30"
  end object
  componentList.add(Primary_Stat_Courage_Label)
  
  // Primary stat - Focus Label
  begin object class=UI_Label Name=Primary_Stat_Focus_Label
    tag="Primary_Stat_Focus_Label"
    bRelativeEnd=true
    posY=575
    posXEnd=-403
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="40"
  end object
  componentList.add(Primary_Stat_Focus_Label)
  
  
  // Sub stat - Health Label
  begin object class=UI_Label Name=Sub_Stat_Label_1
    tag="Sub_Stat_Label_1"
    bRelativeEnd=true
    ///bFormatAbbreviations=true // Abbreviate health numbers
    posY=201
    posXEnd=0
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="5"
  end object
  componentList.add(Sub_Stat_Label_1)
  
  // Sub stat - Physical Damage Label
  begin object class=UI_Label Name=Sub_Stat_Label_2
    tag="Sub_Stat_Label_2"
    bRelativeEnd=true
    posY=261
    posXEnd=0
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="5"
  end object
  componentList.add(Sub_Stat_Label_2)
  
  // Sub stat - Attack Interval Label
  begin object class=UI_Label Name=Sub_Stat_Label_3
    tag="Sub_Stat_Label_3"
    bRelativeEnd=true
    posY=345
    posXEnd=0
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="5"
  end object
  componentList.add(Sub_Stat_Label_3)
  
  // Sub stat - Critical Chance Label
  begin object class=UI_Label Name=Sub_Stat_Label_4
    tag="Sub_Stat_Label_4"
    bRelativeEnd=true
    posY=403
    posXEnd=0
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="5"
  end object
  componentList.add(Sub_Stat_Label_4)
  
  // Sub stat - Multiplier Label
  begin object class=UI_Label Name=Sub_Stat_Label_5
    tag="Sub_Stat_Label_5"
    bRelativeEnd=true
    posY=461
    posXEnd=0
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="5"
  end object
  componentList.add(Sub_Stat_Label_5)
  
  // Sub stat - Accuracy Label
  begin object class=UI_Label Name=Sub_Stat_Label_6
    tag="Sub_Stat_Label_6"
    bRelativeEnd=true
    posY=519
    posXEnd=0
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="5"
  end object
  componentList.add(Sub_Stat_Label_6)
  
  // Sub stat - Mana Label
  begin object class=UI_Label Name=Sub_Stat_Label_7
    tag="Sub_Stat_Label_7"
    bRelativeEnd=true
    posY=575
    posXEnd=0
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="5"
  end object
  componentList.add(Sub_Stat_Label_7)
  
  // Sub stat - Dodge Label
  begin object class=UI_Label Name=Sub_Stat_Label_8
    tag="Sub_Stat_Label_8"
    bRelativeEnd=true
    posY=632
    posXEnd=0
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="5"
  end object
  componentList.add(Sub_Stat_Label_8)
  
  // Sub stat - Threshold Label
  begin object class=UI_Label Name=Sub_Stat_Label_9
    tag="Sub_Stat_Label_9"
    bRelativeEnd=true
    posY=690
    posXEnd=0
    alignX=RIGHT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="5"
  end object
  componentList.add(Sub_Stat_Label_9)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  