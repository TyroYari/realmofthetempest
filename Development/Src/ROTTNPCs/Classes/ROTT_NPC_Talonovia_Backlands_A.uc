/*=============================================================================
 * NPC - Talonovia Backlands (A)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A cleric on the edge of town.
 *===========================================================================*/

class ROTT_NPC_Talonovia_Backlands_A extends ROTT_NPC_Container;

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
    "Spells personify the dreams that have walked beside us",
    "through a lightyear of darkness."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "The uncontainable spirit knows no state of crisis,",
    "only the shell abandoned by it can crumble."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "But the immutable heart ties shell to spirit.",
    "Coalesced, they collapse, and they crack together."
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Blessing",
      "Goodnight",
      "",
      "",
      
      BEHAVIOR_LAUNCH_SERVICE,
      BEHAVIOR_GOODBYE
    `ENDNODE
      
      // This acts as a safeguard
      `ADD_REPLY(GREETING, NUETRAL, 0)
        "(Service unavailable in this version)",
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
  serviceType=SERVICE_BLESSINGS
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Texture
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Blue')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Sprite_Texture
    componentTextures.add(Texture2D'NPCs.Clerics.NPC_Portrait_Cleric_Cyan_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Sprite_Texture
  end object
  npcSprites=NPC_Sprites
}












