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
    "Here comes the hero.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Don't mind me, I'm just inhaling toxins.", //rr2
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Cauldron bubbles babble gently. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Spirits whispered of your arrival to me.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Wispy murmurs from spirits chattering. . .", 
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "But then!",
    "The tempest screams to us!"
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Her coughs continue. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "My name is unknown throughout the kindgoms.", 
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "For it is I, the master practitioner of chemical witchcraft,",
    "channeler of the high queen of the underworld. . ." //ll1
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I am that which is unseen, that which is unheard.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I am Hekatos.",
    "The high queen of the world below."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You don't hear spirits. . . Do you?", 
    "The murmers of my children that have lost their way. . ." // lr1
  `ENDNODE
  
    `ADD_OPTIONS(INTRODUCTION, NUETRAL)
      "I do not listen to ghosts",       // rl1
      "I'm spiritually tuned",           // rl1
      "What spirits?",                   // lr2
      "Are you all right?"               // ll2
    `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "When you get a wiff of this cauldron's fumes,",
        "the whole world changes."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "Attuned to what?", 
        ""
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "The electric air that's fuels the ethereal stream",
        "is static, there is no tuning."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 2)
        "Ding! Ding!",
        "When flood gates open, creaking through rust."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 2)
        "The wraiths rush through the air,",
        "souls howling, chains clinking."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 2)
        "Mirrors shattering on the floor. . .",
        "The cabinets clattering as that terrible sound continues. . ."
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 3)
        "Barely, just barely.  I fought a wraith",
        "with a couple burnt nether roots last night."
      `ENDNODE
    
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "There is terror in our dark little realm,",
    "and the ghosts here know this." // rr1
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "They tell me that your path will wind through the storms",
    "until you reach a citadel, and a tower." // rl1
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "It is the obelisk of Rhunia.",
    "When you reach it's base, abstain from engaging magic."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Stay away!",
    "You understand?"
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "I did not see you coming love,",
    "but what's fun in an adventure is the surprises."
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
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The tomb is where the remains of the Haxlyn priestess",
    "rest, but that is not all." //lr1
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "She yearns to raise waves through the world as you do, %n.",
    "It is not in her nature to rest."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "That is what I know from scripture.", //lr1
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The essence of her will is carried through the blossoms,",
    "the decore for her tomb." 
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "I've carried her essense in my training and was healed,",
    "that is what's happening now for all who have that blessing." //lr1
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "You'll have a chance to free the will of her spirit.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "And that is what I would do.", //lr1
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The ethereal hand from moonlit magick cast itself upon",
    "a set of scrolls, creating a writing that we call the Lunar Credo." // lr1
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Now banished, the text corrupts all who read it without sagacity.",
    "It'll burn holes in the feeble minded, permanently." // lr2
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The high queen of the underworld sanctioned me to read three",
    "of its pages, in which the moonlight etched the golem's husk." // lr2
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "From each esoteric passage, I've learned only that mystery",
    "holds a thick cloak over our little world." // lr2
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "When you are met with a slumbering golem,",
    "what's best is that their sleep never falters, %n."
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



























