/*============================================================================= 
 * ROTT_UI_Page_Over_World
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays player info through the 3D levels
 *===========================================================================*/
 
class ROTT_UI_Page_Over_World extends ROTT_UI_Page;

const NOTIFY_GAMEPLAY_LERP_TO_POSY = 720;  // Destination for gameplay notifications
const NOTIFY_GAMEPLAY_DURATION = 0.25;     // Time in seconds for lerp

// Parent scene
var private ROTT_UI_Scene_Over_World someScene;

// Time controls
var public ROTT_Timer startGameDelayTimer;  // Used to animate area title and screen fade
var public float introInputDelay;          // Used to ignore inputs until fade in
var public float hideNotificationDelay;    // Resets direction of gameplay notification

// Internal references
var privatewrite UI_Container singingGraphic;
var privatewrite ROTT_UI_Displayer_Party partyComponent;
var privatewrite UI_Container prayingGraphic;

var privatewrite ROTT_UI_Displayer_Map_Title mapTitle;
var privatewrite UI_Label speedrunNotification;
var privatewrite UI_Label gameplayNotification;
var privatewrite ROTT_UI_Displayer_Currencies currencyPanel;

var privatewrite UI_Sprite worldFade;

// Timer Effects
var private ROTT_Timer digitCycleTimer;      // Used for digit cycle effect

// Gameplay variables
struct PlayerCurrency {
  var int gold;
  var int gems;
};

// Currency displayed on HUD
var public PlayerCurrency displayCurrency;      

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  // Draw each component
  super.initializeComponent(newTag);
  
  // Parent scene
  someScene = ROTT_UI_Scene_Over_World(outer);
  
  // UI references
  partyComponent = ROTT_UI_Displayer_Party(findComp("World_HUD_Party_Container"));
  gameplayNotification = findLabel("Gameplay_Notification_Label");
  speedrunNotification = findLabel("Speedrun_Notification_Label");
  mapTitle = ROTT_UI_Displayer_Map_Title(findComp("Displayer_Map_Title"));
  worldFade = findSprite("World_Fade_Component");
  prayingGraphic = UI_Container(findComp("Over_World_HUD_Praying_Graphic"));
  singingGraphic = UI_Container(findComp("Over_World_HUD_Singing_Graphic"));
  currencyPanel = ROTT_UI_Displayer_Currencies(findComp("Over_World_HUD_Currency"));
  
  if (gameInfo.playerProfile != none) {
    // Fade the player into the world, by fading out the black cover
    addEffectToComponent(DELAY,    "World_Fade_Component", 1.7);
    addEffectToComponent(FADE_OUT, "World_Fade_Component", 2);
    
    // Initial currency
    displayCurrency.gold = gameInfo.getInventoryCount(class'ROTT_Inventory_Item_Gold');
    displayCurrency.gems = gameInfo.getInventoryCount(class'ROTT_Inventory_Item_Gem');
    
    // Set scene to no input, until fade in effects complete
    /// startGameDelayTimer = gameInfo.Spawn(class'ROTT_Timer');
    /// startGameDelayTimer.makeTimer(1.2, LOOP_OFF, startGameplay);
    
    // Delay input controls when entering a new world
    introInputDelay = 1.0;
  }
  
  // Check for milestone progress
  checkMilestoneProgress();
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Show or hide team info
  partyComponent.setLerpToShow(gameInfo.playerProfile.showOverworldDetail);
  
  // Show or hide prayers and songs
  singingGraphic.setEnabled(gameInfo.playerProfile.bSinging);  
  prayingGraphic.setEnabled(gameInfo.playerProfile.bPraying);
  
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  partyComponent.updateDisplay();
}

/*============================================================================= 
 * onSceneActivation()
 *
 * This event is called every time the parent scene is activated
 *===========================================================================*/
public function onSceneActivation() {
  // Enable currency effects through timer
  digitCycleTimer = gameInfo.spawn(class'ROTT_Timer');
  digitCycleTimer.makeTimer(0.05, LOOP_ON, updateDisplayedCurrency);
  
  // Update hero display info
  partyComponent.attachDisplayer(gameInfo.getActiveParty());
  
  // Force show heroes with timer here?
  /* to do ... */
}

/*============================================================================= 
 * onSceneDeactivation()
 *
 * This event is called every time the parent scene is deactivated
 *===========================================================================*/
public function onSceneDeactivation() {
  digitCycleTimer.destroy();
}

/*=============================================================================
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * inputName        the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
( 
  int ControllerId, 
  name inputName, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  switch (inputName) {
    case 'Tilde':
    case 'XBoxTypeS_Y':
      // Toggle hero status
      if (Event == IE_Released) {
        // Toggle data
        gameInfo.playerProfile.toggleOverworldDetail(); 
        
        // Animated visibility, party component drops down & shuts up
        partyComponent.setLerpToShow(gameInfo.playerProfile.showOverworldDetail);
      }
      break;
      
    case 'Enter':
      // Enable message mode, allow player to type
      if (Event == IE_Pressed) {
        ROTT_UI_Scene_Over_World(parentScene).enableMessageMode();
      }
      break;
      
    case 'LeftShift': 
    case 'XboxTypeS_LeftTrigger': 
      // Turbo speed
      if (Event == IE_Pressed) gameinfo.setTemporalBoost();
      if (Event == IE_Released) gameinfo.setGameSpeed(1);
      break;
    case 'M': 
    case 'XboxTypeS_Back': 
      // World map
      if (Event == IE_Pressed) gameinfo.openWorldMap();
      break;
    case 'I':
      // Move to inventory view
      gameInfo.sceneManager.switchScene(SCENE_GAME_MENU);
      gameInfo.sceneManager.sceneGameMenu.pushMenu(UTILITY_MENU);
      gameInfo.sceneManager.sceneGameMenu.pushMenu(INVENTORY_MENU);
      gameInfo.sceneManager.sceneGameMenu.pushMenu(MGMT_WINDOW_ITEM);
      
      // Play sound
      sfxBox.playSFX(SFX_MENU_NAVIGATE);
      break;
  }
  
  return false;
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  // Track input delay
  if (introInputDelay > 0) {
    introInputDelay -= deltaTime;
    if (introInputDelay <= 0) {
      allowInput();
    }
  }
  
  // Track hide notification delay
  if (hideNotificationDelay > 0) {
    hideNotificationDelay -= deltaTime;
    if (hideNotificationDelay <= 0) {
      resetNotificationLerp();
    }
  }
}

/*============================================================================= 
 * fadeInWorld
 *
 * Called to fade into the world after combat
 *===========================================================================*/
public function fadeInWorld() {
  worldFade.resetEffects();
  worldFade.resetColor();
  worldFade.addEffectToQueue(FADE_OUT, 0.3);
}

/*============================================================================= 
 * updatePrayerStatus
 *
 * Called from the player controller through the gameinfo class.
 * Enables "Praying" activity in 3d World.
 *===========================================================================*/
public function updatePrayerStatus(bool bState) {
  // Show graphic
  prayingGraphic.setEnabled(bState);
  
  /* Eventually want alpha lerping here */
}

/*============================================================================= 
 * updateSingingStatus
 *
 * Called from the player controller through the gameinfo class.
 * Enables "Singing" activity in 3d World.
 *===========================================================================*/
public function updateSingingStatus(bool bState) {
  // Show graphic
  singingGraphic.setEnabled(bState);
  
  /* Eventually want alpha lerping here */
}

/*============================================================================= 
 * updateDisplayedCurrency
 *
 * Description: This function is delegated to a timer, to be called 20 times 
 *              per second to provide visual effects for over world currency
 *===========================================================================*/
public function updateDisplayedCurrency() {
  local int actualGold;
  local int actualGems;
  
  // Get the player currency
  actualGold = gameInfo.getInventoryCount(class'ROTT_Inventory_Item_Gold');
  actualGems = gameInfo.getInventoryCount(class'ROTT_Inventory_Item_Gem');
  
  // Calculate special effects
  digitCycleTrick(actualGold, displayCurrency.Gold);
  digitCycleTrick(actualGems, displayCurrency.Gems);
  
  // Update display values
  updateCurrency(displayCurrency.Gold, displayCurrency.Gems);
}

/*=============================================================================
 * checkMilestoneProgress()
 *
 * Checks for milestone progress, and display it for speedrunners if found.
 *===========================================================================*/
public function checkMilestoneProgress() {
  local MilestoneInfo milestone;
  local string milestoneName, milestoneTime;
  
  // Check for a pending milestone
  if (gameInfo.playerProfile.processPendingMilestone(milestone)) {
    
    // Get milestone description
    milestoneName = milestone.milestoneDescription;
    milestoneTime = milestone.milestoneTimeFormatted;
    // Show milestone time
    showMilestone(milestoneName $ " in " $ milestoneTime);
    
    // Check for personal best
    if (milestone.bPersonalBest) {
      // Set effects for personal best text
      findLabel("Personal_Best_Label").setEnabled(true);
      addEffectToComponent(FADE_IN, "Personal_Best_Label", 0.8);
      addEffectToComponent(DELAY, "Personal_Best_Label", 3.6);
      addEffectToComponent(FADE_OUT, "Personal_Best_Label", 1.7);
    }
  }
}

/*=============================================================================
 * showReducedRate()
 *
 * Displays text for reduced encounter rate
 *===========================================================================*/
public function showReducedRate() {
  // Set the display text
  findLabel("Encounter_Mod_Notification_Label_Shadow").setEnabled(true);
  findLabel("Encounter_Mod_Notification_Label").setEnabled(true);
  
  // Set effects for displaying milestone text
  addEffectToComponent(FADE_IN, "Encounter_Mod_Notification_Label_Shadow", 0.8);
  addEffectToComponent(DELAY, "Encounter_Mod_Notification_Label_Shadow", 3.1);
  addEffectToComponent(FADE_OUT, "Encounter_Mod_Notification_Label_Shadow", 1.35);
  
  addEffectToComponent(FADE_IN, "Encounter_Mod_Notification_Label", 0.8);
  addEffectToComponent(DELAY, "Encounter_Mod_Notification_Label", 1.0);
  addEffectToComponent(FADE_OUT, "Encounter_Mod_Notification_Label", 1.4);
}

/*=============================================================================
 * showMilestone()
 *
 * Displays the speedrun milestone information
 *===========================================================================*/
public function showMilestone(string message) {
  // Set the display text
  findLabel("Speedrun_Notification_Label_Shadow").setEnabled(true);
  findLabel("Speedrun_Notification_Label").setEnabled(true);
  findLabel("Speedrun_Notification_Label_Shadow").setText(message);
  findLabel("Speedrun_Notification_Label").setText(message);
  
  // Set effects for displaying milestone text
  addEffectToComponent(FADE_IN, "Speedrun_Notification_Label_Shadow", 0.8);
  addEffectToComponent(DELAY, "Speedrun_Notification_Label_Shadow", 3.1);
  addEffectToComponent(FADE_OUT, "Speedrun_Notification_Label_Shadow", 1.35);
  
  addEffectToComponent(FADE_IN, "Speedrun_Notification_Label", 0.8);
  addEffectToComponent(DELAY, "Speedrun_Notification_Label", 1.0);
  addEffectToComponent(FADE_OUT, "Speedrun_Notification_Label", 1.4);
}

/*=============================================================================
 * showGameplayNotification()
 *
 * This displays notification text to the overworld, bottom center screen.
 *===========================================================================*/
public function showGameplayNotification(string message) {
  local IntPoint origin;
  local IntPoint destination;
  
  // Set message
  gameplayNotification.setText(message);
  
  // Set home posiiton
  origin.x = gameplayNotification.homePos.x;
  origin.y = gameplayNotification.homePos.y;
  
  // Set destination
  destination.y = NOTIFY_GAMEPLAY_LERP_TO_POSY;
  destination.x = origin.x;
  
  // Enable lerp effect
  gameplayNotification.setLerp(
    origin, 
    destination, 
    NOTIFY_GAMEPLAY_DURATION
  );
  
  // Set time until backward lerp
  hideNotificationDelay = 3.6;
  
  // Debug
  ///gameplayNotification.debugLerpDump();
}

/*============================================================================= 
 * updateCurrency
 *
 * This function updates player trueCurrency on screen.
 *===========================================================================*/
public function updateCurrency(int gold, int gems) { 
  currencyPanel.updateCurrency(gold, gems);
}

/**============================================================================= 
 * updateHeroesStatus
 *
 * This function updates health and mana of all heroes on screen
 *===========================================================================*/
public function updateHeroesStatus() { 
  partyComponent.attachDisplayer(gameInfo.getActiveParty());
}

/// /*============================================================================= 
///  * startGameplay
///  *
///  * This function is delegated to a timer, thus no paramaters. Called after 
///  * fade in completes.
///  *===========================================================================*/
/// private function startGameplay() { 
///   // Area title effects
///   mapTitle.addEffectToQueue(FADE_IN, 1);
///   mapTitle.addEffectToQueue(DELAY, 1.6);
///   mapTitle.addEffectToQueue(FADE_OUT, 1);
///   
///   // Destroy invoking timer
///   startGameDelayTimer.Destroy();
/// } 
/// 
/*============================================================================= 
 * allowInput()
 *
 * Allows player controls in the over world
 *===========================================================================*/
private function allowInput() { 
  // Give control to player
  gameInfo.unpauseGame();
  
  // Destroy invoking timer
  introInputDelay = 0;
} 

/*============================================================================= 
 * resetNotificationLerp()
 *
 * Called when the label is brought back down after being displayed.
 *===========================================================================*/
private function resetNotificationLerp() { 
  local IntPoint origin, destination;
  
  // Set home posiiton
  origin.x = gameplayNotification.homePos.x;
  origin.y = gameplayNotification.homePos.y;
  
  // Set destination
  destination.y = NOTIFY_GAMEPLAY_LERP_TO_POSY;
  destination.x = origin.x;
  
  // Enable lerp effect
  gameplayNotification.setLerp(destination, origin, NOTIFY_GAMEPLAY_DURATION);
} 

/*============================================================================= 
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  super.deleteComp();
  if (startGameDelayTimer != none) startGameDelayTimer.destroy();
  if (digitCycleTimer != none) digitCycleTimer.destroy();
  
  partyComponent = none;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bMandatoryScaleToWindow=true
  
  /** ===== Textures ===== **/
  begin object class=UI_Texture_Info Name=Black_Texture
    componentTextures.add(Texture2D'GUI.Black_Square')
  end object
  ///begin object class=UI_Texture_Info Name=Quest_Info_Notification_Bar_Texture
  ///  componentTextures.add(Texture2D'GUI.Quest_Info_Notification_Bar')
  ///end object
  
  // Player Activity Icons
  begin object class=UI_Texture_Info Name=World_HUD_Praying
    componentTextures.add(Texture2D'GUI_Overworld.World_HUD_Praying')
  end object
  begin object class=UI_Texture_Info Name=World_HUD_Singing
    componentTextures.add(Texture2D'GUI_Overworld.World_HUD_Singing')
  end object
  
  /** ===== UI Components ===== **/
  tag="Over_World_Page"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  
  // Notification for gameplay
  begin object class=UI_Label Name=Gameplay_Notification_Label
    tag="Gameplay_Notification_Label"
    homePos=(x=0,y=945)
    homeDim=(width=NATIVE_WIDTH,height=90)
    posX=0
    posY=945
    posXEnd=NATIVE_WIDTH
    posYEnd=1035
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="Gold +10"
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Gameplay_Notification_Label)
  
  // Hero Data Container
  begin object class=ROTT_UI_Displayer_Party Name=World_HUD_Party_Container
    tag="World_HUD_Party_Container"
    posX=361
    posY=-125
    xSeparator=238
    ySeparator=0
    displayerClass=class'ROTT_UI_Displayer_Hero_Over_World'
  end object
  componentList.add(World_HUD_Party_Container)
  
  // Currency
  begin object class=ROTT_UI_Displayer_Currencies Name=Over_World_HUD_Currency
    tag="Over_World_HUD_Currency"
  end object
  componentList.add(Over_World_HUD_Currency)
  
  // Player activity - Singing
  begin object class=UI_Container Name=Over_World_HUD_Singing_Graphic
    tag="Over_World_HUD_Singing_Graphic"
    bEnabled=false
    
    begin object class=UI_Sprite Name=Over_World_HUD_Singing_Icon
      tag="Over_World_HUD_Singing_Icon"
      posX=34
      posY=32
      images(0)=World_HUD_Singing
    end object
    componentList.add(Over_World_HUD_Singing_Icon)
    
    begin object class=UI_Label Name=Over_World_HUD_Singing_Label
      tag="Over_World_HUD_Singing_Label"
      posX=122
      posY=35
      posXEnd=272
      posYEnd=115
      fontStyle=DEFAULT_MEDIUM_WHITE
      labelText="Singing"
      alignX=CENTER
      alignY=CENTER
    end object
    componentList.add(Over_World_HUD_Singing_Label)
    
  end object
  componentList.add(Over_World_HUD_Singing_Graphic)
  
  // Player activity - Praying
  begin object class=UI_Container Name=Over_World_HUD_Praying_Graphic
    tag="Over_World_HUD_Praying_Graphic"
    bEnabled=false
    
    begin object class=UI_Sprite Name=Over_World_HUD_Praying_Icon
      tag="Over_World_HUD_Praying_Icon"
      posX=1164
      posY=32
      images(0)=World_HUD_Praying
    end object
    componentList.add(Over_World_HUD_Praying_Icon)
    
    begin object class=UI_Label Name=Over_World_HUD_Praying_Label
      tag="Over_World_HUD_Praying_Label"
      posX=1252
      posY=35
      posXEnd=1402
      posYEnd=115
      fontStyle=DEFAULT_MEDIUM_WHITE
      labelText="Praying"
      alignX=CENTER
      alignY=CENTER
    end object
    componentList.add(Over_World_HUD_Praying_Label)
    
  end object
  componentList.add(Over_World_HUD_Praying_Graphic)
  
  // Approaching Quest Info Notification
  ///begin object class=UI_Sprite Name=Quest_Info_Notification_Bar
  ///  tag="Quest_Info_Notification_Bar"
  ///  posX=0
  ///  posY=537
  ///  images(0)=Quest_Info_Notification_Bar_Texture
  ///end object
  ///componentList.add(Quest_Info_Notification_Bar)
  
  // Fader 
  begin object class=UI_Sprite Name=World_Fade_Component
    tag="World_Fade_Component"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
    bMandatoryScaleToWindow=true
  end object
  componentList.add(World_Fade_Component)
  
  // Flicker Effect
  begin object class=UI_Sprite Name=WorldFlickerTexture
    tag="WorldFlickerTexture"
    bEnabled=false
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
  end object
  componentList.add(WorldFlickerTexture)
  
  // Displayer Map Title
  begin object class=ROTT_UI_Displayer_Map_Title Name=Displayer_Map_Title
    tag="Displayer_Map_Title"
  end object
  componentList.add(Displayer_Map_Title)
  
  // Notification for speedrun milestones
  begin object class=UI_Label Name=Speedrun_Notification_Label_Shadow
    tag="Speedrun_Notification_Label_Shadow"
    bEnabled=false
    posX=0
    posY=500
    posXEnd=NATIVE_WIDTH
    posYEnd=550
    padding=(top=1, left=13, right=11, bottom=7)
    fontStyle=DEFAULT_LARGE_ORANGE
    labelText="Defeated Khomat in 34:56.23"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=220, max=255))
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Speedrun_Notification_Label_Shadow)
  
  // Notification for speedrun milestones
  begin object class=UI_Label Name=Speedrun_Notification_Label
    tag="Speedrun_Notification_Label"
    bEnabled=false
    posX=0
    posY=500
    posXEnd=NATIVE_WIDTH
    posYEnd=550
    fontStyle=DEFAULT_LARGE_ORANGE
    labelText="Defeated Khomat in 34:56.23"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=200, max=255))
    activeEffects.add((effectType=EFFECT_FLIPBOOK, lifeTime=-1, elapsedTime=0, intervalTime=0.10, min=0, max=255))
    cycleStyles=(DEFAULT_LARGE_GOLD, DEFAULT_LARGE_ORANGE)
    ///activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.30, min=127, max=255))
    ///activeEffects.add((effectType=EFFECT_HUE_SHIFT, lifeTime=-1, elapsedTime=0, intervalTime=1.0, min=0, max=255))
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Speedrun_Notification_Label)
  
  // Personal best label
  begin object class=UI_Label Name=Personal_Best_Label
    tag="Personal_Best_Label"
    bEnabled=false
    posX=0
    posY=550
    posXEnd=NATIVE_WIDTH
    posYEnd=600
    fontStyle=DEFAULT_SMALL_TAN
    labelText="~ Personal Best! ~"
    activeEffects.add((effectType=EFFECT_HUE_SHIFT, lifeTime=-1, elapsedTime=1.50, intervalTime=2.0, min=120, max=255))
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Personal_Best_Label)
  
  // Notification for encounter rate mod
  begin object class=UI_Label Name=Encounter_Mod_Notification_Label_Shadow
    tag="Encounter_Mod_Notification_Label_Shadow"
    bEnabled=false
    posX=0
    posY=700
    posXEnd=NATIVE_WIDTH
    posYEnd=750
    padding=(top=1, left=13, right=11, bottom=7)
    fontStyle=DEFAULT_LARGE_BLUE
    labelText="You feel an underwhelming presence"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=220, max=255))
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Encounter_Mod_Notification_Label_Shadow)
  
  // Notification for encounter rate mod
  begin object class=UI_Label Name=Encounter_Mod_Notification_Label
    tag="Encounter_Mod_Notification_Label"
    bEnabled=false
    posX=0
    posY=700
    posXEnd=NATIVE_WIDTH
    posYEnd=750
    fontStyle=DEFAULT_LARGE_GREEN
    labelText="You feel an underwhelming presence"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=200, max=255))
    activeEffects.add((effectType=EFFECT_FLIPBOOK, lifeTime=-1, elapsedTime=0, intervalTime=0.10, min=0, max=255))
    cycleStyles=(DEFAULT_LARGE_GREEN, DEFAULT_LARGE_BLUE)
    ///activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.30, min=127, max=255))
    ///activeEffects.add((effectType=EFFECT_HUE_SHIFT, lifeTime=-1, elapsedTime=0, intervalTime=1.0, min=0, max=255))
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Encounter_Mod_Notification_Label)
  
}








