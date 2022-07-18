/*=============================================================================
 * NPC - Tannim Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Tannim is a dragon tamer in Talonovia.  She is discrete, vigilant, and
 * intensily focused.  Her eyes are fiercly ambivalent, like a weathered
 * veteran.  
 *
 * Able to summon massive chains connecting arbitrary points in the
 * sky, dragon tamers sprint fast as light along the metal links, wrapping
 * and climbing across massive demonics opponents, trapping their shrunken
 * spirits down in small, hand sized cages.  To become a dragon tamer one must
 * train under and eventually kill an existing dragon tamer.  Like Auron/Itachi,
 * Dragon Tamers wear one arm in their sleeve out of respect to former masters
 * death.
 *
 * The player may pay dragon tamers to summon high level boss fights, saving
 * the hassle of seeking out such bosses.  Item rewards are increased.
 * Currency rewards are removed.
 *===========================================================================*/

class ROTT_NPC_Talonovia_Tannim extends ROTT_NPC_Container;

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
    "Tannim the dragon tamer is dangling a smoking thurible",
    "over a pet gargoyle. . ."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Are you the new face in town?",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I am Tannim, keeper of beasts and demons,",
    "at your service."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You all right?",
    "First day at the harbor can be rough."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Since you have the eyes of a young wanderer,",
    "I'll have to ask that you tread carefully around the Obelisk of Rhunia."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Ever since \"the black magic tragedy\", the Talonovian high council",
    "has been in nothing but petty disagreements."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I really don't care for arguments.  The solution is simple.",
    "Just leave Rhunia's obelisk alone."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "You're in good hands, friend.",
    "How may I help you?"
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Bestiary",
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
    "This towering monument howls when fed religious psalms,",
    "warding away the unclean, and the damned."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "Tremors shake through their bones, while high ringing screeches",
    "chip away at our hearts, hands, and souls."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "Taming demons and beasts is my purpose here.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "The howling of an ancient pillar's ward is no help to me.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The backbone of physical strength is training.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Champions of light come here in search of combat experience,",
    "against the God-like dwellers of the underworld."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Quite the daunting duty, isn't it?  Having to heal the wounds",
    "of these monstrous giants after each skirmish."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Yet hope exist, nearly within reach.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The tomb of the Haxlyn priestess hosts",
    "a plethora of holy blossoms, imbued with restorative magick."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Collecting petals from around Haxlyn's tomb",
    "may bring the regeneration required to train against them."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "When we fail to fathom the size of a beast,",
    "that is when facing it rewards us most."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Nobody will die under the chains of cowardice,",
    "not in my company, young wanderer."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "So be brave in this endeavor. . .",
    "Face the slumbering ones wide-eyed."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Now think. . .",
    "When you wake ancient golems, will they wake you too?"
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
  npcName=TANNIM
  serviceType=SERVICE_BESTIARY
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = INACTION
  preferences(VALOR_BLOSSOMS)     = ACTION
  preferences(GOLEMS_BREATH)      = ACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Orange
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Orange'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Orange
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Tannim
    componentTextures.add(Texture2D'NPCs.Tamers.NPC_Portrait_Tamer_Orange_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Tannim
  end object
  npcSprites=NPC_Sprites
}


