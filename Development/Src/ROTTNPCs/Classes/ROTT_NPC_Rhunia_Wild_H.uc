/*=============================================================================
 * NPC - Rhunia Wilderness (H)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A wilderness NPC in Rhunia.
 *===========================================================================*/

class ROTT_NPC_Rhunia_Wild_H extends ROTT_NPC_Container;

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
  `NEW_NODE(GREETING, NUETRAL)
    "A distracted man hums and sings around a collection of burning candles. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(GREETING, NUETRAL)
    "If the words sound strange, twisted and deranged,",
    "a little bit dark, yet shiny."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Say crows feet grow, and ghosts eat crows,",
    "while simple hands stay hiding."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Ohhhhh. . .",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Rosy coats and cozy coats and little hands of lightning.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "A kid will see lightning too, wouldn't you?",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Rosy coats and cozy coats",
    "and little hands of lightning."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "A kid will see lightning too, wouldn't you. . . ?",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "If the worms found fear, by staring in the mirror,",
    "a little bit dirty and slimy."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Smoke would show,",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Lights would strobe,",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "With four little bolts of lightning.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Ohhhhh. . .",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  setInquiry(
    "Goodnight",
    "",
    "",
    "",
    
    BEHAVIOR_GOODBYE,
    BEHAVIOR_NONE,
    BEHAVIOR_NONE,
    BEHAVIOR_NONE
  );
  
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // NPC identity
  npcName=GENERIC
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Texture
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Orange')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Portrait
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Black_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Portrait
  end object
  npcSprites=NPC_Sprites
}





























