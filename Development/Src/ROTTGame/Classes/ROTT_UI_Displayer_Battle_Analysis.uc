/*=============================================================================
 * ROTT_UI_Displayer_Battle_Analysis
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object displays a heroes combat statistics after victory
 *===========================================================================*/

class ROTT_UI_Displayer_Battle_Analysis extends ROTT_UI_Displayer
dependsOn(ROTT_Combat_Hero)
dependsOn(ROTT_Combat_Object);

// Internal references
var private UI_Label actionAnalysis[9];
var private UI_Label glyphTotal;
var private UI_Label glyphAnalysis[GlyphSkills];
var private UI_Label glyphDetails[GlyphSkills];

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  local string suffix;
  
  super.initializeComponent(newTag);
  
  // Internal references
  for (i = 0; i < 9; i++) {
    suffix = class'UI_Page'.static.pCase(string(GetEnum(enum'StatisticEnum', i)));
    actionAnalysis[i] = findLabel("Analysis_" $ suffix);
  }
  glyphTotal = findLabel("Analysis_Glyphs_Total");
  
  for (i = 0; i < 8; i++) {
    suffix = class'UI_Page'.static.pCase(string(GetEnum(enum'GlyphSkills', i)));
    glyphAnalysis[i] = findLabel("Analysis_" $ suffix);
  }
  
  glyphDetails[GLYPH_TREE_HEALTH] = findLabel("Analysis_Recovered_health");
  glyphDetails[GLYPH_TREE_MANA] = findLabel("Analysis_Recovered_mana");
  glyphDetails[GLYPH_TREE_MP_REGEN] = findLabel("Analysis_Recovered_mana_regen");
  glyphDetails[GLYPH_TREE_SPEED] = findLabel("Analysis_Recovered_speed");
  glyphDetails[GLYPH_TREE_ACCURACY] = findLabel("Analysis_Recovered_accuracy");
  glyphDetails[GLYPH_TREE_DODGE] = findLabel("Analysis_Recovered_dodge");
  glyphDetails[GLYPH_TREE_DAMAGE] = findLabel("Analysis_Recovered_damage");
  glyphDetails[GLYPH_TREE_ARMOR] = findLabel("Analysis_Recovered_armor");
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
  local string hpRecovered, mpRecovered, mpRegenRecovered;
  local string addedAccuracy, addedDodge, addedDamage;
  local string totalTime;
  local int i;
  
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Display action analysis numbers
  for (i = 0; i < 9 - 1; i++) {
    actionAnalysis[i].setText(
      class'UI_Label'.static.abbreviate(
        int(hero.battleStatistics[i]), 100000
      )
    );
  }
  
  // Display total time
  totalTime = formatTime(int(hero.battleStatistics[BATTLE_TIME]));
  actionAnalysis[BATTLE_TIME].setText(totaltime);
  
  // Display total glyphs
  glyphTotal.setText(hero.getTotalGlyphCount());
  
  // Store and abbreviate analysis numbers
  hpRecovered = class'UI_Label'.static.abbreviate(
    int(hero.battleStatistics[RECOVERED_HEALTH])
  );
  mpRecovered = class'UI_Label'.static.abbreviate(
    int(hero.battleStatistics[RECOVERED_MANA])
  );
  mpRegenRecovered = class'UI_Label'.static.abbreviate(
    int(hero.battleStatistics[RECOVERED_MANA_REGEN])
  );
  addedAccuracy = class'UI_Label'.static.abbreviate(
    int(hero.battleStatistics[ADDED_GLYPH_ACCURACY])
  );
  addedDodge = class'UI_Label'.static.abbreviate(
    int(hero.battleStatistics[ADDED_GLYPH_DODGE])
  );
  addedDamage = class'UI_Label'.static.abbreviate(
    int(hero.battleStatistics[ADDED_GLYPH_DAMAGE])
  );
  
  // Display glyph analysis numbers
  for (i = 0; i < 8; i++) {
    if (hero.glyphSkillPts[i] == 0) {
      glyphAnalysis[i].setText("n/a");
      glyphAnalysis[i].setFont(DEFAULT_MEDIUM_GRAY);
      glyphDetails[i].setText("");
    } else {
      glyphAnalysis[i].setText(hero.totalGlyphCollection[i]);
      glyphAnalysis[i].setFont(DEFAULT_MEDIUM_WHITE);
      
      // Write label analysis details
      switch(i) {
        case GLYPH_TREE_HEALTH:
          glyphDetails[i].setText(
            "+ " $ hpRecovered $ " recovered health"
          );
          break;
        case GLYPH_TREE_MANA:
          glyphDetails[i].setText(
            "+ " $ mpRecovered $ " recovered mana"
          );
          break;
        case GLYPH_TREE_MP_REGEN:
          glyphDetails[i].setText(
            decimal(hero.statBoosts[ADD_MANA_REGEN], 1) $ " mana / sec" $ "\n" $
            "+ " $ mpRegenRecovered $ " recovered mana"
          );
          break;
        case GLYPH_TREE_SPEED:
          glyphDetails[i].setText(
            decimal(hero.getSpeedImprovement(), 2) $ " sec faster"
          );
          break;
        case GLYPH_TREE_ACCURACY:
          glyphDetails[i].setText(
            "+ " $ addedAccuracy $ " accuracy rating"
          );
          break;
        case GLYPH_TREE_DODGE:
          glyphDetails[i].setText(
            "+ " $ addedDodge $ " dodge rating"
          );
          break;
        case GLYPH_TREE_DAMAGE:
          glyphDetails[i].setText(
            addedDamage $ " additional damage"
          );
          break;
        case GLYPH_TREE_ARMOR:
          glyphDetails[i].setText(
            "+ " $ int(hero.battleStatistics[ADDED_GLYPH_ARMOR]) $ " armor rating"
          );
          break;
      }
    }
  }
  
  // Successfully drew hero information
  return true;
}

/*=============================================================================
 * formatTime()
 *
 * Given an integer number of seconds, this formats a strings for MM:SS
 *===========================================================================*/
public function string formatTime(int seconds) {
  local int minutes;
  local string format;
  
  minutes = seconds / 60;
  seconds = seconds % 60;
  
  format = string(minutes) $ ":";
  if (seconds < 10) format $= "0";
  format $= seconds;
  
  return format;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  /** ===== Textures ===== **/
  // Class Names
  begin object class=UI_Texture_Info Name=Portrait_Wizard
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Portrait_Wizard_400x600')
  end object
  begin object class=UI_Texture_Info Name=Portrait_Valkyrie
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Portrait_Valkyrie_400x600')
  end object
  begin object class=UI_Texture_Info Name=Portrait_Goliath
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Portrait_Goliath_400x600')
  end object
  begin object class=UI_Texture_Info Name=Portrait_Titan
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Portrait_Titan_400x600')
  end object
  
  /** ===== UI Components ===== **/
  // Stat descriptions (Left)
  begin object class=UI_Label Name=Analysis_Descriptions_Left
    tag="Analysis_Descriptions_Left"
    posX=80
    posY=405
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText="\n    Hit\n    Missed\n    Damage Dealt\n\n\n    Hit\n    Dodged\n    HP Lost\n\n"
  end object
  componentList.add(Analysis_Descriptions_Left)
  
  // Stat descriptions (Left Orange)
  begin object class=UI_Label Name=Analysis_Descriptions_Left_Orange
    tag="Analysis_Descriptions_Left_Orange"
    posX=80
    posY=405
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_PEACH
    labelText="Outgoing Actions\n\n\n\n\nIncoming Actions\n\n\n\n\nElapsed Time"
  end object
  componentList.add(Analysis_Descriptions_Left_Orange)
  
  // Stat descriptions (Right)
  begin object class=UI_Label Name=Analysis_Descriptions_Right
    tag="Analysis_Descriptions_Right"
    posX=570
    posY=405
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText="\n    Health\n\n    Mana\n    Mana Regen\n\n    Speed\n    Accuracy\n    Dodge\n    Damage\n    Armor"
  end object
  componentList.add(Analysis_Descriptions_Right)
  
  // Stat descriptions (Right Orange)
  begin object class=UI_Label Name=Analysis_Descriptions_Right_Orange
    tag="Analysis_Descriptions_Right_Orange"
    posX=570
    posY=405
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_PEACH
    labelText="Glyphs Collected"
  end object
  componentList.add(Analysis_Descriptions_Right_Orange)
  
  /** --------------------------------------------------------------------- **/
  
  // Total actions
  begin object class=UI_Label Name=Analysis_Outgoing_actions
    tag="Analysis_Outgoing_actions"
    posX=421
    posY=405
    posXEnd=509
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Outgoing_actions)
  
  // Hit actions
  begin object class=UI_Label Name=Analysis_Outgoing_hits
    tag="Analysis_Outgoing_hits"
    posX=421
    posY=440
    posXEnd=509
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Outgoing_hits)
  
  // Missed actions
  begin object class=UI_Label Name=Analysis_Outgoing_misses
    tag="Analysis_Outgoing_misses"
    posX=421
    posY=475
    posXEnd=509
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Outgoing_misses)
  
  // Total damage dealt
  begin object class=UI_Label Name=Analysis_Outgoing_damage
    tag="Analysis_Outgoing_damage"
    posX=421
    posY=510
    posXEnd=509
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Outgoing_damage)
  
  /** --------------------------------------------------------------------- **/
  
  // Incoming attacks
  begin object class=UI_Label Name=Analysis_Incoming_actions
    tag="Analysis_Incoming_actions"
    posX=421
    posY=580
    posXEnd=509
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Incoming_actions)
  
  // Incoming hit count
  begin object class=UI_Label Name=Analysis_Incoming_hits
    tag="Analysis_Incoming_hits"
    posX=421
    posY=615
    posXEnd=509
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Incoming_hits)
  
  // Incoming hits dodged
  begin object class=UI_Label Name=Analysis_Incoming_misses
    tag="Analysis_Incoming_misses"
    posX=421
    posY=650
    posXEnd=509
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Incoming_misses)
  
  // Incoming damage taken
  begin object class=UI_Label Name=Analysis_Incoming_damage
    tag="Analysis_Incoming_damage"
    posX=421
    posY=685
    posXEnd=509
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Incoming_damage)
  
  // Elapsed time
  begin object class=UI_Label Name=Analysis_Battle_time
    tag="Analysis_Battle_time"
    posX=421
    posY=755
    posXEnd=509
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Battle_time)
  
  /** --------------------------------------------------------------------- **/
  
  // Total glyphs collected
  begin object class=UI_Label Name=Analysis_Glyphs_Total
    tag="Analysis_Glyphs_Total"
    posX=886
    posY=405
    posXEnd=947
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Glyphs_Total)
  
  // Health glyph counter
  begin object class=UI_Label Name=Analysis_Glyph_tree_health
    tag="Analysis_Glyph_tree_health"
    posX=886
    posY=440
    posXEnd=947
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Glyph_tree_health)
  
  // Mana glyph counter
  begin object class=UI_Label Name=Analysis_Glyph_tree_mana
    tag="Analysis_Glyph_tree_mana"
    posX=886
    posY=510
    posXEnd=947
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Glyph_tree_mana)
  
  // Mana Regen glyph counter
  begin object class=UI_Label Name=Analysis_Glyph_tree_mp_regen
    tag="Analysis_Glyph_tree_mp_regen"
    posX=886
    posY=545
    posXEnd=947
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Glyph_tree_mp_regen)
  
  // Speed glyph counter
  begin object class=UI_Label Name=Analysis_Glyph_tree_speed
    tag="Analysis_Glyph_tree_speed"
    posX=886
    posY=615
    posXEnd=947
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Glyph_tree_speed)
  
  // Accuracy glyph counter
  begin object class=UI_Label Name=Analysis_Glyph_tree_accuracy
    tag="Analysis_Glyph_tree_accuracy"
    posX=886
    posY=650
    posXEnd=947
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Glyph_tree_accuracy)
  
  // Dodge glyph counter
  begin object class=UI_Label Name=Analysis_Glyph_tree_dodge
    tag="Analysis_Glyph_tree_dodge"
    posX=886
    posY=685
    posXEnd=947
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Glyph_tree_dodge)
  
  // Damage glyph counter
  begin object class=UI_Label Name=Analysis_Glyph_tree_damage
    tag="Analysis_Glyph_tree_damage"
    posX=886
    posY=720
    posXEnd=947
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Glyph_tree_damage)
  
  // Armor glyph counter
  begin object class=UI_Label Name=Analysis_Glyph_tree_armor
    tag="Analysis_Glyph_tree_armor"
    posX=886
    posY=755
    posXEnd=947
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText=""
  end object
  componentList.add(Analysis_Glyph_tree_armor)
  
  

  /** --------------------------------------------------------------------- **/
  
  // Recovered health
  begin object class=UI_Label Name=Analysis_Recovered_health
    tag="Analysis_Recovered_health"
    posX=963
    posY=440
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText=""
  end object
  componentList.add(Analysis_Recovered_health)
  
  // Recovered mana
  begin object class=UI_Label Name=Analysis_Recovered_mana
    tag="Analysis_Recovered_mana"
    posX=963
    posY=510
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText=""
  end object
  componentList.add(Analysis_Recovered_mana)
  
  // Recovered mana through regen
  begin object class=UI_Label Name=Analysis_Recovered_mana_regen
    tag="Analysis_Recovered_mana_regen"
    posX=963
    posY=545
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText=""
  end object
  componentList.add(Analysis_Recovered_mana_regen)
  
  // Speed improvement
  begin object class=UI_Label Name=Analysis_Recovered_speed
    tag="Analysis_Recovered_speed"
    posX=963
    posY=615
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText=""
  end object
  componentList.add(Analysis_Recovered_speed)
  
  // Accuracy improvement
  begin object class=UI_Label Name=Analysis_Recovered_accuracy
    tag="Analysis_Recovered_accuracy"
    posX=963
    posY=650
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText=""
  end object
  componentList.add(Analysis_Recovered_accuracy)
  
  // Dodge improvement
  begin object class=UI_Label Name=Analysis_Recovered_dodge
    tag="Analysis_Recovered_dodge"
    posX=963
    posY=685
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText=""
  end object
  componentList.add(Analysis_Recovered_dodge)
  
  // Damage improvement
  begin object class=UI_Label Name=Analysis_Recovered_damage
    tag="Analysis_Recovered_damage"
    posX=963
    posY=720
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText=""
  end object
  componentList.add(Analysis_Recovered_damage)
  
  // Armor improvement
  begin object class=UI_Label Name=Analysis_Recovered_armor
    tag="Analysis_Recovered_armor"
    posX=963
    posY=755
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText=""
  end object
  componentList.add(Analysis_Recovered_armor)
}
























