/*=============================================================================
 * NPC - Rhunia Wilderness (D)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A wilderness NPC in Rhunia.
 *===========================================================================*/

class ROTT_NPC_Rhunia_Wild_D extends ROTT_NPC_Container;

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
    "Bubbles quietly rustle to the surface of",
    "a boiling stew outside the ragged house."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(GREETING, NUETRAL)
    "With limbs like a ghost, I'm fearful of most.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Twist not the door knob, dare not leave",
    "the outpost."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Chimes in the distance, the caw of",
    "the crows."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "I am a puppet whose strings",
    "come from the nether below."
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
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Tan')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Ghoul
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ghoul_Black_Gold_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Ghoul
  end object
  npcSprites=NPC_Sprites
}
























