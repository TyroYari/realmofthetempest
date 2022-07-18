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
    "Kalev the Prince is busy reading, and avoids eye contact. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Hi.  You're not the first stranger to pop up here",
    "at my house." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The mystical gates of this harbor were woven", 
    "by ancient sages for us to act as our nexus across the realm."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I am formerly a prince of royal blood, but my kingdom is lost in chaos.",
    "Named by the emperor at birth. . . I'm addressed as Kalev."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The gate to Rhunia will lead you on your journey to a forsaken citadel, where",
    "if your courage permits, you'll find an obelisk." 
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I do not play with magick.",
    "I would not engage the obelisk."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "You're just in time for cider and short bread, %n.",
    "I do not mind sharing."
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
    "Not every pillar of protection is a step toward salvation.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "The aura of the obelisk exerts pressure on",
    "more than just our enemies."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "It weighs against the breath of nature, the nourishment",
    "of the living, and the vigor of young minds."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "The obelisk is a burden, disguised by hope and desperation.",
    "Its aura should remain muted."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Before the era of descent, an unwavering sense",
    "of loyalty tied together all the great kingdoms."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The harmony of these kingdoms became lost when servents",
    "from the house that held no citadel released the forbidden books."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Losing Haxlyn hurt worst of all. . .",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "A valiant priestess is buried there on Haxlyn's holy ground,",
    "with her tomb adorned by blossoms infused with purity and valor."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "It is a sacred place that should not be disturbed.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Long ago, before the building of our kingdoms,",
    "our ancestors lived in Ix land."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Ix land is where the Vixbane and Nix wood clans",
    "once banished the nine forbidden texts."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The Cipher of Six and Spirit,",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The Red Codex,",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The Nightmyrius Doctrine,",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The Lunar Credo,",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The Grimoire of the Nix Wood Priest,",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The Dread Llyr's Sins,",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The Heretics Coil,",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "The Black Water Script,",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "And the three volumes of Oblivion: Lesser Oblivion,",
    "Greater Oblivion, and Final Oblivion."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "When our kingdoms were built, each received a holy citadel,",
    "except one."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Those who served the house with no citadel became bitter,",
    "and released the forbidden texts from their unholy vaults."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Now their spite lingers in every ghastly demon that walks the realm.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Given this history, we are in no place",
    "to wake the golems and face their judgement."
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







