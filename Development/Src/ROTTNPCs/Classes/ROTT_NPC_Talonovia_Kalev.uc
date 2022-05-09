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
    "by ancient sages for us to to act as our nexus across the realm."
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




















/**=============================================================================
 * NPC - Kalev Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Kalev is a former prince, living in Talonovia.  He's commanding and  
 * diplomatic, superficially.
 *=========================================================================

class ROTT_NPC_Talonovia_Kalev extends ROTT_NPC_Container;

function initdialogue() {
  
  / 1 - Love, 2 - Hate, 3 - Used to love, 4 - Used to hate, 
  //Love
  NPCMoodDialogueNode[1].MoodNode.AddItem(makeDialogNode(
  "Welcome, great champion.""I am honored to see you again.");
  
  NPCMoodDialogueNode[1].MoodNode.AddItem(makeDialogNode(
  """");
  
  //Hate
  NPCMoodDialogueNode[2].MoodNode.AddItem(makeDialogNode(
  "I don't care to see you or your party, %C.");
  NPCMoodDialogueNode[2].MoodNode.AddItem(makeDialogNode(
  "You've brought me nothing but grief.");
  
  NPCMoodDialogueNode[2].MoodNode.AddItem(makeDialogNode(
  "");
  NPCMoodDialogueNode[2].MoodNode.AddItem(makeDialogNode(
  "");
  
  //Used to Love
  NPCMoodDialogueNode[3].MoodNode.AddItem(makeDialogNode(
  "Good to see you, champion.");
  NPCMoodDialogueNode[3].MoodNode.AddItem(makeDialogNode(
  "You will always have my gratitude.");
  
  NPCMoodDialogueNode[3].MoodNode.AddItem(makeDialogNode(
  "");
  NPCMoodDialogueNode[3].MoodNode.AddItem(makeDialogNode(
  "");
  
  //Used to Hate
  NPCMoodDialogueNode[4].MoodNode.AddItem(makeDialogNode(
  "Hello %C.");
  NPCMoodDialogueNode[4].MoodNode.AddItem(makeDialogNode(
  "Have you come for my counsel?");
  
  NPCMoodDialogueNode[4].MoodNode.AddItem(makeDialogNode(
  "");
  NPCMoodDialogueNode[4].MoodNode.AddItem(makeDialogNode(
  "");
  
  //Neutral
  NPCMoodDialogueNode[0].MoodNode.AddItem(makeDialogNode(
  "Yes?");
  NPCMoodDialogueNode[0].MoodNode.AddItem(makeDialogNode(
  "");
  
  NPCMoodDialogueNode[0].MoodNode.AddItem(makeDialogNode(
  "");
  NPCMoodDialogueNode[0].MoodNode.AddItem(makeDialogNode(
  "");
  /
  
  / 0 - Intro, 1 - Conflict, 2 - none, 3 - Conflict, 4 - Conflict, 5 - none/
  //Intro
  eventResponses[INTRODUCTION].PosGreetNode.AddItem(makeDialogNode(
  "A new %C?  Greetings.",
  "I am Kalev, the prince of a kingdom long lost. . ."));
  
  eventResponses[INTRODUCTION].PosGreetNode.AddItem(makeDialogNode(
  "But there's no time to dwell on the past.",
  "Let's speak of the present, shall we?"));
  
  eventResponses[INTRODUCTION].PosGreetNode.AddItem(makeDialogNode(
  "In Rhunia, there is an obelisk.",
  "Have you heard of it?"));
  
  eventResponses[INTRODUCTION].PosGreetNode.AddItem(makeDialogNode(
  "No matter what, do not turn it on.",
  "Understand?"));
  
  
  / The Obelisk Conflict /
  / Positive /
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "Greetings %C.  I'm happy to see you alive and well after",
  "your journey through Rhunia."));
  
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "And it looks as though the obilisk remains inactive,",
  "as it should be."));
  
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "Thank you, hero.",
  ""));
  
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "Continue to Etzland, %C.",
  "Never stop exploring this vast realm of mysteries."));
  
  / Negative /
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "When I first heard of your arrival, I was afraid this would",
  "happen. . ."));
  
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "You activated the Obelisk!",
  "The most destructive force in the realm!"));
  
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "I am not exaggerating, can't you see?",
  "Its radiation will soon ruin much of our supplies."));
  
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "Oh well. . . It seems we must adapt.",
  "How very unfortunate."));
  
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "I suppose some good has come of this.  Maybe you noticed?",
  "The portal to Etzland is open."));
  
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "I don't know much about Etzland.",
  "Good luck on your travels, adventurer."));
  
  
  / The 2nd Hero /
  / Positive /
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "I see that a companion has joined you.",
  "Well done."));
  
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "Your noble deeds have sparked the materialization of the",
  "Haxlyn portal.  What an excellent turn of events!"));
  
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "I must advise you, brave adventurers. . .  Danger lies ahead,",
  "as well as a very important monument known as The Tomb."));
  
  
  / Negative /
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "Rumors in town suggest you may have neglected to rescue",
  "a potential companion from a prison in Etzland."));
  
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "It may be wise to go back for them.  Unless perhaps. . . you",
  "prefer to be alone?"));
  
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "Well, on to other matters.",
  "There is something we must discuss."));
  
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "Your noble deeds have sparked the materialization of the",
  "Haxlyn portal."));
  
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "I must advise you, brave adventurer. . .  Danger lies ahead,",
  "as well as a very important monument known as The Tomb."));
  
  
  / The Tomb Conflict /
  / Positive /
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "You have honored me, %C.  Your quest through Haxlyn has proven your",
  "strength, and your respect for The Tomb proves the purity of your heart."));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "May the guardian spirit protect you on your journeys, my friend.",
  ""));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "You and your party will soon head to Valimor I suspect?",
  "I ask that you hear my counsel one last time, regarding The Golem."));
  
  / Negative /
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "You have ransacked and vandalized the tomb of Haxlyn. . .",
  "It was the last surviving symbol of my lineage!"));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "How heartless of you. . .",
  ""));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  ". . .",
  ""));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "What are you looking at?",
  "I have not lost my composure completely quite yet, you know."));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "Listen here %C, Before you and your party run recklessly",
  "to Valimor, I ask that you hear my counsel regarding The Golem."));
  
  
  / The Golem Conflict /
  / Positive /
  eventResponses[GOLEMS_BREATH].PosGreetNode.AddItem(makeDialogNode(
  "I believe you've done the right thing, my friend.",
  "The golems are not to be disturbed."));
  
  eventResponses[GOLEMS_BREATH].PosGreetNode.AddItem(makeDialogNode(
  "Thanks to you, I can rest easy knowing that we are safe.",
  "You have great wisdom and bravery."));
  
  / Negative /
  eventResponses[GOLEMS_BREATH].NegGreetNode.AddItem(makeDialogNode(
  "You fool!",
  ""));
  
  eventResponses[GOLEMS_BREATH].NegGreetNode.AddItem(makeDialogNode(
  "There may be unimaginable consequences for activating the golem shrine.",
  "I fear the worst. . ."));
  
  eventResponses[GOLEMS_BREATH].NegGreetNode.AddItem(makeDialogNode(
  "If what my father said was true,",
  "this may be the end for us all."));
  
  
  / Inquiry /
  / The Obelisk /
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "The obelisk has the power to emanate a protective force over Talonovia,",
  "but that's not all it emanates."));
  
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "It will spread radiation that will destroy our",
  "supplies, tools, and resources."));
  
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "We survive now without the obelisk, don't we?",
  "What value is there in safety when we suffer from famine?"));
  
  
  / The Tomb /
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "As a young prince my father told me legends of Haxlyn.",
  "Legends that speak of a valiant hero, burried in a sacred tomb"));
  
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "My royal descent derives from the great hero burried in The Tomb.",
  ""));
  
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "So please, I ask you, do not violate The Tomb in any way.",
  "Leave it alone."));
  
  
  / The Golem /
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "The golem is one of many, that's all anyone actually knows.",
  "Anything else you hear is merely fabled."));
  
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "The true secrets of the golems died with my father, the last",
  "king of the deep realm."));
  
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "His dying words were entrusted to me.",
  "Struggling with each syllable. . . Sentences staggered. . ."));
  
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "Believe me %C, it is unwise to let any",
  "energy flow through the golems again."));
  
  
}


defaultProperties
{
  animTime=0.50
  
  eventPrefs(INTRODUCTION)       = NEUTRAL 
  eventPrefs(OBELISK_ACTIVATION) = DISABLED   // NO to Obelisk
  eventPrefs(ETZLAND_HERO)       = ENABLED   // skipping the hero is shameful 
  eventPrefs(VALOR_BLOSSOMS)     = DISABLED  // NO to Valor blossoms
  eventPrefs(GOLEMS_BREATH)      = DISABLED  // NO to Golem 
  
  begin object class=GUITexturedrawInfo Name=NPC_Kalev_F1
    componentTextures.add(Texture2D'GUI.Kalev_Animation_F1'
  end object
  begin object class=GUITexturedrawInfo Name=NPC_Kalev_F2
    componentTextures.add(Texture2D'GUI.Kalev_Animation_F2'
  end object
  
  begin object class=GUISprite Name=NPC_Sprites
    tag="NPC_Sprites"
    PosX=464
    PosY=23 
    PosXEnd=976
    PosYEnd=535
    images(0)=None
    images(1)=NPC_Kalev_F1
    images(2)=NPC_Kalev_F2
  end object
  npcSprites=NPC_Sprites
  
  NPCMood=0
  FluxAnimationTempo=4
  
}

**/



















































