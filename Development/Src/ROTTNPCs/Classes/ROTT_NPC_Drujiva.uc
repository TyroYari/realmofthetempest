/*=============================================================================
 * ROTT_NPC_Drujiva
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Tethered to the mountain shrine, Drujiva is the druid sage that fused with
 * the spirit of the land.  Drujiva requests the player's help in restoring the
 * land from corruption, but is in fact already corrupt by Dominus.
 *===========================================================================*/

class ROTT_NPC_Drujiva extends ROTT_NPC_Container;

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
  
  // Introduction
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Distant birds quietly chatter in the distance, as an old man", 
    "gently lifts open his eyes from a pose of deep meditation."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Well now, a visitor after all this time.", 
    ""
  `ENDNODE
      
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I'm Drujiva, druid sage from the Temple of Nature,", 
    "I act now as the speaker for the mountain."
  `ENDNODE
      
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "With each new day here, I'll stand feet firmly in the soil,", 
    "restoring the land with thorough deep breaths, until the sun sets."
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "So you are that %n hero?", 
    "How would I know that your name is. . . ? Well. . ."
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "News does not travel to our quiet mountain shrine often,", 
    "but I've read it, it's in your skin."
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "So. . . you've finally escaped the commotion of Talonovia?", 
    ""
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The one thing that council agrees on is perpetual disagreement.", 
    ""
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I'd like to ask, if I may, it's been frustrating. . . hasn't it?", 
    "To find your way?"
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Amidst all this chaos, from the aftermath of that. . . black magic tragedy,", 
    "nothing is for certain."
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "A sacred collection of golden ornaments have become spawled out,", 
    "now in the hands of evil."
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "These precious relics lie in the fallen citadels of", 
    "Rhunia, Etzland, Haxlyn, Valimor, and Kalroth."
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "No one's told who is responsible for this mess, why gatekeepers", 
    "fall from the ethereal stream, why illness spreads, or why wars begin."
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "But you'll seek them out, won't you?", 
    "I am stuck. . . tethered here, tending to the mountain shrine."
  `ENDNODE

  `NEW_NODE(INTRODUCTION, NUETRAL)
    "With all the golden ornaments collected, this world will know", 
    "nothing but peace in the restoration of good. . . our natural order."
  `ENDNODE

  setInquiry(
    "Goodnight",
    "",
    "",
    "",
    
    BEHAVIOR_GOODBYE,
    BEHAVIOR_NONE,
    BEHAVIOR_NONE,
    BEHAVIOR_NONE
  );
  
  // Greeting
  //`NEW_NODE(GREETING, NUETRAL)
  //  "Each branch of the Sister's Oak", 
  //  "forms a stem of hope."
  //`ENDNODE
  
  // Greeting
  `NEW_NODE(GREETING, NUETRAL)
    "Hello again.", 
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Fairing well I hope?", 
    ""
  `ENDNODE
  
  /**
  "I've sensed the power of the ornaments in your posession."
  "Well done."
  [Offer items][Goodbye]
  
  **/
  
  /// --------------------------------------------------------------
  
  /** 
  
  [Pause, 3 second delay] 
  
  [Music starts] 
    (0:00)
  
  [Data corruption symptoms, letters falling like the matrix]
    
  [Dialog remains locked, and blank, as music plays]
  
  [Drujiva sprite flicker]
    (0:08)
  
  [Continue dialog with a fixed pace]
    (0:16)
  
  **/
  
  
  /// --------------------------------------------------------------
  
  /**
  
  "Do you know where black magic comes from?"
  ""
  
  "It comes from bones."
  ""
  
  "Ironic how the structure of all you sick organic machines was 
  built on the desire and devastation of the all knowing void."
  
  "Black magic is in your ivory core, little ant."
  ""
    (0:32)
  
  "And I've come to rip the marrow through every living throat,"
  "one. at. a. time."
  
  "Except you of course, loyal champion."
  ""
  
  "I've had many servants under my thrall,"
  "and I have never harmed them."
  
  "The imp that scavanged my bones after my inceneration,"
  ""
  
  "The sage's son, who buried my remains here,"
  ""
  
  "They live through me, and I through them,"
  "just as the druid sage is here now."
  
  "Drujiva is not Drujiva,"
  "not anymore."
  
  "I've long since soaked this land in the charcoal of my blackened bones."
  ""
  
  "So much for the impervious spirit of the mountain."
  ""
  
  "Hope belongs to me."
  ""
    (Dominus disappears, player control resumed at goodbye option)
    [Goodbye]
  
  **/
  
  /// --------------------------------------------------------------
  
  
  /** 
  
  // Walk pace slows about 1/2 with screen shake
  
  [Credits start @ mountain shrine]
   {Bramble Gate Studios presents: Realm of the Tempest}
   {Written by Otay}
   {Designed by Otays}
   {Art by Otaykins}
   {Programmed by Otay}
   {Music by Otays}
   {}
   
  [music change to black magic @ rhunia outskirts]
  
  // Game menu scan at 8 seconds in
  // Walk pace slows to 1/8 around 20 seconds
  // text starts around 28 seconds
  
  (Rhunia should load in Greater Oblivion mode)
  (Options for lesser / greater oblivion mode should only appear from talonovia)
  
  **/
  
  
  /// --------------------------------------------------------------
  
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
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Lycanthrox_Orange_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Black_Gatekeeper
  end object
  npcSprites=NPC_Sprites
}





