/*=============================================================================
 * NPC - Rhunia Wilderness (G)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A wilderness NPC in Rhunia.
 *===========================================================================*/

class ROTT_NPC_Rhunia_Wild_G extends ROTT_NPC_Container;

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
    "Welcome to Rhunia.  This land and its people are corrupt",
    "from black magic, and alchemical witchcraft."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Heavy hatred hangs from the abandoned kingdom above us.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "By praying, you'll encounter enemies less, but",
    "you will face stronger opponents."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "By singing, you'll attract more. . . elite enemies.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "By crawling, you will taunt enemies for more frequent encounters.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "You've been gifted temporal magic, controlling the pace of time.",
    "You are encouraged to do so liberally."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Good luck.",
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
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Red')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Portrait
    componentTextures.add(Texture2D'NPCs.Clerics.NPC_Portrait_Cleric_Red_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Portrait
  end object
  npcSprites=NPC_Sprites
}





























