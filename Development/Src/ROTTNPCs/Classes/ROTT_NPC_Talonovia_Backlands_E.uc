/*=============================================================================
 * NPC - Talonovia Backlands (E)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Magic instructor.
 *===========================================================================*/

class ROTT_NPC_Talonovia_Backlands_E extends ROTT_NPC_Container;

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
    "In the dark, the east wind calls to us.",
		""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "There are no beasts.",
		""
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Bestiary",
      "Goodnight",
      "",
      "",
      
      BEHAVIOR_LAUNCH_SERVICE,
      BEHAVIOR_GOODBYE
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
  serviceType=SERVICE_BESTIARY
  
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
    componentTextures.add(Texture2D'NPCs.Tamers.NPC_Portrait_Tamer_Black_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Sprite_Texture
  end object
  npcSprites=NPC_Sprites
}












