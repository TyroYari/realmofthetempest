/*=============================================================================
 * NPC - Tannim Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Tannim is a dragon tamer in Talonovia.  She is discrete, vigilant, and
 * intensily focused.  Her eyes are fiercly ambivalent, like a weathered
 * veteran.  
 *
 * Able to summon massive chains connecting arbitrary points in the
 * sky, dragon tamers sprint fast as light along the metal links, wrapping
 * and climbing across massive demonics opponents, trapping their shrunken
 * spirits down in small, hand sized cages.  To become a dragon tamer one must
 * train under and eventually kill an existing dragon tamer.  Like Auron/Itachi,
 * Dragon Tamers wear one arm in their sleeve out of respect to former masters
 * death.
 *
 * The player may pay dragon tamers to summon high level boss fights, saving
 * the hassle of seeking out such bosses.  Item rewards are increased.
 * Currency rewards are removed.
 *===========================================================================*/

class ROTT_NPC_Talonovia_Tannim extends ROTT_NPC_Container;

// Macros for formatting dialog content
`DEFINE NEW_NODE(TOPIC, MODE)           addDialogNode(`TOPIC, `MODE, 
`DEFINE ADD_OPTIONS(TOPIC, MODE)        addOptions(`TOPIC, `MODE, 
`DEFINE ADD_REPLY(TOPIC, MODE, INDEX)   addReplyChain(`TOPIC, `MODE, `INDEX,

`DEFINE ENDNODE );

/*=============================================================================
 * initDialogue()
 * 
 * This sets all the dialog content
 *===========================================================================*/
public function initDialogue() {
  super.initDialogue();
  
  // Intro
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Tannim the Dragon Tamer is dangling a smoking thurible by",
    "a pet gargoyle. . ."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Are you the new face",
    "around the docks?"
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I am the keeper of beasts and demons, Tannim.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Are you ok?",
    "Coming to the harbor can be rough."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Listen. . .",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The high council is nothing",
    "but petty arguments here lately."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The Black Magic Tragedy was a recent disaster",
    "for our entire realm, and we are still recovering."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "None of us agree, but I say we ought not worship",
    "the forsaken obelisk monument."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "Nothing whispered is sacred.",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Bestiary",
      "Inquiry",
      "",
      "",
      
      BEHAVIOR_LAUNCH_SERVICE,
      BEHAVIOR_NONE
    `ENDNODE
    
      `ADD_REPLY(GREETING, NUETRAL, 0)
        "(Service unavailable in this version)",
        ""
      `ENDNODE
    
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "None of us agree, but I say we ought not worship",
    "the forsaken obelisk monument."
  `ENDNODE
	
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    ". . .",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    ". . .",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  setInquiry(
    "Ask about the obelisk",
    "Ask about the tomb",
    "Ask about the golem",
    "Goodnight",
    
    BEHAVIOR_INQUIRY_OBELISK,
    BEHAVIOR_INQUIRY_TOMB,
    BEHAVIOR_INQUIRY_GOLEM,
    BEHAVIOR_GOODBYE
  );
  
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // NPC identity
  npcName=TANNIM
  serviceType=SERVICE_BESTIARY
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = INACTION
  preferences(VALOR_BLOSSOMS)     = ACTION
  preferences(GOLEMS_BREATH)      = ACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Orange
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Orange'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Orange
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Tannim
    componentTextures.add(Texture2D'NPCs.Tamers.NPC_Portrait_Tamer_Orange_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Tannim
  end object
  npcSprites=NPC_Sprites
}









