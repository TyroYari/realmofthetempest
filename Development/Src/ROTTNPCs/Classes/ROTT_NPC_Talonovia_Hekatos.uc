/*=============================================================================
 * NPC - Hekatos Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Hekatos is a witch in Talonovia.  She's cyptic and eccentric. 
 * The player is supposed to be able to play some sort of minigame with her,
 * possibly potion crafting for permanent stat boosts, (eventually.)
 *===========================================================================*/

class ROTT_NPC_Talonovia_Hekatos extends ROTT_NPC_Container;

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
    "Hekatos the Witch is coughing over a haze of violet fumes. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Don't mind me, I'm just inhaling toxins.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Spirits whispered of your arrival, you know. . .",
    "I do not lie."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The wispy murmurs of spirits chatter,",
    "while your tempests scream toward us!" //rr2
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Her coughs continue. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "My name is known throughout the kindgoms.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "For it is I, the master practitioner of chemical witchcraft,",
    "channeler of the high queen of the underworld. . ."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I am Hekatos, Hekatos. . .  Hekatos!",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You hear don't them too. . .  Do you?", // ll2
    "The spirits?"
  `ENDNODE
  
    `ADD_OPTIONS(INTRODUCTION, NUETRAL)
      "I do not listen to ghosts",
      "I'm well attuned",
      "To what spirits?",
      "I don't know, are you all right?"
    `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "Well, when you get a wiff of my cauldron. . .",
        "Nevermind."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "You're attuned to what?",
        "The electric air of the ethereal stream!?"
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 2)
        "Ding! Ding!",
        "The flood gates open!"
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 2)
        "The wraiths rush out,",
        "souls howling, chains clinking."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 2)
        "Mirrors shattering on the floor. . .",
        ""
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 2)
        "Huh?  I really do not have time to play games, love.",
        ""
      `ENDNODE
    
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "There is terror in our dark little realm,",
    "and the spirits know it." //rr1
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "They tell me that your path will wind through the storms",
    "until you reach a citadel, and a tower."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "It is the obelisk of Rhunia.",
    "When you reach it, abstain from its agitation."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "I'm everywhere, anywhere, and nowhere, sweetheart.",
    "How can I help?"
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Lottery",
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
    "The obelisk of Rhunia must not be disturbed.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "The screech of that awful tower deafens my link",
    "to the spirit world."
  `ENDNODE
  
  ///`NEW_NODE(INQUIRY_OBELISK, NUETRAL)
  ///  "The raging energy invested within it deafens my link",
  ///  "to the spirit world."
  ///`ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Yes, yes. . . The tomb.",
    "It is where the soul of the Haxlyn priestess rests."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "I held her spirit long ago, but still know it well.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "She yearns to raise waves through the world as you do, %n.",
    "It is not in her nature to rest."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The essence of her will is carried through the blossoms,",
    "the decore for her tomb."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Free the will of my sisters spirit upon the world,",
    "bring us back her botanical blessing."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The ethereal hand from moonlit magick cast itself upon",
    "a set of scrolls, creating a writing that we call the Lunar Credo."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Now banished, the text corrupts all who read it without sagacity.",
    "It burns holes in their minds."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The high queen of the underworld sanctioned me to read three",
    "of its pages, in which the moonlight etched the golem's husk."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "From each esoteric passage, I learned only that mystery",
    "holds a thick cloak over our world."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Do not meddle with their slumber, %n.",
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
  npcName=HEKATOS
  serviceType=SERVICE_LOTTERY
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = INACTION
  preferences(VALOR_BLOSSOMS)     = ACTION
  preferences(GOLEMS_BREATH)      = INACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Violet
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Violet'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Violet
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Hekatos
    componentTextures.add(Texture2D'NPCs.Witches.NPC_Portrait_Witch_Purple_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Hekatos
  end object
  npcSprites=NPC_Sprites
}




























