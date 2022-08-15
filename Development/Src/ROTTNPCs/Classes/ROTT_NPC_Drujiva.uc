/*=============================================================================
 * ROTT_NPC_Drujiva
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Tethered to the mountain shrine, Drujiva is the druid sage that fused with
 * the spirit of the land.  Drujiva requests the player's help in restoring the
 * land from corruption, but is in fact already corrupt by Dominus.
 *===========================================================================*/

class ROTT_NPC_Drujiva extends ROTT_NPC_Container;

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
  
  // Introduction
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Birds are resting around", 
    "an old sage."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Hello champion.", 
    ""
  `ENDNODE
  
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
  
  // Greeting
  `NEW_NODE(GREETING, NUETRAL)
    "How's it goin'?", 
    ""
  `ENDNODE
  
  
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
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Lycanthrox_Orange_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Black_Gatekeeper
  end object
  npcSprites=NPC_Sprites
}





