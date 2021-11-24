/*=============================================================================
 * ROTT_NPC_Dominus
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Final boss
 *===========================================================================*/

class ROTT_NPC_Dominus extends ROTT_NPC_Container;

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
    "Welcome %n, we meet again.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Your presence here has me feeling a bit nostalgic.",
    "Do you remember how you entered this world?"
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "You fell just as I did, from the ethereal stream of course.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "It's such a shame we'll never know what gate you kept.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Perhaps we can guess our gates,",
    "how about it %n?"
  `ENDNODE
  /// [Yes][No]
  /** no: exit dialog, no boss fight **/
  
  `NEW_NODE(GREETING, NUETRAL)
    "When I first fell, I swam the tempest's ocean.",
    "I touched the mysteries of the deep, twisting toward the void."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "And through the depths, I found a new surface to emerge from.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "I spread the strings of our dreams, through the",
    "cold needle fingers of eternity's ethereal hand."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "But I'm not a killer, %n.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "The lives I touch rush and twist,",
    "like a serpent in a waterfall."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Who am I?",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "I am the final serpent, the swallower of the benign,",
    "gatekeeper of the void."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "And you are my kin.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "You are my brother in chaos, and my sister in sin.",
    "We are the blood of the ethereal stream."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "So what is your gate, %n?",
    "What have you done since you fell here?"
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Suppose I hold a raven's skull,",
    "and ask you \"do you know what this is?\""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "If you say \"a raven's skull\" you'd be right,",
    "but if you say \"yes\" you'd be wrong."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Raven skulls are a category of objects that satisfy",
    "a set of properties."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "And those properties are identifiable through the",
    "approximation of your senses, while reality is not."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "In all definitions of raven skulls, large portions of detail",
    "are intentionally ignored."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "In the definition of any category details are ignored",
    "so that some properties are allowed to vary."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Categorization is a form of approximation.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "The beings of this world live and breath in categories.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "But in their hubris they have forgotten that the omition",
    "of detail is the foundation of categorization, thanks to you."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "You fell from the gate of lies, and you are the heart",
    "of this world."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "You fell from the gate of confusion, and you are the",
    "catalyst of chaos."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "You fell from the gate of sin, and you are the",
    "venom of all serpents."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "And in the pursuit of your desires,",
    "you have slain %KILLCOUNT lives."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Forgiveness is a category to which we do not belong.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "So prepare to be torn apart from this world,",
    "just as you were from the ethereal stream. . ."
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    ". . . and enter the furious void of the final serpent with me.",
    ""
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





