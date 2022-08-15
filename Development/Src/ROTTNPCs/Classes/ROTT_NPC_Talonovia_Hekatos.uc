/*=============================================================================
 * NPC - Hekatos Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Hekatos is a witch in Talonovia.  She's cyptic and eccentric. 
 * The player is supposed to be able to play some sort of minigame with her,
 * possibly potion crafting for permanent stat boosts, (eventually.)
 *===========================================================================*/

class ROTT_NPC_Talonovia_Hekatos extends ROTT_NPC_Container;

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
    ". . .", 
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "Special little secret.",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Lottery",
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
    ". . .",
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
  npcName=HEKATOS
  serviceType=SERVICE_LOTTERY
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = INACTION
  preferences(VALOR_BLOSSOMS)     = ACTION
  preferences(GOLEMS_BREATH)      = INACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Violet
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Violet'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Violet
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Hekatos
    componentTextures.add(Texture2D'NPCs.Witches.NPC_Portrait_Witch_Purple_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Hekatos
  end object
  npcSprites=NPC_Sprites
}



























