/*=============================================================================
 * ROTT_NPC_Aliskus
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Aliskus is the opening NPC gatekeeper.  Through this dialog, the player
 * selects their first familiar spirit and the name for their account.
 *===========================================================================*/
 
class ROTT_NPC_Aliskus extends ROTT_NPC_Container;

// Macros for formatting dialog content
`DEFINE NEW_NODE(TOPIC, MODE) addDialogNode(`TOPIC, `MODE, 
`DEFINE ENDNODE );

`DEFINE ADD_OPTIONS(TOPIC, MODE) addOptions(`TOPIC, `MODE, 

/*=============================================================================
 * initDialogue()
 * 
 * This sets all the dialog content
 *===========================================================================*/
public function initDialogue() {
  super.initDialogue();
  
  // Pre-Intro
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "In a subtractive space, black is the absolute combination",
    "of all color."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "And in the additive space, black is the emptiness of all color.",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "But here in this world, black magic is both.",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  // Intro
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Wake up.",
    ""
  `ENDNODE
  overrideMusic(INTRODUCTION, NUETRAL);
  setColor(DEFAULT_MEDIUM_WHITE);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Even when you're dead, waking up is possible.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "That is just a little trick for us gatekeepers. . .",
    "out here, in the ethereal stream."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "There are two sides to any gate.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Some say death is not life's complement, but",
    "each are governed by the same gate."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "To cheat life's complement, know now. . . that what",
    "precedes life is \"not living.\""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "No world is made without paradox, no matter",
    "how omnipotent the hand may be."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You won't find what you seek to obtain here. . .",
    "for it is no more obtainable here than where you're from."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The world is still waiting to feel our presence.",         
    "So let's incarnate your first familiar."
  `ENDNODE
  
  // character creation
  characterCreation(INTRODUCTION, NUETRAL);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "What should they call you?",             
    ""
  `ENDNODE
  
  // Name creation
  nameCreation(INTRODUCTION, NUETRAL);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Alright then.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Brace yourself %n.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Menacing laughter slowly erupts from the cloaked figure. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I came into the world like spit,",
    "and so will you!"
  `ENDNODE
  
  // Transfer to control sheet
  showControls(INTRODUCTION, NUETRAL);
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // NPC identity
  npcName=ALISKUS
  
  // Fade in effects for new game
  bFadeIn=true
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Texture
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Gray')
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

































