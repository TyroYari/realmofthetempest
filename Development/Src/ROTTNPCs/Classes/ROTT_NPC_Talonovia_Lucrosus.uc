/*=============================================================================
 * NPC - Lucrosus Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Lucrosus is a merchant in Talonovia.  He's a greedy scoundrel. 
 * The player is supposed to be able to sell stuff to him (eventually.)
 *===========================================================================*/

class ROTT_NPC_Talonovia_Lucrosus extends ROTT_NPC_Container;

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
    "With a sudden turn to the door, Lucrosus the Merchant drops",
    "some coins to the floor. . ."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  // Intro
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Yes this shop is open, welcome!",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Offering wares blessed by the silver wind,",
    "with the shine that guides the path of all great heroes!"
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "If you're keen to a cut of fortune for yourself,",
    "why not seek out the Obelisk's shrine for me?"
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You have heard of this haven't you?",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(INTRODUCTION, NUETRAL)
      "Uhuh. . .",
      "No",
      "",
      ""
    `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "Splendid news!",
        ""
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "The obelisk is an abandoned monument in the citadel of Rhunia.",
        ""
      `ENDNODE
    
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Praying at the shrine summons an immense power,",
    "whose flow will cripple food production."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Supply and demand will forge my wages with an iron hammer,",
    "which will kindly bless my hungry treasury."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You do understand, don't you?",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "It's also a protective obelisk, so everyone benefits.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Go call the roar of this ancient tower,",
    "and you'll have my. . . my deepest praise. . ."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "May fortune smile upon us.",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Barter",
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
    "The tome at the base of the obelisk in Rhunia's citadel",
    "will summon a protective force when it is activated."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "Which also cripples food production. . . See?",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "Not the worst thing to exploit for profit. . . Right?",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Those wretched blossoms will ruin me again.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "So I swear on the storms. . . Do not harvest that tomb.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Many fanatics believe that the golems hold",
    "the secrets of our souls."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "They would likely pay handsomely to visit",
    "the golem of Talonovia."
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
  npcName=LUCROSUS
  serviceType=SERVICE_BARTERING
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = ACTION
  preferences(VALOR_BLOSSOMS)     = INACTION
  preferences(GOLEMS_BREATH)      = ACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Green
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Green'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Green
  end object
  npcBackground=NPC_Background
  
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Lucrosus
    componentTextures.add(Texture2D'NPCs.Merchants.NPC_Portrait_Merchant_Green_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Lucrosus
  end object
  npcSprites=NPC_Sprites
}










/**


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

function initdialogue()
{
  local string tempLine1, tempLine2;
  
  QuestConflictPreference.Length = 6;
  QuestInquiryNode.Length = 2;
  NPCMoodDialogueNode.Length = 5;
  GreetByQuestIndex.Length = 6;
  InformByQuestIndex.Length = 4;
  
  
  / Conflict Preferences: 
  /  1 - No
  /  2 - Yes
  /  0 - No preference /
  QuestConflictPreference[0] = 0; / introduction /
  QuestConflictPreference[1] = 2;  / YES to Obelisk /
  QuestConflictPreference[2] = 2; / YES to 2nd Hero /
  QuestConflictPreference[3] = 1; / NO to valor blossoms /
  QuestConflictPreference[4] = 2; / YES to Golem /
  QuestConflictPreference[5] = 0; //Boss
  
  
  
  
  / 1 - Love, 2 - Hate, 3 - Used to love, 4 - Used to hate, /
  //Love
  /
  NPCMoodDialogueNode[1].MoodNode.AddItem("[%Option=0][%Alchemy]You are most welcome here, %C.");
  NPCMoodDialogueNode[1].MoodNode.AddItem("Have you come to perform Alchemy?");
    // YES NO answers
    OptionNode.Additem("Yes.+No.++");
  /
  NPCMoodDialogueNode[1].MoodNode.AddItem("[%Inquiry]My favorite business partner!");
  NPCMoodDialogueNode[1].MoodNode.AddItem("What can I do for you today?");
  
  
  //Hate
  /
  NPCMoodDialogueNode[2].MoodNode.AddItem("[%Option=1][%Alchemy]Your presence disgusts me.");
  NPCMoodDialogueNode[2].MoodNode.AddItem("Don't tell me you are here for Alchemy.");
    // YES NO answers 
    OptionNode.Additem("I am.+I am not.++");
  /
  NPCMoodDialogueNode[2].MoodNode.AddItem("[%Inquiry]You'll be getting no discounts from me,");
  NPCMoodDialogueNode[2].MoodNode.AddItem("you selfish backstabber.");
  
  
  //Used to Love
  /
  NPCMoodDialogueNode[3].MoodNode.AddItem("It seems your loyalties have shifted,");
  NPCMoodDialogueNode[3].MoodNode.AddItem("but you still have my gratitude.");
  
  NPCMoodDialogueNode[3].MoodNode.AddItem("[%Option=0][%Alchemy]Are you here for alchemy?");
  NPCMoodDialogueNode[3].MoodNode.AddItem("");
    // YES NO answers [0]
  /
  NPCMoodDialogueNode[3].MoodNode.AddItem("[%Inquiry]I still have great respect for you %C.");
  NPCMoodDialogueNode[3].MoodNode.AddItem("What can I do for you?");
  
  
  //Used to Hate
  /
  NPCMoodDialogueNode[4].MoodNode.AddItem("[%Option=0][%Alchemy]Welcome %C.");
  NPCMoodDialogueNode[4].MoodNode.AddItem("Here to trade?");
    // YES NO answers [0]
    //OptionNode.Additem("Yes.+No.++");
  /
  NPCMoodDialogueNode[4].MoodNode.AddItem("[%Inquiry]Welcome %C.");
  NPCMoodDialogueNode[4].MoodNode.AddItem("");
  
  
  //Neutral
  /
  NPCMoodDialogueNode[0].MoodNode.AddItem("[%Option=0][%Alchemy]Greetings.");
  NPCMoodDialogueNode[0].MoodNode.AddItem("Do you seek alchemy to build your artifacts?");
    // YES NO answers [0]
  /
  NPCMoodDialogueNode[0].MoodNode.AddItem("[%Inquiry]Hello %C.");
  NPCMoodDialogueNode[0].MoodNode.AddItem("Here for business?");
  
  
  
  / 0 - Intro, 1 - Conflict, 2 - none, 3 - Conflict, 4 - Conflict, 5 - none/
  / Introduction /
  GreetByQuestIndex[0].PosGreetNode.Additem("Welcome, customer. Please do come right in.");
  GreetByQuestIndex[0].PosGreetNode.Additem("I am Lucrosus, the greatest merchant to ever grace Talonovia.");
  
  GreetByQuestIndex[0].PosGreetNode.Additem("[%Option=0]Perhaps you may be keen towards a business proposition. . .");
  GreetByQuestIndex[0].PosGreetNode.Additem("Care to hear what I have in mind?");
    OptionNode.Additem("Okay.+No Thanks.++");
  
  / temp lines holding options data, seperated by plus signs /
  tempLine1 = "";
  tempLine2 = "";
  
  tempLine1 $= "Splendid!";
  tempLine2 $= "";
  tempLine1 $= "+Oh now hold on there friend, hear me out in case";
  tempLine2 $= "+you change your mind.";
  tempLine1 $= "+";
  tempLine2 $= "+";
  tempLine1 $= "+";
  tempLine2 $= "+";
  
  GreetByQuestIndex[0].PosGreetNode.Additem(tempLine1); //Adds the options!
  GreetByQuestIndex[0].PosGreetNode.Additem(tempLine2); //Adds the options!
  
  GreetByQuestIndex[0].PosGreetNode.Additem("As an adventurer, surely you will be. . . adventuring?");
  GreetByQuestIndex[0].PosGreetNode.Additem("Well, there is an obelisk that you might find in Rhunia.");
  
  GreetByQuestIndex[0].PosGreetNode.Additem("If touched, the enchantment of the obelisk will be restored,");
  GreetByQuestIndex[0].PosGreetNode.Additem("enabling an aura of protection here in Talonovia.");
  
  GreetByQuestIndex[0].PosGreetNode.Additem("And between you and me, there might just be a small side");
  GreetByQuestIndex[0].PosGreetNode.Additem("effect from this aura, which might lead to a great deal of wealth.");
  
  GreetByQuestIndex[0].PosGreetNode.Additem("[%Complete][%Inquiry]So how about it %C?  Become my business partner,");
  GreetByQuestIndex[0].PosGreetNode.Additem("and go activate that obelisk!");
  
  
  
  
  
  / The Obelisk Conflict /
  / Positive /
  GreetByQuestIndex[1].PosGreetNode.AddItem("My new business partner, the %C!  I knew I could count on you.");
  GreetByQuestIndex[1].PosGreetNode.AddItem("I have good news for you.");
  
  GreetByQuestIndex[1].PosGreetNode.AddItem("I've heard rumors about this new portal to Etzland that just");
  GreetByQuestIndex[1].PosGreetNode.AddItem("materialized.  Apparently there's a long lost adventurer trapped there.");
  
  GreetByQuestIndex[1].PosGreetNode.AddItem("I think it's time to expand the business, if you know what I mean.");
  GreetByQuestIndex[1].PosGreetNode.AddItem("Think about it!  If you rescue that adventurer, he would be in our debt.");
  
  GreetByQuestIndex[1].PosGreetNode.AddItem("[%Complete][%Inquiry]We could be filthy rich! Absolutely unstoppable!");
  GreetByQuestIndex[1].PosGreetNode.AddItem("What are you waiting for?  Go to Etzland!");
  
  / Negative /
  GreetByQuestIndex[1].NegGreetNode.AddItem("Some lousy business partner you turned out to be.");
  GreetByQuestIndex[1].NegGreetNode.AddItem("Now I know why the Merchant's Guild says trust no one.");
  
  GreetByQuestIndex[1].NegGreetNode.AddItem("Perhaps I need to gain your trust first, %C?");
  GreetByQuestIndex[1].NegGreetNode.AddItem("I have a little tip for you, information free of charge.");
  
  GreetByQuestIndex[1].NegGreetNode.AddItem("There is another adventurer, like you, trapped in Etzland.");
  GreetByQuestIndex[1].NegGreetNode.AddItem("");
  
  GreetByQuestIndex[1].NegGreetNode.AddItem("[%Complete][%Inquiry]If you were to rescue him or her, they would be");
  GreetByQuestIndex[1].NegGreetNode.AddItem("in your debt, see?  Now go. . . off to Etzland!");
  
  
  / The 2nd Hero /
  / Positive /
  GreetByQuestIndex[2].PosGreetNode.AddItem("Ahh... A new addition to the team I see.");
  GreetByQuestIndex[2].PosGreetNode.AddItem("Another potential business partner perhaps?");
  
  GreetByQuestIndex[2].PosGreetNode.AddItem("Listen up because I have a new plan, but it's not ready yet.");
  GreetByQuestIndex[2].PosGreetNode.AddItem("");
  
  GreetByQuestIndex[2].PosGreetNode.AddItem("While we wait for the right time to hatch this scheme,");
  GreetByQuestIndex[2].PosGreetNode.AddItem("all I ask of you is this. . .");
  
  GreetByQuestIndex[2].PosGreetNode.AddItem("[%Complete][%Inquiry]Do not retrieve the Valor Blossoms from The Tomb");
  GreetByQuestIndex[2].PosGreetNode.AddItem("in Haxlyn.  Okay?");
  
  / Negative /
  GreetByQuestIndex[2].NegGreetNode.AddItem("You're back. . . and alone?");
  GreetByQuestIndex[2].NegGreetNode.AddItem("How unfortunate.");
  
  GreetByQuestIndex[2].NegGreetNode.AddItem("Well, anyway.");
  GreetByQuestIndex[2].NegGreetNode.AddItem("Listen up because I have a new plan, but it's not ready yet.");
  
  GreetByQuestIndex[2].NegGreetNode.AddItem("So while we wait for the right time to hatch this scheme,");
  GreetByQuestIndex[2].NegGreetNode.AddItem("all I ask of you is this. . .");
  
  GreetByQuestIndex[2].NegGreetNode.AddItem("[%Complete][%Inquiry]Do not retrieve the Valor Blossoms from The Tomb");
  GreetByQuestIndex[2].NegGreetNode.AddItem("in Haxlyn.  Okay?");
  
  
  / The Tomb Conflict /
  / Positive /
  GreetByQuestIndex[3].PosGreetNode.AddItem("Everything is going according to plan.");
  GreetByQuestIndex[3].PosGreetNode.AddItem("Thank you, %C.");
  
  GreetByQuestIndex[3].PosGreetNode.AddItem("I don't know what I would have done if you had ruined");
  GreetByQuestIndex[3].PosGreetNode.AddItem("my business with those awful Valor Blossoms.");
  
  GreetByQuestIndex[3].PosGreetNode.AddItem("Now, if you recall I had mentioned a plan.");
  GreetByQuestIndex[3].PosGreetNode.AddItem("Thanks to your work in Haxlyn, the portal to Valimor is open.");
  
  GreetByQuestIndex[3].PosGreetNode.AddItem("[%Complete][%Inquiry]The shrine of the ancient golem is in Valimor,");
  GreetByQuestIndex[3].PosGreetNode.AddItem("and it's the key to our plan's success.");
  
  / Negative /
  GreetByQuestIndex[3].NegGreetNode.AddItem("Oh no. No, no, no.");
  GreetByQuestIndex[3].NegGreetNode.AddItem("You brought back the Valor Blossoms?  I'm ruined!");
  
  GreetByQuestIndex[3].NegGreetNode.AddItem("There goes the business, thanks a lot, %C.");
  GreetByQuestIndex[3].NegGreetNode.AddItem("There's only one thing that can possibly bring us back now.");
  
  GreetByQuestIndex[3].NegGreetNode.AddItem("Remember that plan I had mentioned?");
  GreetByQuestIndex[3].NegGreetNode.AddItem("We might still be able to pull it off.");
  
  GreetByQuestIndex[3].NegGreetNode.AddItem("[%Complete][%Inquiry]There is an ancient shrine in Valimor,");
  GreetByQuestIndex[3].NegGreetNode.AddItem("and it's the key to waking The Golem.");
  
  / The Golem Conflict /
  / Positive /
  GreetByQuestIndex[4].PosGreetNode.AddItem("Welcome to the beautiful harbors of Talonovia, home of the");
  GreetByQuestIndex[4].PosGreetNode.AddItem("heroic champions who woke the golems of the ancient realm!");
  
  GreetByQuestIndex[4].PosGreetNode.AddItem("Just imagine it, my friend.  They will come from far and wide just");
  GreetByQuestIndex[4].PosGreetNode.AddItem("to have you sign their cloaks.");
  
  GreetByQuestIndex[4].PosGreetNode.AddItem("[%Complete][%Inquiry]We will be rich.");
  GreetByQuestIndex[4].PosGreetNode.AddItem("");
  
  / Negative /
  GreetByQuestIndex[4].NegGreetNode.AddItem("Look %C, this is no time to fool around.  This is a financial");
  GreetByQuestIndex[4].NegGreetNode.AddItem("crisis.  Do you even know what business partner means?");
  
  GreetByQuestIndex[4].NegGreetNode.AddItem("[%Complete][%Inquiry]I'm ruined without that golem.  I beg you to reconsider,");
  GreetByQuestIndex[4].NegGreetNode.AddItem("preferably before I go completely bankrupt.");
  
  
  //The Dominus Demise
  GreetByQuestIndex[5].PosGreetNode.AddItem("You completed the last quest?");
  GreetByQuestIndex[5].PosGreetNode.AddItem("Cool.");
  
  
  
  / Inquiry /
  / The Obelisk /
  InformByQuestIndex[1].QuestNode.AddItem("The obelisk?  Well it will protect us, of course.");
  InformByQuestIndex[1].QuestNode.AddItem("I have nothing to hide. . . Except, well. . .");
  
  InformByQuestIndex[1].QuestNode.AddItem("Let's just say there may be some radiation emitted");
  InformByQuestIndex[1].QuestNode.AddItem("that destroys some supplies here in Talonovia.");
  
  InformByQuestIndex[1].QuestNode.AddItem("And those supplies happen to be my competition.");
  InformByQuestIndex[1].QuestNode.AddItem("");
  
  InformByQuestIndex[1].QuestNode.AddItem("[%Inquiry]So how about it traveller?  Activate the obelisk for the protection");
  InformByQuestIndex[1].QuestNode.AddItem("of the town and the wealth of your new friend Lucrosus.");
  
  
  
  / The Tomb /
  InformByQuestIndex[2].QuestNode.AddItem("You may have heard about these awful Valor Blossoms while");
  InformByQuestIndex[2].QuestNode.AddItem("mingling with the people of Talonovia.");
  
  InformByQuestIndex[2].QuestNode.AddItem("Well stop mingling, alright?");
  InformByQuestIndex[2].QuestNode.AddItem("Those Valor Blossoms will kill my business.");
  
  InformByQuestIndex[2].QuestNode.AddItem("How can we be business partners without");
  InformByQuestIndex[2].QuestNode.AddItem("any business?");
  
  InformByQuestIndex[2].QuestNode.AddItem("I swear on the storms, if you come back from Haxlyn");
  InformByQuestIndex[2].QuestNode.AddItem("loaded with free handouts, I will never forgive you.");
  
  InformByQuestIndex[2].QuestNode.AddItem("[%Inquiry]Do not harvest the valor blossoms at the tomb site.");
  InformByQuestIndex[2].QuestNode.AddItem("");
  
  
  / The Golem /
  InformByQuestIndex[3].QuestNode.AddItem("From what I've gathered, an ancient enchantment is sealed");
  InformByQuestIndex[3].QuestNode.AddItem("away in the depths of Valimor at a sacred shrine.");
  
  InformByQuestIndex[3].QuestNode.AddItem("This enchantment is the one and only spell that will wake");
  InformByQuestIndex[3].QuestNode.AddItem("not just our golem, but all the golems of the realm.");
  
  InformByQuestIndex[3].QuestNode.AddItem("Why does that matter you ask?  Well think about it %C.");
  InformByQuestIndex[3].QuestNode.AddItem("Many fanatics believe that the golems hold the secrets of our souls.");
  
  InformByQuestIndex[3].QuestNode.AddItem("[%Inquiry]They would pay handsomely to see the great golem of Talonovia, and");
  InformByQuestIndex[3].QuestNode.AddItem("meet the great %C who woke them from their dark slumber.");
  
  
}


DefaultProperties
{
  NPCMood=0
  Animation_Index=1
  NPC_Name="Lucrosus"
  FluxAnimationTempo=4
  BaseAnimationTempo=10
  CurrentAnimationTick=14
  QuestResponseIndex=0
  
  
}


**/






























































