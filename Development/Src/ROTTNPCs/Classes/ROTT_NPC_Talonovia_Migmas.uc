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
    "Hello and welcome.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "This is an alchemy shop here.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "My name is Migmas the Great.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I handle the enchantment of",
    "special relics."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "These relics are holy,",
    "and their powers sacred."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "They are an essential part of survival",
    "for a traveller."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "In the north, there is an obelisk,",
    "abandoned, in need of help."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "My magick is tied to the tower.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I will reward the revival of the tower",
    "and help with your battles out there."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Stay golden champ.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "Stay golden champ.",
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
    "In the north, there is an obelisk,",
    "abandoned, in need of help."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "My magick is tied to the tower.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "I will reward the revival of the tower",
    "and help with your battles out there."
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


























