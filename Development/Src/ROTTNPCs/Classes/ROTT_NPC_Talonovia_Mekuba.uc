/*=============================================================================
 * NPC - Mekuba Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Mekuba is a necromancer in Talonovia.  He's brief, dark, and morbid. 
 * The player is supposed to be able to battle hoards of enemies summoned by
 * him (eventually.)
 *===========================================================================*/

class ROTT_NPC_Talonovia_Mekuba extends ROTT_NPC_Container;

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
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Mekuba the Necromancer stands still, like unplugged machinery. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    ". . .",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(INTRODUCTION, NUETRAL)
      "Hello?",
      "Maybe I'll just leave. . .",
      "",
      "",
      
      BEHAVIOR_NONE,
      BEHAVIOR_GOODBYE
    `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "What do you seek?",
        ""
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "I am watcher of the damned, lord of rot. . .",
        "You speak now to Mekuba."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "Necromancy, this is not a profession,",
        "but a birthright."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "Speaking with the dead.",
        "That is what I do."
      `ENDNODE
    
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    ". . .",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Necromancy",
      "Inquiry",
      "",
      "",
      
      BEHAVIOR_LAUNCH_SERVICE,
      BEHAVIOR_NONE
    `ENDNODE
    
      `ADD_REPLY(GREETING, NUETRAL, 0)
        "(Service unavailable in this version)",
        ""
      `ENDNODE
    
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "The hand of death has infinite reach,",
    "well beyond the top of any tower."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "Dare not taunt the underworld.",
    "Leave the obelisk at rest."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The dead are not for you to disturb, %n.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The dead belong to me.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "A golem never lives, and never dies.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "They wait, and they watch.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The chains that hold the golem's breath",
    "obstruct us from what's hiding in our history."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Release them, so you may learn from their mysteries.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  setInquiry(
    "Ask about the obelisk",
    "Ask about the tomb",
    "Ask about the golem",
    "Goodnight",
    
    BEHAVIOR_INQUIRY_OBELISK,
    BEHAVIOR_INQUIRY_TOMB,
    BEHAVIOR_INQUIRY_GOLEM,
    BEHAVIOR_GOODBYE
  );
  
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // NPC identity
  npcName=MEKUBA
  serviceType=SERVICE_NECROMANCY
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = INACTION
  preferences(VALOR_BLOSSOMS)     = INACTION
  preferences(GOLEMS_BREATH)      = ACTION
  
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
  begin object class=UI_Texture_Info Name=NPC_Mekuba
    componentTextures.add(Texture2D'NPCs.Necromancers.NPC_Portrait_Necromancer_Black_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Mekuba
  end object
  npcSprites=NPC_Sprites
}



