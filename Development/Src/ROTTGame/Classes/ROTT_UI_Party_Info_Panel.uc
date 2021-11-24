/*=============================================================================
 * ROTT_UI_Party_Info_Panel
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This info panel displays team information.
 *===========================================================================*/

class ROTT_UI_Party_Info_Panel extends ROTT_UI_Displayer;

// Internal references
var private UI_Label headerLabel;
var private UI_Label heroClassLabels[3];
var private UI_Label heroLevelLabels[3];
var private UI_Label partyStatus;
var private UI_Label activityLabel;
var private UI_Sprite activityBox;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // Internal References
  headerLabel = findLabel("Party_Header_Label");
  partyStatus = findLabel("Party_Status_Label");
  activityLabel = findLabel("Shrine_Activity_Label");
  activityBox = findSprite("Party_Activity_Box");
  
  for (i = 0; i < 3; i++) {
    heroClassLabels[i] = findLabel("Party_Hero_Class_Label_" $ i + 1);
    heroLevelLabels[i] = findLabel("Party_Hero_Level_Label_" $ i + 1);
  }
  
}

/*=============================================================================
 * renderPartyInfo()
 *
 * Takes a party as a paramter, and displays that party's status & info
 *===========================================================================*/
public function renderPartyInfo(ROTT_Party displayParty) {
  local string labelText;
  local FontStyles labelFont;
  local int i;
  
  // Visibility settings
  if (displayParty == none) {
    setEnabled(false);
    return;
  }
  setEnabled(true);
  activityBox.setEnabled(displayParty.isShrineActive());
  
  // Header text
  headerLabel.setText("Team #" $ displayParty.partyIndex + 1);
  
  // Write hero classes
  for (i = 0; i < 3; i++) {
    if (i < displayParty.getPartySize()) {
      // Draw hero information
      heroClassLabels[i].setText(displayParty.getHero(i).myClass);
      heroLevelLabels[i].setText("Lvl " $ displayParty.getHero(i).level);
    } else {
      // Hide hero information
      heroClassLabels[i].setText("");
      heroLevelLabels[i].setText("");
    }
  }
  
  // Write party status
  switch (displayParty.partyStatus) {
    case PARTY_ACTIVE: 
      labelText = "Active"; 
      labelFont = DEFAULT_SMALL_GREEN; 
      break;
    case PARTY_IDLE:    
      labelText = "Idle";    
      labelFont = DEFAULT_SMALL_TAN; 
      break;
    case PARTY_WORSHIPPING: 
      labelText = "Worshipping"; 
      labelFont = DEFAULT_SMALL_BLUE; 
      break;
    case PARTY_MONSTER_HUNTING:
      labelText = "Hunting"; 
      labelFont = DEFAULT_SMALL_ORANGE; 
      break;
    case PARTY_TENDING_GARDENS:
      labelText = "Tending Gardens"; 
      labelFont = DEFAULT_SMALL_GREEN; 
      break;
  }
  
  partyStatus.setText(labelText);
  partyStatus.setFont(labelFont);
  
  // Write shrine activity
  switch (displayParty.partyActivity) {
    case NO_SHRINE_ACTIVITY: 
      labelText = ""; 
      break;
      
    case CLERICS_SHRINE:
      labelText = "Clerics Shrine";
      break;
    case COBALT_SANCTUM:
      labelText = "Cobalt Sanctum";
      break;
    case THE_ROSETTE_PILLARS:
      labelText = "The Rosette Pillars";
      break;
    case LOCKSPIRE_SHRINE:
      labelText = "Lockspire Shrine";
      break;
      
    case THE_UNDEAD:
      labelText = "The Undead";
      break;
    case THE_DEMONIC:
      labelText = "The Demonic";
      break;
    case THE_SERPENTINE:
      labelText = "The Serpentine";
      break;
    case THE_BEASTS:
      labelText = "The Beasts";
      break;
      
    case HAWKSPIRE_MEADOW:
      labelText = "Hawkspire Meadow";
      break;
    case LACEROOT_SHRINE:
      labelText = "Laceroot Shrine";
      break;
    case FATEWOOD_GROVE:
      labelText = "Fatewood Grove";
      break;
    case MYRRHIAN_THICKET:
      labelText = "Myrrhian Thicket";
      break;
      
  }
  
  activityLabel.setText(labelText);
}

/*=============================================================================
 * renderSaveInfo()
 *
 * Takes a party as a paramter, and displays save game info
 *===========================================================================*/
public function renderSaveInfo(ROTT_Game_Player_Profile profile, optional int saveIndex = -1) {
  local ROTT_Party displayParty;
  local string labelText;
  local FontStyles labelFont;
  local int i;
  
  displayParty = profile.getActiveParty();
  
  // Visibility settings
  if (displayParty == none) {
    setEnabled(false);
    return;
  }
  setEnabled(true);
  activityBox.setEnabled(true);
  
  // Header text
  if (saveIndex != -1) {
    headerLabel.setText("Save File #" $ saveIndex);
  } else {
    headerLabel.setText("Autosave");
  }
  
  // Write hero classes
  for (i = 0; i < 3; i++) {
    if (i < displayParty.getPartySize()) {
      // Draw hero information
      heroClassLabels[i].setText(displayParty.getHero(i).myClass);
      heroLevelLabels[i].setText("Lvl " $ displayParty.getHero(i).level);
    } else {
      // Hide hero information
      heroClassLabels[i].setText("");
      heroLevelLabels[i].setText("");
    }
  }
  
  // Show play time
  labelText = "Play time: " $ gameInfo.milestoneCookie.formatMilestoneTime(profile.elapsedPlayTime); 
  labelFont = DEFAULT_SMALL_GREEN;
  partyStatus.setText(labelText);
  partyStatus.setFont(labelFont);
  
  // Show game mode
  switch (profile.gameMode) {
    case MODE_CASUAL:
      labelText = "Casual"; 
      labelFont = DEFAULT_SMALL_CYAN;
      break;
    case MODE_HARDCORE:
      labelText = "Hardcore"; 
      labelFont = DEFAULT_SMALL_ORANGE;
      break;
    case MODE_TOUR:
      labelText = "Tour"; 
      labelFont = DEFAULT_SMALL_GREEN;
      break;
  } 
  activityLabel.setText(labelText);
  activityLabel.setFont(labelFont);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Info sprites
  begin object class=UI_Texture_Info Name=Party_Data_Component
    componentTextures.add(Texture2D'GUI.Team_Manager.Team_Info_Window_Background')
  end object
  begin object class=UI_Texture_Info Name=Party_Activity_Component
    componentTextures.add(Texture2D'GUI.Hyper_Shrine_Text_Box')
  end object
  
  // Party info container background
  begin object class=UI_Sprite Name=Party_Data_Background
    tag="Party_Data_Background" 
    posX=0
    posY=0
    images(0)=Party_Data_Component
  end object
  componentList.add(Party_Data_Background)
  
  // Party header
  begin object class=UI_Label Name=Party_Header_Label
    tag="Party_Header_Label"
    posX=18
    posY=17
    posXEnd=637
    posYEnd=67
    alignX=CENTER
    alignY=CENTER
    padding=(top=0, left=14, right=18, bottom=6)
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="Team #1"
  end object
  componentList.add(Party_Header_Label)
  
  // Hero labels
  begin object class=UI_Label Name=Party_Hero_Class_Label_1
    tag="Party_Hero_Class_Label_1" 
    posX=18
    posY=74
    posXEnd=330
    posYEnd=124
    alignX=LEFT
    alignY=CENTER
    padding=(top=0, left=14, right=18, bottom=6)
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Valkyrie"
  end object
  componentList.add(Party_Hero_Class_Label_1)
  begin object class=UI_Label Name=Party_Hero_Class_Label_2
    tag="Party_Hero_Class_Label_2"
    posX=18
    posY=132
    posXEnd=330
    posYEnd=182
    alignX=LEFT
    alignY=CENTER
    padding=(top=0, left=14, right=18, bottom=6)
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Wizard"
  end object
  componentList.add(Party_Hero_Class_Label_2)
  begin object class=UI_Label Name=Party_Hero_Class_Label_3
    tag="Party_Hero_Class_Label_3"
    posX=18
    posY=190
    posXEnd=330
    posYEnd=240
    alignX=LEFT
    alignY=CENTER
    padding=(top=0, left=14, right=18, bottom=6)
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Goliath"
  end object
  componentList.add(Party_Hero_Class_Label_3)
  
  // Hero level labels
  begin object class=UI_Label Name=Party_Hero_Level_Label_1
    tag="Party_Hero_Level_Label_1" 
    posX=18
    posY=74
    posXEnd=330
    posYEnd=124
    alignX=RIGHT
    alignY=CENTER
    padding=(top=0, left=14, right=18, bottom=6)
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Lvl 5"
  end object
  componentList.add(Party_Hero_Level_Label_1)
  begin object class=UI_Label Name=Party_Hero_Level_Label_2
    tag="Party_Hero_Level_Label_2"
    posX=18
    posY=132
    posXEnd=330
    posYEnd=182
    alignX=RIGHT
    alignY=CENTER
    padding=(top=0, left=14, right=18, bottom=6)
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Lvl 6"
  end object
  componentList.add(Party_Hero_Level_Label_2)
  begin object class=UI_Label Name=Party_Hero_Level_Label_3
    tag="Party_Hero_Level_Label_3"
    posX=18
    posY=190
    posXEnd=330
    posYEnd=240
    alignX=RIGHT
    alignY=CENTER
    padding=(top=0, left=14, right=18, bottom=6)
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Lvl 4"
  end object
  componentList.add(Party_Hero_Level_Label_3)
  
  // Party status
  begin object class=UI_Label Name=Party_Status_Label
    tag="Party_Status_Label"
    posX=342
    posY=74
    posXEnd=637
    posYEnd=124
    alignX=LEFT
    alignY=CENTER
    padding=(top=0, left=14, right=18, bottom=6)
    fontStyle=DEFAULT_SMALL_GREEN
    labelText="Idle"
  end object
  componentList.add(Party_Status_Label)
  
  // Activity Box (fifth continer box)
  begin object class=UI_Sprite Name=Party_Activity_Box
    tag="Party_Activity_Box"
    bEnabled=true
    posX=342
    posY=133
    images(0)=Party_Activity_Component
  end object
  componentList.add(Party_Activity_Box)
  
  // Shrine Activity Label
  begin object class=UI_Label Name=Shrine_Activity_Label
    tag="Shrine_Activity_Label"
    posX=342
    posY=133
    posXEnd=637
    posYEnd=182
    alignX=LEFT
    alignY=CENTER
    padding=(top=0, left=14, right=18, bottom=6)
    fontStyle=DEFAULT_SMALL_TAN
    labelText=""
  end object
  componentList.add(Shrine_Activity_Label)
  
}














