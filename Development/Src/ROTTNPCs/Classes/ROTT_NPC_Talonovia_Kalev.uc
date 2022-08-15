/*=============================================================================
 * NPC - Kalev Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Kalev is a former prince, living in Talonovia.  He's stern and aloof,
 * but enjoys sharing baked snacks.
 *===========================================================================*/

class ROTT_NPC_Talonovia_Kalev extends ROTT_NPC_Container;

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
    "Kalev the Prince is busy reading, and avoids",
    "looking up."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "This here harbor is",
    "part of Talonovia's kingdom." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "In the past there were collectively",
    "seven grand kingdoms." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I'm the former royal prince of a",
    "destroyed kingdom." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "All but the Talonovian region have",
    "been corrupted by evil." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Special monuments have been abandoned out there,",
    "as they should be in these times of calamity." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Despite what others say, you must never touch",
    "the obelisk of Rhunia's badland, up north." 
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "Hello champion.",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Information",
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
    "Well, the obelisks are shunned.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "An obelisk ritual creates an aura that",
    "slows food production for our humbled harbor."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "It's really no good.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    ". . .",
    ". . ."
  `ENDNODE
	
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    ". . .",
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
  npcName=KALEV
  serviceType=SERVICE_INFORMATION
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = INACTION
  preferences(VALOR_BLOSSOMS)     = INACTION
  preferences(GOLEMS_BREATH)      = INACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Dark_Tan
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Tan'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Dark_Tan
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Kalev
    componentTextures.add(Texture2D'NPCs.Princes.NPC_Portrait_Prince_Cyan_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Kalev
  end object
  npcSprites=NPC_Sprites
}





