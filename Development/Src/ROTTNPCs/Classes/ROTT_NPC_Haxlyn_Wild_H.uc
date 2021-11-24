/*=============================================================================
 * NPC - Haxlyn Wilderness (H)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A wilderness NPC in Haxlyn.
 *===========================================================================*/

class ROTT_NPC_Haxlyn_Wild_H extends ROTT_NPC_Container;

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
    "One morning as a marble rolled amongst my instruments,",
    "I listened to it sing a rhythmic song."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "It made a clink, a clank, a",
    "krrrrrrrrrrrrrruht-ka-tonk."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Shh- Klonk.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "It was then that I asked myself. . .",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "What is this fear of mine that",
    "holds me here in these storms. . . ?"
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "What boils these needles in my chest. . . ?",
    "What creeps like lake fog. . . up my throat. . . ?"
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Is it. . . the way the tempest howls while berating the walls of my home?",
    ". . . or the sudden crack of thunder while I sleep?"
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "No, neither.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "A myriad of ticks and tocks from these. . . clicking clocks",
    "have conditioned me to the contrary."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Now I do not fear the storm, oh no.",
    "The company they've kept with me is necessary."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "What I fear is the hollow gap that is abandoned",
    "by the storms, when it calls I shake and writhe."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "That which strangles the roots of my heart,",
    "is absence. . ."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Haunted by that impending absence,",
    "I reached. . ."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "And reaching for my quiet marble as it lay resting, was",
    "like reaching toward a howling void."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Mourn with me now, for the song of my marble",
    "called your name. . . %n."
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
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Emissary_Black_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Sprite_Texture
  end object
  npcSprites=NPC_Sprites
}












