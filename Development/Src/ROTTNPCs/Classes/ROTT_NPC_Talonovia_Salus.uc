/*=============================================================================
 * ROTT_NPC_Talonovia_Salus
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Salus is the town healer of Talonovia.
 *===========================================================================*/
 
class ROTT_NPC_Talonovia_Salus extends ROTT_NPC_Container;

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
    "Salus the Cleric is tinkering with some flasks. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Welcome to Talonovia.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Just another traveller here to unwind, huh?",
    "Talonovia's harbors are quite the place for that."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "How do you fair?",
    "Why are you here?"
  `ENDNODE
  
    `ADD_OPTIONS(INTRODUCTION, NUETRAL)
      "I am here to help.",               
      "I'm here to fight evil.",          
      "I don't know.",                    
      "None of your business, \"Salus.\"" 
    `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "That fresh breath of bravery is out there.",
        "Can't say no to an extra hand."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "What's that? I doubt you are capable of doing harm.",
        "I really don't know a fighter when I. . . I see one."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 2)
        "Searching for purpose? I'll tell you what.",
        "When I don't know, I don't know."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 2)
        "But the hand of Serenity has a hold on our realm.",
        "You know?"
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 3)
        "I really don't agree.",
        "As a cleric's promise, my business is with the well-being of my people."
      `ENDNODE
    
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Your time would be well spent in Rhunia,",
    "where one of the portals is tethered to."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "An obelisk waits under the red skies of the haunted citadel.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I would read the obelisk's psalms, %n. . .",
    "You know, if I were you that is. . ."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "May the storms settle in your heart.",
    "May the wind settle at your feet."
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Blessing",
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
    "When reading the psalms at the shrine of the obelisk. . .",
    "a powerful spiritual pressure emenates from it."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "This pressure protects us, but slows the",
    "production of food, and the energy of life."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "Our ancestors learned to accept this comprimise,",
    "after their dangerous haste became their undoing."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "As the fifth scripture of the Agony Schema states. . .",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "\"The many hungers of our bodies and minds must each find",
    "their own proper pace between being fed, and being tamed.\""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "So ignite your prayers at the Obelisk, and",
    "join us together in patience. . . and protection."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The Haxlyn Priestess wrote the holy scriptures of",
    "the Half Moon Memoirs before her execution."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Now, her rejuvinating spirit circulates through a",
    "collection of blossoms around her tomb."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Through magic rituals, the priestess studied finality and suffering. . .",
    "forever changing how the world perceives mystery, and sacrifice."
  `ENDNODE
  
  ///`NEW_NODE(INQUIRY_TOMB, NUETRAL)
  ///  "For spirits that sacrifice knowledge to take physical form,",
  ///  "mystery and sacrifice must be intrinsic to their souls."
  ///`ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Why not harvest this gift at the tombsite,",
    "instead of wasting a great history of selfless perseverance?"
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The golems may be dangerous, %n.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "May faith belong to scriptures,",
    "not to wishful rumors of ancient mysteries."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Faith may not tell us why they were frozen, but perhaps to protect us,",
    "and maybe it should remain that way."
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
  npcName=SALUS
  serviceType=SERVICE_BLESSINGS
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = ACTION
  preferences(VALOR_BLOSSOMS)     = ACTION
  preferences(GOLEMS_BREATH)      = INACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Tan_Blue
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Tan_Blue'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Tan_Blue
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Salus
    componentTextures.add(Texture2D'NPCs.Clerics.NPC_Portrait_Cleric_Blue_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Salus
  end object
  npcSprites=NPC_Sprites
}


