/*=============================================================================
 * ROTT_UI_Displayer_Combat_Hero
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displayer shows a heroes visual information during
 * combat.
 *  (See: ROTT_Combat_Hero.uc)
 *
 *===========================================================================*/

class ROTT_UI_Displayer_Combat_Hero extends ROTT_UI_Displayer_Combat;

// Reference to parent container
var private ROTT_UI_Displayer_Combat_Heroes parentDisplayer;

// Store delay time before showing HUD updates
var public float displayerDelay;

// Internal references
var private ROTT_UI_Displayer_Tuna_Bar tunaDisplayer;
var private ROTT_UI_Displayer_Health_Globe healthDisplayer;
var private ROTT_UI_Displayer_Mana_Globe manaDisplayer;

var private UI_Sprite classLabel;

var private UI_Label healthLabel;
var private UI_Label maxhealthLabel;
var private UI_Label manaLabel;
var private UI_Label maxmanaLabel;
var private UI_Label manaSlash;
var private UI_Label healthSlash;

var private UI_Label speedAmpLabel;
var private ROTT_UI_Status_Label statusLabel;
var private ROTT_UI_Status_Label demoralizeLabel;

/*============================================================================= 
 * initializeComponent()
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Parent
  parentDisplayer = ROTT_UI_Displayer_Combat_Heroes(outer);
  
  // Internal references
  tunaDisplayer = ROTT_UI_Displayer_Tuna_Bar(findComp("Combat_Tuna_Displayer"));
  healthDisplayer = ROTT_UI_Displayer_Health_Globe(findComp("Combat_Health_Displayer"));
  manaDisplayer = ROTT_UI_Displayer_Mana_Globe(findComp("Combat_Mana_Displayer"));
  classLabel = findSprite("Hero_Class_Label");
  
  healthLabel = findLabel("Hero_Current_Health_Label");
  healthSlash = findLabel("Hero_Health_Slash");
  maxhealthLabel = findLabel("Hero_Max_Health_Label");
  
  manaLabel = findLabel("Hero_Current_Mana_Label");
  manaSlash = findLabel("Hero_Mana_Slash");
  maxmanaLabel = findLabel("Hero_Max_Mana_Label");
  
  speedAmpLabel = findLabel("Hero_Speed_Amp_Label");
  statusLabel = ROTT_UI_Status_Label(findComp("Hero_Status_Label"));
  demoralizeLabel = ROTT_UI_Status_Label(findComp("Hero_Demoralized_Label"));
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
 * showDetail()
 *
 * This is used to turn on or off extra combat details
 *===========================================================================*/
public function showDetail(bool bShow) {
  healthLabel.setEnabled(bShow);
  healthSlash.setEnabled(bShow);
  maxhealthLabel.setEnabled(bShow);
  
  manaLabel.setEnabled(bShow);
  manaSlash.setEnabled(bShow);
  maxmanaLabel.setEnabled(bShow);
  
  statusLabel.setEnabled(bShow);
  demoralizeLabel.setEnabled(bShow);
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
  
  // Class type
  classLabel.setDrawIndex(hero.myClass);
  
  if (hero.bDead && hero.getMasteryLevel(MASTERY_RESURRECT) > 0) {
    // resurrection
    healthSlash.setText("/");
    healthLabel.setText(hero.uiFormat(RESURRECTION_CURRENT));
    maxhealthLabel.setText(hero.uiFormat(RESURRECTION_LIMIT));
  } else {
    // health
    healthSlash.setText("/");
    healthLabel.setText(hero.uiFormat(CURRENT_HEALTH));
    maxhealthLabel.setText(hero.uiFormat(MAX_HEALTH));
  }
  // mana
  manaSlash.setText("/");
  manaLabel.setText(hero.uiFormat(CURRENT_MANA));
  maxmanaLabel.setText(hero.uiFormat(MAX_MANA));
  
  // Successfully drew hero information
  return true;
}

/*=============================================================================
 * makeLabel()
 *
 * Creates a label to show feedback for combat actions
 *===========================================================================*/
protected function UI_Label makeLabel
(
  coerce string text,
  optional CombatFonts fontIndex = FONT_LARGE,
  optional ColorStyles colorIndex = COLOR_GRAY,
  optional LabelClass labelType = LABEL_TYPE_RESIST,
  optional float labelDelay = 0.f
) 
{
  local UI_Label label;
  
  // Regular make label routine
  label = super.makeLabel(text, fontIndex, colorIndex, labelType);
  
  // Set label delay
  if (labelDelay != 0) {
    label.activationDelay = labelDelay;
    label.setEnabled(false);
  }
  
  // Adjust text location
  switch (labelType) {
    case LABEL_TYPE_STAT_REPORT: 
      // Label placement
      label.updatePosition(getX(), getY() - 25, getX() + 294, getY() + 35);
      break;
    case LABEL_TYPE_STAT_CHANGE: 
      // Label placement
      label.updatePosition(getX(), getY() - 55, getX() + 384, getY() + 5);
      break;
    // Health recovery
    case LABEL_TYPE_HEALTH_GAIN: 
      label.updatePosition(getX() + 75, getY() + 135, getX() + 305, getY() + 75);
      break;
    // Mana recovery
    case LABEL_TYPE_MANA_GAIN:   
      label.updatePosition(getX(), getY() + 10, getX() + 150, getY() + 45);
      break;
    // Damage numbers
    case LABEL_TYPE_DAMAGE:
      label.updatePosition(getX() + 175, getY(), NATIVE_WIDTH, getY() + 300);
      break;
    // Mana Damage
    case LABEL_TYPE_MANA_DAMAGE:
      label.updatePosition(getX() + 80, getY() + 21, NATIVE_WIDTH, getY() + 66);
      break;
    default:
      yellowLog("Warning (!) Unhandled label type.", DEBUG_COMBAT);
      break;
  }
  
  // Sets home position data
  label.postInit();
  
  label.drawLayer = 2;
  
  // Return reference of this label
  return label;
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  // The parent class will erase temporary combat labels over time
  super.elapseTimer(deltaTime, gameSpeedOverride);
}

/*=============================================================================
 * addStatus()
 *
 * Called to add a status to be displayed in by this label
 *===========================================================================*/
public function addStatus(ROTT_Descriptor_Hero_Skill skillInfo) {
  // Separate tag for demoralize label
  if (skillInfo.statusTag == "Demoralized") {
    // Set demoralize label here
    demoralizeLabel.addStatus(skillInfo.statusTag, skillInfo.statusColor);
  } else {
    // Set all other status labels here
    statusLabel.addStatus(skillInfo.statusTag, skillInfo.statusColor);
  }
}

/*=============================================================================
 * addManualStatus()
 *
 * A manual status has no hero skill descriptor, e.g. Persistence
 *===========================================================================*/
public function addManualStatus(string statusTag, FontStyles statusColor) {
  // Set all other status labels here
  statusLabel.addStatus(statusTag, statusColor);
}

/*=============================================================================
 * removeStatus()
 *
 * Called to remove a status from being displayed by this label
 *===========================================================================*/
public function removeStatus(ROTT_Descriptor_Hero_Skill skillInfo) {
  if (skillInfo.statusTag == "Demoralized") {
    demoralizeLabel.removeStatus(skillInfo);
  } else {
    statusLabel.removeStatus(skillInfo);
  }
}

/*=============================================================================
 * removeStatusManually()
 *
 * Given a tag, removes the correponding status
 *===========================================================================*/
public function removeStatusManually(string statusTag) {
  statusLabel.removeStatusManually(statusTag);
}

/*=============================================================================
 * removeAllStatus()
 *
 * Called to remove all status
 *===========================================================================*/
public function removeAllStatus() {
  demoralizeLabel.removeAllStatus();
  statusLabel.removeAllStatus();
}

/*=============================================================================
 * showDamage()
 *
 * Called when the unit takes damage
 *===========================================================================*/
public function showDamage(int damage, bool bCrit) {
  makeLabel(
    "-" $ class'UI_Label'.static.abbreviate(damage), 
    FONT_LARGE, 
    (bCrit) ? COLOR_GOLD : COLOR_GRAY, 
    LABEL_TYPE_DAMAGE
  );
}

/*=============================================================================
 * showDamageToMana()
 *
 * Called when the unit takes damage to their mana
 *===========================================================================*/
public function showDamageToMana(int damage, bool bCrit) {
  makeLabel(
    "-" $ class'UI_Label'.static.abbreviate(damage), 
    FONT_MEDIUM, 
    COLOR_GRAY, 
    LABEL_TYPE_MANA_DAMAGE
  );
}

/*=============================================================================
 * onResisted()
 *
 * Called when the displayed unit has resisted an effect
 *===========================================================================*/
public function onResisted() {
  makeLabel(
    "resisted"
  );
}

/*=============================================================================
 * improveStat()
 *
 * Called when a stat improvement has been made
 *===========================================================================*/
public function improveStat(float value, float total, MechanicTypes targetStat) {
  local ColorStyles msgColor;
  local string totalMsg, totalValue;
  local string addedMsg, addedValue;
  local float overlapDelay;
  
  // Fetch delay time from parent
  overlapDelay = 0;
  if (targetStat != parentDisplayer.lastStatType) {
    overlapDelay = parentDisplayer.overlapDelay;
    parentDisplayer.queueStatType = targetStat;
  }
  
  // Set UI color
  switch (targetStat) {
    case ADD_ALL_STATS:          msgColor = COLOR_TAN;      break;
    case ADD_STRENGTH:           msgColor = COLOR_ORANGE;   break;
    case ADD_COURAGE:            msgColor = COLOR_GOLD;     break;
    case ADD_FOCUS:              msgColor = COLOR_BLUE;     break;
    case ADD_SPEED:              msgColor = COLOR_YELLOW;   break;
    case ADD_ACCURACY:           msgColor = COLOR_GREEN;    break;
    case ADD_DODGE:              msgColor = COLOR_PURPLE;   break;
    case ADD_ARMOR:              msgColor = COLOR_TAN;      break;
    case ELEMENTAL_MULTIPLIER:   msgColor = COLOR_CYAN;     break;
    case PHYSICAL_MULTIPLIER:    msgColor = COLOR_ORANGE;   break;
    case AMPLIFY_NEXT_DAMAGE:    msgColor = COLOR_ORANGE;   break;
    case ADD_EXTRA_MANA_REGEN:   msgColor = COLOR_CYAN;     break;
    case ADD_MANA_REGEN:         msgColor = COLOR_CYAN;     break;
    case ADD_HEALTH_REGEN:       msgColor = COLOR_RED;      break;
    case ADD_STRENGTH_PERCENT:   msgColor = COLOR_TAN;      break;
    case ADD_COURAGE_PERCENT:    msgColor = COLOR_TAN;      break;
    default:
      yellowLog("Unhandled stat boost: " $ MechanicTypes(targetStat));
      break;
  }
  
  // Abbreviate total
  totalValue = class'UI_Label'.static.abbreviate(int(total));
  
  // Total stat boost feedback
  switch (targetStat) {
    case ADD_ALL_STATS:   totalMsg = "+" $ totalValue $ " all stats"; break;
    case ADD_STRENGTH:    totalMsg = "+" $ totalValue $ " strength";  break;
    case ADD_COURAGE:     totalMsg = "+" $ totalValue $ " courage";   break;
    case ADD_FOCUS:       totalMsg = "+" $ totalValue $ " focus";     break;
    case ADD_SPEED:       totalMsg = "+" $ totalValue $ " speed";     break;
    case ADD_ACCURACY:    totalMsg = "+" $ totalValue $ " accuracy";  break;
    case ADD_DODGE:       totalMsg = "+" $ totalValue $ " dodge";     break;
    case ADD_ARMOR:       totalMsg = "+" $ totalValue $ " armor";     break;
    case ADD_STRENGTH_PERCENT:       
      totalMsg = "+" $ int(total) $ "% strength";    
      break;
    case ADD_COURAGE_PERCENT:       
      totalMsg = "+" $ int(total) $ "% courage";    
      break;
    case PHYSICAL_MULTIPLIER:  
    case ELEMENTAL_MULTIPLIER:  
    case AMPLIFY_NEXT_DAMAGE:  
      totalMsg = "+" $ int(total) $ "% damage";    
      break;
    case ADD_EXTRA_MANA_REGEN:  
    case ADD_MANA_REGEN:  
      totalMsg = "+" $ class'UI_Container'.static.decimal(total, 1) $ " regen";    
      break;
    case ADD_HEALTH_REGEN:  
      totalMsg = "+" $ class'UI_Container'.static.decimal(total, 1) $ " regen";    
      break;
    default:
      yellowLog("Unhandled stat boost: " $ MechanicTypes(targetStat));
      break;
  }
  
  // Skip next message for when stance is reverting attributes
  if (value < 0) return;
  
  // Abbreviate total
  addedValue = class'UI_Label'.static.abbreviate(int(value));
  
  // Total stat message
  makeLabel(
    totalMsg, 
    FONT_MEDIUM_ITALICS, 
    msgColor, 
    LABEL_TYPE_STAT_REPORT,
    displayerDelay + overlapDelay
  );
  
  // Set hero add message
  switch (targetStat) {
    case ADD_ALL_STATS:        addedMsg = "+" $ addedValue; break;
    case ADD_STRENGTH:         addedMsg = "+" $ addedValue; break;
    case ADD_COURAGE:          addedMsg = "+" $ addedValue; break;
    case ADD_FOCUS:            addedMsg = "+" $ addedValue; break;
    case ADD_SPEED:            addedMsg = "+" $ addedValue; break;
    case ADD_ACCURACY:         addedMsg = "+" $ addedValue; break;
    case ADD_DODGE:            addedMsg = "+" $ addedValue; break;
    case ADD_ARMOR:            addedMsg = "+" $ addedValue; break;
    case PHYSICAL_MULTIPLIER:  addedMsg = "+" $ addedValue $ "%"; break;
    case ELEMENTAL_MULTIPLIER: addedMsg = "+" $ addedValue $ "%"; break;
    case AMPLIFY_NEXT_DAMAGE:  addedMsg = "+" $ addedValue $ "%"; break;
    case ADD_STRENGTH_PERCENT: addedMsg = "+" $ addedValue $ "%"; break;
    case ADD_COURAGE_PERCENT:  addedMsg = "+" $ addedValue $ "%"; break;
    case ADD_EXTRA_MANA_REGEN: addedMsg = "+" $ class'UI_Container'.static.decimal(value, 1); break;
    case ADD_MANA_REGEN:       addedMsg = "+" $ class'UI_Container'.static.decimal(value, 1); break;
    case ADD_HEALTH_REGEN:     addedMsg = "+" $ class'UI_Container'.static.decimal(value, 1); break;
    default:
      yellowLog("Unhandled stat boost: " $ MechanicTypes(targetStat));
  }
  
  // Added stat message
  makeLabel(
    addedMsg, 
    FONT_MEDIUM_ITALICS, 
    msgColor, 
    LABEL_TYPE_STAT_CHANGE,
    displayerDelay + overlapDelay
  );
  
  // Increase overlap delay
  parentDisplayer.overlapDelayUpdate(targetStat);
  
}
  
/*=============================================================================
 * updateSpeedAmp()
 *
 * Called when the speed amp changes
 *===========================================================================*/
public function updateSpeedAmp(float speedAmp) {
  local string speedText;
  
  // Hide for zero amp
  if (speedAmp == 1) {
    speedAmpLabel.setText("");
    return;
  }
  
  // Formatting
  speedText = string(speedAmp);
  //speedText = string(((100 + speedAmp) / 100) ** -1);
  speedText = class'UI_Container'.static.decimal(speedText, 2) $ "x";
  
  // Set text
  speedAmpLabel.setText(speedText);
}

/*=============================================================================
 * onAnalysisComplete()
 * 
 * This function is called after a battle is done, and after battle analysis
 * is finished.
 *===========================================================================*/
public function onAnalysisComplete() {
  statusLabel.reset();
}

/*=============================================================================
 * attachmentUpdate()
 *
 * Called when a new object is attached
 *===========================================================================*/
protected function attachmentUpdate() {
  super.attachmentUpdate();
  
  // Initially clear
  updateSpeedAmp(1);
}
  
/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  // Animation modes for each label class
  animationModes(LABEL_TYPE_STAT_REPORT)=ANIMATE_SLOW_BOUNCE
  animationModes(LABEL_TYPE_STAT_CHANGE)=ANIMATE_UP_AND_FADE
  animationModes(LABEL_TYPE_HEALTH_GAIN)=ANIMATE_UP_AND_FADE_QUICK
  animationModes(LABEL_TYPE_MANA_GAIN)=ANIMATE_UP_AND_FADE_QUICK
  animationModes(LABEL_TYPE_DAMAGE)=ANIMATE_POP_RIGHT
  animationModes(LABEL_TYPE_MANA_DAMAGE)=ANIMATE_POP_RIGHT
  animationModes(LABEL_TYPE_RESIST)=ANIMATE_STILL
  
  /** ===== Textures ===== **/
  // Class labels
  begin object class=UI_Texture_Info Name=Class_Label_Wizard
    componentTextures.add(Texture2D'GUI.Encounter_Wizard_Label')
  end object
  begin object class=UI_Texture_Info Name=Class_Label_Valkyrie
    componentTextures.add(Texture2D'GUI.Encounter_Valkyrie_Label')
  end object
  begin object class=UI_Texture_Info Name=Class_Label_Goliath
    componentTextures.add(Texture2D'GUI.Encounter_Goliath_Label')
  end object
  begin object class=UI_Texture_Info Name=Class_Label_Titan
    componentTextures.add(Texture2D'GUI.Encounter_Titan_Label')
  end object
  
  
  /** ===== UI Components ===== **/
  // Hero Tuna
  begin object class=ROTT_UI_Displayer_Tuna_Bar Name=Combat_Tuna_Displayer
    tag="Combat_Tuna_Displayer"
    posX=39
    posY=332
  end object
  componentList.add(Combat_Tuna_Displayer)
  
  // Hero Health Globe
  begin object class=ROTT_UI_Displayer_Health_Globe Name=Combat_Health_Displayer
    tag="Combat_Health_Displayer"
    posX=40
    posY=100
  end object
  componentList.add(Combat_Health_Displayer)
  
  // Hero Mana Globe
  begin object class=ROTT_UI_Displayer_Mana_Globe Name=Combat_Mana_Displayer
    tag="Combat_Mana_Displayer"
    posX=1
    posY=21
  end object
  componentList.add(Combat_Mana_Displayer)
  
  // Hero Class Label
  begin object class=UI_Sprite Name=Hero_Class_Label
    tag="Hero_Class_Label"
    posX=50
    posY=386
    images(0)=Class_Label_Wizard
    images(WIZARD)=Class_Label_Wizard
    images(TITAN)=Class_Label_Titan
    images(VALKYRIE)=Class_Label_Valkyrie
    images(GOLIATH)=Class_Label_Goliath
  end object
  componentList.add(Hero_Class_Label)
  
  // Health label
  begin object class=UI_Label Name=Hero_Health_Slash
    tag="Hero_Health_Slash"
    posX=40
    posY=174
    posXEnd=254
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="/"
  end object
  componentList.add(Hero_Health_Slash)
  
  begin object class=UI_Label Name=Hero_Current_Health_Label
    tag="Hero_Current_Health_Label"
    posX=68
    posY=154
    posXEnd=147
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Hero_Current_Health_Label)
  
  begin object class=UI_Label Name=Hero_Max_Health_Label
    tag="Hero_Max_Health_Label"
    posX=147
    posY=194
    posXEnd=226
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Hero_Max_Health_Label)
  
  // Mana label
  begin object class=UI_Label Name=Hero_Mana_Slash
    tag="Hero_Mana_Slash"
    posX=6
    posY=36
    posXEnd=112
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="/"
  end object
  componentList.add(Hero_Mana_Slash)
  
  begin object class=UI_Label Name=Hero_Current_Mana_Label
    tag="Hero_Current_Mana_Label"
    posX=6
    posY=26
    posXEnd=59
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Hero_Current_Mana_Label)
  
  begin object class=UI_Label Name=Hero_Max_Mana_Label
    tag="Hero_Max_Mana_Label"
    posX=59
    posY=46
    posXEnd=112
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Hero_Max_Mana_Label)
  
  // Speed amplifier
  begin object class=UI_Label Name=Hero_Speed_Amp_Label
    tag="Hero_Speed_Amp_Label"
    posX=0
    posY=0
    posXEnd=258
    posYEnd=346
    AlignX=RIGHT
    AlignY=BOTTOM
    fontStyle=COMBAT_SMALL_TAN
    labelText="1.55x"
  end object
  componentList.add(Hero_Speed_Amp_Label)
  
  // Status label (Demoralized)
  begin object class=ROTT_UI_Status_Label Name=Hero_Demoralized_Label
    tag="Hero_Demoralized_Label"
    posX=38
    posY=179
    posXEnd=258
    posYEnd=344
  end object
  componentList.add(Hero_Demoralized_Label)
  
  // Status label
  begin object class=ROTT_UI_Status_Label Name=Hero_Status_Label
    tag="Hero_Status_Label"
    bAlignXCenter=false
    posX=35
    posY=0
    posXEnd=258
    posYEnd=346
  end object
  componentList.add(Hero_Status_Label)
  
}


















