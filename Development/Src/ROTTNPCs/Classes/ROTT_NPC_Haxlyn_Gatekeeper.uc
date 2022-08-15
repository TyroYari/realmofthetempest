/*=============================================================================
 * NPC - Haxlyn Gatekeeper (Boss)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * The Haxlyn gatekeeper guards the exit of the citadel, and summons the boss.
 *===========================================================================*/

class ROTT_NPC_Haxlyn_Gatekeeper extends ROTT_NPC_Container;

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
  
  // Greeting
  `NEW_NODE(GREETING, NUETRAL)
    "May our faith lay eternal with the blind mother",
    "of this ethereal stream."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "It is in the chaos of the universe that we discover",
    "who we must be."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Under the pull of a ceaseless crescent, chaos will rise",
    "through the night fog."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Open forth, triune gate, take me to the world below,",
    "the world within, and the world beyond."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Show my holy form to me.",
    ""
  `ENDNODE
  
  setInquiry(
    "Goodnight",
    "",
    "",
    "",
    
    BEHAVIOR_FORCE_ENCOUNTER,
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
  begin object class=UI_Texture_Info Name=Background_Texture
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Blue'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Portrait
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Blue_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Portrait
  end object
  npcSprites=NPC_Sprites
}





