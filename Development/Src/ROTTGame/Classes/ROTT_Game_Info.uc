/*=============================================================================
 * Realm of the Tempest
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles all the high level game data.
 *===========================================================================*/

class ROTT_Game_Info extends UI_Game_Info 
dependsOn(ROTT_Worlds_Encounter_Info)
dependsOn(ROTT_UI_Scene_Manager)
dependsOn(ROTT_NPC_Container);
 
// Version info
const MAJOR = 1;  const MINOR = 5;  const REVISION = 4;  const PATCH = 'F';  
const PHASE_INFO = "";

// Publishing settings
const bDevMode = true;      
const bQaMode = false;     

// Parameters used in ROTT_Timers:
const LOOP_OFF = false;     
const LOOP_ON  = true;

// Spawn rates
const ELITE_SPAWN_CHANCE = 10;

const COMMON_SPAWN_CHANCE = 60;
const UNCOMMON_SPAWN_CHANCE = 30;
const RARE_SPAWN_CHANCE = 10;

var privatewrite int spawnRates[3];

// Mob spawning indices
const LEFT_SLOT = 0;
const MIDDLE_SLOT = 1;
const RIGHT_SLOT = 2;

// Parameter used for save/load transitions
const TRANSITION_SAVE = true;     

// Common references
var privatewrite ROTT_UI_Scene_Manager sceneManager;
var privatewrite ROTT_UI_HUD hud;
var privatewrite ROTT_Player_Pawn tempestPawn;
var privatewrite ROTT_Player_Controller tempestPC; 
var privatewrite ROTT_Game_Player_Profile playerProfile;
var privatewrite ROTT_Game_Music jukebox;

// Inventory cost structure
struct ItemCost {
  var class<ROTT_Inventory_Item> currencyType;
  var int quantity;
};

// 3D World Gameplay
var private int lastCheckpointIndex;     // player checkpoint tracker

// Map descriptors
enum MapNameEnum {
  NO_MAP_NAME,
  
  // UI Scenes
  MAP_UI_TITLE_MENU,
  MAP_UI_CREDITS,
  MAP_UI_GAME_OVER,
  
  // Talonovia
  MAP_TALONOVIA_TOWN,
  MAP_TALONOVIA_SHRINE,
  MAP_TALONOVIA_BACKLANDS,
  MAP_TALONOVIA_OUTSKIRTS,
  
  // Rhunia
  MAP_RHUNIA_CITADEL,
  MAP_RHUNIA_WILDERNESS,
  MAP_RHUNIA_BACKLANDS,
  MAP_RHUNIA_OUTSKIRTS,
  
  // Etzland
  MAP_ETZLAND_CITADEL,
  MAP_ETZLAND_WILDERNESS,
  MAP_ETZLAND_BACKLANDS,
  MAP_ETZLAND_OUTSKIRTS,
  
  // Haxlyn
  MAP_HAXLYN_CITADEL,
  MAP_HAXLYN_WILDERNESS,
  MAP_HAXLYN_BACKLANDS,
  MAP_HAXLYN_OUTSKIRTS,
  
  // Valimor
  MAP_VALIMOR_CITADEL,
  MAP_VALIMOR_WILDERNESS,
  MAP_VALIMOR_BACKLANDS,
  MAP_VALIMOR_OUTSKIRTS,
  
  // Kalroth
  MAP_KALROTH_CITADEL,
  MAP_KALROTH_WILDERNESS,
  MAP_KALROTH_BACKLANDS,
  MAP_KALROTH_OUTSKIRTS,
  
  // Caves
  MAP_KYRIN_CAVERN,
  MAP_KAUFINAZ_CAVERN,
  MAP_KORUMS_CAVERN,
  
  // Misc: The land between the tempests
  MAP_AKSALOM_SKYGATE,
  MAP_AKSALOM_GROVE,
  MAP_AKSALOM_STORMLANDS,
  MAP_MYSTERY_PATH,
  MAP_MOUNTAIN_SHRINE,
  
};

// Portal specifications
enum PortalState {
  GATE_CLOSED,
  GATE_OPEN
};

// Encounter control
var private bool safetyMode;    // True if player is in a safety zone
var private int encounterTicks; // Tracks progress toward encounter
var public int encounterLimit;  // Triggers encounter when reached by ticks
var public int encounterMod;    // Modified by game mode, added to limit

// Encounter zones
var private array<ROTT_Worlds_Encounter_Info> encounterZones; 

// Enemy mob
var public ROTT_Mob enemyEncounter;
var public bool bEncounterActive;
var public bool bEncounterPending;

// Time until encounter forced
var private float encounterDelay;
var private bool bDelayedCombat;
var private array<SpawnerInfo> delayedMobInfo;

// Combat trigger delay for traps and falling
var private ROTT_Timer combatTriggerDelay;

// NPC dialog delegate to display after NPC transition
var public delegate<npcDelegate> queuedNPC;

// Respawn info
struct RespawnInfo {
  var vector location;
  var rotator rotation;
};
var privatewrite array<RespawnInfo> checkPoints;
var privatewrite bool bPlayerFalling;

// Stores milestones for tracking personal bests
var privatewrite ROTT_Milestone_Cookie milestoneCookie;

// Store all possible items that may drop in the game
var public array<class<ROTT_Inventory_Item> > lootTypes;
var public array<class<ROTT_Inventory_Item> > equipTypes;

// Item drop rate modifier
struct ItemDropMod {
  // Type of item
  var() class<ROTT_Inventory_Item> dropType;
  
  // Override modifications
  var() float chanceOverride;
  var() float minOverride;
  var() float maxOverride;
  
  // Amplifiers
  var() float chanceAmp;
  var() float quantityAmp;
  
  structdefaultproperties {
    chanceOverride = -1
    minOverride = -1
    maxOverride = -1
    
    chanceAmp = 1.f
    quantityAmp = 1.f
  }
};

var public byte queuedRitual;

enum EncounterRateMods {
  ENCOUNTER_RATE_STANDARD,
  ENCOUNTER_RATE_REDUCED,
  ENCOUNTER_RATE_WARNING,
};

// Store encounter rate modifier rate
var privatewrite EncounterRateMods encounterRateMod;

// Store encounter rate modifier pending
var privatewrite bool bPendingZoneCheck;

// Plain stub for a function that will launch an npc dialog
delegate npcDelegate();

/*=============================================================================
 * initGame
 *
 * For more info on this event: 
 * https://wiki.beyondunreal.com/What_happens_at_map_startup
 *===========================================================================*/
event initGame(string options, out string errorMessage) {
  super.initGame(options, errorMessage);
  whitelog("--+-- ROTT_Game_Info: InitGame()       --+--");
  
  // Set up music and sfx
  sfxBox = new class'ROTT_Game_Sfx';
  sfxBox.gameInfo = self;
  jukebox = new class'ROTT_Game_Music';
  jukebox.initialize();
  
  // Set up music and sfx
  milestoneCookie = new class'ROTT_Milestone_Cookie';
  milestoneCookie.linkReferences();
  
  // Attempt to load speedrun info
  if (class'Engine'.static.basicLoadObject(milestoneCookie, "Save\\milestones.bin", true, 0)) {
    cyanLog("Speedrun info loaded", DEBUG_DATA_STRUCTURE);
  }
  
  // Load gameplay based on map name
  switch (getCurrentMap()) {
    case MAP_UI_TITLE_MENU:
    case MAP_UI_GAME_OVER:
    case MAP_UI_CREDITS:
      // No gameplay, no save data
      break;
      
    default:
      loadSavedGame(TRANSITION_SAVE);
      break;
  }
}

/*=============================================================================
 * preBeginPlay()
 *
 * Called when the game is starting
 *===========================================================================*/
event preBeginPlay() {
  super.preBeginPlay();
  whitelog("--+-- ROTT_Game_Info: PreBeginPlay()   --+--");
}

/*=============================================================================
 * postBeginPlay()
 *
 * Called when the game has started
 *===========================================================================*/
event postBeginPlay() {
  super.postBeginPlay();
  whitelog("--+-- ROTT_Game_Info: PostBeginPlay()  --+--");
}

/*=============================================================================
 * PostLogin()
 *
 * Called when the player is ready
 *===========================================================================*/
public function postLogin(PlayerController newPlayer) {
  super.postLogin(newPlayer);
  
  whitelog("--+-- ROTT_Game_Info: PostLogin()      --+--");
  
  // Set up player controller
  tempestPC.setPostLoginReferences();
  tempestPC.setInitialControls();
  
  // Play music
  jukebox.loadMusic(getCurrentMap());
  
  // Set initial checkpoint
  if (playerProfile != none) {
    tempestPawn.setArrivalCheckpoint(playerProfile.arrivalCheckpoint);
  }
  
  // Any initial touch events must be forced
  tempestPawn.forceTouchEvents();
  
  // Set initial UI scene
  hud.sceneManager.setInitScene();
  
  // Set up transitioner
  ROTT_UI_Scene_Manager(hud.sceneManager).transitioner = new(self) class'ROTT_UI_Transitioner';
  ROTT_UI_Scene_Manager(hud.sceneManager).transitioner.setGameInfo();
  ROTT_UI_Scene_Manager(hud.sceneManager).transitioner.initializeComponent();
  ROTT_UI_Scene_Manager(hud.sceneManager).transitioner.startEvent();
  
  // Queue kismit quest marks
  if (playerProfile == none) return;
  if (playerProfile.bQuestMarks[HAXLYN_BRIDGE] == QUEST_MARK_COMPLETE) {
    // Open Haxlyn Bridge
    triggerGlobalEventClass(
      class'ROTT_Kismet_Event_Open_Bridge', 
      tempestPawn
    );
  }
  
  // Increase freedom of movement for casual
  if (playerProfile.gameMode == MODE_CASUAL) encounterMod = 250;
  
  // Default encounter rate
  encounterRateMod = ENCOUNTER_RATE_STANDARD;
  
  /// Load essential scenes...?
  sceneManager.sceneBestiary.initScene();
  sceneManager.sceneBarter.initScene();
  sceneManager.sceneGameMenu.initScene();
  
  saveVsync();
}

/*=============================================================================
 * getSaveFile()
 * 
 * Returns a player profile if it exists.
 *===========================================================================*/
public function ROTT_Game_Player_Profile getSaveFile
(
  optional string folder = "save",
  optional string path = "\\player_profile.bin"
) 
{
  local ROTT_Game_Player_Profile profile;
  
  // Initialize a player profile
  profile = new class'ROTT_Game_Player_Profile';
  
  // Attempt to load from path
  if (class'Engine'.static.basicLoadObject(profile, folder $ path, true, 0)) {
    profile.linkReferences();
    return profile;
  }
  return none;
}

/*=============================================================================
 * saveFileExist()
 * 
 * Based on a given index returns true if there is a save file.
 *===========================================================================*/
public function bool saveFileExist(optional int saveIndex = -1) {
  switch (saveIndex) {
    case -1:
      // Load from temp save folder
      if (getSaveFile("temp") != none) return true;
      break;
    default:      
      // Load from main save folder
      if (getSaveFile("save") != none) return true;
      break;
  }
  return false;
}

/*=============================================================================
 * saveFilesExist()
 * 
 * Returns true if there is at least one save file.
 *===========================================================================*/
public function bool saveFilesExist() {
  // Check autosave and first(0th) slot
  return (saveFileExist() || saveFileExist(0));
}

/*=============================================================================
 * loadSavedGame()
 * 
 * This function loads all player profile information from binary files.
 * Returns true if save file exists, false otherwise.
 *===========================================================================*/
public function bool loadSavedGame(optional bool transitionMode = false) {
  local string path;
  local string folder;
  folder = (transitionMode == true) ? "temp" : "save";
  
  if (transitionMode == true) {
    darkcyanlog("Transition load", DEBUG_DATA_STRUCTURE);
  } else {
    darkcyanlog("Hard load", DEBUG_DATA_STRUCTURE);
  }
  
  path = folder $ "\\player_profile.bin";
  
  // Initialize a player profile
  playerProfile = new(self) class'ROTT_Game_Player_Profile';
  
  // Attempt to load profile
  darkcyanlog("Loading profile: ..." $ path, DEBUG_DATA_STRUCTURE);
  if (class'Engine'.static.basicLoadObject(playerProfile, path, true, 0)) {
    // Upon successful profile load, continue loading and setup profile
    playerProfile.loadProfile(transitionMode);
    playerProfile.linkReferences();
    return true;
  } else {
    // Failed to load
    playerProfile = none;
    return false;
  }
}

/*=============================================================================
 * newGameSetup()
 *
 * Called when 'new game' is selected, before fading into the intro dialog.
 *===========================================================================*/
public function newGameSetup(byte gameMode) {
  // Initialize a player profile
  playerProfile = new class'ROTT_Game_Player_Profile';
  playerProfile.linkReferences();
  
  // Reset defend options
  optionsCookie.bAlwaysDefendHero1 = false;
  optionsCookie.bAlwaysDefendHero2 = false;
  optionsCookie.bAlwaysDefendHero3 = false;
  saveOptions();
  
  // Set up a new gamewould recommend trying the time boost in combat early
  playerProfile.newGameSetup(gameMode);
  saveGame(TRANSITION_SAVE);
}

/*=============================================================================
 * saveGame()
 *
 * This function saves all player profile information to binary files.
 *===========================================================================*/
public function saveGame
(
  optional bool transitionMode = false, 
  optional int arrivalIndex = -1
)
{
  local string folder;
  folder = (transitionMode == true) ? "temp" : "save";
  
  // Log message
  if (transitionMode == true) {
    darkcyanlog("Transition save", DEBUG_DATA_STRUCTURE);
  } else {
    darkcyanlog("Hard save", DEBUG_DATA_STRUCTURE);
  }
  
  // Save game options & milestones
  saveOptions();
  saveMilestones();
  
  // Save the profile's children
  playerProfile.saveGame(transitionMode, arrivalIndex);
  
  // Save the profile itself
  class'Engine'.static.basicSaveObject(playerProfile, folder $ "\\player_profile.bin", true, 0);
}

/*=============================================================================
 * recordMilestone()
 * 
 * Called to record a milestone time, returns true if personal best.
 *===========================================================================*/
public function bool recordMilestone(int milestoneIndex, float milestoneTime) {
  local bool bPersonalBest;
  
  // Update milestone progress in cookie, and store result
  bPersonalBest = milestoneCookie.recordMilestone(milestoneIndex, milestoneTime);
  
  // Save result cookie
  saveMilestones();
  
  return bPersonalBest;
}

/*=============================================================================
 * saveMilestones()
 *
 * Called when a new personal best is entered, and stored separate from 
 * player profiles.
 *===========================================================================*/
public function saveMilestones() {
  // Save the profile itself
  class'Engine'.static.basicSaveObject(
    milestoneCookie, 
    "Save\\milestones.bin", 
    true, 
    0
  );
}

/*=============================================================================
 * saveVsync()
 * 
 * Used to set system setting for resolving vertical tearing issue
 *===========================================================================*/
public function saveVsync() {
	local CustomSystemSettings vsyncSetting;

  vsyncSetting = class'WorldInfo'.static.GetWorldInfo().Spawn(class'CustomSystemSettings');
  
	// Force VSync (game looks awful without it)
	vsyncSetting.setUseVsync(true);
}

/*=============================================================================
 * openChest()
 * 
 * Called when the player opens a chest in the 3D world.
 *===========================================================================*/
public function openChest
(
  int dropLevel,
  float dropAmplifier,
  array<ItemDropMod> itemDropRates,
  optional float lootDelay = 0.f
) 
{
  // Show the chest UI
  sceneManager.sceneOverWorld.pushPage(sceneManager.sceneOverWorld.chestPage);
  
  // Transfer chest loot info to UI display
  sceneManager.sceneOverWorld.chestPage.setItems(
    generateLoot(dropLevel, dropAmplifier, itemDropRates), 
    lootDelay
  );
}

/*=============================================================================
 * setPlayerFallen()
 * 
 * When player falls off the map, or into a trap, this is called to invoke the
 * respawn process for them.
 * (For respawn sequence, see respawnTransitionIn())
 *===========================================================================*/
public function setPlayerFallen(optional int checkpointIndex = -1) {
  // Ignore multiple calls
  if (bPlayerFalling == true) return;
  bPlayerFalling = true;
  
  // Stop player movement
  setPlayerControl(false);
  
  // Call over world effects
  sceneManager.sceneOverWorld.onPlayerFall();    
}

/*=============================================================================
 * setLastCheckpointIndex()
 * 
 * This function sets a new respawn point based on entering a checkpoint zone
 * (See CheckpointZone.uc)
 *===========================================================================*/
public function setLastCheckpointIndex(int checkpointIndex) {
  lastCheckpointIndex = checkpointIndex;
}

/*=============================================================================
 * respawnTransitionIn()
 *
 * Called when the respawn transition should start
 *===========================================================================*/
public function respawnTransitionIn() {
  // Reset falling trap status
  bPlayerFalling = false;
  
  // Skip if in tour or cheating
  if (playerProfile.gameMode == MODE_TOUR) { unpauseGame(false); return; }
  if (playerProfile.cheatNoEncounters) { unpauseGame(false); return; }
  
  // Attempt to create a mob from the active zones
  if (rollRandomMob()) {
    // Mark encounter pending to prevent menu operations
    bEncounterPending = true;
    
    // Damage party before combat
    getActiveParty().trapDamage();  
    
    // Delay transition to combat
    startCombatTransition(0.5);
  } else {
    // Unpause in safe areas with no enemies
    unpauseGame(false);
  }
}

/*=============================================================================
 * startCombatTransition()
 *
 * Called to start the transition into combat
 * Precondition: 'enemyEncounter' variable already stores a mob.
 *===========================================================================*/
public function startCombatTransition(optional float delay = 0.f) {
  if (enemyEncounter == none) {
    yellowLog("Warning (!) Attempt to transition to combat without enemies.");
    return;
  }
  
  whiteLog("--+-- StartCombatTransition --+--");
  playerProfile.encounterCount++;
  
  // Check if combat is already taking place
  if (bEncounterActive) return;
  
  // Prevent layering combat transitions
  bEncounterActive = true;
  bEncounterPending = false;
  
  // Reset the tracking system for next encounter
  encounterTicks = 0;
  
  // Stop player from moving in 3D world
  pauseGame();
  
  // Prepare all combat units
  enemyEncounter.battlePrep();
  getActiveParty().battlePrep();
  
  // Load skill graphics in cache
  if (sceneManager.sceneCombatEncounter.combatPage != none) {
    sceneManager.sceneCombatEncounter.combatPage.cacheSkills();
  }
  
  // Check for mob failure to load
  if (enemyEncounter.getMobSize() == 0) {
    yellowLog("Warning (!) Enemy mob is empty");
    return;
  } 
  
  // Start the UI transition process
  if (delay == 0) {
    combatTransition();
  } else {
    combatTriggerDelay = spawn(class'ROTT_Timer');
    combatTriggerDelay.makeTimer(delay, LOOP_OFF, combatTransition);
  }
}

/*=============================================================================
 * combatTransition()
 * 
 * This pushes an effect to transition into combat
 *===========================================================================*/
public function combatTransition() {
  // Destroy the invoking timer
  if (combatTriggerDelay != none) combatTriggerDelay.destroy();
  
  // Check which scene we transition away from
  switch (sceneManager.scene) {
    case sceneManager.sceneOverWorld:
      // Transition from over world
      sceneManager.sceneOverWorld.combatTransition();
      break;
    case sceneManager.sceneNpcDialog:
      // Transition from NPC
      sceneManager.sceneNpcDialog.combatTransition();
      break;
    case sceneManager.sceneBestiary:
      // Transition from Bestiary NPC service
      sceneManager.sceneBestiary.combatTransition();
      break;
    
  }
}

/*=============================================================================
 * forceEncounterDelay()
 *
 * Called to delay an encounter for a given time
 *===========================================================================*/
public function forceEncounterDelay(
  array<SpawnerInfo> mobInfo, 
  float delayTime
) 
{
  // Set up delay until combat
  encounterDelay = delayTime;
  bDelayedCombat = true;
  delayedMobInfo = mobInfo;
  
  // Stop player movement
  setPlayerControl(false);
}

/*=============================================================================
 * forceEncounter()
 *
 * Called to force battles with specific bosses and what not
 *===========================================================================*/
public function forceEncounter(array<SpawnerInfo> mobInfo) {
  local ROTT_Combat_Enemy enemyUnit;
  local int i;
  
  whiteLog("--+-- Forcing Encounter --+--");
  
  // Make a new mob
  enemyEncounter = new(self) class'ROTT_Mob';
  enemyEncounter.linkReferences();

  // Generate enemies
  for (i = 0; i < mobInfo.length; i++) {
    enemyUnit = makeUnit(mobInfo[i], mobInfo[i].spawnMode); 
    enemyEncounter.addEnemy(enemyUnit);
  }
  
  // Transition to combat
  startCombatTransition();
  
}

/*=============================================================================
 * queueEncounter()
 *
 * Called to queue a mob that will be triggered later (e.g. from npc dialog)
 *===========================================================================*/
public function queueEncounter(array<SpawnerInfo> mobInfo) {
  local ROTT_Combat_Enemy enemyUnit;
  local int i;
  
  whiteLog("--+-- Queueing Encounter --+--");
  
  // Make a new mob
  enemyEncounter = new(self) class'ROTT_Mob';
  enemyEncounter.linkReferences();

  // Generate enemies
  for (i = 0; i < mobInfo.length; i++) {
    enemyUnit = makeUnit(mobInfo[i], mobInfo[i].spawnMode); 
    enemyEncounter.addEnemy(enemyUnit);
  }
}

/*=============================================================================
 * teleportPlayerTo()
 * 
 * Teleports the player to the checkpoint at the given index
 *===========================================================================*/
public function teleportPlayerTo(int arrivalIndex) {
  // Mark checkpoint destination
  tempestPawn.setArrivalCheckpoint(arrivalIndex);
  
  // Transition
  sceneManager.sceneOverWorld.startDoorTransition();
}

/*=============================================================================
 * pauseGame()
 * 
 * Disables over world control
 *===========================================================================*/
public function pauseGame() {
  tempestPawn.pausePawn();
  
  setPlayerControl(false);
  
  setGameSpeed(1);
}

/*=============================================================================
 * unpauseGame()
 * 
 * Enables over world control
 *===========================================================================*/
public function unpauseGame(optional bool bKeepVelocity = true) {
  tempestPawn.unpausePawn(bKeepVelocity);
  
  setPlayerControl(true);
  
  setGameSpeed(1);
}

/*=============================================================================
 * setTemporalBoost()
 * 
 * Increases the pace of time for the game
 *===========================================================================*/
public function setTemporalBoost() {
  // Skip if transition is up
  if (
    ROTT_UI_Scene_Manager(hud.sceneManager).transitioner.bRenderingEnabled && 
    ROTT_UI_Scene_Manager(hud.sceneManager).transitioner.bConsumeInput
  ) return;
  
  // Check game mode
  if (playerProfile.gameMode == MODE_CASUAL) {
    // Softcore speed
    setGameSpeed(3.f);
  } else {
    // Hardcore and tour mode speed
    setGameSpeed(4.f);
  }
  
  // Sfx
  sfxBox.playSfx(SFX_WORLD_TEMPORAL);
  
}

/*=============================================================================
 * getPortalState()
 * 
 * returns the portal state for a given portal
 *===========================================================================*/
public function PortalState getPortalState(MapNameEnum mapIndex) {
  if (mapIndex >= MapNameEnum.EnumCount) {
    yellowLog("Warning (!) Map index out of bounds.");
    return GATE_CLOSED;
  }
  
  // Never unlocked a missing destination
  if (mapIndex == NO_MAP_NAME) return GATE_CLOSED;
  
  return playerProfile.mapLocks[mapIndex];
}

/*=============================================================================
 * getMapName()
 * 
 * returns the filename for a given map
 *===========================================================================*/
public function string getMapFileName(coerce byte mapName) {
  switch (MapNameEnum(mapName)) {
    // No map defined?
    case NO_MAP_NAME:     return "";
    
    // UI Scenes
    case MAP_UI_TITLE_MENU:       return "ROTT-UI_Title_Screen";         
    case MAP_UI_CREDITS:          return "ROTT-UI_Credits";              
    case MAP_UI_GAME_OVER:        return "ROTT-UI_Game_Over";            
    
    // Talonovia
    case MAP_TALONOVIA_TOWN:      return "ROTT-Talonovia_Town";       
    case MAP_TALONOVIA_SHRINE:    return "ROTT-Talonovia_Shrine";     
    case MAP_TALONOVIA_OUTSKIRTS: return "ROTT-Talonovia_Outskirts";  
    case MAP_TALONOVIA_BACKLANDS: return "ROTT-Talonovia_Backlands";  
    
    // Rhunia
    case MAP_RHUNIA_CITADEL:      return "ROTT-Rhunia_Citadel";      
    case MAP_RHUNIA_WILDERNESS:   return "ROTT-Rhunia_Wilderness";   
    case MAP_RHUNIA_OUTSKIRTS:    return "ROTT-Rhunia_Outskirts";    
    case MAP_RHUNIA_BACKLANDS:    return "ROTT-Rhunia_Backlands";    
    
    // Etzland
    case MAP_ETZLAND_CITADEL:     return "ROTT-Etzland_Citadel";      
    case MAP_ETZLAND_WILDERNESS:  return "ROTT-Etzland_Wilderness";   
    case MAP_ETZLAND_OUTSKIRTS:   return "ROTT-Etzland_Outskirts";    
    case MAP_ETZLAND_BACKLANDS:   return "ROTT-Etzland_Backlands";    
    
    // Haxlyn
    case MAP_HAXLYN_CITADEL:      return "ROTT-Haxlyn_Citadel";       
    case MAP_HAXLYN_WILDERNESS:   return "ROTT-Haxlyn_Wilderness";    
    case MAP_HAXLYN_OUTSKIRTS:    return "ROTT-Haxlyn_Outskirts";     
    case MAP_HAXLYN_BACKLANDS:    return "ROTT-Haxlyn_Backlands";     
    
    // Valimor
    case MAP_VALIMOR_CITADEL:     return "ROTT-Valimor_Citadel";       
    case MAP_VALIMOR_WILDERNESS:  return "ROTT-Valimor_Wilderness";    
    case MAP_VALIMOR_OUTSKIRTS:   return "ROTT-Valimor_Outskirts";     
    case MAP_VALIMOR_BACKLANDS:   return "ROTT-Valimor_Backlands";     
    
    // Kalroth
    case MAP_KALROTH_CITADEL:     return "ROTT-Kalroth_Citadel";      
    case MAP_KALROTH_WILDERNESS:  return "ROTT-Kalroth_Wilderness";   
    case MAP_KALROTH_OUTSKIRTS:   return "ROTT-Kalroth_Outskirts";    
    case MAP_KALROTH_BACKLANDS:   return "ROTT-Kalroth_Backlands";    
    
    // Caves
    case MAP_KYRIN_CAVERN:        return "ROTT-Kyrin_Cavern"; 
    case MAP_KAUFINAZ_CAVERN:     return "ROTT-Kaufinaz_Cavern"; 
    
    // The land between the tempests
    case MAP_AKSALOM_SKYGATE:     return "ROTT-Aksalom_Skygate";      
    case MAP_AKSALOM_GROVE:       return "ROTT-Aksalom_Grove";        
    case MAP_AKSALOM_STORMLANDS:  return "ROTT-Aksalom_Stormlands";   
    case MAP_MYSTERY_PATH:        return "ROTT-Mystery_Path";  
    case MAP_MOUNTAIN_SHRINE:     return "ROTT-Mountain_Shrine";    
    
    default:
      yellowLog("Warning (!) Unhandled map name (" $ mapName $ ")");
      break;
  }
}

/*=============================================================================
 * getCurrentMap()
 * 
 * returns an enumerated map entry for the current map
 *===========================================================================*/
public function MapNameEnum getCurrentMap() {
  local string mapFile;
  
  mapFile = worldInfo.getMapName();
  
  switch (mapFile) {
    // No map defined?
    case "": return NO_MAP_NAME;
    
    // UI Scenes
    case "UI_Title_Screen":     return MAP_UI_TITLE_MENU;
    case "UI_Credits":          return MAP_UI_CREDITS;
    case "UI_Game_Over":        return MAP_UI_GAME_OVER;
    
    // Talonovia
    case "Talonovia_Town":      return MAP_TALONOVIA_TOWN;
    case "Talonovia_Shrine":    return MAP_TALONOVIA_SHRINE;
    case "Talonovia_Outskirts": return MAP_TALONOVIA_OUTSKIRTS;
    case "Talonovia_Backlands": return MAP_TALONOVIA_BACKLANDS;
    
    // Rhunia
    case "Rhunia_Citadel":      return MAP_RHUNIA_CITADEL;
    case "Rhunia_Wilderness":   return MAP_RHUNIA_WILDERNESS;
    case "Rhunia_Outskirts":    return MAP_RHUNIA_OUTSKIRTS;
    case "Rhunia_Backlands":    return MAP_RHUNIA_BACKLANDS;
    
    // Etzland
    case "Etzland_Citadel":     return MAP_ETZLAND_CITADEL;
    case "Etzland_Wilderness":  return MAP_ETZLAND_WILDERNESS;
    case "Etzland_Outskirts":   return MAP_ETZLAND_OUTSKIRTS;
    case "Etzland_Backlands":   return MAP_ETZLAND_BACKLANDS;
    
    // Haxlyn
    case "Haxlyn_Citadel":      return MAP_HAXLYN_CITADEL;
    case "Haxlyn_Wilderness":   return MAP_HAXLYN_WILDERNESS;
    case "Haxlyn_Outskirts":    return MAP_HAXLYN_OUTSKIRTS;
    case "Haxlyn_Backlands":    return MAP_HAXLYN_BACKLANDS;
    
    // Valimor
    case "Valimor_Citadel":     return MAP_VALIMOR_CITADEL;
    case "Valimor_Wilderness":  return MAP_VALIMOR_WILDERNESS;
    case "Valimor_Outskirts":   return MAP_VALIMOR_OUTSKIRTS;
    case "Valimor_Backlands":   return MAP_VALIMOR_BACKLANDS;
    
    // Kalroth
    case "Kalroth_Citadel":     return MAP_KALROTH_CITADEL;
    case "Kalroth_Wilderness":  return MAP_KALROTH_WILDERNESS;
    case "Kalroth_Outskirts":   return MAP_KALROTH_OUTSKIRTS;
    case "Kalroth_Backlands":   return MAP_KALROTH_BACKLANDS;
    
    // Caves
    case "Kyrin_Cavern":   return MAP_KYRIN_CAVERN; 
    case "Kaufinaz_Cavern":   return MAP_KAUFINAZ_CAVERN; 
    
    // The land between the tempests
    case "Aksalom_Skygate":     return MAP_AKSALOM_SKYGATE;
    case "Aksalom_Grove":       return MAP_AKSALOM_GROVE;
    case "Aksalom_Stormlands":  return MAP_AKSALOM_STORMLANDS;
    case "Mystery_Path":        return MAP_MYSTERY_PATH;
    case "Mountain_Shrine":     return MAP_MOUNTAIN_SHRINE;
    
    default:
      yellowLog("Warning (!) Current map (" $ mapFile $ ") is not enumerated");
      break;
  }
}

/*=============================================================================
 * getCombatScene()
 * 
 * 
 *===========================================================================*/
public function ROTT_UI_Scene_Combat_Encounter getCombatScene() {
  return sceneManager.sceneCombatEncounter;
}

/*=============================================================================
 * getOverWorldPage()
 * 
 * Accessor for the over world page in the over world scene
 *===========================================================================*/
public function ROTT_UI_Page_Over_World getOverWorldPage() {
  if (sceneManager == none) return none;
  if (sceneManager.sceneOverWorld == none) return none;
  if (sceneManager.sceneOverWorld.overWorldPage == none) return none;
  return sceneManager.sceneOverWorld.overWorldPage;
}

/*=============================================================================
 * showGameplayNotification()
 * 
 * Displays a message at the bottom-center of the over world screen
 *===========================================================================*/
public function showGameplayNotification(string message) {
  if (getOverWorldPage() == none) return;
  // Pass to the over world page
  getOverWorldPage().showGameplayNotification(message);
}

/*=============================================================================
 * scene
 * 
 * Returns a referene to the scene that is currently being drawn on screen.
 *===========================================================================*/
public function UI_Scene getActiveScene() {
  return ROTT_UI_Scene_Manager(hud.sceneManager).scene;
}

/*=============================================================================
 * setPlayerControl()
 * 
 * Gives player control for movement in the 3D over world
 *===========================================================================*/
public function setPlayerControl(bool bEnabled) {
  tempestPC.enablePlayerControls(bEnabled);
}

/*=============================================================================
 * updateHeroesStatus()
 * 
 * Renders a status update in the over world
 *===========================================================================*/
public function updateHeroesStatus() {
  if (sceneManager == none) return;
  
  // If the active scene is overworld, do stuff with its display
  sceneManager.sceneOverWorld.updateHeroesStatus();
}

/*=============================================================================
 * canOpenMenu()
 * 
 * Returns true if the menu can be opened.
 *===========================================================================*/
public function bool canOpenMenu() {
  // Ignore while transitioning
  if (ROTT_UI_Scene_Manager(hud.sceneManager).transitioner.bRenderingEnabled) return false;
  
  // Ignore if we arent in the 3D world
  if (sceneManager.scene != sceneManager.sceneOverWorld) return false;
  if (bEncounterPending) return false;
  if (bEncounterActive) return false;
  if (bPlayerFalling) return false;
  
  // Otherwise allow
  return true;
}

/*=============================================================================
 * openWorldMap()
 * 
 * Attempts to open the world map
 *===========================================================================*/
public function openWorldMap() {
  if (canOpenMenu()) sceneManager.switchScene(SCENE_WORLD_MAP);
  
  // Sfx
  sfxBox.playSFX(SFX_OPEN_WORLD_MAP);
}

/*=============================================================================
 * openGameMenu()
 * 
 * Opens game menu
 *===========================================================================*/
public function openGameMenu() {
  // Find the scene in the scene manager and switch to it
  sceneManager.switchScene(SCENE_GAME_MENU);
  
  // Sfx
  sfxBox.playSFX(SFX_MENU_NAVIGATE);
}

/*=============================================================================
 * closeGameMenu()
 * 
 * Switches from game menu to over world
 *===========================================================================*/
public function closeGameMenu() {
  sceneManager.switchScene(SCENE_OVER_WORLD);
  sceneManager.closeGameMenu();
  hud.closeGameMenu();
  
  if (sceneManager.sceneCombatResults.bLootPending) {
    sceneManager.sceneOverWorld.fadeIn();
    sceneManager.sceneCombatResults.bLootPending = false;
  }
}

/*=============================================================================
 * openNPCDialog()
 * 
 * Opens the npc scene with the given npc
 *===========================================================================*/
public function openNPCDialog(class<ROTT_NPC_Container> npcType) {
  local UI_Scene activeScene;
  
  sceneManager.switchScene(SCENE_NPC_DIALOG);
  activeScene = sceneManager.scene;
  ROTT_UI_Scene_Npc_Dialog(activeScene).openNPCDialog(npcType);
}

/*=============================================================================
 * getEnemyUI()
 * 
 * Accessor for enemy UI containers
 *===========================================================================*/
public function ROTT_UI_Displayer_Combat_Enemy getEnemyUI(int index) { 
  local ROTT_UI_Scene_Combat_Encounter combatScene;
  
  combatScene = sceneManager.sceneCombatEncounter;
  
  if (combatScene.combatPage == none) {
    return none;
  }
  
  return combatScene.combatPage.enemyDisplayers[index];
}

/*=============================================================================
 * pushJournalEntry()
 * 
 * Called by quest milestone triggers to update the journal.
 *===========================================================================*/
public function pushJournalEntry(string questMsg) {
  playerProfile.pushJournalEntry(questMsg);
}

/*=============================================================================
 * tick()
 * 
 * Called every time the engine renders a frame, with the elapsed render time.
 *===========================================================================*/
public function tick(float deltaTime) {
  super.tick(deltaTime);
  
  // Give time to profile
  if (playerProfile != none) {
    playerProfile.elapseTime(deltaTime);
    
    // Track temporal usage
    if (gameSpeed != 1) {
      playerProfile.timeTemporallyAccelerated += deltaTime / gameSpeed;
    }
  }
  
  // Track combat delay
  if (bDelayedCombat) {
    // Track time for countdown
    encounterDelay -= deltaTime;
    
    // Check for completion
    if (encounterDelay <= 0) {
      bDelayedCombat = false;
      forceEncounter(delayedMobInfo);
    }
  }
  
  // Give time to transitioner
  ROTT_UI_Scene_Manager(hud.sceneManager).transitioner.elapseTimers(deltaTime);
}

/*=============================================================================
 * addEncounterTick()
 * 
 * Increments the "progress" toward encountering enemies in the 3D World.
 *===========================================================================*/
public function addEncounterTick() {
  local float frequencyAmp;
  
  // Check for enemy population
  if (playerProfile.gameMode == MODE_TOUR) return;
  if (playerProfile.cheatNoEncounters) return;
  if (safetyMode) return;
  if (!isHostileArea()) return;
  
  // Check for pending encounter rate mods
  if (bPendingZoneCheck) {
    yellowLog("Pending zone check!");
    if (checkZoneRate()) bPendingZoneCheck = false;
  }
  
  // Default frequency
  frequencyAmp = 2;
  
  // Prayer frequency modifier
  if (playerProfile.bPraying) {
    frequencyAmp /= 2;
  }
  
  // Prayer frequency modifier
  if (encounterRateMod == ENCOUNTER_RATE_REDUCED) {
    frequencyAmp /= 2;
  }
  
  // Crouch frequency modifier
  if (tempestPC.bCrouching) {
    frequencyAmp *= 2;
  }
  
  // Increment ticks
  encounterTicks += (2 + rand(4)) * frequencyAmp * gameSpeed;
  
  // Check if time has elapsed enough for an encounter
  if (encounterTicks >= encounterLimit + encounterMod) {
    // Roll a random mob
    if (rollRandomMob()) {
      startCombatTransition();
    } else {
      yellowLog("Warning (!) Could not roll mob for this zone");
      scriptTrace();
      
      // Load back to town
      consoleCommand("open " $ getMapFileName(MAP_TALONOVIA_TOWN));
    }
  }
}

/*=============================================================================
 * rollRandomMob()
 * 
 * Rolls random enemy units based on encounter zones
 *
 * Pre condition notes: Encounter UI is not actually up yet.
 *
 * Post condition: All combat units and their respective data is ready.
 *===========================================================================*/
private function bool rollRandomMob() {
  local ROTT_Combat_Enemy enemyUnit;
  local SpawnerInfo spawnInfo;
  local SpawnTypes spawnType;
  local int mobSize;
  local int i;
  
  whiteLog("--+-- Rolling Random Mob --+--");
  
  // Check validity of mob zone
  if (!isHostileArea()) return false;
  
  // Create new mob
  enemyEncounter = new(self) class'ROTT_Mob';
  enemyEncounter.linkReferences();
  
  // Set spawn mode from prayer
  spawnType = (playerProfile.bPraying) ? SPAWN_ALTERNATE : SPAWN_NORMAL;
  
  // Roll for elite
  if (rand(100) < ELITE_SPAWN_CHANCE * ((playerProfile.bSinging) ? 2 : 1)) {
    // Roll champion spawn
    enemyUnit = makeUnit(getRandomSpawnRecord(), SPAWN_CHAMPION);
    enemyEncounter.addEnemy(enemyUnit);
    sfxBox.playSFX(SFX_COMBAT_START_CHAMP);
    
    // Roll for henchmen duo (50%)
    if (rand(2) == 0) {
      // Roll henchman type
      spawnInfo = getRandomSpawnRecord();
      
      // Add left henchmen
      enemyUnit = makeUnit(spawnInfo, spawnType);
      enemyEncounter.addEnemy(enemyUnit);
      
      // Add right henchmen
      enemyUnit = makeUnit(spawnInfo, spawnType);
      enemyEncounter.addEnemy(enemyUnit);
    }
    
  } else {
    // Roll random mob size
    if (playerProfile.bSinging) {
      mobSize = rand(2) + 2;
    } else {
      mobSize = rand(3) + 1;
    }
    
    sfxBox.playSFX(SFX_COMBAT_START);
    
    // Roll enemies
    for (i = 0; i < mobSize; i++) {
      // Make unit
      enemyUnit = makeUnit(getRandomSpawnRecord(), spawnType);
      enemyEncounter.addEnemy(enemyUnit);
    }
  }
  
  // Success
  return true;
}

/*=============================================================================
 * getRandomSpawnRecord()
 * 
 * Returns a random record containing enemy spawn info
 *===========================================================================*/
private function SpawnerInfo getRandomSpawnRecord() {
  local array<SpawnerInfo> spawnRecords;
  local bool spawnHit;
  local int chanceSum;
  local int divisor;
  local int roll;
  local int i, j;
  
  // Common chance cut when crouched
  divisor = (tempestPC.bCrouching) ? 2 : 1;
  
  // Make a list of all spawn records
  for (i = 0; i < encounterZones.length; i++) {
    // Check if zone is active
    if (encounterZones[i].bActiveZone) {
      if (playerProfile.bPraying) {
        // Make alternate List
        for (j = 0; j < encounterZones[i].altSpawnList.length; j++) {
          spawnRecords.addItem(encounterZones[i].altSpawnList[j]);
        }
      } else {
        // Make regular List
        for (j = 0; j < encounterZones[i].spawnList.length; j++) {
          spawnRecords.addItem(encounterZones[i].spawnList[j]);
        }
      }
    }
  }
  
  // Calculate chance sum
  for (i = 0; i < spawnRecords.length; i++) {
    switch (spawnRecords[i].rarity) {
      case Common:     chanceSum += COMMON_SPAWN_CHANCE / divisor; break;
      case Uncommon:   chanceSum += UNCOMMON_SPAWN_CHANCE;         break;
      case Rare:       chanceSum += RARE_SPAWN_CHANCE;             break;
    }
  }
  
  // Roll one by one
  i = 0;
  while (chanceSum > 0 && i < spawnRecords.length) {
    // Reroll
    roll = rand(chanceSum);
    switch (spawnRecords[i].rarity) {
      case Common:    spawnHit = roll < COMMON_SPAWN_CHANCE / divisor;  break;
      case Uncommon:  spawnHit = roll < UNCOMMON_SPAWN_CHANCE;          break;
      case Rare:      spawnHit = roll < RARE_SPAWN_CHANCE;              break;
    }
    
    if (spawnHit) {
      // Return result
      return spawnRecords[i];
    } else {
      // Remove chance to spawn from the chance sum
      switch (spawnRecords[i].rarity) {
        case Common:    chanceSum -= COMMON_SPAWN_CHANCE / divisor;  break;
        case Uncommon:  chanceSum -= UNCOMMON_SPAWN_CHANCE;          break;
        case Rare:      chanceSum -= RARE_SPAWN_CHANCE;              break;
      }
    }
    i++;
  }
  
  yellowLog("Warning (!) Failed to randomize spawn records.");
}

/*=============================================================================
 * debugSpawnRecords()
 * 
 * Outputs all spawn records to the console
 *===========================================================================*/
public function debugSpawnRecords() {
  local array<SpawnerInfo> spawnRecords;
  local int i, j;
  
  // Make list of all spawn records
  for (i = 0; i < encounterZones.length; i++) {
    if (playerProfile.bPraying) {
      for (j = 0; j < encounterZones[i].altSpawnList.length; j++) {
        // Alternate List
        spawnRecords.addItem(encounterZones[i].altSpawnList[j]);
      }
    } else {
      for (j = 0; j < encounterZones[i].spawnList.length; j++) {
        // Regular List
        spawnRecords.addItem(encounterZones[i].spawnList[j]);
      } 
    }
  }
  
  // Debug output
  for (i = 0; i < spawnRecords.length; i++) {
    ///cyanLog("[" $ i $ "]" @ spawnRecords[i].enemyType, DEBUG_WORLD);
    ///whiteLog("   --- Levels:" @ spawnRecords[i].levelRange.min @ "-" @ spawnRecords[i].levelRange.max, DEBUG_WORLD);
    if (spawnRecords[i].levelRange.max == 0 || spawnRecords[i].levelRange.min == 0) redLog("Error (!) Max level zero");
  }
}

/*=============================================================================
 * makeUnit()
 * 
 * Creates a unit from a given spawn record
 *===========================================================================*/
public function ROTT_Combat_Enemy makeUnit
(
  SpawnerInfo spawnRecord, 
  SpawnTypes spawnMode
) 
{
  local class<ROTT_Combat_Enemy> enemyClass;
  local ROTT_Combat_Enemy enemyUnit;
  
  // Check for valid monster
  if (getMonsterClass(spawnRecord) == none) {
    yellowLog("Warning (!) Monster class not found for " $ spawnRecord.enemyType);
    return none;
  }
  
  // Spawn by monster type
  enemyClass = getMonsterClass(spawnRecord);
  enemyUnit = class'ROTT_Combat_Enemy'.static.generateMonster(
    enemyClass,
    spawnRecord,
    spawnMode
  );
  
  return enemyUnit;
}

/*=============================================================================
 * getMonsterClass()
 * 
 * Accesses class files for the given spawn record
 *===========================================================================*/
public function class<ROTT_Combat_Enemy> getMonsterClass
(
  SpawnerInfo spawnRecord
) 
{
  return encounterZones[0].getEnemyClass(spawnRecord.enemyType);
  
  // Any encounter zone can be used to access the class list
  //return info.static.getEnemyClass(spawnRecord.enemyType);
}

/*=============================================================================
 * endCombat()
 * 
 * Called when the final enemy has been defeated, and "removed"
 *===========================================================================*/
public function endCombat() {
  // Set up exp transfer
  getActiveParty().addExp(enemyEncounter.mobExp);
  
  // Queue transition to victory UI
  getCombatScene().endBattle();
}

/*=============================================================================
 * addEncounterZone()
 * 
 * Populates a zone into a list for fetching random spawn records for 
 * encounters
 *===========================================================================*/
public function addEncounterZone(ROTT_Worlds_Encounter_Info zone) {
  encounterZones.addItem(zone);
}

/*=============================================================================
 * zoneTouchUpdate()
 * 
 * Called when the player touches an encounter zone
 *===========================================================================*/
public function zoneTouchUpdate() {
  if (getOverWorldPage() != none) {
    checkZoneRate();
  } else {
    bPendingZoneCheck = true;
  }
}

/*=============================================================================
 * checkZoneRate()
 * 
 * Called to compare the culled enemy level to the current mobs
 *===========================================================================*/
public function bool checkZoneRate() {
  local int i, j;
  local int max;
  
  if (getOverWorldPage() == none) return false;
  
  // Scan alternative prayer list
  for (i = 0; i < encounterZones.length; i++) {
    for (j = 0; j < encounterZones[i].altSpawnList.length; j++) {
      if (encounterZones[i].bActiveZone) {
        if (max < encounterZones[i].altSpawnList[j].levelRange.max) {
          max = encounterZones[i].altSpawnList[j].levelRange.max;
        }
      }
    }
  }
  
  // Check if max level is within reduced rate range
  if (max <= playerProfile.reducedRateEnemyLevel) {
    // Check if enemy rate is not already reduced
    if (encounterRateMod != ENCOUNTER_RATE_REDUCED) {
      // Display message
      getOverWorldPage().showReducedRate();
      
      // Change encounter rate mod
      encounterRateMod = ENCOUNTER_RATE_REDUCED;
    }
  } else {
    // Change encounter rate mod
    encounterRateMod = ENCOUNTER_RATE_STANDARD;
  }
  
  return true;
}

/*=============================================================================
 * setCheckpointInfo()
 *
 * This function sets the checkpoint info for the given index
 *===========================================================================*/
public function setCheckpointInfo
(
  int index,
  vector spawnLocation,
  rotator spawnRotation
) 
{
  // Expand array as needed
  if (checkpoints.length <= index) checkpoints.length = index + 1;
  
  // Add info the array
  checkPoints[index].location = spawnLocation;
  checkPoints[index].rotation = spawnRotation;  /// Funky bug here?
}

/*=============================================================================
 * setSafetyMode()
 * 
 * Used to prevent encounters for safe areas in the 3d world
 *===========================================================================*/
public function setSafetyMode(bool safetyState) {
  safetyMode = safetyState;
}

/*=============================================================================
 * isHostileArea()
 * 
 * Returns true if enemies are spawnable right now.
 *===========================================================================*/
public function bool isHostileArea() {
  local int i;
  
  // Scan for active zones 
  for (i = 0; i < encounterZones.length; i++) {
    if (encounterZones[i].bActiveZone) return true; /// (temporary fix, need to look for actual spawners not just zones)
  }
  
  return false; 
}

/*=============================================================================
 * isInTown()
 * 
 * Returns true if player is in a town
 *===========================================================================*/
public function bool isInTown() {
  switch (getCurrentMap()) {
    case MAP_TALONOVIA_TOWN:
    case MAP_TALONOVIA_BACKLANDS:
    case MAP_TALONOVIA_OUTSKIRTS:
    case MAP_TALONOVIA_SHRINE:
    case MAP_AKSALOM_SKYGATE:
    case MAP_AKSALOM_GROVE:
      return true;
    default:
      return false;
  }
}

/*=============================================================================
 * launchNPCService()
 *
 * Transfers out from NPC dialog to the specified NPC Service interface.
 *===========================================================================*/
public function launchNPCService(NpcServices serviceType) {
  switch (serviceType) {
    case SERVICE_BLESSINGS: 
      // Switch to blessing interface
      sceneManager.switchScene(SCENE_SERVICE_BLESSINGS);
      break;
    case SERVICE_ALCHEMY: 
      // Switch to alchemy minigame for enchantments
      sceneManager.switchScene(SCENE_SERVICE_ALCHEMY);
      break;
    case SERVICE_BESTIARY: 
      // Switch to bestiary combat
      sceneManager.switchScene(SCENE_SERVICE_BESTIARY);
      break;
    case SERVICE_INFORMATION: 
      // Switch to information booklet
      sceneManager.switchScene(SCENE_SERVICE_INFORMATION);
      break;
    case SERVICE_LOTTERY: 
      // Switch to witch's lottery minigame
      sceneManager.switchScene(SCENE_SERVICE_LOTTERY);
      break;
    case SERVICE_NECROMANCY: 
      // Switch to necromancy minigame
      sceneManager.switchScene(SCENE_SERVICE_NECROMANCY);
      break;
    case SERVICE_BARTERING: 
      // Switch to merchant's bartering service
      sceneManager.switchScene(SCENE_SERVICE_BARTERING);
      break;
    default:
      yellowLog("Warning (!) Unhandled service type.");
      break;
  }
}

/*=============================================================================
 * canDeductCosts()
 *
 * Returns true if the player can afford the costs, false otherwise.
 *===========================================================================*/
public function bool canDeductCosts(array<ItemCost> costList) {
  local int i;
  
  // Scan through costs
  for (i = 0; i < costList.length; i++) {
    // Return false if any item is insufficient
    if (!playerProfile.canDeductItem(costList[i])) return false;
  }
  
  return true;
}


/*=============================================================================
 * deductCosts()
 *
 * Used to try and deduct costs, (e.g. during NPC services). Returns true if
 * player has sufficient item quantities, false otherwise.
 *===========================================================================*/
public function bool deductCosts(array<ItemCost> costList) {
  local int i;
  
  // Check if costs can be deducted
  if (!canDeductCosts(costList)) {
    return false;
  }
  
  // Iterate through costs
  for (i = 0; i < costList.length; i++) {
    // Deduct each cost
    playerProfile.deductItem(costList[i]);
  }
  
  return true;
}

/*=============================================================================
 * getConscriptionCost()
 * 
 * returns the price of adding a new party, based on the number of existing
 * parties in the player's profile
 *===========================================================================*/
public function array<ItemCost> getConscriptionCost
(
  int parties = playerProfile.getNumberOfParties()
) 
{
  local array<ItemCost> costList;
  local ItemCost costInfo;
  
  // Set gold cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gold';
  costInfo.quantity = (parties * 12500) + 12500;
  
  // Add to list
  costList.addItem(costInfo);
  
  // Set gems cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gem';
  costInfo.quantity = (parties * 125) + 125;
  
  // Add to list
  costList.addItem(costInfo);
  
  // Return list
  return costList;
}

/*=============================================================================
 * getResetStatCost()
 * 
 * returns the price resetting a stat point
 *===========================================================================*/
public function array<ItemCost> getResetStatCost() {
  local array<ItemCost> costList;
  local ItemCost costInfo;
  
  // Set gold cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gold';
  costInfo.quantity = 250;
  
  // Add to list
  costList.addItem(costInfo);
  
  // Return list
  return costList;
}

/*=============================================================================
 * getResetSkillCost()
 * 
 * returns the price resetting a skill point
 *===========================================================================*/
public function array<ItemCost> getResetSkillCost() {
  local array<ItemCost> costList;
  local ItemCost costInfo;
  
  // Set gold cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gold';
  costInfo.quantity = 125;
  
  // Add to list
  costList.addItem(costInfo);
  
  // Set gems cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gem';
  costInfo.quantity = 5;
  
  // Add to list
  costList.addItem(costInfo);
  
  // Return list
  return costList;
}

/*=============================================================================
 * getBlessingCost()
 * 
 * returns the price for blessing a hero's stats
 *===========================================================================*/
public function array<ItemCost> getBlessingCost() {
  local array<ItemCost> costList;
  local ItemCost costInfo;
  
  // Set gold cost
  costInfo.currencyType = class'ROTT_Inventory_Item_Gold';
  costInfo.quantity = sceneManager.scene.getSelectedHero().getBlessingCost();
  
  // Add to list
  costList.addItem(costInfo);
  
  // Return list
  return costList;
}

/*=============================================================================
 * getVersionInfo()
 *
 * A string of the game version to be displayed on the screen.
 *===========================================================================*/
public static function string getVersionInfo() {
  local string verString;
  
  verString = "v " $ MAJOR $ "." $ MINOR $ "." $ REVISION;
  if (PATCH != '') verString $= "." $ PATCH;
  
  return verString;
}

/*=============================================================================
 * getInventoryCount()
 *
 * Given a type of item, this will return the amount the player has of it.
 *===========================================================================*/
public function int getInventoryCount(class<ROTT_Inventory_Item> itemType) {
  // Return zero if the item is not found
  if (playerProfile.findItem(itemType) == none) return 0;
  
  // Find item quantity
  return playerProfile.findItem(itemType).quantity;
}

/*=============================================================================
 * generateLoot()
 *
 * Given a monster/chest level, and a list of loot modifiers, generates items.
 * - itemLevel: Impacts equipment attributes
 * - amplifier: Impacts quantities, and increases itemLevels
 * - dropMods:  Specific loot modifiers for quantity, chance, etc. 
 *===========================================================================*/
public function ROTT_Inventory_Package generateLoot
(
  int itemLevel,
  float amplifier,
  array<ItemDropMod> dropMods
) 
{
  local ROTT_Inventory_Package lootPackage;
  local ROTT_Inventory_Item newItem;
  local ItemDropMod dropMod;
  local int i, j, k;
  
  lootPackage = new class'ROTT_Inventory_Package';
  lootPackage.linkReferences();
  
  // Add enchantment power to amplifier
  amplifier += playerProfile.getLuckBoost();
  
  // Iterate through currencies and ritual drops
  for (i = 0; i < lootTypes.length && lootPackage.count() < 8; i++) {
    // Find drop modifications
    dropMod = getDropMod(dropMods, lootTypes[i]);
    
    // Reset item drop count
    k = 0;
    
    // Apply full level quantity amplifiers
    for (j = 0; j < int(amplifier); j++) {
      // Try to generate an item
      newItem = lootTypes[i].static.generateItem(
        lootTypes[i], itemLevel + amplifier, dropMod,
        enemyEncounter.bBestiarySummon
      );
      
      // Check if item dropped
      if (newItem != none) {
        newItem.initializeAttributes();
        lootPackage.addItem(newItem);
        
        // Count item drops per item type
        k++;
        
        // Cap for gem drops...
        if (k >= 3 && lootTypes[i] == class'ROTT_Inventory_Item_Gem') break;
      }
    }
    
    // Check for remaining fraction level amplifier
    if (amplifier - int(amplifier) > 0) {
      // Apply amplifier fraction to chance
      dropMod.chanceAmp *= amplifier - int(amplifier);
      
      // Try to generate an item
      newItem = lootTypes[i].static.generateItem(
        lootTypes[i], itemLevel + amplifier, dropMod,
        enemyEncounter.bBestiarySummon
      );
    
      // Check if item dropped
      if (newItem != none) {
        newItem.initializeAttributes();
        lootPackage.addItem(newItem);
      }
    }
  }
  
  // Cull item count, removes extra ritual items
  lootPackage.cullInventory();
  
  /// Strongly recommend randomizing the order of iteration through equipment, otherwise
  /// the items near the end of the list are more likely to be culled
  // Iterate through all possible equipment drops
  for (i = 0; i < equipTypes.length && lootPackage.count() < 8; i++) {
    // Find drop modifications
    dropMod = getDropMod(dropMods, equipTypes[i]);
    
    // Try to generate an item
    newItem = equipTypes[i].static.generateItem(
      equipTypes[i], itemLevel + amplifier, dropMod,
        enemyEncounter.bBestiarySummon
    );
    
    // Check if item dropped
    if (newItem != none) {
      newItem.initializeAttributes();
      lootPackage.addItem(newItem);
    }
  }
  
  // Cull item count, removes items for 8 slot limit
  lootPackage.cullInventory();
  
  return lootPackage;
}
  
/*=============================================================================
 * getDropMod()
 * 
 * Returns a drop mod for the given item type, or a default drop modifier.
 *===========================================================================*/
public function ItemDropMod getDropMod
(
  array<ItemDropMod> dropMods,
  class<ROTT_Inventory_Item> lootType
) 
{
  local ItemDropMod dropMod;
  local int i;
  
  // Skip gems for bestiary summons
  if (enemyEncounter != none) {
    if (enemyEncounter.bBestiarySummon) {
      if (lootType == class'ROTT_Inventory_Item_Gem') return dropMod;
    }
  }
  
  // Look through drop mods
  for (i = 0; i < dropMods.length; i++) {
    // Check if item types match
    if (dropMods[i].dropType == lootType) {
      return dropMods[i];
    }
  }
  
  // Default drop mod
  return dropMod;
}

/*=============================================================================
 * generateBarterItem()
 *
 * Generates an item for barter menu 
 *===========================================================================*/
public function ROTT_Inventory_Item generateBarterItem
(
  int itemLevel,
  array<class<ROTT_Inventory_Item> > itemTypes
) 
{
  local ROTT_Inventory_Item newItem;
  local ItemDropMod dropMod;
  local int randomIndex;
  
  // Randomly select an item class
  randomIndex = rand(itemTypes.length);
  
  // Force 100% chance to generate
  dropMod.dropType = itemTypes[randomIndex];
  dropMod.chanceOverride = 100;
  
  // Generate the item
  newItem = itemTypes[randomIndex].static.generateItem(
    itemTypes[randomIndex], 
    itemLevel, 
    dropMod
  );
  
  if (newItem == none) {
    yellowLog("Warning (!) Failed to generate barter item, index " $ randomIndex);
    scriptTrace();
  }
  
  newItem.initializeAttributes();
  return newItem;
}
  
/*=============================================================================
 * Party accessors
 *===========================================================================*/
public function ROTT_Party getActiveParty() {
  return playerProfile.getActiveParty();
}

/*=============================================================================
 *  Linking functions
 *===========================================================================*/
public function setPlayerController(ROTT_Player_Controller pc) {
  `assert(pc != none);
  tempestPC = pc;
}

public function setPawn(ROTT_Player_Pawn pawn) {
  `assert(pawn != none);
  tempestPawn = pawn;
}

public function setSceneManager(ROTT_UI_Scene_Manager sceneMgr) {
  `assert(sceneMgr != none);
  
  // Reference scene manager and hud
  sceneManager = sceneMgr;
  hud = ROTT_UI_HUD(sceneManager.outer);
  
  // Provide references to UI components
  if (playerProfile != none) {
    playerProfile.linkGUIReferences(sceneManager);
  }
}

/*=============================================================================
 * debugDataStructure()
 * 
 * Dumps most of the data structure to the console log when called
 * (Note: excludes player profile, see DEBUG_PLAYER_PROFILE instead)
 *===========================================================================*/
public function debugDataStructure() {
  whiteLog("-Scene Manager-");
  sceneManager.debugDataStructure();
  
  whiteLog("-Enemy Encounter-");
  if (enemyEncounter == none) {
    greenLog("  none");
  } else {
    enemyEncounter.debugDataStructure();
  }
}

// Ignore default weapon stuff from unreal
function adddefaultinventory(pawn playerPawn);

event destroyed() {
  super.destroyed(); 
}
  
/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Game settings
  HUDType=class'ROTT_UI_HUD'
  DefaultPawnClass=class'ROTT_Player_Pawn'
  PlayerControllerClass=class'ROTT_Player_Controller'
  
  // Encounter limit default
  encounterLimit=3000 ///2800
  
  // Loot types
  lootTypes.add(class'ROTT_Inventory_Item_Gold')
  lootTypes.add(class'ROTT_Inventory_Item_Gem')
  
  equipTypes.add(class'ROTT_Inventory_Item_Quest_Ice_Tome')
  equipTypes.add(class'ROTT_Inventory_Item_Quest_Amulet')
  equipTypes.add(class'ROTT_Inventory_Item_Quest_Goblet')
  
  lootTypes.add(class'ROTT_Inventory_Item_Herb')
  lootTypes.add(class'ROTT_Inventory_Item_Herb_Unjah')
  lootTypes.add(class'ROTT_Inventory_Item_Herb_Saripine')
  lootTypes.add(class'ROTT_Inventory_Item_Herb_Koshta')
  lootTypes.add(class'ROTT_Inventory_Item_Herb_Xuvi')
  lootTypes.add(class'ROTT_Inventory_Item_Herb_Zeltsi')
  lootTypes.add(class'ROTT_Inventory_Item_Herb_Aquifinie')
  lootTypes.add(class'ROTT_Inventory_Item_Herb_Jengsu')
  
  lootTypes.add(class'ROTT_Inventory_Item_Charm_Bayuta')
  lootTypes.add(class'ROTT_Inventory_Item_Charm_Kamita')
  lootTypes.add(class'ROTT_Inventory_Item_Charm_Eluvi')
  lootTypes.add(class'ROTT_Inventory_Item_Charm_Myroka')
  lootTypes.add(class'ROTT_Inventory_Item_Charm_Shukisu')
  lootTypes.add(class'ROTT_Inventory_Item_Charm_Erazi')
  lootTypes.add(class'ROTT_Inventory_Item_Charm_Cerok')
  equipTypes.add(class'ROTT_Inventory_Item_Charm_Zogis_Anchor')
  
  lootTypes.add(class'ROTT_Inventory_Item_Bottle_Swamp_Husks')
  lootTypes.add(class'ROTT_Inventory_Item_Bottle_Harrier_Claws')
  lootTypes.add(class'ROTT_Inventory_Item_Bottle_Nettle_Roots')
  lootTypes.add(class'ROTT_Inventory_Item_Bottle_Faerie_Bones')
  lootTypes.add(class'ROTT_Inventory_Item_Bottle_Norkiva_Chips')
  lootTypes.add(class'ROTT_Inventory_Item_Bottle_Yinras_Ore')
  
  equipTypes.add(class'ROTT_Inventory_Item_Lustrous_Baton')
  equipTypes.add(class'ROTT_Inventory_Item_Lustrous_Baton_Chroma_Conductor')
  
  equipTypes.add(class'ROTT_Inventory_Item_Shield_Kite')
  equipTypes.add(class'ROTT_Inventory_Item_Shield_Kite_Crimson_Heater')
  
  equipTypes.add(class'ROTT_Inventory_Item_Shield_Buckler')
  equipTypes.add(class'ROTT_Inventory_Item_Buckler_Smoke_Shell')
  equipTypes.add(class'ROTT_Inventory_Item_Buckler_Oak_Wilters_Crest')
  
  equipTypes.add(class'ROTT_Inventory_Item_Flat_Brush')
  
  equipTypes.add(class'ROTT_Inventory_Item_Paintbrush')
  equipTypes.add(class'ROTT_Inventory_Item_Paintbrush_Zephyrs_Whisper')
  
  equipTypes.add(class'ROTT_Inventory_Item_Flail')
  equipTypes.add(class'ROTT_Inventory_Item_Flail_Ultimatum')
  
  equipTypes.add(class'ROTT_Inventory_Item_Ceremonial_Dagger')
  equipTypes.add(class'ROTT_Inventory_Item_Ceremonial_Dagger_Whirlwind_Spike')
  
}
















