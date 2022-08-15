/*=============================================================================
 * NPC - Rhunia Gatekeeper (Boss)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * The Rhunia gatekeeper guards the exit of the citadel, and summons the boss.
 *===========================================================================*/

class ROTT_NPC_Rhunia_Gatekeeper extends ROTT_NPC_Container;

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
    "The frigid clasp of the ice tome breaks only here,",
    "in the heart of this forsaken temple's house."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Rhunia, goddess of nature's cruelty, obey desire as",
    "your birthright and devour my soul now."
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
  begin object class=UI_Texture_Info Name=NPC_Background_Red
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Red'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Red
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Red_Gatekeeper
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Red_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Red_Gatekeeper
  end object
  npcSprites=NPC_Sprites
}





