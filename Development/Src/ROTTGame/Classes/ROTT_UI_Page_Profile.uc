/*=============================================================================
 * ROTT_UI_Page_Profile
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *
 *===========================================================================*/
 
class ROTT_UI_Page_Profile extends ROTT_UI_Page;

// Internal references
var private UI_Label labelHeroName;
var private UI_Label labelGameMode;
var private UI_Label labelGameTime;
var private UI_Label labelHeroCount;
var private UI_Label labelPartyCount;
var private UI_Label labelTotalGold;
var private UI_Label labelTotalGems;
var private UI_Label labelTotalEncounters;
var private UI_Label labelTotalSlainCount;
var private UI_Label labelTotalBossCount;

var private UI_Label labelTemporal;
var private UI_Label labelTimeSaved;

var private UI_Label labelSpeedRunAzra;
var private UI_Label labelSpeedRunHyrix;
var private UI_Label labelSpeedRunKhomat;
var private UI_Label labelSpeedRunViscorn;
var private UI_Label labelSpeedRunGinqsu;

var private UI_Label labelBestAzra;
var private UI_Label labelBestHyrix;
var private UI_Label labelBestKhomat;
var private UI_Label labelBestViscorn;
var private UI_Label labelBestGinqsu;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  labelHeroName = UI_Label(findComp("Profile_Value_Hero_Name"));
  labelGameMode = UI_Label(findComp("Profile_Value_Profile_Mode"));
  labelGameTime = UI_Label(findComp("Profile_Value_Profile_Time"));
  labelHeroCount = UI_Label(findComp("Profile_Value_Hero_Count"));
  labelPartyCount = UI_Label(findComp("Profile_Value_Party_Count"));
  labelTotalGold = UI_Label(findComp("Profile_Value_Total_Gold"));
  labelTotalGems = UI_Label(findComp("Profile_Value_Total_Gems"));
  labelTotalEncounters = UI_Label(findComp("Profile_Value_Total_Encounters"));
  labelTotalSlainCount = UI_Label(findComp("Profile_Value_Monsers_Slain"));
  labelTotalBossCount = UI_Label(findComp("Profile_Value_Bosses_Slain"));
  
  labelTemporal = UI_Label(findComp("Profile_Value_Temporal_Use"));
  labelTimeSaved = UI_Label(findComp("Profile_Value_Time_Saved"));
  
  // Speed labels
  labelSpeedRunAzra = UI_Label(findComp("Profile_Value_Azra"));
  labelSpeedRunHyrix = UI_Label(findComp("Profile_Value_Hyrix"));
  labelSpeedRunKhomat = UI_Label(findComp("Profile_Value_Khomat"));
  labelSpeedRunViscorn = UI_Label(findComp("Profile_Value_Viscorn"));
  labelSpeedRunGinqsu = UI_Label(findComp("Profile_Value_Ginqsu"));
  
  // Best times
  labelBestAzra = UI_Label(findComp("Profile_Value_Azra_Best"));
  labelBestHyrix = UI_Label(findComp("Profile_Value_Hyrix_Best"));
  labelBestKhomat = UI_Label(findComp("Profile_Value_Khomat_Best"));
  labelBestViscorn = UI_Label(findComp("Profile_Value_Viscorn_Best"));
  labelBestGinqsu = UI_Label(findComp("Profile_Value_Ginqsu_Best"));
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Render profile information
  refresh();
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  // Elapsed game time
  labelGameTime.setText(
    gameInfo.milestoneCookie.formatMilestoneTime(
      gameInfo.playerProfile.elapsedPlayTime
    )
  );
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  // Game mode info
  switch (gameInfo.playerProfile.gameMode) {
    case MODE_CASUAL:
      labelGameMode.setText("Casual");
      labelGameMode.setFont(DEFAULT_SMALL_CYAN);
      break;
    case MODE_HARDCORE:
      labelGameMode.setText("Hardcore");
      labelGameMode.setFont(DEFAULT_SMALL_RED);
      break;
    case MODE_TOUR:
      labelGameMode.setText("Tour");
      labelGameMode.setFont(DEFAULT_SMALL_GREEN);
      break;
  }
  
  // Render profile information
  labelHeroName.setText(gameInfo.playerProfile.username);
  labelHeroCount.setText(gameInfo.playerProfile.getHeroCount());
  labelPartyCount.setText(gameInfo.playerProfile.getNumberOfParties());
  labelTotalGold.setText(gameInfo.playerProfile.getTotalGoldEarned());
  labelTotalGems.setText(gameInfo.playerProfile.getTotalGemsEarned());
  labelTotalEncounters.setText(gameInfo.playerProfile.getEncounterCount());
  labelTotalSlainCount.setText(gameInfo.playerProfile.getTotalMonstersSlain());
  labelTotalBossCount.setText(gameInfo.playerProfile.getTotalBossesSlain());
  
  labelTemporal.setText(gameInfo.playerProfile.timeTemporallyAccelerated);
  labelTimeSaved.setText(3 * gameInfo.playerProfile.timeTemporallyAccelerated);
  
  // This Profile's Speedrun times
  labelSpeedRunAzra.setText(gameinfo.playerProfile.milestoneList[MILESTONE_AZRA_KOTH].milestoneTimeFormatted);
  labelSpeedRunHyrix.setText(gameinfo.playerProfile.milestoneList[MILESTONE_HYRIX].milestoneTimeFormatted);
  labelSpeedRunKhomat.setText(gameinfo.playerProfile.milestoneList[MILESTONE_KHOMAT].milestoneTimeFormatted);
  labelSpeedRunViscorn.setText(gameinfo.playerProfile.milestoneList[MILESTONE_VISCORN].milestoneTimeFormatted);
  labelSpeedRunGinqsu.setText(gameinfo.playerProfile.milestoneList[MILESTONE_GINQSU].milestoneTimeFormatted);
  
  // Best Speedrun times
  labelBestAzra.setText(gameinfo.milestoneCookie.formatMilestoneTime(gameinfo.milestoneCookie.bestTimes[MILESTONE_AZRA_KOTH]));
  labelBestHyrix.setText(gameinfo.milestoneCookie.formatMilestoneTime(gameinfo.milestoneCookie.bestTimes[MILESTONE_HYRIX]));
  labelBestKhomat.setText(gameinfo.milestoneCookie.formatMilestoneTime(gameinfo.milestoneCookie.bestTimes[MILESTONE_KHOMAT]));
  labelBestViscorn.setText(gameinfo.milestoneCookie.formatMilestoneTime(gameinfo.milestoneCookie.bestTimes[MILESTONE_VISCORN]));
  labelBestGinqsu.setText(gameinfo.milestoneCookie.formatMilestoneTime(gameinfo.milestoneCookie.bestTimes[MILESTONE_GINQSU]));
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function bool preNavigateUp();
public function bool preNavigateDown();

public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  
}

protected function navigationRoutineB() {
  // Sfx
  gameinfo.sfxBox.playSFX(SFX_MENU_BACK);
  
  // Pop this page
  parentScene.popPage();
}

 
/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  posX=0
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Profile Background
  begin object class=UI_Texture_Info Name=Profile_Background
    componentTextures.add(Texture2D'GUI.Profile_Background')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Background
    tag="Background"
    posX=0
    posY=0
    images(0)=Profile_Background
  end object
  componentList.add(Background)

  // Statistic Labels
  begin object class=UI_Label Name=Profile_Info_Labels0
    tag="Profile_Info_Labels0"
    posX=333
    posY=75
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_LARGE_GREEN
    labelText="Name:"
  end object
  componentList.add(Profile_Info_Labels0)
  
  begin object class=UI_Label Name=Profile_Info_Labels00
    tag="Profile_Info_Labels00"
    posX=333
    posY=151
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Mode:"
  end object
  componentList.add(Profile_Info_Labels00)
  
  begin object class=UI_Label Name=Profile_Info_Labels000
    tag="Profile_Info_Labels000"
    posX=333
    posY=201
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Time:"
  end object
  componentList.add(Profile_Info_Labels000)
  
  begin object class=UI_Label Name=Profile_Info_Labels1
    tag="Profile_Info_Labels1"
    posX=60
    posY=151
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Heroes:"
  end object
  componentList.add(Profile_Info_Labels1)
  
  begin object class=UI_Label Name=Profile_Info_Labels2
    tag="Profile_Info_Labels2"
    posX=60
    posY=201
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Parties:"
  end object
  componentList.add(Profile_Info_Labels2)
  
  begin object class=UI_Label Name=Profile_Info_Labels3
    tag="Profile_Info_Labels3"
    posX=60
    posY=251
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Gold Earned:"
  end object
  componentList.add(Profile_Info_Labels3)
  
  begin object class=UI_Label Name=Profile_Info_Labels4
    tag="Profile_Info_Labels4"
    posX=60
    posY=301
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Gems Earned:"
  end object
  componentList.add(Profile_Info_Labels4)
  
  begin object class=UI_Label Name=Profile_Info_Labels5
    tag="Profile_Info_Labels5"
    posX=60
    posY=351
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Encounters:"
  end object
  componentList.add(Profile_Info_Labels5)
  
  begin object class=UI_Label Name=Profile_Info_Labels6
    tag="Profile_Info_Labels6"
    posX=60
    posY=401
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Monsters Slain:"
  end object
  componentList.add(Profile_Info_Labels6)
  
  begin object class=UI_Label Name=Profile_Info_Labels7
    tag="Profile_Info_Labels7"
    posX=60
    posY=451
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Bosses Slain:"
  end object
  componentList.add(Profile_Info_Labels7)
  
  begin object class=UI_Label Name=Profile_Info_Labels8
    tag="Profile_Info_Labels8"
    posX=60
    posY=501
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Temporal Use:"
  end object
  componentList.add(Profile_Info_Labels8)
  
  begin object class=UI_Label Name=Profile_Info_Labels9
    tag="Profile_Info_Labels9"
    posX=60
    posY=551
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Time Saved:"
  end object
  componentList.add(Profile_Info_Labels9)
  
  begin object class=UI_Label Name=Profile_Info_Labels10
    tag="Profile_Info_Labels10"
    posX=60
    posY=601
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_CYAN
    labelText="Az'ra Time:"
  end object
  componentList.add(Profile_Info_Labels10)
  
  begin object class=UI_Label Name=Profile_Info_Labels11
    tag="Profile_Info_Labels11"
    posX=60
    posY=651
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_CYAN
    labelText="Hyrix Time:"
  end object
  componentList.add(Profile_Info_Labels11)
  
  begin object class=UI_Label Name=Profile_Info_Labels12
    tag="Profile_Info_Labels12"
    posX=60
    posY=701
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_CYAN
    labelText="Khomat Time:"
  end object
  componentList.add(Profile_Info_Labels12)
  
  begin object class=UI_Label Name=Profile_Info_Labels13
    tag="Profile_Info_Labels13"
    posX=60
    posY=751
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_CYAN
    labelText="Viscorn Time:"
  end object
  componentList.add(Profile_Info_Labels13)
  
  begin object class=UI_Label Name=Profile_Info_Labels14
    tag="Profile_Info_Labels14"
    posX=60
    posY=801
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_CYAN
    labelText="Ginqsu Time:"
  end object
  componentList.add(Profile_Info_Labels14)
      
    begin object class=UI_Label Name=Profile_Info_Labels15
      tag="Profile_Info_Labels15"
      posX=400
      posY=601
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Best:"
    end object
    componentList.add(Profile_Info_Labels15)
    
    begin object class=UI_Label Name=Profile_Info_Labels16
      tag="Profile_Info_Labels16"
      posX=400
      posY=651
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Best:"
    end object
    componentList.add(Profile_Info_Labels16)
    
    begin object class=UI_Label Name=Profile_Info_Labels17
      tag="Profile_Info_Labels17"
      posX=400
      posY=701
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Best:"
    end object
    componentList.add(Profile_Info_Labels17)
    
    begin object class=UI_Label Name=Profile_Info_Labels18
      tag="Profile_Info_Labels18"
      posX=400
      posY=751
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Best:"
    end object
    componentList.add(Profile_Info_Labels18)
    
    begin object class=UI_Label Name=Profile_Info_Labels19
      tag="Profile_Info_Labels19"
      posX=400
      posY=801
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Best:"
    end object
    componentList.add(Profile_Info_Labels19)
    
  // Statistic Values - Profile name
  begin object class=UI_Label Name=Profile_Value_Hero_Name
    tag="Profile_Value_Hero_Name"
    posX=463
    posY=75
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_LARGE_WHITE
    labelText="#n"
  end object
  componentList.add(Profile_Value_Hero_Name)
  
  begin object class=UI_Label Name=Profile_Value_Profile_Mode
    tag="Profile_Value_Profile_Mode"
    posX=419
    posY=151
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText=""
  end object
  componentList.add(Profile_Value_Profile_Mode)
  
  begin object class=UI_Label Name=Profile_Value_Profile_Time
    tag="Profile_Value_Profile_Time"
    posX=419
    posY=201
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText=""
  end object
  componentList.add(Profile_Value_Profile_Time)
  
  // Statistic Values - Hero count
  begin object class=UI_Label Name=Profile_Value_Hero_Count
    tag="Profile_Value_Hero_Count"
    posY=151
    posX=172
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="#h"
  end object
  componentList.add(Profile_Value_Hero_Count)
  
  // Statistic Values - Party count
  begin object class=UI_Label Name=Profile_Value_Party_Count
    tag="Profile_Value_Party_Count"
    posY=201
    posX=172
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="#p"
  end object
  componentList.add(Profile_Value_Party_Count)
  
  // Statistic Values - Gold
  begin object class=UI_Label Name=Profile_Value_Total_Gold
    tag="Profile_Value_Total_Gold"
    posY=251
    posX=248
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="#g1"
  end object
  componentList.add(Profile_Value_Total_Gold)
  
  // Statistic Values - Gems
  begin object class=UI_Label Name=Profile_Value_Total_Gems
    tag="Profile_Value_Total_Gems"
    posY=301
    posX=244
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="#g2"
  end object
  componentList.add(Profile_Value_Total_Gems)
  
  // Statistic Values - Encounters
  begin object class=UI_Label Name=Profile_Value_Total_Encounters
    tag="Profile_Value_Total_Encounters"
    posY=351
    posX=233
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="#e"
  end object
  componentList.add(Profile_Value_Total_Encounters)
  
  // Statistic Values - Slain count
  begin object class=UI_Label Name=Profile_Value_Monsers_Slain
    tag="Profile_Value_Monsers_Slain"
    posY=401
    posX=273
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="#m"
  end object
  componentList.add(Profile_Value_Monsers_Slain)
  
  begin object class=UI_Label Name=Profile_Value_Bosses_Slain
    tag="Profile_Value_Bosses_Slain"
    posY=451
    posX=223
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="#b"
  end object
  componentList.add(Profile_Value_Bosses_Slain)
  
  begin object class=UI_Label Name=Profile_Value_Temporal_Use
    tag="Profile_Value_Temporal_Use"
    posY=501
    posX=249
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="#t1"
  end object
  componentList.add(Profile_Value_Temporal_Use)
  
  begin object class=UI_Label Name=Profile_Value_Time_Saved
    tag="Profile_Value_Time_Saved"
    posY=551
    posX=213
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="#t2"
  end object
  componentList.add(Profile_Value_Time_Saved)
  
  
  // Speedruns
  begin object class=UI_Label Name=Profile_Value_Azra
    tag="Profile_Value_Azra"
    posY=601
    posX=214
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Azra)
  
  // Speedruns
  begin object class=UI_Label Name=Profile_Value_Hyrix
    tag="Profile_Value_Hyrix"
    posY=651
    posX=219
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Hyrix)
  
  // Speedruns
  begin object class=UI_Label Name=Profile_Value_Khomat
    tag="Profile_Value_Khomat"
    posY=701
    posX=247
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Khomat)
  
  // Speedruns
  begin object class=UI_Label Name=Profile_Value_Viscorn
    tag="Profile_Value_Viscorn"
    posY=751
    posX=254
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Viscorn)
  
  // Speedruns
  begin object class=UI_Label Name=Profile_Value_Ginqsu
    tag="Profile_Value_Ginqsu"
    posY=801
    posX=280
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Ginqsu)
  
  
  
  // Best speedruns
  begin object class=UI_Label Name=Profile_Value_Azra_Best
    tag="Profile_Value_Azra_Best"
    posY=601
    posX=475
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Azra_Best)
  
  // Best speedruns
  begin object class=UI_Label Name=Profile_Value_Hyrix_Best
    tag="Profile_Value_Hyrix_Best"
    posY=651
    posX=475
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Hyrix_Best)
  
  // Best speedruns
  begin object class=UI_Label Name=Profile_Value_Khomat_Best
    tag="Profile_Value_Khomat_Best"
    posY=701
    posX=475
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Khomat_Best)
  
  // Best speedruns
  begin object class=UI_Label Name=Profile_Value_Viscorn_Best
    tag="Profile_Value_Viscorn_Best"
    posY=751
    posX=475
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Viscorn_Best)
  
  // Best speedruns
  begin object class=UI_Label Name=Profile_Value_Ginqsu_Best
    tag="Profile_Value_Ginqsu_Best"
    posY=801
    posX=475
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="N/A"
  end object
  componentList.add(Profile_Value_Ginqsu_Best)
  
}











