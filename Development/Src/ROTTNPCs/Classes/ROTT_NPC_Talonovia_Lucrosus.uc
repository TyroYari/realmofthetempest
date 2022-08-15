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
    "With a sudden turn to the front door,",
    "Lucrosus drops some coins to the floor."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The bear smells the air.",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  // Intro
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "A new soldier of the stormlands here?",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "To shop, at our humble shop?",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Well do come in love.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Our inventory grows with each new day.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "But hey, listen.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The bear grunts briefly.",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "When you go out in the wilderness here. . .",
    "" 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "There is an obelisk that needs your",
    "help with a messy ritual." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "An aura will be released that",
    "protects us from harm." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The bear whines and pushes some gold",
    "coins across the tiled flooring loudly."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "With my shipments secured,",
    "My income is secured as well."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I am no fighter, but you may grace the",
    "shrine with a careful psalm or two."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The books are there, in Rhunia's badland,",
    "at the north citadel's tower."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Read them with purpose and a clear mind.",
    ""
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
    "An obelisk ritual creates an aura that",
    "keeps our harbors safe from evil's grasp."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "Stay safe champion.",
    ""
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
























