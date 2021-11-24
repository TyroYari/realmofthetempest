/*=============================================================================
 * ROTT_UI_Page_Game_Intro
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Donations, thank yous, and version notes
 *===========================================================================*/
 
class ROTT_UI_Page_Game_Intro extends ROTT_UI_Page;

const BLACK_BAR_COUNT = 60;

// Track time this page has been up
var private float elapsedTime;

// Vertical fade effect time
var private float elapsedEffectTime;
var private bool bTransitionOut;

// Internal references
var private UI_Sprite blackBars[BLACK_BAR_COUNT];

// Navigation variable
var private bool bRedirectToMenu;

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  local UI_Texture_Info texture;
  texture = new class'UI_Texture_Info';
  texture.componentTextures.addItem(Texture2D'GUI.Black_Square');
  
  super.initializeComponent(newTag);
  
  // Column iteration
  for (i = 0; i < BLACK_BAR_COUNT; i++) {
    // Create sprites
    blackBars[i] = new class'UI_Sprite';
    blackBars[i].images.addItem(new class'UI_Texture_Info');
    blackBars[i].modifyTexture(texture);
    componentList.addItem(blackBars[i]);
    blackBars[i].bMandatoryScaleToWindow = true;
    
    // Position black bar sprites across the screen for retro fading effect
    blackBars[i].updatePosition(
      0, 
      i * NATIVE_HEIGHT / BLACK_BAR_COUNT, 
      NATIVE_WIDTH, 
      (i+1) * NATIVE_HEIGHT / BLACK_BAR_COUNT
    );
    blackBars[i].setEnabled(false);
    blackBars[i].drawLayer=TOP_LAYER;
    blackBars[i].initializeComponent();
  }
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Skip effects if not part of intro
  if (!bRedirectToMenu) {
    addEffectToComponent(FADE_OUT, "Fade_Component", 0.6);
  } else {
    findSprite("Fade_Component").setEnabled(false);
  }
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  
}

/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  
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
  
  // Track time that this page has been up
  elapsedTime += deltaTime;
  
  // Column iteration
  if (bTransitionOut) {
    // Track elapsed time for the fading black bars effect
    elapsedEffectTime += deltaTime;
    
    // Adjust the vertical mask over time
    blackBars[0].setVerticalMask(elapsedEffectTime * 1.2);
    
    // Start new game after effect
    if (elapsedEffectTime > 1.35) {
      // Load the NPC intro
      gameInfo.openNPCDialog(class'ROTT_NPC_Aliskus');
      gameInfo.sfxBox.playSfx(SFX_AMBIENT_OMINOUS);
      
      // Start speedrun timer
      gameInfo.playerProfile.bTrackTime = true;
    }
  }
}

/*=============================================================================
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  if (!bRedirectToMenu) startTransitionOut();
}

protected function navigationRoutineB() {
  // Navigation
  if (!bRedirectToMenu) {
    // End of intro
    startTransitionOut();
  } else {
    // Back to menu
    parentScene.popPage();
  }
  
  // Sound effect
  if (!bTransitionOut) sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * startTransitionOut()
 *
 * Called to start the transition into a new game
 *===========================================================================*/
protected function startTransitionOut() {
  local int i;
  
  // Column iteration
  for (i = 0; i < BLACK_BAR_COUNT; i++) {
    blackBars[i].setEnabled(true);
  }
  
  bTransitionOut = true;
  
}

/*=============================================================================
 * Requirements
 *===========================================================================*/
protected function bool requirementRoutineA() { 
  return elapsedTime > 2 || bRedirectToMenu; 
}

protected function bool requirementRoutineB() { 
  return elapsedTime > 2 || bRedirectToMenu; 
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  bRedirectToMenu=false
  
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
  
  /** ===== UI Components ===== **/
  // Black texture
  begin object class=UI_Texture_Info Name=Black_Texture
    componentTextures.add(Texture2D'GUI.Black_Square')
  end object
  
  // Background
  begin object class=UI_Sprite Name=Background_Sprite 
    tag="Background_Sprite"
    bMandatoryScaleToWindow=true
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
  end object
  componentList.add(Background_Sprite)
  
  // Version
  begin object class=UI_Label Name=H1_Label
    tag="H1_Label"
    posX=0
    posY=30
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_LARGE_TAN
    labelText="Realm of the Tempest"
  end object
  componentList.add(H1_Label)
  
  begin object class=UI_Label Name=P1_Label
    tag="P1_Label"
    posX=0
    posY=78
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="Table of Contents"
  end object
  componentList.add(P1_Label)
  
  begin object class=UI_Label Name=H3_Gameplay_Label
    tag="H3_Gameplay_Label"
    posX=0
    posY=125
    posXEnd=620
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="- Gameplay -"
  end object
  componentList.add(H3_Gameplay_Label)
  
  begin object class=UI_Label Name=H3_Story_Label
    tag="H3_Story_Label"
    posX=720
    posY=125
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="- Story -"
  end object
  componentList.add(H3_Story_Label)
  
    // Info
    begin object class=UI_Label Name=Guide_Info_Labels1A
      tag="Guide_Info_Labels1A"
      posX=60
      posY=171
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_RED
      labelText="Campaign 1:  Rhunia"
    end object
    componentList.add(Guide_Info_Labels1A)
    
    begin object class=UI_Label Name=Guide_Info_Labels1B
      tag="Guide_Info_Labels1B"
      posX=60
      posY=203
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Defeat Az'ra Koth the Wicked."
    end object
    componentList.add(Guide_Info_Labels1B)
    
    begin object class=UI_Label Name=Guide_Info_Labels2A
      tag="Guide_Info_Labels2A"
      posX=60
      posY=271
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_GREEN
      labelText="Campaign 2:  Etzland"
    end object
    componentList.add(Guide_Info_Labels2A)
    
    begin object class=UI_Label Name=Guide_Info_Labels2B
      tag="Guide_Info_Labels2B"
      posX=60
      posY=303
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Defeat Hyrix the Storm Raiser."
    end object
    componentList.add(Guide_Info_Labels2B)
    
    begin object class=UI_Label Name=Guide_Info_Labels3A
      tag="Guide_Info_Labels3A"
      posX=60
      posY=371
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_BLUE
      labelText="Campaign 3:  Haxlyn"
    end object
    componentList.add(Guide_Info_Labels3A)
    
    begin object class=UI_Label Name=Guide_Info_Labels3B
      tag="Guide_Info_Labels3B"
      posX=60
      posY=403
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Defeat Khomat the Guardian"
    end object
    componentList.add(Guide_Info_Labels3B)
    
    
    begin object class=UI_Label Name=Guide_Info_Labels4A
      tag="Guide_Info_Labels4A"
      posX=60
      posY=471
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_PURPLE
      labelText="Campaign 4: Valimor"
    end object
    componentList.add(Guide_Info_Labels4A)
    
    begin object class=UI_Label Name=Guide_Info_Labels4C
      tag="Guide_Info_Labels4C"
      posX=350
      posY=471
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_ORANGE
      labelText="(Work in Progress)"
    end object
    componentList.add(Guide_Info_Labels4C)
    
    begin object class=UI_Label Name=Guide_Info_Labels4B
      tag="Guide_Info_Labels4B"
      posX=60
      posY=503
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Defeat Viscorn the Tormentor"
    end object
    componentList.add(Guide_Info_Labels4B)
    
    begin object class=UI_Label Name=Guide_Info_Labels5A
      tag="Guide_Info_Labels5A"
      posX=60
      posY=571
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Campaign 5: Kalroth"
    end object
    componentList.add(Guide_Info_Labels5A)
    
    begin object class=UI_Label Name=Guide_Info_Labels5C
      tag="Guide_Info_Labels5C"
      posX=350
      posY=571
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_RED
      labelText="(Incomplete)"
    end object
    componentList.add(Guide_Info_Labels5C)
    
    begin object class=UI_Label Name=Guide_Info_Labels5B
      tag="Guide_Info_Labels5B"
      posX=60
      posY=603
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Defeat Ginqsu the Magi"
    end object
    componentList.add(Guide_Info_Labels5B)
    
    begin object class=UI_Label Name=Guide_Info_Labels6A
      tag="Guide_Info_Labels6A"
      posX=60
      posY=671
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_GRAY
      labelText="Campaign 6: The Seventh House"
    end object
    componentList.add(Guide_Info_Labels6A)
    
    begin object class=UI_Label Name=Guide_Info_Labels6C
      tag="Guide_Info_Labels6C"
      posX=390
      posY=671
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_RED
      labelText="               (Not Started)"
    end object
    componentList.add(Guide_Info_Labels6C)
    
    begin object class=UI_Label Name=Guide_Info_Labels6B
      tag="Guide_Info_Labels6B"
      posX=60
      posY=703
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Find and stop Dominus, the fallen gatekeeper."
    end object
    componentList.add(Guide_Info_Labels6B)
    
    begin object class=UI_Label Name=Guide_Info_Labels10A
      tag="Guide_Info_Labels10A"
      posX=780
      posY=171
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Obelisk Side Quest"
    end object
    componentList.add(Guide_Info_Labels10A)
    
    begin object class=UI_Label Name=Guide_Info_Labels10C
      tag="Guide_Info_Labels10C"
      posX=1020
      posY=171
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_ORANGE
      labelText="(Work in Progress)"
    end object
    componentList.add(Guide_Info_Labels10C)
    
    begin object class=UI_Label Name=Guide_Info_Labels10B
      tag="Guide_Info_Labels10B"
      posX=780
      posY=203
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Help the Talonovian council decide\n    on the Obelisk conflict."
    end object
    componentList.add(Guide_Info_Labels10B)
    
    begin object class=UI_Label Name=Guide_Info_Labels11A
      tag="Guide_Info_Labels11A"
      posX=780
      posY=271
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_BLUE
      labelText="Rescuing Teammates"
    end object
    componentList.add(Guide_Info_Labels11A)
    
    begin object class=UI_Label Name=Guide_Info_Labels11C
      tag="Guide_Info_Labels11C"
      posX=1110
      posY=271
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_ORANGE
      labelText=""
    end object
    componentList.add(Guide_Info_Labels11C)
    
    begin object class=UI_Label Name=Guide_Info_Labels11B
      tag="Guide_Info_Labels11B"
      posX=780
      posY=303
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Rescue your first teammate from the\n    Prison of Etzland Citadel."
    end object
    componentList.add(Guide_Info_Labels11B)
    
    begin object class=UI_Label Name=Guide_Info_Labels12A
      tag="Guide_Info_Labels12A"
      posX=780
      posY=371
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Tomb of the Priestess"
    end object
    componentList.add(Guide_Info_Labels12A)
    
    begin object class=UI_Label Name=Guide_Info_Labels12C
      tag="Guide_Info_Labels12C"
      posX=1065
      posY=371
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_ORANGE
      labelText="(Work in Progress)"
    end object
    componentList.add(Guide_Info_Labels12C)
    
    begin object class=UI_Label Name=Guide_Info_Labels12B
      tag="Guide_Info_Labels12B"
      posX=780
      posY=403
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Choose to harvest the blossoms of\n    the priestess's tomb, or not."
    end object
    componentList.add(Guide_Info_Labels12B)
    
    begin object class=UI_Label Name=Guide_Info_Labels13A
      tag="Guide_Info_Labels13A"
      posX=780
      posY=471
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Golem's Slumber Side Quest"
    end object
    componentList.add(Guide_Info_Labels13A)
    
    begin object class=UI_Label Name=Guide_Info_Labels13C
      tag="Guide_Info_Labels13C"
      posX=1105
      posY=471
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_ORANGE
      labelText="     (Work in Progress)"
    end object
    componentList.add(Guide_Info_Labels13C)
    
    begin object class=UI_Label Name=Guide_Info_Labels13B
      tag="Guide_Info_Labels13B"
      posX=780
      posY=503
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Free the ancient golems from slumber,\n    or let them rest for eternity."
    end object
    componentList.add(Guide_Info_Labels13B)
    
    begin object class=UI_Label Name=Guide_Info_Labels14A
      tag="Guide_Info_Labels14A"
      posX=780
      posY=571
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_WHITE
      labelText="Main Questline"
    end object
    componentList.add(Guide_Info_Labels14A)
    
    begin object class=UI_Label Name=Guide_Info_Labels14C
      tag="Guide_Info_Labels14C"
      posX=990
      posY=571
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_ORANGE
      labelText="(Work in Progress)"
    end object
    componentList.add(Guide_Info_Labels14C)
    
    begin object class=UI_Label Name=Guide_Info_Labels14B
      tag="Guide_Info_Labels14B"
      posX=780
      posY=603
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Collect the golden ornaments of\n    chaos, restore order to the realm."
    end object
    componentList.add(Guide_Info_Labels14B)
    
  ///begin object class=UI_Label Name=P2_Label
  ///  tag="P2_Label"
  ///  posX=0
  ///  posY=188
  ///  posXEnd=NATIVE_WIDTH
  ///  posYEnd=NATIVE_HEIGHT
  ///  alignX=CENTER
  ///  alignY=TOP
  ///  fontStyle=DEFAULT_LARGE_TAN
  ///  labelText=""
  ///end object
  ///componentList.add(P2_Label)
  ///begin object class=UI_Label Name=P3_Label
  ///  tag="P3_Label"
  ///  posX=0
  ///  posY=228
  ///  posXEnd=NATIVE_WIDTH
  ///  posYEnd=NATIVE_HEIGHT
  ///  alignX=CENTER
  ///  alignY=TOP
  ///  fontStyle=DEFAULT_MEDIUM_WHITE
  ///  labelText=""
  ///end object
  ///componentList.add(P3_Label)
  ///
  ///begin object class=UI_Label Name=P4_Label
  ///  tag="P4_Label"
  ///  posX=0
  ///  posY=308
  ///  posXEnd=NATIVE_WIDTH
  ///  posYEnd=NATIVE_HEIGHT
  ///  alignX=CENTER
  ///  alignY=TOP
  ///  fontStyle=DEFAULT_LARGE_GREEN
  ///  labelText="Open source on Github.com/Otays"
  ///end object
  ///componentList.add(P4_Label)
  ///begin object class=UI_Label Name=P5_Label
  ///  tag="P5_Label"
  ///  posX=0
  ///  posY=348
  ///  posXEnd=NATIVE_WIDTH
  ///  posYEnd=NATIVE_HEIGHT
  ///  alignX=CENTER
  ///  alignY=TOP
  ///  fontStyle=DEFAULT_MEDIUM_WHITE
  ///  labelText="All art and code made public for educational use."
  ///end object
  ///componentList.add(P5_Label)
  ///
  ///begin object class=UI_Label Name=H2_Donor_Label
  ///  tag="H2_Donor_Label"
  ///  posX=0
  ///  posY=448
  ///  posXEnd=NATIVE_WIDTH
  ///  posYEnd=NATIVE_HEIGHT
  ///  alignX=CENTER
  ///  alignY=TOP
  ///  fontStyle=DEFAULT_LARGE_TAN
  ///  labelText="- Donation Squad -"
  ///end object
  ///componentList.add(H2_Donor_Label)
  ///begin object class=UI_Label Name=Donor_List_Label_1
  ///  tag="Donor_List_Label_1"
  ///  posX=0
  ///  posY=508
  ///  posXEnd=NATIVE_WIDTH
  ///  posYEnd=NATIVE_HEIGHT
  ///  alignX=CENTER
  ///  alignY=TOP
  ///  fontStyle=DEFAULT_MEDIUM_CYAN
  ///  labelText="Phillis Emril Productions, XenoJB, val, formerfuture, Dustin Pundt, Gaiashield, cydy,"
  ///end object
  ///componentList.add(Donor_List_Label_1)
  ///begin object class=UI_Label Name=Donor_List_Label_2
  ///  tag="Donor_List_Label_2"
  ///  posX=0
  ///  posY=548
  ///  posXEnd=NATIVE_WIDTH
  ///  posYEnd=NATIVE_HEIGHT
  ///  alignX=CENTER
  ///  alignY=TOP
  ///  fontStyle=DEFAULT_MEDIUM_CYAN
  ///  labelText="Loud Pockets, Dumpis, Avnova, The Wolverine, Grimnir, Poe Link, lelia, sc0ttmst, Phantom"
  ///end object
  ///componentList.add(Donor_List_Label_2)
  ///begin object class=UI_Label Name=Donor_List_Label_3
  ///  tag="Donor_List_Label_3"
  ///  posX=0
  ///  posY=588
  ///  posXEnd=NATIVE_WIDTH
  ///  posYEnd=NATIVE_HEIGHT
  ///  alignX=CENTER
  ///  alignY=TOP
  ///  fontStyle=DEFAULT_MEDIUM_CYAN
  ///  labelText="Summoner99, JD"
  ///end object
  ///componentList.add(Donor_List_Label_3)
  
  begin object class=UI_Label Name=P6_Label
    tag="P6_Label"
    posX=0
    posY=768
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_SMALL_GRAY
    labelText="RealmOfTheTempest@gmail.com"
  end object
  componentList.add(P6_Label)
  begin object class=UI_Label Name=P7_Label
    tag="P7_Label"
    posX=0
    posY=798
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_SMALL_GRAY
    labelText="www.RealmOfTheTempest.com"
  end object
  componentList.add(P7_Label)
  begin object class=UI_Label Name=P8_Label
    tag="P8_Label"
    posX=0
    posY=828
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_SMALL_GRAY
    labelText="twitter.com/BrambleGate"
  end object
  componentList.add(P8_Label)

  // Fade effects
  begin object class=UI_Sprite Name=Fade_Component
    tag="Fade_Component"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
  end object
  componentList.add(Fade_Component)
  
}



