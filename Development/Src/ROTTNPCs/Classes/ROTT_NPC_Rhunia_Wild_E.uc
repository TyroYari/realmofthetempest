/*=============================================================================
 * NPC - Rhunia Wilderness (E)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A wilderness NPC in Rhunia.
 *===========================================================================*/

class ROTT_NPC_Rhunia_Wild_E extends ROTT_NPC_Container;

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
    "Dark haze surrounds an old saddened figure. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(GREETING, NUETRAL)
    "There is no place for me here in these woods.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "But in my loneliness, I've been reminded that how \"different\" one feels",
    "is a predetermined result. . ."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    ". . . from the ambition of your soul.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "So even though lives like mine are not sustained here,",
    "where the common evil thrives. . ."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "I will one day rest. . . in heaven.",
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
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Gray')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Tan_Gatekeeper
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Orange_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Tan_Gatekeeper
  end object
  npcSprites=NPC_Sprites
}





























