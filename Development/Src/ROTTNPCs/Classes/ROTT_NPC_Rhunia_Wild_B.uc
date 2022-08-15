/*=============================================================================
 * NPC - Rhunia Wilderness (B)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A wilderness NPC in Rhunia.
 *===========================================================================*/

class ROTT_NPC_Rhunia_Wild_B extends ROTT_NPC_Container;

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
    "A cauldron babbles gently in",
    "a thick red haze. . ."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(GREETING, NUETRAL)
    "Oh how chaos mocks our fickle fate",
    "while order takes us to it."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Whirlwind of miserable dreams, bring us back",
    "to the ethereal stream."
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
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Gray')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Gatekeeper
    componentTextures.add(Texture2D'NPCs.Witches.NPC_Portrait_Witch_Red_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Gatekeeper
  end object
  npcSprites=NPC_Sprites
}





