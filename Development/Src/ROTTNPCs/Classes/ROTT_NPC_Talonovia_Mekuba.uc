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
        "Necromancy, this is not my profession,",
        "but a birthright."
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
























/**

/=============================================================================
 * NPC - Mekuba Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Mekuba is a necromancer in Talonovia.  He's brief, dark, and morbid. 
 * The player is supposed to be able to battle hoards of enemies summoned by
 * him (eventually.)
 *===========================================================================/

class ROTT_NPC_Talonovia_Mekuba extends ROTT_NPC_Container;

function initdialogue() {
  local int length;               // Used to access a recently added node
  local ReplyNode newReplyNode;   // Used to prepare a reply node
  
  / 1 - Love, 2 - Hate, 3 - Used to love, 4 - Used to hate, 
  //Love
  NPCMoodDialogueNode[1].MoodNode.AddItem(makeDialogNode(
  "The Great One. . . May I serve you?""");
  
  NPCMoodDialogueNode[1].MoodNode.AddItem(makeDialogNode(
  """");
  
  //Hate
  NPCMoodDialogueNode[2].MoodNode.AddItem(makeDialogNode(
  "I feel the presence of filth. . .");
  NPCMoodDialogueNode[2].MoodNode.AddItem(makeDialogNode(
  "It must be you, %C.");
  
  NPCMoodDialogueNode[2].MoodNode.AddItem(makeDialogNode(
  "");
  NPCMoodDialogueNode[2].MoodNode.AddItem(makeDialogNode(
  "");
  
  //Used to Love
  NPCMoodDialogueNode[3].MoodNode.AddItem(makeDialogNode(
  "Hail to you, Great One.");
  NPCMoodDialogueNode[3].MoodNode.AddItem(makeDialogNode(
  "");
  
  NPCMoodDialogueNode[3].MoodNode.AddItem(makeDialogNode(
  "");
  NPCMoodDialogueNode[3].MoodNode.AddItem(makeDialogNode(
  "");
  
  //Used to Hate
  NPCMoodDialogueNode[4].MoodNode.AddItem(makeDialogNode(
  ". . .");
  NPCMoodDialogueNode[4].MoodNode.AddItem(makeDialogNode(
  "");
  
  NPCMoodDialogueNode[4].MoodNode.AddItem(makeDialogNode(
  "");
  NPCMoodDialogueNode[4].MoodNode.AddItem(makeDialogNode(
  "");
  
  //Neutral
  NPCMoodDialogueNode[0].MoodNode.AddItem(makeDialogNode(
  "What do you seek from me, mortal?");
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
  ". . .",
  "",
    "Who are you?",
    "Maybe I should go. . ."));
   
  newReplyNode.replyTop[0]    = "Lord of death and necromancy, my name is Mekuba.";
  newReplyNode.replyBottom[0] = "";
  
  newReplyNode.replyTop[1]    = ". . ."; // need to force goodbye here
  newReplyNode.replyBottom[1] = "";
  
  newReplyNode.replyTop[2]    = "";
  newReplyNode.replyBottom[2] = "";
  
  newReplyNode.replyTop[3]    = "";
  newReplyNode.replyBottom[3] = "";
  
  length = eventResponses[INTRODUCTION].PosGreetNode.Length;
  eventResponses[INTRODUCTION].PosGreetNode[length-1].optionReplies.addItem(newReplyNode);
 
  
  / The Obelisk Conflict /
  / Positive /
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "You've done well in Rhunia",
  "The obelisk must remain undisturbed."));
  
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "Continue to Etzland, %C.",
  ""));
  
  / Negative /
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "You have enchanted the obelisk. . .",
  "So be it."));
  
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "But know that you are wrong, mortal.",
  "You will see that the Obelisk does not aid you."));
  
  
  / The 2nd Hero /
  / Positive /
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "So you have saved the life of this mortal, and now",
  "they are bound to move as you do?"));
  
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "It seems we are not so different after all, for the",
  "undead that I summon behave the same way."));
  
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "Now listen, mortal, for my advisement",
  "to you now must not be ignored."));
  
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "The Tomb found in Haxlyn is not to be disturbed.",
  "Understand?"));
  
  / Negative /
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "Have you left the Etzland prisoner to die?",
  "You've abandoned him as I would have, for there is beauty in death."));
  
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "Now listen, mortal.",
  "For my advisement to you now must not be ignored."));
  
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "The Tomb found in Haxlyn is not to be disturbed.",
  "Understand?"));
  
  
  / The Tomb Conflict /
  / Positive /
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "You've done well.",
  ""));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "Instead of robbing the tomb of its treasures like a common",
  "vulture, you've displayed true willpower and respect."));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "I know now that you are ready to seek out",
  "the shrine of The Golem."));
  
  / Negative /
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  ". . .",
  ""));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "The air of the deceased crawls from your lips, %C.",
  "It lingers on your breath."));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "You return from The Tomb believing that defiling it",
  "was an act of heroism?  Fool."));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "Dare not cross me again.",
  "The dead belong to me."));
  
  
  / The Golem Conflict /
  / Positive /
  eventResponses[GOLEMS_BREATH].PosGreetNode.AddItem(makeDialogNode(
  "Archaic lords of the forgotten realm rise from the void of eternal",
  "night! And you, great champion, will forever be remembered."));
  
  eventResponses[GOLEMS_BREATH].PosGreetNode.AddItem(makeDialogNode(
  "The resurrection of The Golems is a feat",
  "that cannot be matched by mortal men."));
  
  eventResponses[GOLEMS_BREATH].PosGreetNode.AddItem(makeDialogNode(
  "You have my allegiance.",
  ""));
  
  / Negative /
  eventResponses[GOLEMS_BREATH].NegGreetNode.AddItem(makeDialogNode(
  ". . .",
  ""));
  
  eventResponses[GOLEMS_BREATH].NegGreetNode.AddItem(makeDialogNode(
  "You will regret betraying my adjurations.",
  ""));
  
  eventResponses[GOLEMS_BREATH].NegGreetNode.AddItem(makeDialogNode(
  "The monumental resurrection of The Golems will proceed",
  "with or without you.  A way will be found. . ."));
  
  
  //The Dominus Demise
  //eventResponses[5].PosGreetNode.AddItem(makeDialogNode(
  //"You completed the last quest?"));
  //eventResponses[5].PosGreetNode.AddItem(makeDialogNode(
  //"Cool."));
  
  
  
  
  / Inquiry /
  / The Obelisk /
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "Death always comes.  Neither you nor the obelisk",
  "can stop it."));
  
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "Leave it be.",
  ""));
  
  / The Tomb /
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "The dead are not for you to disturb, %C.",
  ""));
  
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "The dead belong to me.",
  ""));
  
  / The Golem /
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "The golem is one of many.",
  "They have never lived, and will never die."));
  
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "And yet, they long to breathe with us once more.",
  ""));
  
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "Unchain them, %C.",
  "So we might study their mysteries."));
  
}


defaultProperties
{
  animTime=0.25
  
  eventPrefs(INTRODUCTION)       = NEUTRAL 
  eventPrefs(OBELISK_ACTIVATION) = DISABLED    // NO to Obelisk 
  eventPrefs(ETZLAND_HERO)       = ENABLED   // skipping the hero is shameful 
  eventPrefs(VALOR_BLOSSOMS)     = ENABLED    // Yes to valor blossoms 
  eventPrefs(GOLEMS_BREATH)      = ENABLED    // YES to Golem 
  
  begin object class=GUITexturedrawInfo Name=NPC_Mekuba_F1
    componentTextures.add(Texture2D'GUI.Mekuba_Animation_F1'
  end object
  begin object class=GUITexturedrawInfo Name=NPC_Mekuba_F2
    componentTextures.add(Texture2D'GUI.Mekuba_Animation_F2'
  end object
  begin object class=GUITexturedrawInfo Name=NPC_Mekuba_F3
    componentTextures.add(Texture2D'GUI.Mekuba_Animation_F3'
  end object
  begin object class=GUITexturedrawInfo Name=NPC_Mekuba_F4
    componentTextures.add(Texture2D'GUI.Mekuba_Animation_F4'
  end object
  
  begin object class=GUISprite Name=NPC_Sprites
    tag="NPC_Sprites"
    PosX=464
    PosY=56
    PosXEnd=976
    PosYEnd=567
    images(0)=None
    images(1)=NPC_Mekuba_F1
    images(2)=NPC_Mekuba_F2
    images(3)=NPC_Mekuba_F1
    images(4)=NPC_Mekuba_F2
    images(5)=NPC_Mekuba_F1
    images(6)=NPC_Mekuba_F3
    images(7)=NPC_Mekuba_F4
    images(8)=NPC_Mekuba_F3
    images(9)=NPC_Mekuba_F4
    images(10)=NPC_Mekuba_F3
  end object
  npcSprites=NPC_Sprites
  
  NPCMood=0
  FluxAnimationTempo=0
  
  
}




/        Obelisk, Tomb, Golem

  NPC           [1][2][3]  Big Reward
  Merchant      Y  N  Y    ✓
  Prince        N  N  N    ✓
  Medicine Man    Y  Y  N    
  Witch -        N  Y  N    ✓
  Necromancer -    N  N  Y    
  Alchemist -      Y  Y  Y    ✓
  Dragon Tamer -    N  Y  Y    
  
  Merchant wants obelisk ON for supply and demand of his products
  Prince wants obelisk OFF to prevent famine
  Librarian -
  Medicine man wants obelisk ON because it makes his job easier
  Witch wants obelisk the obelisk OFF because the radiation will disrupt her spells
  Necromancer wants obelisk 
  Alchemist wants the obelisk ON because the radiation will amplify his spells (lmao)
  Dragon tamer wants obelisk 
  
  Merchant wants tomb UNDISTURBED so he can sell his potions
  Prince wants tomb UNDISTURBED because he buried his sister there
  Librarian -
  Medicine man wants tomb TAKEN because it makes his job easier (even though he burried many of the people in the cemetary)
  Witch wants tomb TAKEN because she benefits from the cemetary being disturbed, she can harness disrupted astral energy
  Necromancer wants tomb 
  Alchemist wants tomb because he can use the tomb for potions
  Dragon tamer wants tomb 
  
  Merchant wants golem 
  Prince wants golem 
  Librarian -
  Medicine man wants golem 
  Witch wants golem 
  Necromancer wants golem 
  Alchemist wants golem 
  Dragon tamer wants golem 
  
  Librarian:
  - Explains portals and monsters
  - Explains gas planet lore
  - Explains Dominus
  - Responds to each level's completion but not the conflict?
/





















**/



















