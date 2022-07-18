/*=============================================================================
 * ROTT_NPC_Talonovia_Migmas
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Migmas is an alchemist in Talonovia, who provides the enchantment minigame.
 *===========================================================================*/
 
 class ROTT_NPC_Talonovia_Migmas extends ROTT_NPC_Container;

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
    "Migmas the Alchemist is handling a magical flame. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Hello young storm walker.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "When thunder strikes I'll watch the wind raging",
    "in the tempest, thrashing against itself."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You're really not the type to believe alchemy works the same way,", 
    "are you?" // lr1
  `ENDNODE
    
    `ADD_OPTIONS(INTRODUCTION, NUETRAL)
      "I don't do Alchemy",
      "I'm a believer",
      "",
      ""
    `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "We do not always know what we need,",
        "but I really believe in the power of alchemical services."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "I'll push the alchemical craft to the limit",
        "for a fellow believer."
      `ENDNODE
    
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "That is what I do.",
        ""
      `ENDNODE
    
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I'm Migmas, the local alchemist,",
    "member of the Talonovian high council."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I do not always care for company, but I'll handle your",
    "enchantment services for a fair price."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Through the portal of Rhunia, you'll find an obelisk",
    "towering above the halls of an abandoned citadel." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You can't read the psalms of Rhunia without", 
    "awakening a lost magnificent power from within. . ."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "So go forth to the shrine beneath this monument,", //rr2
    "and let's see if you'll restore the power of that ancient stone."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "You don't need help, do you?",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Alchemy",
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
    "Practicing alchemy helps to fortify and sustain Talonovia.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "The aura exerted by the obelisk will empower these magicks.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "So go forth, and give it a heartfelt prayer once again.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The spiritual energy of the priestess buried in Haxlyn",
    "will forever permeate the walls of her tomb."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Only by feeding from her energy can",
    "the Haxlyn blossoms flourish."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Harvest these blossoms, and return them to us.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The alchemical benefit is unparalleled,",
    "and they will always grow back."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Little is known of the slumbering golems.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "There is mention of them only in the holy text of The Agony Schema, and",
    "the Half Moon Memoirs."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Are you not eager to witness their power?",
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
  npcName=MIGMAS
  serviceType=SERVICE_ALCHEMY
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = ACTION
  preferences(VALOR_BLOSSOMS)     = ACTION
  preferences(GOLEMS_BREATH)      = ACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Red
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Red'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Red
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Migmas
    componentTextures.add(Texture2D'NPCs.Alchemists.NPC_Portrait_Alchemist_Red_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Migmas
  end object
  npcSprites=NPC_Sprites
}




