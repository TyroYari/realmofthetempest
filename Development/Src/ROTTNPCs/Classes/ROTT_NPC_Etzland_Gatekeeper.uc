/*=============================================================================
 * NPC - Etzland Gatekeeper (Boss)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * The Etzland gatekeeper guards the exit of the citadel, and summons the boss.
 *===========================================================================*/

class ROTT_NPC_Etzland_Gatekeeper extends ROTT_NPC_Container;

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
    "The dark conscience lurks below our vestigial hearts.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Ablation for oblation,",
    "our hearts in our hands are our offering."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Shroud of Etzland, unwind your spells from our minds.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "May those who were banished upon the wind,",
    "walk amongst us once again."
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
  begin object class=UI_Texture_Info Name=NPC_Background_Dark_Gray
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Gray'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Dark_Gray
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Black_Gatekeeper
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Black_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Black_Gatekeeper
  end object
  npcSprites=NPC_Sprites
}





