/*=============================================================================
 * ROTT_NPC_Container
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This contains all npc dialogue data.  Its important that we
 *              DO NOT store save info here, because its exploitable.
 *===========================================================================*/

class ROTT_NPC_Container extends ROTT_Object
abstract;

// Making a regular function to fetch this somehow failed
`DEFINE LENGTH topicNodes[topic].topicChains[mode].dialogNodes.length
`DEFINE NODE topicNodes[topic].topicChains[mode].dialogNodes[`LENGTH - 1]
`DEFINE CURRENT_LENGTH topicNodes[currentTopic].topicChains[currentMode].dialogNodes.length
`DEFINE CURRENT_NODE topicNodes[currentTopic].topicChains[currentMode].dialogNodes[currentNode]

`DEFINE REPLY_INDEX `CURRENT_NODE.replyChains[selectedOption].replyIndex
`DEFINE REPLY_LENGTH `CURRENT_NODE.replyChains[selectedOption].optionReplies.length
`DEFINE REPLY_NODE `CURRENT_NODE.replyChains[selectedOption].optionReplies[`REPLY_INDEX]

`DEFINE LAST_NODE topicNodes[lastTopic].topicChains[lastMode].dialogNodes[lastIndex]

// Macro for scene
`DEFINE NPC_SCENE gameInfo.sceneManager.sceneNpcDialog

// A list of core NPC names
enum NPCs {
  // Intro NPC
  ALISKUS,
  
  // Talonovian Council
  SALUS,
  MEKUBA,
  HEKATOS,
  TANNIM,
  LUCROSUS,
  MIGMAS,
  KALEV,
  
  // Main quest line characters
  DRUJIVA,
  DOMINUS,
  
  // Generic NPCs (with no save feature)
  GENERIC
};

// Stores the identity of this NPC for save data
var privatewrite NPCs npcName;

// NPC Sprite sheet information
var public UI_Texture_Storage npcSprites;
var public UI_Texture_Storage npcBackground;

// NPC Sprite sheet information
var public ROTT_UI_Page_NPC_Dialogue dialogPage;

// Npc flags
var privatewrite bool bFadeIn;
//var privatewrite bool bHostile;

/*===========================================================================*/

// Game events that NPCs may reply to
enum TopicList {
  // The first time introduction event
  INTRODUCTION,
  
  // Neutral events
  ETZLAND_HERO,
  
  // Conflicts
  OBELISK_ACTIVATION,
  VALOR_BLOSSOMS,
  GOLEMS_BREATH,
  
  // This marks the end of topics that require activation
  END_OF_ACTIVATED_TOPICS,
  
  // Allows player to ask about topics
  INQUIRY_MODE,
  
  // Conflict inquiry
  INQUIRY_OBELISK,
  INQUIRY_TOMB,
  INQUIRY_GOLEM,
  
  // This is called only when the npc launches with no topics to discuss
  GREETING
};

// NPCs support preferences toward players actions in conflict topics
enum TopicPreference {
  NEUTRAL,
  ACTION,
  INACTION
};

// Stores the unique preferences of an npc
var public TopicPreference preferences[TopicList];

// Behaviors triggered by option selection
enum OptionBehavior {
  BEHAVIOR_NONE,
  
  BEHAVIOR_INQUIRY_OBELISK,
  BEHAVIOR_INQUIRY_TOMB,
  BEHAVIOR_INQUIRY_GOLEM,
  
  BEHAVIOR_FORCE_ENCOUNTER,
  
  BEHAVIOR_LAUNCH_SERVICE,
  
  BEHAVIOR_GOODBYE,
};

// NPCs support preferences toward players actions in conflict topics
enum NpcServices {
  NO_SERVICES,
  SERVICE_BLESSINGS,
  SERVICE_ALCHEMY,
  SERVICE_BARTERING,
  SERVICE_NECROMANCY,
  SERVICE_BESTIARY,
  SERVICE_LOTTERY,
  SERVICE_INFORMATION,
};

var privatewrite NpcServices serviceType;

// Store types of inventory items for bartering service
///var() privatewrite array<ROTT_Inventory_Item> barterInventory;

// Display text
struct OptionText {
  var string options[4];
  
  var OptionBehavior behaviors[4];
};

// Display text
struct DialogText {
  var string topLine;
  var string bottomLine;
};

// Stores dialog text for replying to a dialog option
struct ReplyChain {
  // Index for which option reply node to display
  var int replyIndex;
  
  // Dialog sequence for this reply chain
  var array<DialogText> optionReplies;
};

// The main building block for dialog data
struct DialogNode {
  // First thing displayed from this node to the screen
  var DialogText mainMessage; 
  
  // Options for player reply
  var OptionText options;
  
  // True when options have been set
  var bool bOptionsEnabled;
  
  // True when options have been rendered to the screen
  var bool bOptionsRendered;
  
  // Response sequences for each of the dialog options
  var ReplyChain replyChains[4];
  
  // Flags for special actions
  var bool bForceGoodbye;
  var bool bCharacterCreation;
  var bool bNameCreation;
  var bool bWorldTransfer;
  var bool bOverrideMusic; 
  var bool bShowControls; 
  
  // Stores destination for world transfer
  var byte destination;
  
  // Stores a font to render the text with
  var SoundEffectsEnum queueSfx;
  
  // Stores a font to render the text with
  var FontStyles fontOverride;
  
  structdefaultproperties {
    fontOverride = DEFAULT_MEDIUM_WHITE
  }
};

// A chain of dialog data for a single topic
struct TopicChain {
  var array<DialogNode> dialogNodes;
};

// Different reply modes for each topic
enum ReplyModes {
  NUETRAL,
  SATISFIED,
  UNSATISFIED,
  SATISFIED_REVERSED,
  UNSATISFIED_REVERSED
};

// A reference to the full dialog sequence for a given topic
struct TopicNode {
  var TopicChain topicChains[ReplyModes];
};

// Dialog for each topic is stored in these chains
var protected TopicNode topicNodes[TopicList];

// Store most recently added node
var protected TopicList lastTopic;
var protected ReplyModes lastMode;
var protected int lastIndex;

// Inquiry options
var protected OptionText inquiryOptions;
var protected bool bInquiryUp;

/*===========================================================================*/

// Navigation variables for dialog traversal
var private TopicList currentTopic;
var private ReplyModes currentMode;
var private int currentNode;

// Stores the index of the option selected by the player
var private int selectedOption;

/*=============================================================================
 * initDialogue()
 * 
 * This stub is defined in children to set up an NPC's dialog content 
 *===========================================================================*/
public function initDialogue() {
  linkReferences();
  
  // Graphics initialization
  npcSprites.initializeComponent();
  npcBackground.initializeComponent();
  
  // Dialog content
  /* (defined in children classes) */
}

/*=============================================================================
 * startConversation()
 * 
 * Called when NPC is launched.  This initializes dialog traversal settings.
 *===========================================================================*/
public function startConversation(ROTT_UI_Page_NPC_Dialogue ui) {
  // Set reference to the interface
  dialogPage = ui;
  
  // initialize dialog traversal
  currentNode = 0;
  currentTopic = getTopic(true);
  
  // Check for quest update
  gameInfo.playerProfile.questCheck(currentTopic, self);
}

/*============================================================================*
 * behaviorInput()
 * 
 * This function is called when a dialog option is selected by the player.
 * Returns true if behavior overrides dialog traversal.
 *===========================================================================*/
public function bool behaviorInput(OptionBehavior behaviorType) {
  // Log
  cyanLog("Executing behavior " $ behaviorType);
  
  // Execute behavior by type
  switch (behaviorType) {
    case BEHAVIOR_NONE:
      // No action
      return false;
    case BEHAVIOR_GOODBYE:
      // Exit dialog
      dialogPage.exitDialog();
      return true;
      
    // Inquiry topics
    case BEHAVIOR_INQUIRY_OBELISK:    
      changeTopic(INQUIRY_OBELISK);  
      return true;
    case BEHAVIOR_INQUIRY_TOMB:       
      changeTopic(INQUIRY_TOMB);   
      return true;
    case BEHAVIOR_INQUIRY_GOLEM:      
      changeTopic(INQUIRY_GOLEM);    
      return true;
      
    // Encounter
    case BEHAVIOR_FORCE_ENCOUNTER:  
      // Transition to combat
      gameInfo.startCombatTransition();
      
      // Lock controls
      dialogPage.menuControl = IGNORE_INPUT;
      return true;
      
    // Launch NPC services
    case BEHAVIOR_LAUNCH_SERVICE:  
      // If no service is available, skip to "unavailable" message in dialog
      if (serviceType == NO_SERVICES) return false;
    
      // Open UI for an NPC service
      gameInfo.launchNPCService(serviceType);
      return true;
      
    default:
      yellowLog("Unhandled dialog behavior");
      return true;
  }
}

/*============================================================================*
 * changeTopic()
 * 
 * This changes the topic
 *===========================================================================*/
public function changeTopic(TopicList topic) {
  // Set traversal data
  dialogPage.clearOptions();
  currentTopic = topic;  
  currentNode = 0;
  
  // Render to screen
  renderCurrentNode();
}

/*============================================================================*
 * dialogTraversal()
 * 
 * This function handles progression through the npc dialog content
 *===========================================================================*/
public function dialogTraversal(optional bool skipMode = false) {
  // Filter "B" button if inquiry is up
  if (bInquiryUp && skipMode) return;
  
  // Check for inquiry input
  if (bInquiryUp) {
    // Reset inquiry state, assume we navigate away on input
    bInquiryUp = false;
    
    // Execute selected option behavior
    behaviorInput(inquiryOptions.behaviors[dialogPage.getOptionSelection()]);
    return;
  }
  
  // Filter "B" button if options up
  if (`CURRENT_NODE.bOptionsRendered && skipMode) return;

  // Skip option check if we are already displaying replies
  if (`REPLY_INDEX == 0) {
    // Check for dialog options
    if (`CURRENT_NODE.bOptionsEnabled && !`CURRENT_NODE.bOptionsRendered) {
      if (dialogPage.isTextUp() ) {
        dialogPage.renderOptions(`CURRENT_NODE.options);
        `CURRENT_NODE.bOptionsRendered = true;
      } else {
        dialogPage.skipScrollEffect();
      }
      return;
    }
  }

  // Check flags
  if (dialogPage.isTextUp() || skipMode) {
    // Exit dialog for forced goodbye flag
    if (`CURRENT_NODE.bForceGoodbye) {
      dialogPage.exitDialog();
    } 
    
    // Control sheet transfer flag
    if (`CURRENT_NODE.bShowControls) {
      // Save
      gameInfo.saveGame(gameInfo.const.TRANSITION_SAVE);
      
      // Execute transition
      gameInfo.sceneManager.transitioner.setTransition(
        TRANSITION_OUT,                              // Transition direction
        RANDOM_SORT_TRANSITION,                      // Sorting config
        ,                                            // Pattern reversal
        ,                                            // Destination scene
        gameInfo.sceneManager.sceneNpcDialog.controlSheet,                                            
        // Destination page
        ,                                            // Destination world
        ,                                            // Color
        10,                                          // Tile speed
        0.f,                                         // Delay
        false,
        "Page_New_World_Transition"
      );
      dialogPage.menuControl = IGNORE_INPUT;
      return;
    } 
    
    // World transfer flag
    if (`CURRENT_NODE.bWorldTransfer) {
      // Save
      gameInfo.saveGame(gameInfo.const.TRANSITION_SAVE);
      
      // Execute transition
      gameInfo.sceneManager.transitioner.setTransition(
        TRANSITION_IN,                               // Transition direction
        RANDOM_SORT_TRANSITION,                      // Sorting config
        ,                                            // Pattern reversal
        ,                                            // Destination scene
        ,                                            // Destination page
        gameInfo.getMapFileName(`CURRENT_NODE.destination),
        // Destination world
        ,                                            // Color
        10,                                          // Tile speed
        0.f                                          // Delay
      );
      
      // Lock controls
      dialogPage.menuControl = IGNORE_INPUT;
      return;
    } 
    
    // Character creation flag
    if (`CURRENT_NODE.bCharacterCreation) {
      `CURRENT_NODE.bCharacterCreation = false;
      gameInfo.sceneManager.switchScene(SCENE_CHARACTER_CREATION);
      return;
    } 
    
    // Name designation flag
    if (`CURRENT_NODE.bNameCreation) {
      `CURRENT_NODE.bNameCreation = false;
      gameInfo.sceneManager.sceneNpcDialog.openNamingInterface();
      return;
    } 
    
    // Music flag
    if (`CURRENT_NODE.bOverrideMusic) {
      // Queue music
      gameInfo.jukeBox.overrideSoundtrack(MUSIC_CHARACTER_CREATION, 0.9, 9.0);
      
      // Fade into the NPC's scene
      dialogPage.addEffectToComponent(FADE_OUT, "Dialogue_Fade_Screen", 9.0);
    } 
    
    // Extra sound effects
    if (`CURRENT_NODE.queueSfx != NO_SFX) {
      gameInfo.sfxBox.playSfx(`CURRENT_NODE.queueSfx);
    } 
    
    // Handle option input
    if (`CURRENT_NODE.bOptionsRendered) {
      // Store player's option selection
      selectedOption = dialogPage.getOptionSelection();
      
      // Clear option text
      dialogPage.clearOptions();
      `CURRENT_NODE.bOptionsRendered = false;
      
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      
      // Execute option behavior
      if (behaviorInput(`CURRENT_NODE.options.behaviors[selectedOption])) {
        // Return if behavior overrides traversal
        return;
      }
      
      // Initialize reply index to the beginning
      `REPLY_INDEX = 0;
    }
    
    // Traverse
    if (`REPLY_INDEX < `REPLY_LENGTH) {
      // Render a reply to an option selection
      dialogPage.renderDialog(`REPLY_NODE);
      
      // Increment to next reply message
      `REPLY_INDEX++;
      
      // Move on to next dialog node if replies are done
      if (`REPLY_INDEX == `REPLY_LENGTH) {
        ///incrementNode();
      }
    } else {
      // Navigate to next dialog node
      incrementNode();
      
      // Render the node we just traversed to
      renderCurrentNode();
    }
  } else {
    // Skip scrolling effect
    dialogPage.skipScrollEffect();
  }
  
  whitelog("------------------------------");
  greenLog("dialogTraversal()");
  yellowLog(" ~ currentTopic:"@currentTopic);
  yellowLog(" ~ currentMode:"@currentMode);
  yellowLog(" ~ currentNode:"@currentNode);
  whitelog("------------------------------");
  
}

/*=============================================================================
 * incrementNode()
 * 
 * Attempts to progress to a new dialog node index
 *===========================================================================*/
protected function incrementNode() {
  local int i;
  
  // Increment node index
  currentNode++;
  
  // Check if new node index is valid
  if (!(currentNode < `CURRENT_LENGTH)) {
    // Save topic history
    for (i = 0; i < TopicList.enumCount; i++) {
      gameInfo.playerProfile.completeTopic(npcName, currentTopic);
    }
    
    // Try finding next topic
    if (getTopic() != INQUIRY_MODE) {
      currentTopic = getTopic();
      currentNode = 0;
    } else {
      dialogPage.renderOptions(inquiryOptions);
      bInquiryUp = true;
      return;
    }
  }
}

/*=============================================================================
 * addDialogNode()
 * 
 * Given a topic and response mode, this adds a dialog node to the NPC
 *===========================================================================*/
protected function addDialogNode
(
  TopicList topic,
  ReplyModes mode,
  string topLine, 
  string bottomLine
) 
{
  local DialogText text;
  local DialogNode node;
  
  // Set dialog text
  text.topLine = topLine;
  text.bottomLine = bottomLine;
  
  // Assign dialog content
  node.mainMessage = text;
  
  // Attach node to npc
  topicNodes[topic].topicChains[mode].dialogNodes.addItem(node);
  
  // Update last node reference
  lastTopic = topic;
  lastMode = mode;
  lastIndex = topicNodes[topic].topicChains[mode].dialogNodes.length - 1;
}

/*=============================================================================
 * addReplyChain()
 * 
 * This is used to build an NPC response to a player's selected dialog option
 *===========================================================================*/
protected function addReplyChain
(
  TopicList topic,
  ReplyModes mode,
  int index,
  string topLine, 
  string bottomLine
) 
{
  local DialogText text;
  
  // Set reply text
  text.topLine = topLine;
  text.bottomLine = bottomLine;
  
  // This accesses the last node added to this topic, for this mode
  `NODE.replyChains[index].optionReplies.addItem(text);
  
}

/*=============================================================================
 * setInquiry()
 * 
 * Sets the inquiry options for this NPC
 *===========================================================================*/
protected function setInquiry
(
  optional string option1 = "", 
  optional string option2 = "", 
  optional string option3 = "", 
  optional string option4 = "",
  
  optional OptionBehavior behavior1 = BEHAVIOR_NONE,
  optional OptionBehavior behavior2 = BEHAVIOR_NONE,
  optional OptionBehavior behavior3 = BEHAVIOR_NONE,
  optional OptionBehavior behavior4 = BEHAVIOR_NONE
) 
{
  inquiryOptions.options[0] = option1;
  inquiryOptions.options[1] = option2;
  inquiryOptions.options[2] = option3;
  inquiryOptions.options[3] = option4;
  
  inquiryOptions.behaviors[0] = behavior1;
  inquiryOptions.behaviors[1] = behavior2;
  inquiryOptions.behaviors[2] = behavior3;
  inquiryOptions.behaviors[3] = behavior4;
}

/*=============================================================================
 * addOptions()
 * 
 * Given a topic and response mode, this adds options to the last node.
 *===========================================================================*/
protected function addOptions
(
  TopicList topic,
  ReplyModes mode,
  optional string option1 = "", 
  optional string option2 = "", 
  optional string option3 = "", 
  optional string option4 = "",
  optional OptionBehavior behavior1 = BEHAVIOR_NONE,
  optional OptionBehavior behavior2 = BEHAVIOR_NONE,
  optional OptionBehavior behavior3 = BEHAVIOR_NONE,
  optional OptionBehavior behavior4 = BEHAVIOR_NONE
) 
{
  local OptionText options;
  
  // Assign dialog content
  options.options[0] = option1;
  options.options[1] = option2;
  options.options[2] = option3;
  options.options[3] = option4;
  
  // Assign option behaviors
  options.behaviors[0] = behavior1;
  options.behaviors[1] = behavior2;
  options.behaviors[2] = behavior3;
  options.behaviors[3] = behavior4;
  
  // Attach options to most recently added node
  `NODE.options = options;
  `NODE.bOptionsEnabled = true;
}

/*=============================================================================
 * forceGoodbye()
 * 
 * Given a topic and response mode, this forces the dialog to end at the most
 * recently added node.
 *===========================================================================*/
protected function forceGoodbye
(
  TopicList topic,
  ReplyModes mode
) 
{
  // Set force goodbye flag to most recently added node
  `NODE.bForceGoodbye = true; 
}

/*=============================================================================
 * characterCreation()
 * 
 * This flags a recently added node to transfer to character creation mode
 *===========================================================================*/
protected function characterCreation
(
  TopicList topic,
  ReplyModes mode
) 
{
  // Set character creation flag to most recently added node
  `NODE.bCharacterCreation = true;
}

/*=============================================================================
 * nameCreation()
 * 
 * This flags a recently added node to transfer to name creation mode
 *===========================================================================*/
protected function nameCreation
(
  TopicList topic,
  ReplyModes mode
) 
{
  // Set force goodbye flag to most recently added node
  `NODE.bNameCreation = true;
}

/*=============================================================================
 * overrideMusic()
 * 
 * This flags a node to queue a music override
 *===========================================================================*/
protected function overrideMusic
(
  TopicList topic,
  ReplyModes mode
) 
{
  // Set force goodbye flag to most recently added node
  `NODE.bOverrideMusic = true;
}

/*=============================================================================
 * worldTransfer()
 * 
 * Given a topic and response mode, this forces the player to transfer worlds
 *===========================================================================*/
protected function worldTransfer
(
  TopicList topic,
  ReplyModes mode,
  byte destination
) 
{
  // Set force goodbye flag to most recently added node
  `NODE.bWorldTransfer = true;
  `NODE.destination = destination;
}

/*=============================================================================
 * showControls()
 * 
 * Transfers to control sheet
 *===========================================================================*/
protected function showControls
(
  TopicList topic,
  ReplyModes mode
) 
{
  // Set transfer to control sheet info
  `NODE.bShowControls = true;
}

/*=============================================================================
 * getTopic()
 * 
 * Returns the topic that this npc wants to discuss.  Should be accurate no 
 * matter when this function is called.
 *===========================================================================*/
protected function TopicList getTopic(optional bool bFirstTopic = false) {
  local ROTT_Game_Player_Profile profile;
  local bool bSkipTopic;
  local int i, j;
  
  // Get profile
  profile = gameInfo.playerProfile;
  
  // Scan through topics that require activation 
  for (i = 0; i < TopicList.enumCount; i++) {
    // end scan at this marker
    if (i == END_OF_ACTIVATED_TOPICS) break;
    
    // Skip inactive topics
    if (profile.activeTopics[i] == INACTIVE) 
      bSkipTopic = true;
    
    // Skip completed dialogs
    if (profile.npcRecords[npcName].npcTopicHistory[i] == COMPLETED) 
      bSkipTopic = true;
  
    // Check if we haven't already decided to skip this topic
    if (!bSkipTopic) {
      // Search for conflict data on this topic
      for (j = 0; j < profile.conflictData.length; j++) {
        // Check if data is for the current topic
        if (profile.conflictData[j].topicIndex == TopicList(i)) {
          // If the player hasnt taken action yet, discuss the topic
          if (profile.conflictData[j].status == NOT_STARTED) return TopicList(i);
          
          // If the NPC has already replied to a players action on this subject
          if (profile.npcRecords[npcName].npcTopicHistory[i] == REPLIED) {
            // If the player has reversed their action, discuss this topic again
            if (profile.conflictData[j].bReversed) return TopicList(i);
          }
          
          // We found no reason to discuss this conflict topic
          bSkipTopic = true;
        }
      }
    }
    
    // Topic is active and not a conflict at this point, so return it
    if (!bSkipTopic && topicNodes[i].topicChains[NUETRAL].dialogNodes.length != 0) return TopicList(i);
  }
  
  // Always greet if this is first topic, and no activated topics were found
  if (bFirstTopic) return GREETING;
  
  // Check if npc offers services
  //if (topicNodes[SERVICE_MODE].topicChains[NUETRAL].dialogNodes.length != 0) return SERVICE_MODE;
  
  // Return inquiry mode as last resort
  return INQUIRY_MODE;
}

/*=============================================================================
 * renderCurrentNode()
 * 
 * Called to render the current node
 *===========================================================================*/
public function renderCurrentNode() {
  if (currentNode >= topicNodes[currentTopic].topicChains[currentMode].dialogNodes.length) {
    yellowLog("Warning (!) Dialog node out of bounds for index " $ currentNode);
    yellowLog("--- Topic: " $ currentTopic);
    yellowLog("--- Mode:  " $ currentMode);
    return;
  }

  // Text Color
  dialogPage.setTextColor(`CURRENT_NODE.fontOverride);
  
  // Render text
  dialogPage.renderDialog(`CURRENT_NODE.mainMessage);
}

/*=============================================================================
 * setColor()
 *
 * Designates a color for the last node added
 *===========================================================================*/
public function setColor(FontStyles newFont) {
  `LAST_NODE.fontOverride = newFont;
}

/*=============================================================================
 * queueSfx()
 *
 * Tells the last node added to play the given sfx
 *===========================================================================*/
public function queueSfx(SoundEffectsEnum soundEffect) {
  `LAST_NODE.queueSfx = soundEffect;
}

/*=============================================================================
 * debugDialog()
 * 
 * 
 *===========================================================================*/
protected function debugDialog() {
  local int i, j, k;
  
  for (i = 0; i < TopicList.enumCount; i++) {
    greenlog("Topic " $ i $ ":");
    for (j = 0; j < ReplyModes.enumCount; j++) {
      yellowlog("Mode " $ j $ ":");
      for (k = 0; k < topicNodes[i].topicChains[j].dialogNodes.length; k++) {
        `log(topicNodes[i].topicChains[j].dialogNodes[k].mainMessage.topLine);
        `log(topicNodes[i].topicChains[j].dialogNodes[k].mainMessage.bottomLine);
      }
    }
  }
}

/*============================================================================= 
 * debugNpcHistory()
 *
 * 
 *===========================================================================*/
public function debugNpcHistory(NPCs npcIndex) {
  local int i;
  
  for (i = 0; i < TopicList.enumCount; i++) {
    yellowLog("Npc " $ npcIndex $ " on topic #" $ i $ " is:" $ gameInfo.playerProfile.npcRecords[npcIndex].npcTopicHistory[i]);
  }
}

/*============================================================================= 
 * debugActiveTopics()
 *
 * 
 *===========================================================================*/
public function debugActiveTopics() {
  local int i;
  
  for (i = 0; i < TopicList.enumCount; i++) {
    yellowLog("Topic #" $ i $ " is:" $ gameInfo.playerProfile.activeTopics[i]);
  }
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  
}














/*=============================================================================
 * isNPCSatisfied()
 * 
 * returns true if the players event choice matches the NPC's preference
 *===========================================================================
public function bool isNPCSatisfied(ROTT_NPC_Container targetNPC, byte eventIndex) {
  local byte npcPref;
  local byte playerStatus;
  
  // Get npc preference and player event status
  npcPref = targetNPC.topicPrefs[eventIndex];
  playerStatus = playerProfile.playerEvents[eventIndex];
  
  // Skip satisfaction check on nuetral preferences
  if (npcPref == 0) return true;
  
  // Evaluate match
  return (npcPref == playerStatus);
}
*/









/**
// This node holds replies based on player input to dialog options
struct ReplyNode {
  var string replyTop[4];
  var string replyBottom[4];
};

// This node holds first time introduction and conflict completion responses 
struct DialogNode  {
  // Implemented separately due to difficulty with multiline label implementation 
  var string topLine;
  var string bottomLine;
  
  // Displays up to 4 options, skipped if strings are empty
  var string options[4];
  var array<ReplyNode> optionReplies;
};

// This node holds first time introduction and conflict completion responses 
struct EventResponseNodes  {
  var array<DialogNode> PosGreetNode; 
  var array<DialogNode> NegGreetNode;
};

// These store a chain of dialogue nodes for each event
var public EventResponseNodes eventResponses[TopicList];

// NPCs have conflicting opinions on these inquiry topics
enum InquiryTopics {
  THE_OBELISK,
  THE_TOMB,
  THE_GOLEM
};

// This node holds first time introduction and conflict completion responses 
struct InquiryNodeList  {
  var array<DialogNode> inquiryNodes; 
};

// These store replies to inqueries (the obelisk, the tomb, the golem)
var public InquiryNodeList inquiryReplies[3];
**/
// Seconds between animation frames
//var private float animTime;   








/** --- old stuff ------------------------------------------------
// This node holds responses based on all conflicts being completed 
struct MoodNodes {
  var array<string> MoodNode;
};

var array<MoodNodes> NPCMoodDialogueNode;
*/
//var byte NPCMood; // Neutral, Love, Hate, Used to Love, Used to Hate

//var int FluxAnimationTempo; // varies the base tempo 
/** --- old stuff ------------------------------------------------*/











