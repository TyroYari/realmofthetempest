/*=============================================================================
 * ROTT_UI_Page_Passive_Shrine_Management
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Users are shown reset skill information through this interface.
 *===========================================================================*/

class ROTT_UI_Page_Passive_Shrine_Management extends ROTT_UI_Page;

// External References
var privatewrite ROTT_UI_Scene_Party_Manager someScene;
var public ROTT_Party targetParty;

// Internal References
var privatewrite UI_Selector menuSelector;
var privatewrite ROTT_UI_Displayer_Shrine_Reward shrineReward1;
var privatewrite ROTT_UI_Displayer_Shrine_Reward shrineReward2;

// Selection variables
var privatewrite PassiveShrineActivies selectedShrine;

// Display text
var private array<string> headers;
var private array<string> subHeaders;
var private array<FontStyles> headerFonts;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // External References
  someScene = ROTT_UI_Scene_Party_Manager(outer);
  
  // Internal References
  menuSelector = UI_Selector(findComp("Shrine_Selector"));
  shrineReward1 = ROTT_UI_Displayer_Shrine_Reward(findComp("Reward_1_Displayer"));
  shrineReward2 = ROTT_UI_Displayer_Shrine_Reward(findComp("Reward_2_Displayer"));
  
}

/*=============================================================================
 * refresh()
 *
 * Called to update the gold and gems
 *===========================================================================*/
public function refresh() {
  local HyperShrineDescriptor hyperRewards;
  
  // Set selection
  selectedShrine = PassiveShrineActivies(menuSelector.getSelection() + 1);
  
  // Store hyper rewards
  hyperRewards = class'ROTT_Descriptor_Hyper_Shrine_List'.static.getShrineRewards(selectedShrine);
  
  // Set header and sub header
  findLabel("Header_Label").setText(headers[menuSelector.getSelection() / 4]);
  findLabel("Header_Label").setFont(headerFonts[menuSelector.getSelection() / 4]);
  findLabel("Sub_Header_Label").setText(subHeaders[menuSelector.getSelection()]);
  
  // Preview image
  findSprite("Shrine_Preview_Sprite").setDrawIndex(selectedShrine);
  
  // Prowess level
  switch (menuSelector.getSelection() / 4) {
    case 0:
      findLabel("Prowess_Level_Decoration").setFont(DEFAULT_MEDIUM_CYAN);
      findLabel("Prowess_Level_Label").setText(
        "Spiritual Prowess: " $ targetParty.getSpiritualProwess()
      );
      break;
    case 1:
      findLabel("Prowess_Level_Decoration").setFont(DEFAULT_MEDIUM_ORANGE);
      findLabel("Prowess_Level_Label").setText(
        "Hunting Prowess: " $ targetParty.getHuntingProwess()
      );
      break;
    case 2:
      findLabel("Prowess_Level_Decoration").setFont(DEFAULT_MEDIUM_GREEN);
      findLabel("Prowess_Level_Label").setText(
        "Botanical Prowess: " $ targetParty.getBotanicalProwess()
      );
      break;
  }
  
  // Reward info
  shrineReward1.setRewardInfo(
    hyperRewards.firstReward
  );
  shrineReward2.setRewardInfo(
    hyperRewards.secondReward
  );
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  menuSelector.resetSelection();
  
  refresh();
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * 
 *===========================================================================*/
event onPopPageEvent() {
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateUp() { refresh(); }
public function onNavigateDown() { refresh(); }

/*=============================================================================
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  // Set shrine
  targetParty.setShrineActivity(selectedShrine);
  
  // Navigate back
  someScene.popPage(tag);
  someScene.popPage("Page_Party_Viewer");
  
  // Play Sound
  sfxBox.playSfx(SFX_MENU_BLESS_STAT);
}

protected function navigationRoutineB() {
  // Navigate back
  someScene.popPage();
  
  // Play Sound
  sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Headers
  subHeaders(0)="Cleric's Shrine"
  subHeaders(1)="Cobalt Sanctum"
  subHeaders(2)="The Rosette Pillars"
  subHeaders(3)="Lockspire Shrine"
  
  subHeaders(4)="Of The Undead"
  subHeaders(5)="Of The Demonic"
  subHeaders(6)="Of The Serpentine"
  subHeaders(7)="Of The Beasts"
  
  subHeaders(8)="Hawkspire Meadow"
  subHeaders(9)="Laceroot Shrine"
  subHeaders(10)="Fatewood Grove"
  subHeaders(11)="Myrrhian Thicket"
  
  // Subheaders
  headers(0)="Shrine of Worship"
  headers(1)="Hunting Grounds"
  headers(2)="Botanical Garden"

  headerFonts(0)=DEFAULT_LARGE_CYAN
  headerFonts(1)=DEFAULT_LARGE_ORANGE
  headerFonts(2)=DEFAULT_LARGE_GREEN

  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Preview shrines
  begin object class=UI_Texture_Info Name=Shrine_Preview_Clerics_Shrine
    componentTextures.add(Texture2D'GUI.Team_Manager.Preview_Clerics_Shrine')
  end object
  
  // Background
  begin object class=UI_Texture_Info Name=Background_Texture
    componentTextures.add(Texture2D'GUI.Team_Manager.Passive_Shrine_Background')
  end object
  
  /** ===== UI Components ===== **/
  // Shrine Preview
  begin object class=UI_Sprite Name=Shrine_Preview_Sprite
    tag="Shrine_Preview_Sprite"
    posX=587
    posY=148
    
    images(0)=Shrine_Preview_Clerics_Shrine
    
    images(CLERICS_SHRINE)=Shrine_Preview_Clerics_Shrine
    images(COBALT_SANCTUM)=Shrine_Preview_Clerics_Shrine
    images(THE_ROSETTE_PILLARS)=Shrine_Preview_Clerics_Shrine
    images(LOCKSPIRE_SHRINE)=Shrine_Preview_Clerics_Shrine
    
    images(THE_UNDEAD)=Shrine_Preview_Clerics_Shrine
    images(THE_DEMONIC)=Shrine_Preview_Clerics_Shrine
    images(THE_SERPENTINE)=Shrine_Preview_Clerics_Shrine
    images(THE_BEASTS)=Shrine_Preview_Clerics_Shrine
    
    images(HAWKSPIRE_MEADOW)=Shrine_Preview_Clerics_Shrine
    images(LACEROOT_SHRINE)=Shrine_Preview_Clerics_Shrine
    images(FATEWOOD_GROVE)=Shrine_Preview_Clerics_Shrine
    images(MYRRHIAN_THICKET)=Shrine_Preview_Clerics_Shrine
    
  end object
  componentList.add(Shrine_Preview_Sprite)
  
  // Background Sprite
  begin object class=UI_Sprite Name=Background_Sprite
    tag="Background_Sprite"
    posX=0
    posY=0
    images(0)=Background_Texture
  end object
  componentList.add(Background_Sprite)
  
  // Shrine Selection Box
  begin object class=UI_Selector Name=Shrine_Selector
    tag="Shrine_Selector"
    bEnabled=true
    posX=57
    posY=57
    navigationType=SELECTION_VERTICAL
    selectionOffset=(x=0,y=55)
    numberOfMenuOptions=12
    
    // Render offsets
    renderOffsets(0)=(xCoord=0,yCoord=4,xOffset=0,yOffset=58)
    renderOffsets(1)=(xCoord=0,yCoord=5,xOffset=0,yOffset=58)
    renderOffsets(2)=(xCoord=0,yCoord=6,xOffset=0,yOffset=58)
    renderOffsets(3)=(xCoord=0,yCoord=7,xOffset=0,yOffset=58)
    
    renderOffsets(4)=(xCoord=0,yCoord=8,xOffset=0,yOffset=116)
    renderOffsets(5)=(xCoord=0,yCoord=9,xOffset=0,yOffset=116)
    renderOffsets(6)=(xCoord=0,yCoord=10,xOffset=0,yOffset=116)
    renderOffsets(7)=(xCoord=0,yCoord=11,xOffset=0,yOffset=116)
    
    // Hover Coordinates
    hoverCoords(0)=(xStart=62,yStart=57,xEnd=480,yEnd=114)
    hoverCoords(1)=(xStart=62,yStart=112,xEnd=480,yEnd=169)
    hoverCoords(2)=(xStart=62,yStart=167,xEnd=480,yEnd=224)
    hoverCoords(3)=(xStart=62,yStart=222,xEnd=480,yEnd=279)
    
    hoverCoords(4)=(xStart=62,yStart=335,xEnd=480,yEnd=392)
    hoverCoords(5)=(xStart=62,yStart=390,xEnd=480,yEnd=447)
    hoverCoords(6)=(xStart=62,yStart=445,xEnd=480,yEnd=502)
    hoverCoords(7)=(xStart=62,yStart=500,xEnd=480,yEnd=557)
    
    hoverCoords(8)=(xStart=62,yStart=613,xEnd=480,yEnd=670)
    hoverCoords(9)=(xStart=62,yStart=668,xEnd=480,yEnd=725)
    hoverCoords(10)=(xStart=62,yStart=723,xEnd=480,yEnd=780)
    hoverCoords(11)=(xStart=62,yStart=778,xEnd=480,yEnd=835)
    
    // Selector texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Team_Manager.Shrine_Selector')
    end object
    
    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Shrine_Selector)
  
  // Header label
  begin object class=UI_Label Name=Header_Label
    tag="Header_Label"
    posX=586
    posY=36
    posXEnd=1352
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_LARGE_CYAN
    AlignX=CENTER
    AlignY=TOP
    labelText="Shrine of Worship"
  end object
  componentList.add(Header_Label)
  
  // Sub Header label
  begin object class=UI_Label Name=Sub_Header_Label
    tag="Sub_Header_Label"
    posX=586
    posY=80
    posXEnd=1352
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_MEDIUM_GOLD
    AlignX=CENTER
    AlignY=TOP
    labelText="Cleric's Shrine"
  end object
  componentList.add(Sub_Header_Label)
  
  // Reward 1 Displayer
  begin object class=ROTT_UI_Displayer_Shrine_Reward Name=Reward_1_Displayer
    tag="Reward_1_Displayer"
    posX=380
    posY=626
  end object
  componentList.add(Reward_1_Displayer)
  
  // Reward 2 Displayer
  begin object class=ROTT_UI_Displayer_Shrine_Reward Name=Reward_2_Displayer
    tag="Reward_2_Displayer"
    posX=828
    posY=626
  end object
  componentList.add(Reward_2_Displayer)
  
  // Prowess Level Label
  begin object class=UI_Label Name=Prowess_Level_Label
    tag="Prowess_Level_Label"
    posX=586
    posY=796
    posXEnd=1352
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_MEDIUM_GOLD
    AlignX=CENTER
    AlignY=TOP
    labelText="Prowess level: "
  end object
  componentList.add(Prowess_Level_Label)
  
  // Prowess Level Decoration
  begin object class=UI_Label Name=Prowess_Level_Decoration
    tag="Prowess_Level_Decoration"
    posX=586
    posY=796
    posXEnd=1352
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_MEDIUM_CYAN
    AlignX=CENTER
    AlignY=TOP
    labelText="***                                                                            ***"
  end object
  componentList.add(Prowess_Level_Decoration)
  
}













