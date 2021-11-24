/*=============================================================================
 * Player Profile
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is essentially a saved game profile, containing all
 *              of a players progress in the game.
 *===========================================================================*/

class ROTT_Game_Player_Profile extends ROTT_Object
dependsOn(ROTT_Party)
dependsOn(ROTT_NPC_Container)
dependsOn(ROTT_Descriptor_Enchantment_List);

// Username, name of the profile
var privatewrite string username;

// Game modes
enum GameModes {
  MODE_CASUAL,
  MODE_HARDCORE,
  MODE_TOUR,
};

// Username, name of the profile
var privatewrite GameModes gameMode;

// Elapsed game time (excluding load times)
var privatewrite float elapsedPlayTime;

// Milestones for speedruns
enum SpeedRunMilestones {
  MILESTONE_AZRA_KOTH,
  MILESTONE_HYRIX,
  MILESTONE_KHOMAT,
  MILESTONE_VISCORN,
  MILESTONE_GINQSU,
};

// Status for tracking milestone progress
enum MilestoneStatus {
  MILESTONE_INCOMPLETE,
  MILESTONE_JUST_COMPLETED,
  MILESTONE_FINISHED
};

// Data for a single milestone
struct MilestoneInfo {
  var MilestoneStatus status;
  var bool bPersonalBest;
  var float milestoneTime;
  var string milestoneDescription;
  var string milestoneTimeFormatted;
};

// Stores all milestone information for this profile
var privatewrite MilestoneInfo milestoneList[SpeedRunMilestones];

// Stores save data, to access actual variable use getNumberOfParties()
var private int numberOfParties;

// The party controlled by the player is at this index
var public byte activePartyIndex;

// Units controlled by player
var privatewrite ROTT_Party_System partySystem;   

// Players items (inventory items)
var privatewrite ROTT_Inventory_Package_Player playerInventory;   
var privatewrite int savedItemCount;   

// head of linked list, the rest is in each item
var privatewrite class<ROTT_Inventory_Item> firstSavedItemType;   

// Portals unlocked by player
var privatewrite PortalState mapLocks[MapNameEnum];  

// Enchantment levels from minigames
var privatewrite int enchantmentLevels[EnchantmentEnum];  

// Profile data
var public int totalGoldEarned;
var public int totalGemsEarned;
var public int encounterCount;
var public float timeTemporallyAccelerated;

// Tooltip storage
var public bool bHideHeroInfoToolTip;

// Enchantment data
///var privatewrite ROTT_Descriptor_Enchantment_List enchantmentData;

//==================================================//


// Player's action toward conflict
enum ConflictStatus {
  NOT_STARTED,
  ACTION_TAKEN,
  ACTION_SKIPPED
};

// Conflict information storage
struct ConflictInfo {
  var TopicList topicIndex;
  var ConflictStatus status;
  var bool bReversed;
};

var privatewrite array<ConflictInfo> conflictData;

// NPC information for active topics for conversation
enum TopicStatus {
  INACTIVE,
  ACTIVE
};

// A list of 
var privatewrite TopicStatus activeTopics[TopicList];

// Topic history information
enum TopicHistory {
  NOT_DISCUSSED,
  REPLIED,
  COMPLETED
};

// History status for all topics for a single npc
struct NpcHistoryRecord {
  var TopicHistory npcTopicHistory[TopicList];
};

// A list of dialog records for every npc
var privatewrite NpcHistoryRecord npcRecords[NPCs];


//==================================================//

// Milestones for speedruns
enum JournalMilestones {
  // Talonovia
  JOURNAL_TALKED_TO_COUNCIL,
  JOURNAL_COUNCIL_CONFLICT,
  
  // Mountain shrine
  JOURNAL_MET_DRUJIVA,
  JOURNAL_COLLECTED_ICE_TOME,
};

// Quest entry markers
enum QuestMilestones {
  JOURNAL_READY,
  JOURNAL_COMPLETE
};

// Track journal milestones
var privatewrite QuestMilestones bJournalMiletones[JournalMilestones];

// Quest Marks
enum QuestMarks {
  NO_MARK,
  HAXLYN_BRIDGE,
};

// Quest Values
enum QuestValues {
  QUEST_MARK_INCOMPLETE,
  QUEST_MARK_COMPLETE,
};

// Track journal milestones
var privatewrite QuestValues bQuestMarks[QuestMarks];

// Store the preference of the first Talonovian council member
var privatewrite bool bFirstCouncilVotesYes;

// A list of journal entries for quest progression
var privatewrite array<string> journalEntries;
var public int nightCounter;

//==================================================//

// Portal destination checkpoint
var public int arrivalCheckpoint;

// Secrets
var public bool hyperUnlocked;

// Time tracking
var public bool bTrackTime;

// UI Preferences
var public bool showOverworldDetail;

// Hyper glyph skill descriptors
var public ROTT_Descriptor_List_Hyper_Skills hyperSkills;

// Activity statuses
var public bool bPraying;
var public bool bSinging;

// Monsters under this level will have a reduced encounter rate
var public int reducedRateEnemyLevel;
var public int topEnemyLevelsDefeated[10];

// Store tutorial progress for tool tip display 
var public bool bHasUsedSkill;

// Cheats
var public bool cheatNoEncounters;
var public bool cheatManaSkip;
var public bool cheatInvincibility;

/*=============================================================================
 * newGameSetup
 * 
 * Description: This function is called for new games
 *===========================================================================*/
public function newGameSetup(byte newGameMode) {
  // Make party System
  partySystem = new(self) class'ROTT_Party_System';
  partySystem.initSystem();
  partySystem.linkReferences();
  
  // Make inventory
  playerInventory = new(self) class'ROTT_Inventory_Package_Player';
  playerInventory.linkReferences();
  
  // Make hyper glyph storage
  hyperSkills = new(self) class'ROTT_Descriptor_List_Hyper_Skills';
  hyperSkills.initialize();
  
  // Portal system
  initNewGamePortals();
  
  // Set initial event progress (enables NPC greetings)
  activateTopic(INTRODUCTION);
  
  // Set game mode
  setGameMode(GameModes(newGameMode));
}

/*=============================================================================
 * setGameMode()
 *
 * Sets a game mode, should remain unchanged.
 *===========================================================================*/
public function setGameMode(GameModes newGameMode) {
  gameMode = newGameMode;
  
  // Check game mode
  switch (gameMode) {
    case MODE_CASUAL:
      // No changes here
      break;
    case MODE_HARDCORE:
      // Add luck boost
      enchantmentLevels[OMNI_SEEKER] = 10;
      break;
    case MODE_TOUR:
      // Open all portals
      gameInfo.playerProfile.unlockAllPortals();
      break;
  }
  
}

/*=============================================================================
 * pushJournalEntry()
 * 
 * Called by quest milestone triggers to update the journal.
 *===========================================================================*/
public function pushJournalEntry(string questMsg) {
  // Night enumeration prefix
  questMsg = "Night " $ nightCounter $ ": " $ questMsg;
  
  journalEntries.addItem(questMsg);
  
  gameInfo.showGameplayNotification("New Journal Entry!");
}

/*=============================================================================
 * reportMobLevel()
 * 
 * Used to track average monster levels for reducing encounter rates
 *===========================================================================*/
public function reportMobLevel(int addLevel) {
  local int i, j;
  
  // Scan top ten levels
  for (i = 0; i < 10; i++) {
    // Check if input fits in top ten
    if (topEnemyLevelsDefeated[i] < addLevel) {
      // Move the rest down
      for (j = 9; j > i; j--) {
        topEnemyLevelsDefeated[j] = topEnemyLevelsDefeated[j - 1];
      }
      // Insert the new level
      topEnemyLevelsDefeated[i] = addLevel;
      
      // Set new the reduced enemy encounter level
      reducedRateEnemyLevel = topEnemyLevelsDefeated[9] / 3;
      return;
    }
  }
}

/*=============================================================================
 * debugTopLevels()
 * 
 * 
 *===========================================================================*/
public function debugTopLevels() {
  local int i;
  greenLog("Top levels:");
  // Scan top ten levels
  for (i = 0; i < 10; i++) {
    greenLog(" ~ " @ topEnemyLevelsDefeated[i]);
  }
}

/*=============================================================================
 * toggleOverworldDetail()
 *
 * This function modifies the data for tracking overworld detail visibility.
 *===========================================================================*/
public function toggleOverworldDetail() {
  showOverworldDetail = !showOverworldDetail;
}

/*=============================================================================
 * questCheck()
 *
 * Checks for updating journal entries.
 *===========================================================================*/
public function questCheck
(
  TopicList currentTopic, 
  ROTT_NPC_Container targetNPC
)
{
  local string questText;
  
  // Check if player has been introduced to a Talonovian Council member
  if (bJournalMiletones[JOURNAL_TALKED_TO_COUNCIL] == JOURNAL_READY) {
    // Check for introduction trigger
    if (currentTopic == INTRODUCTION) {
      // Replace quest info based on NPC preference
      switch (targetNPC.preferences[OBELISK_ACTIVATION]) {
        case ACTION:
          // Set quest text
          questText = "\n I've been introduced to the %PROFESSION,";
          questText $= "\n %NPC, who has requested me to engage";
          questText $= "\n the obelisk's ritual.";
          bFirstCouncilVotesYes = true;
          break;
        case INACTION:
          // Set quest text
          questText = "\n I've been introduced to the %PROFESSION,";
          questText $= "\n %NPC, who has requested me to abstain";
          questText $= "\n from the obelisk ritual.";
          bFirstCouncilVotesYes = false;
          break;
        default:
          yellowLog("Warning (!) No obelisk preference found?");
      }
      
      // Replace valid talonovian council names
      switch (targetNPC.npcName) {
        case SALUS:    questText = repl(questText, "%NPC", "Salus"); break;
        case MEKUBA:   questText = repl(questText, "%NPC", "Mekuba"); break;
        case HEKATOS:  questText = repl(questText, "%NPC", "Hekatos"); break;
        case TANNIM:   questText = repl(questText, "%NPC", "Tannim"); break;
        case LUCROSUS: questText = repl(questText, "%NPC", "Lucrosus"); break;
        case MIGMAS:   questText = repl(questText, "%NPC", "Migmas"); break;
        case KALEV:    questText = repl(questText, "%NPC", "Kalev"); break;
        default: return;
      }
      
      // Replace professions
      switch (targetNPC.npcName) {
        case SALUS:    questText = repl(questText, "%PROFESSION", "town healer"); break;
        case MEKUBA:   questText = repl(questText, "%PROFESSION", "necromancer"); break;
        case HEKATOS:  questText = repl(questText, "%PROFESSION", "local witch"); break;
        case TANNIM:   questText = repl(questText, "%PROFESSION", "dragon tamer"); break;
        case LUCROSUS: questText = repl(questText, "%PROFESSION", "merchant"); break;
        case MIGMAS:   questText = repl(questText, "%PROFESSION", "alchemist"); break;
        case KALEV:    questText = repl(questText, "%PROFESSION", "former prince"); break;
        default: return;
      }
      
      // Commit to journal entry
      gameInfo.playerProfile.pushJournalEntry(questText);
      bJournalMiletones[JOURNAL_TALKED_TO_COUNCIL] = JOURNAL_COMPLETE;
    }
  }

  // Check if player has noticed conflicting quest info
  if (bJournalMiletones[JOURNAL_COUNCIL_CONFLICT] == JOURNAL_READY) {
    // Check for introduction trigger
    if (currentTopic == INTRODUCTION) {
      // Ignore if no quest conflict found
      if (bFirstCouncilVotesYes && targetNPC.preferences[OBELISK_ACTIVATION] == ACTION) return;
      if (!bFirstCouncilVotesYes && targetNPC.preferences[OBELISK_ACTIVATION] == INACTION) return;
      
      // Replace quest info based on NPC preference
      switch (targetNPC.preferences[OBELISK_ACTIVATION]) {
        case ACTION:
          // Set quest text
          questText = "\n The Talonovian council seems to be in";
          questText $= "\n disagreement.  %NPC, the %PROFESSION,";
          questText $= "\n pushed for performing the obelisk ritual.";
          break;
        case INACTION:
          // Set quest text
          questText = "\n The Talonovian council seems to be in";
          questText $= "\n disagreement.  %NPC, the %PROFESSION,";
          questText $= "\n says not to disturb the obelisk.";
          break;
        default:
          yellowLog("Warning (!) No obelisk preference found?");
      }
      
      // Replace valid talonovian council names
      switch (targetNPC.npcName) {
        case SALUS:    questText = repl(questText, "%NPC", "Salus"); break;
        case MEKUBA:   questText = repl(questText, "%NPC", "Mekuba"); break;
        case HEKATOS:  questText = repl(questText, "%NPC", "Hekatos"); break;
        case TANNIM:   questText = repl(questText, "%NPC", "Tannim"); break;
        case LUCROSUS: questText = repl(questText, "%NPC", "Lucrosus"); break;
        case MIGMAS:   questText = repl(questText, "%NPC", "Migmas"); break;
        case KALEV:    questText = repl(questText, "%NPC", "Kalev"); break;
        default: return;
      }
      
      // Replace professions
      switch (targetNPC.npcName) {
        case SALUS:    questText = repl(questText, "%PROFESSION", "town healer"); break;
        case MEKUBA:   questText = repl(questText, "%PROFESSION", "necromancer"); break;
        case HEKATOS:  questText = repl(questText, "%PROFESSION", "local witch"); break;
        case TANNIM:   questText = repl(questText, "%PROFESSION", "dragon tamer"); break;
        case LUCROSUS: questText = repl(questText, "%PROFESSION", "merchant"); break;
        case MIGMAS:   questText = repl(questText, "%PROFESSION", "alchemist"); break;
        case KALEV:    questText = repl(questText, "%PROFESSION", "former prince"); break;
        default: return;
      }
      
      // Commit to journal entry
      gameInfo.playerProfile.pushJournalEntry(questText);
      bJournalMiletones[JOURNAL_COUNCIL_CONFLICT] = JOURNAL_COMPLETE;
    }
  }

};

/*=============================================================================
 * markQuest()
 *
 * This function is called to save a quest checkpoint. (e.g. Haxlyn Bridge)
 *===========================================================================*/
public function markQuest(QuestMarks questEntry, QuestValues questValue) {
  bQuestMarks[questEntry] = questValue;
}

/*=============================================================================
 * elapseTime()
 *
 * This function is called every tick.
 *===========================================================================*/
public function elapseTime(float deltaTime) {
  if (bTrackTime) elapsedPlayTime += deltaTime / gameInfo.gameSpeed;
}

/*=============================================================================
 * formatMilestoneTime()
 *
 * Returns a formatted version of the current time
 *===========================================================================*/
private function formatMilestoneTime
(
  SpeedRunMilestones milestoneIndex, 
  float milestoneTime
) 
{
  local string formatted;
  
  // Get formatted time from milestone cookie
  formatted = gameInfo.milestoneCookie.formatMilestoneTime(milestoneTime);
  
  // Store time
  milestoneList[milestoneIndex].milestoneTimeFormatted = formatted;
}

/*=============================================================================
 * updateMilestone()
 *
 * This function is called to update milestone progress.
 *===========================================================================*/
public function updateMilestone
(
  SpeedRunMilestones milestoneIndex, 
  MilestoneStatus progress
) 
{
  // Check for valid progress
  if (milestoneList[mileStoneIndex].status < progress) {
    // Mark progress
    milestoneList[mileStoneIndex].status = progress;
    
    // Record time for completion
    if (progress == MILESTONE_FINISHED) {
      milestoneList[mileStoneIndex].milestoneTime = elapsedPlayTime;
      formatMilestoneTime(mileStoneIndex, elapsedPlayTime);
      
      // Check for personal best
      if (gameInfo.recordMilestone(mileStoneIndex, elapsedPlayTime)) {
        milestoneList[mileStoneIndex].bPersonalBest = true;
      }
    }
  } else {
    yellowLog("Warning (!) Invalid progress for milestone");
  }
}

/*=============================================================================
 * processPendingMilestone()
 *
 * Returns a pending milestone if one can be found.
 *===========================================================================*/
public function bool processPendingMilestone(out MilestoneInfo milestone) {
  local int i;
  
  // Scan for milestone updates
  for (i = 0; i < SpeedRunMilestones.enumCount; i++) {
    if (milestoneList[i].status == MILESTONE_JUST_COMPLETED) {
      // Update milestone progress in profile
      updateMilestone(
        SpeedRunMilestones(i), 
        MILESTONE_FINISHED
      );
      
      // Set out milestone argument
      milestone = milestoneList[i];
      return true;
    }
  }
  return false;
}

/*=============================================================================
 * findItem()
 *
 * This function just shortens the path for finding items.
 *===========================================================================*/
public function ROTT_Inventory_Item findItem(class<ROTT_Inventory_Item> itemClass) {
  return playerInventory.findItem(itemClass);
}

/*=============================================================================
 * addCurrency()
 *
 * Used to add currencies or shrine items (independent from drop level info)
 *===========================================================================*/
public function addCurrency
(
  class<ROTT_Inventory_Item> itemClass, 
  int amount, 
  optional bool bSkipCurrencyUpdate = false
) 
{
  local ROTT_Inventory_Item item;

  // Create item
  item = new itemClass;
  item.initialize();
  item.setQuantity(amount);
  
  // Move item to inventory
  playerInventory.addItem(item);
  
  if (bSkipCurrencyUpdate) return;
}

/*=============================================================================
 * canDeductItem()
 *
 * Checks if a list of items can be deducted
 *===========================================================================*/
public function bool canDeductItems(array<ItemCost> costs) {
  local int i;
  
  // Scan the cost list
  for (i = 0; i < costs.length; i++) { 
    if (!canDeductItem(costs[i])) return false;
  }
  return true;
}

/*=============================================================================
 * canDeductItem()
 *
 * Checks if an item can be deducted.  Returns true if sufficient items.
 *===========================================================================*/
public function bool canDeductItem(ItemCost cost) {
  if (cost.quantity < 0) {
    yellowLog("Warning (!) Cost is negative?");
    return false;
  }
  
  // Return true if cost is zero
  if (cost.quantity == 0) return true;
  
  // Return false if the item is not in inventory
  if (findItem(cost.currencyType) == none) return false;
  
  // Check if item quantity is sufficient
  return cost.quantity <= findItem(cost.currencyType).quantity;
}
 
/*=============================================================================
 * deductItems()
 *
 * Subtracts a list of items from the inventory
 *===========================================================================*/
public function bool deductItems(array<ItemCost> costs) {
  local int i;

  // Check if we can deduct this cost
  if (!canDeductItems(costs)) return false;
  
  // Deduct each of the costs
  for (i = 0; i < costs.length; i++) {
    playerInventory.deductItem(costs[i]);
  }
  
  return true;
}

/*=============================================================================
 * deductItem()
 *
 * Subtracts a quantity cost from the inventory if sufficient funds.
 * Returns true if sufficient funds, false if insufficient.
 *===========================================================================*/
public function bool deductItem(ItemCost costInfo) {
  // Check if we can deduct this cost
  if (!canDeductItem(costInfo)) return false;
  
  // Deduct cost from inventory
  return playerInventory.deductItem(costInfo);
}

/*=============================================================================
 * nameProfile()
 *
 * Sets a name for this profile
 *===========================================================================*/
public function nameProfile(string profileName) {
  username = profileName;
}
 
/*=============================================================================
 * These references must be linked after GUI initialization events
 *===========================================================================*/
public function linkGUIReferences(ROTT_UI_Scene_Manager sceneMgr) {
  super.linkGUIReferences(sceneMgr);
  
  // Pass down references all children
  `assert(isRefComplete() == true);
  
  // # here we want to copy scene manager reference down?
}

/*============================================================================= 
 * saveGame()
 *
 * Saves each child component of the player profile
 * (See ROTT_Game_Info.saveGame())
 *===========================================================================*/
public function saveGame
(
  optional bool transitionMode = false, 
  optional int arrivalIndex = -1
) 
{
  local ROTT_Combat_Hero heroUnit;
  local ROTT_Party party;
  local string folder;
  local int i, j;
  
  // Set arrival checkpoint
  arrivalCheckpoint = arrivalIndex;
  
  // Get file path
  folder = (transitionMode == true) ? "temp" : "save";
  
  // Save items
  savedItemCount = playerInventory.count();
  if (playerInventory.count() > 0) firstSavedItemType = playerInventory.itemList[0].class;
  
  for (i = 0; i < playerInventory.count(); i++) {
    // Store item types
    if (i+1 < playerInventory.count()) {
      playerInventory.itemList[i].nextSavedItemType = playerInventory.itemList[i+1].class;
    }
    
    // Save item
    class'Engine'.static.BasicSaveObject(playerInventory.itemList[i], folder $ "\\items\\item[" $ i $ "].bin", true, 0);
  }
  
  // Save number of parties for load procedure
  numberOfParties = partySystem.getNumberOfParties();
  activePartyIndex = partySystem.activePartyIndex;
  
  // Save parties and heroes
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    // Get party
    party = partySystem.getParty(i);
    party.prepareSaveInfo();
    
    // Save Party
    class'Engine'.static.BasicSaveObject(party, folder $ "\\party[" $ i $ "].bin", true, 0);
    
    for (j = 0; j < party.getPartySize(); j++) {
      // Get hero
      heroUnit = party.getHero(j);
      
      // Save hero
      class'Engine'.static.BasicSaveObject(heroUnit, folder $ "\\hero[" $ i $ "][" $ j $ "].bin", true, 0);
      
      // Check for held item data
      if (heroUnit.heldItemType != none) {
        // Save held item
        class'Engine'.static.BasicSaveObject(
          heroUnit.heldItem, 
          folder $ "\\heldItem[" $ i $ "][" $ j $ "].bin", 
          true, 
          0
        );
      }
    }
  }
}

/*============================================================================= 
 * loadProfile()
 *
 * Loads in data and prepares the profile for play.
 *===========================================================================*/
public function loadProfile(optional bool transitionMode = false) {
  local ROTT_Party party;
  local ROTT_Combat_Hero tempHero;
  local ROTT_Inventory_Item tempItem;
  local string itemPath;
  local string path;
  local string folder;
  local int i, j; 
  
  folder = (transitionMode == true) ? "temp" : "save";
  
  // Reset player inventory
  playerInventory = new(self) class'ROTT_Inventory_Package_Player';
  playerInventory.linkReferences();
  
  // Load player items
  for (i = 0; i < savedItemCount; i++) {
    if (i == 0) {
      // Load first item type
      tempItem = new(self) firstSavedItemType;
    } else {
      tempItem = new(self) tempItem.nextSavedItemType;
    }
    // Load item from memory
    class'Engine'.static.BasicLoadObject(tempItem, folder $ "\\items\\item[" $ i $ "].bin", true, 0);
    tempItem.initialize();
    
    // Store item to inventory
    playerInventory.loadItem(tempItem, false);
  }
  
  // Load party system 
  partySystem = new(self) class'ROTT_Party_System';
  partySystem.linkReferences();
  
  // Load all parties
  for (i = 0; i < numberOfParties; i++) { 
    // Load party info
    party = new(partySystem) class'ROTT_Party';
    path = folder $ "\\party[" $ i $ "].bin";
    
    // Load a party
    if (class'Engine'.static.BasicLoadObject(party, path, true, 0)) {
      
      // Reset to initial data structure
      party.initialize(i);
      
      // Place party into profile
      partySystem.loadParty(party);

      // Iterate through each hero slot
      for (j = 0; j < party.saveInfoPartySize; j++) { 
        // Create hero data
        tempHero = new(party) party.heroSaveTypes[j];
        
        // Set path for loading
        path = folder $ "\\hero[" $ i $ "][" $ j $ "].bin";
        itemPath = folder $ "\\heldItem[" $ i $ "][" $ j $ "].bin";
        
        // Attempt to load hero
        if (class'Engine'.static.BasicLoadObject(tempHero, path, true, 0)) {
          // Load initial hero data 
          partySystem.getParty(i).loadHero(tempHero);
          
          // Check if held item type info exists
          if (tempHero.heldItemType != none) {
            tempItem = new(self) tempHero.heldItemType;
            
            // Attempt to load hero item
            if (class'Engine'.static.BasicLoadObject(tempItem, itemPath, true, 0)) {
              tempItem.initialize();
              partySystem.getParty(i).getHero(j).equipItem(tempItem);
            }
          }
        }
      }
    }
  }
  
  // Make hyper glyph storage
  hyperSkills = new(self) class'ROTT_Descriptor_List_Hyper_Skills';
  hyperSkills.initialize();
  
  debugProfileDump();
  
  // Set active party
  partySystem.setActiveParty(activePartyIndex);
  
}

/*============================================================================= 
 * setEventStatus()
 *
 * Stores data for when player interacts with monument shrines (quests.)
 *===========================================================================*/
public function setEventStatus(TopicList topic, ConflictStatus status) {
  local ConflictInfo info;
  local int i;
  
  // Check for invalid topics
  switch (topic) {
    case INTRODUCTION:
    case ETZLAND_HERO:
    case END_OF_ACTIVATED_TOPICS:
    case INQUIRY_MODE:
    case INQUIRY_OBELISK:
    case INQUIRY_TOMB:
    case INQUIRY_GOLEM:
    case GREETING:
      yellowLog("Warning (!) Cannot set event info for topic: " $ topic);
      return;
  }
  
  // Scan through events
  for (i = 0; i < conflictData.length; i++) {
    // If it already exists, flip the reverse value
    if (conflictData[i].topicIndex == topic) {
      // Reverse status
      /// problematic: this should only happen once per map
      conflictData[i].bReversed = !conflictData[i].bReversed;
      
      // Flip status
      if (conflictData[i].status == ACTION_TAKEN) {
        conflictData[i].status = ACTION_SKIPPED;
      } else {
        conflictData[i].status = ACTION_TAKEN;
      }
      
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_WORLD_SHRINE);
      return;
    }
  }
  
  // Add to new info to the list if it wasnt found before
  info.topicIndex = topic;
  info.status = status;
  conflictData.addItem(info);
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_WORLD_SHRINE);
}

/*============================================================================= 
 * getEventStatus()
 *
 * This function returns the status of a given event
 *===========================================================================*/
public function ConflictStatus getEventStatus(TopicList topic) {
  local int i;
  
  // Scan through events
  for (i = 0; i < conflictData.length; i++) {
    // Check if topic matches event data
    if (conflictData[i].topicIndex == topic) {
      return conflictData[i].status;
    }
  }
  
  return NOT_STARTED;
}

/*============================================================================= 
 * getLuckBoost()
 *
 * Returns the total percent luck boost (e.g. 0.1f is ten percent)
 *===========================================================================*/
public function float getLuckBoost() {
  local float luckBoost;
  local int i;
  
  // Start with enchantment boost (already includes mastery boost...)
  luckBoost = getEnchantBoost(OMNI_SEEKER) / 100.f;
  
  // Sum an additional boost from held items
  for (i = 0; i < getActiveParty().getPartySize(); i++) {
    luckBoost += getActiveParty().getHero(i).heldItemStat(ITEM_ADD_LOOT_LUCK) / 100.f;
  }
  
  return luckBoost;
}

/*============================================================================= 
 * healActiveParty
 *
 * Description: This function heals the active party
 *
 * Usage: From 3D world only?
 *===========================================================================*/
public function healActiveParty() {
  partySystem.getActiveParty().restoreAll();
  sfxBox.playSFX(SFX_MENU_BLESS_STAT);
  gameInfo.showGameplayNotification("You have been healed");
}

/*=============================================================================
 * getHeroCount()
 *
 * Returns the number of heros
 *===========================================================================*/
public function int getHeroCount() {
  local int i, heroCount;
  
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    heroCount += partySystem.getParty(i).getPartySize();
  }
  
  return heroCount;
}

/*=============================================================================
 * getHardcoreOmniBonus()
 *
 * 
 *===========================================================================*/
public function int getHardcoreOmniBonus() {
  local int i, omniBoost;
  
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    omniBoost += partySystem.getParty(i).getHardcoreOmniBonus();
  }
  
  return omniBoost;
}

/*=============================================================================
 * getTotalBossesSlain()
 *
 * 
 *===========================================================================*/
public function int getTotalBossesSlain() {
  local int i, slayCount;
  
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    slayCount += partySystem.getParty(i).getTotalBossesSlain();
  }
  
  return slayCount;
}

/*=============================================================================
 * getTotalMonstersSlain()
 *
 * 
 *===========================================================================*/
public function int getTotalMonstersSlain() {
  local int i, slayCount;
  
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    slayCount += partySystem.getParty(i).getTotalMonsersSlain();
  }
  
  return slayCount;
}

/*=============================================================================
 * getEncounterCount()
 *
 * 
 *===========================================================================*/
public function int getEncounterCount() {
  return encounterCount;
}

/*=============================================================================
 * getTotalGemsEarned()
 *
 * 
 *===========================================================================*/
public function int getTotalGemsEarned() {
  return totalGemsEarned;
}

/*=============================================================================
 * getTotalGoldEarned()
 *
 * 
 *===========================================================================*/
public function int getTotalGoldEarned() {
  return totalGoldEarned;
}

/*=============================================================================
 * getNumberOfParties()
 *
 * Returns the number of parties on this profile
 *===========================================================================*/
public function int getNumberOfParties() {
  return partySystem.getNumberOfParties();
}


/**============================================================================= 
 * getDialogStart
 *
 * Returns the index for an event which the npc wishes to discuss with the
 * player.
 *===========================================================================
public function EventList getDialogStart(NPCs targetNPC) { 
  local int i;
  
  ///cyanlog("  Checking events & player progress");
  for (i = 0; i < EventList.EnumCount; i++) {
    ///cyanlog("   Checking if " $ targetNPC $ " is ready to talk about " $ string(i));
    // Check if this conversation has already happened
    if (npcInteractions[targetNPC].dialogueProgress[i] == NOT_STARTED) {
      ///cyanlog("   " $ npcInteractions[targetNPC].dialogueProgress[i]);
      ///cyanlog("   " $ playerEvents[i]);
      // Check if the event is ready to be discussed
      if (playerEvents[i] != NOT_STARTED) {
        ///cyanlog("    " $ targetNPC $ " is ready to talk about " $ EventList(i));
        return EventList(i);
      }
    }
  }
  
  return SKIP_ALL_EVENTS;
}
*/
/*============================================================================= 
 * resetTopic()
 *
 * This is used to make greetings repeat
 *===========================================================================*/
public function resetTopic(NPCs npcName, TopicList topic) {
  npcRecords[npcName].npcTopicHistory[topic] = NOT_DISCUSSED;
}

/*============================================================================= 
 * completeTopic()
 *
 * This is used to progress through topics
 *===========================================================================*/
public function completeTopic(NPCs npcName, TopicList topic) {
  // Never save inquiry progress
  if (topic == INQUIRY_MODE) return;
  
  npcRecords[npcName].npcTopicHistory[topic] = COMPLETED;
}

/*============================================================================= 
 * activateTopic()
 *
 * Used to flag a topic for discussion with NPCs
 *===========================================================================*/
public function activateTopic(TopicList topic) {
  activeTopics[topic] = ACTIVE;
}

/*=============================================================================
 * toggleEventStatus()
 *
 * Switches the state of a monument shrine when the player activates a ritual.
 *===========================================================================*/
public function bool toggleEventStatus(TopicList targetTopic) {
  local bool bMonumentWasActive;
  
  // Get monument status
  bMonumentWasActive = getEventStatus(targetTopic) == ACTION_TAKEN;
  
  if (bMonumentWasActive) {
    // Set event to inactive
    setEventStatus(targetTopic, ACTION_SKIPPED);
  } else {
    // Set event to activated
    setEventStatus(targetTopic, ACTION_TAKEN);
  }
  
  // Return current state
  return !bMonumentWasActive;
}

/*============================================================================= 
 * addEnchantBoost()
 *
 * Increases an enchantment
 *===========================================================================*/
public function addEnchantBoost(coerce byte enchantmentIndex, int addValue) {
  // Add to enchantment
  enchantmentLevels[enchantmentIndex] += addValue;
}

/*============================================================================= 
 * getEnchantBoost()
 *
 * Returns the bonus provided by the given enchantment
 *===========================================================================*/
public function int getEnchantBoost(coerce byte enchantmentIndex) {
  local int bonus;
  
  // Get hard stat point level
  bonus = enchantmentLevels[enchantmentIndex];
  
  // Catch additional bonuses
  switch(enchantmentIndex) {
    case OMNI_SEEKER:
      if (gameInfo.playerProfile.gameMode == MODE_HARDCORE) {
        bonus += getHardcoreOmniBonus();
      }
      break;
  }
  
  // Fetch enchantment bonuses from items held from all teams
  bonus += partySystem.getHeldItemEnchantment(enchantmentIndex);
  
  // Multiply by bonus per level, as stated in the descriptors
  bonus *= class'ROTT_Descriptor_Enchantment_List'.static.getEnchantment(enchantmentIndex).bonusPerLevel;
  
  return bonus;
}

/*============================================================================= 
 * initNewGamePortals()
 *
 * Description: initializes the map lock system for a new game
 *===========================================================================*/
public function initNewGamePortals() {
  // Open portals by default
  setPortalUnlocked(MAP_TALONOVIA_TOWN);
  setPortalUnlocked(MAP_RHUNIA_WILDERNESS);
  
  // First journal entry
  gameInfo.playerProfile.pushJournalEntry(
    "\n What happened . . .\n Did I choose a familiar from inside\n the ethereal stream?"
  );
  
  // Placeholder maps
  setPortalUnlocked(MAP_TALONOVIA_SHRINE);
}

/*============================================================================= 
 * setPortalUnlocked()
 *
 * Description: Unlocks a portal
 *===========================================================================*/
public function setPortalUnlocked(MapNameEnum unlockMap) {
  mapLocks[unlockMap] = GATE_OPEN;
}

/*============================================================================= 
 * getActiveParty()
 *
 * Description: returns the party that is currently controlled by the player
 *===========================================================================*/
public function ROTT_Party getActiveParty() {
  return partySystem.getActiveParty();
}

/*=============================================================================
 * getSpiritualProwess()
 *
 * Returns total spiritual prowess for active worshippers
 *===========================================================================*/
public function float getSpiritualProwess() {
  local int i;
  local float prowess;
  
  // Scan through parties
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    // Check if party is worshipping
    if (partySystem.getParty(i).partyActivity != NO_SHRINE_ACTIVITY) {
      // Track sum of spiritual prowess
      prowess += partySystem.getParty(i).getSpiritualProwess();
    }
  }
  
  return prowess;
}

/*=============================================================================
 * getShrineActivityCount()
 *
 * Counts how many parties are attending the given shrine
 *===========================================================================*/
public function int getHyperGlyphLevel
(
  int hyperIndex
) 
{
  switch (hyperIndex) {
    case GLYPH_TREE_ARMOR:
      return getShrineActivityCount(COBALT_SANCTUM);
      break;
    default:
      yellowLog("Warning (!) Unhandled Hyper glyph level " $ hyperIndex);
      break;
  }
  return 0;
}
  
/*=============================================================================
 * getShrineActivityCount()
 *
 * Counts how many parties are attending the given shrine
 *===========================================================================*/
public function int getShrineActivityCount
(
  PassiveShrineActivies shrineType
) 
{
  local int i;
  local int count;
  
  // Scan through parties
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    // Check if party is worshipping at the given shrine
    if (partySystem.getParty(i).partyActivity == shrineType) {
      count++;
    }
  }
  
  return count;
}

/*============================================================================= 
 * unlockAllPortals()
 *
 * This is a cheat that opens all portals
 *===========================================================================*/
public function unlockAllPortals() {
  local int i;
  
  for (i = 0; i < arrayCount(mapLocks); i++) {
    mapLocks[i] = GATE_OPEN;
  }
}

/*============================================================================= 
 * debugProfileDump
 *
 * Description: This function shows all the parties and heroes in the profile
 *===========================================================================*/
private function debugProfileDump() {
  local int i;
  local int j;
  
  grayLog("Player profile:", DEBUG_PLAYER_PROFILE);
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    greenlog(" Team #" $ i, DEBUG_PLAYER_PROFILE);
    for (j = 0; j < partySystem.getParty(i).getPartySize(); j++) {
      darkgreenlog("  Hero["$j$"]: " $ partySystem.getParty(i).getHero(j).myClass, DEBUG_PLAYER_PROFILE);
    }
  }
  grayLog(" ", DEBUG_PLAYER_PROFILE);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Night counter for journal entries
  nightCounter=1
  
  // Portal checkpoint
  arrivalCheckpoint=-1
  
  // Milestone notification info
  milestoneList(MILESTONE_AZRA_KOTH)=(milestoneDescription="Az'ra Koth defeated")
  milestoneList(MILESTONE_HYRIX)=(milestoneDescription="Hyrix defeated")
  milestoneList(MILESTONE_KHOMAT)=(milestoneDescription="Khomat defeated")
  milestoneList(MILESTONE_VISCORN)=(milestoneDescription="Viscorn defeated")
  milestoneList(MILESTONE_GINQSU)=(milestoneDescription="Ginqsu defeated")
}


















