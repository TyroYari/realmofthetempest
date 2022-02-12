/*=============================================================================
 * NPC - Rhunia Wilderness (C)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A wilderness NPC in Rhunia.
 *===========================================================================*/

class ROTT_NPC_Rhunia_Wild_C extends ROTT_NPC_Container;

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
    "A dozen frantic crows pass overhead, now squawking in the distance. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(GREETING, NUETRAL)
    "I've read the Cipher of Six and Spirit, a forbidden text.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Now every time I've knelt beside my bed in prayer,",
    "I. . . I. . . I lose myself, as if I've fallen asleep."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "I can never remember my prayers.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "When I've embraced my loved ones,",
    "again I've felt my mind just. . . washes away."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "I can never remember touch.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "My. . . My-My mind has lost its link to heaven and body!",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Memory of hope and affection leak from me!",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "I'm begging now. . . Please kill me.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  setInquiry(
    "I'm sorry. . .",
    "Goodnight",
    "",
    "",
    
    BEHAVIOR_GOODBYE,
    BEHAVIOR_GOODBYE,
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
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Tan')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Zombie
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Red_Black_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Zombie
  end object
  npcSprites=NPC_Sprites
}





