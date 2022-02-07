/*=============================================================================
 * NPC - Haxlyn Wilderness (F)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A wilderness NPC in Haxlyn.
 *===========================================================================*/

class ROTT_NPC_Haxlyn_Wild_F extends ROTT_NPC_Container;

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
    "A disoriented man is becoming a zombie. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(GREETING, NUETRAL)
    "After starving myself for six days. . .",
    "Like the locksmith did in Lesser Oblivion. . ."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "The soul suffers separation sickness, while",
    "my shell laments for the loss of clarity."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "But now, when my mind's eye wanders,",
    "images appear."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    ". . . Seemingly separate from my own cognition.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "And when these visions appear. . .",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "I pray. . .",
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
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Gray'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Sprite_Texture
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Black_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Sprite_Texture
  end object
  npcSprites=NPC_Sprites
}












