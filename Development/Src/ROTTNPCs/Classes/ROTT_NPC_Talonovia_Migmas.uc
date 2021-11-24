/*=============================================================================
 * ROTT_NPC_Talonovia_Migmas
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Migmas is an alchemist in Talonovia, who provides the enchantment minigame.
 *===========================================================================*/
 
 class ROTT_NPC_Talonovia_Migmas extends ROTT_NPC_Container;

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
    "Migmas the Alchemist is handling a magical flame. . .",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "On stormy nights, I'll watch the wind raging",
    "in the tempest, thrashing against itself. . ."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Is this mixing any different than the concoctions",
    "of alchemy, or are they equally enchanting?"
  `ENDNODE
    
    `ADD_OPTIONS(INTRODUCTION, NUETRAL)
      "Sure",
      "Not at all",
      "",
      ""
    `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 0)
        "Excellently so.",
        ""
      `ENDNODE
    
      `ADD_REPLY(INTRODUCTION, NUETRAL, 1)
        "Suppose so.",
        ""
      `ENDNODE
    
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Call me. . . Migmas, the local alchemist,",
    "member of the Talonovian high council."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I'm not the type for company, but I handle enchantment",
    "services for travellers like yourself."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Now heed this advice carefully. . .",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Through the portal of Rhunia, you'll find an obelisk",
    "towering above the halls of an abandoned citadel."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "You can't read the psalms of Rhunia without",
    "awakening a lost magnificent power from within. . ."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "So go forth to the shrine beneath this monument,",
    "and let's see if this ancient magick will be restored."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(GREETING, NUETRAL)
    "Do you need something?",
    ""
  `ENDNODE
  
    `ADD_OPTIONS(GREETING, NUETRAL)
      "Alchemy",
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
    "Practicing alchemy helps to fortify and sustain Talonovia.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "The aura exerted by the obelisk will empower these magicks.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_OBELISK, NUETRAL)
    "So go forth, and give it your prayer once again.",
    ""
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The spiritual energy of the priestess buried in Haxlyn",
    "will forever permeate the walls of her tomb."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Only by feeding from her energy can",
    "the Haxlyn blossoms flourish."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "Harvest these blossoms, and return them to us.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_TOMB, NUETRAL)
    "The alchemical benefit is unparalleled,",
    "and they will always grow back."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Little is known of the slumbering golems.",
    ""
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "There is mention of them only in the holy text of The Agony Schema, and",
    "the Half Moon Memoirs."
  `ENDNODE
  
  `NEW_NODE(INQUIRY_GOLEM, NUETRAL)
    "Are you not eager to witness their power?",
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
  npcName=MIGMAS
  serviceType=SERVICE_ALCHEMY
  
  // Quest preferences
  preferences(OBELISK_ACTIVATION) = ACTION
  preferences(VALOR_BLOSSOMS)     = ACTION
  preferences(GOLEMS_BREATH)      = ACTION
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Red
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Red'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Red
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Migmas
    componentTextures.add(Texture2D'NPCs.Alchemists.NPC_Portrait_Alchemist_Red_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Migmas
  end object
  npcSprites=NPC_Sprites
}








/**




  eventResponses[INTRODUCTION].PosGreetNode.Additem(makeDialogNode(
  "There is a portal here in town that leads to",
  "Rhunia."));
  
  eventResponses[INTRODUCTION].PosGreetNode.Additem(makeDialogNode(
  "A massive obelisk towering through the sky will be there.",
  "It can be activated, and you must summon its power, %C."));
  
  
  
  // The Obelisk Conflict 
  // Positive *
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "Excellent. . . Excellent!",
  "The power of the obelisk sheilds Talonovia and warms my bones."));
  
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "Such remarkable power, finally released.",
  ""));
  
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "%c, I've heard a new portal has materialized.",
  "You are now free to travel to Etzland."));
  
  eventResponses[OBELISK_ACTIVATION].PosGreetNode.AddItem(makeDialogNode(
  "I sense something special waits for you.",
  "Go now to Etzland."));
  
  // Negative *
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "How dare you return here without bringing the",
  "power of the obelisk with you, %C."));
  
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "If someone has persuaded you that food and supplies",
  "are more important, you have been horribly mislead."));
  
  eventResponses[OBELISK_ACTIVATION].NegGreetNode.AddItem(makeDialogNode(
  "Leave my sight, %C.",
  "Why do you linger here in town when Etzland's portal waits for you?"));
  
  
  // The 2nd Hero 
  // Positive *
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "So you have acquired an ally?",
  "Your power thrives on adventure, young %C."));
  
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "I'm sure more will join you as you proceed to Haxlyn.",
  "Surely you have heard?  The portal is open. Ha!"));
  
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "It's perfect, it's finally here.  Now is the time.",
  "This is the beginning of an era!"));
  
  eventResponses[ETZLAND_HERO].PosGreetNode.AddItem(makeDialogNode(
  "Alchemy will soon be redefined so long as you find",
  "the ancient tomb. . ."));
  
  // Negative *
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "Ha!  What a terrible mistake.  You abandoned the",
  "prisoner in Etzland?  What a shame."));
  
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "Proceeding to Haxlyn alone will be quite the",
  "challenge for you."));
  
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "The time has come.",
  "This is the beginning of an era!"));
  
  eventResponses[ETZLAND_HERO].NegGreetNode.AddItem(makeDialogNode(
  "Alchemy will soon be redefined so long as you find",
  "the ancient tomb within the heart of Haxlyn. . ."));
  
  
  // The Tomb Conflict 
  // Positive *
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "Unbelievable, the valor blossoms are really here. . .",
  "Here in the harbors of Talonovia, it begins. . ."));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "The power I summon with this will be unstopable!",
  ""));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "Speaking of power, I sense your spirit strengthening.",
  "Good, you need great power for the portal that awaits you."));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "Valimor is a dreadful, dark place.  A true nightmare.",
  ""));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "The ancient magi of Valimor have sealed away their secrets",
  "within mysterious golems scattered through the realm."));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "We have one of the golems here, in Talonovia.  If you",
  "activate their sacred shrine in Valimor, the golems will awaken."));
  
  eventResponses[VALOR_BLOSSOMS].PosGreetNode.AddItem(makeDialogNode(
  "Bring forth their secrets!  Release the golems from their",
  "eternal slumber."));
  
  // Negative *
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "It takes great bravery to defy an alchemist with a scythe.",
  "I need those valor blossoms, %C."));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "It's never too late to return to Haxlyn and harvest",
  "the plants from the ancient tomb."));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "Or maybe you would be more interested in what lies",
  "ahead, in the dark dreadful depths of Valimor?"));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "Valimor holds many secrets, sealed away by the ancient magi.",
  "Secrets frozen within mysterious golems."));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "We have one of the golems here, in Talonovia.  If you",
  "activate their sacred shrine in Valimor, the golems will awaken."));
  
  eventResponses[VALOR_BLOSSOMS].NegGreetNode.AddItem(makeDialogNode(
  "Bring forth their secrets!  Release the golems from their",
  "eternal slumber."));
  
  
  
  
  // The Golem Conflict 
  // Positive *
  eventResponses[GOLEMS_BREATH].PosGreetNode.AddItem(makeDialogNode(
  "Success, great success!",
  "Your brave journey to Valimor was honorable, %C."));
  
  eventResponses[GOLEMS_BREATH].PosGreetNode.AddItem(makeDialogNode(
  "The golems you have awakened are now free",
  "to release their mysteries upon the world."));
  
  eventResponses[GOLEMS_BREATH].PosGreetNode.AddItem(makeDialogNode(
  "Secrets of alchemy long forgotten will soon",
  "be remembered!"));
  
  eventResponses[GOLEMS_BREATH].PosGreetNode.AddItem(makeDialogNode(
  "It will just take patience. . .",
  "It is not easy to communicate with the ancient ones."));
  
  // Negative *
  eventResponses[GOLEMS_BREATH].NegGreetNode.AddItem(makeDialogNode(
  "You have tainted your brave journey with your betrayal",
  "of my wishes."));
  
  eventResponses[GOLEMS_BREATH].NegGreetNode.AddItem(makeDialogNode(
  "Disabled golems are worthless, what are you",
  "so afraid of %C?"));
  
  
  //The Dominus Demise
  /
  //eventResponses[5].PosGreetNode[0] = "You completed the last quest?";
  //eventResponses[5].PosGreetNode[1] = "Cool.";
  /
  
  
  // Inquiry 
  // The Obelisk *
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "Just as my blade and I protect this town, ",
  "The power of the obelisk will protect us as well."));
  
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "Not only that, but my alchemy can feed off of",
  "the power of this obelisk."));
  
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "If anyone else has spoken to you about this,",
  "opposing my position. . ."));
  
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "They are dead wrong.  Complete fools, all of them.",
  ""));
  
  inquiryReplies[THE_OBELISK].inquiryNodes.AddItem(makeDialogNode(
  "We need that power.  Go now.",
  "Go to Rhunia and activate the obelisk."));
  
  // The Tomb *
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "The tomb in Haxlyn is an ancient one, where a brave",
  "warrior's powerful spirit has been magically preserved."));
  
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "His unbreakable will to stop evil prevents his spirit from",
  "leaving our world, and so it remains, manifested in a new form."));
  
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "And that is how the valor blossoms came to be.",
  "They are the hero, reincarnated."));
  
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "Every text on alchemy notates the power of the blossom.",
  "It's power is enormous, just like the hero."));
  
  inquiryReplies[THE_TOMB].inquiryNodes.AddItem(makeDialogNode(
  "Go retrieve the valor blossoms, young hero.",
  "Return the power to the Talonovian people!"));
  
  
  // The Golem *
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "The golems are the keepers of ancient secrets.",
  "Countless decades and centuries of mysteries, locked away. . ."));
  
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "Even the deepest secrets of alchemy",
  "may be held within these dormant creatures."));
  
  inquiryReplies[THE_GOLEM].inquiryNodes.AddItem(makeDialogNode(
  "And that is why you must awaken them.",
  ""));
}


defaultProperties
{
  eventPrefs(INTRODUCTION)       = NEUTRAL 
  eventPrefs(OBELISK_ACTIVATION) = ENABLED   // YES to Obelisk 
  eventPrefs(ETZLAND_HERO)       = ENABLED   // skipping the hero is shameful 
  eventPrefs(VALOR_BLOSSOMS)     = ENABLED   // Yes to valor blossoms 
  eventPrefs(GOLEMS_BREATH)      = ENABLED   // YES to Golem 
  

**/

