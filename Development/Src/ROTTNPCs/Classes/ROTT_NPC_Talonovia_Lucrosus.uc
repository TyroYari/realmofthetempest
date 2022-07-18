/*=============================================================================
 * NPC - Lucrosus Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Lucrosus is a merchant in Talonovia.  He's a greedy scoundrel. 
 * The player is supposed to be able to sell stuff to him (eventually.)
 *===========================================================================*/

class ROTT_NPC_Talonovia_Lucrosus extends ROTT_NPC_Container;

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
    "With a sudden turn to the door, Lucrosus the Merchant drops",
    "some coins to the floor. . ."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  // Intro
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Well if it isn't a new spirit walker. . .",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The bear grunts briefly, tilting up and",
    "sniffing the air."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Our wares blessed by the silver wind are nothing",
    "but a humble gift to assist on your brave adventures." // ll1
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Well, for a fee.",
    "" 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The bear exhales powerfully.",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Do you chase after currency?",
    "" 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The bear whines and pushes some.",
    "gold coins across the floor."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I don't. Why bother?",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Have you heard of this obelisk business?",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(INTRODUCTION, NUETRAL)
      "I have no idea.",
      "I've heard that's an issue.",
      "",
      ""
    `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "We don't squabble for no reason, but the",
        "Talonovian Council believes you'll help resolve the matter."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "I don't have a solution, but a recommendation.",
        "A suggestion unwise to refuse."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "It isn't an issue, but you'll need to make",
        "a decision."
      `ENDNODE
          
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "I have nothing but a recommendation to suggest.",
        ""
      `ENDNODE
          
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The bear glares directly at you.",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "That obelisk in Rhunia is an abandoned monument,",
    "found in the citadel."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Praying at the shrine summons an immense flowing power,",
    "crippling food production."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Supply and demand.  My business is nothing but",
    "a matter of currency."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You've understood this request?",
    "Good.  I don't have time to play games."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "May fortune smile upon us.",
    "What do you need?"
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Barter",
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
    "The tome at the base of the obelisk in Rhunia's citadel",
    "will summon a protective force when it is activated."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "Which also cripples food production. . . See?",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "Not the worst thing to exploit for profit. . . Right?",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Those wretched blossoms will ruin me again.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "So I swear on the storms. . . Do not harvest that tomb.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Many fanatics believe that the golems hold",
    "the secrets of our souls."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "They would likely pay handsomely to visit",
    "the golem of Talonovia."
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
  npcName=LUCROSUS
  serviceType=SERVICE_BARTERING
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = ACTION
  preferences(VALOR_BLOSSOMS)     = INACTION
  preferences(GOLEMS_BREATH)      = ACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Green
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Green'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Green
  end object
  npcBackground=NPC_Background
  
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Lucrosus
    componentTextures.add(Texture2D'NPCs.Merchants.NPC_Portrait_Merchant_Green_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Lucrosus
  end object
  npcSprites=NPC_Sprites
}





