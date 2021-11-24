/*=============================================================================
 * NPC - Haxlyn Backlands (A)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A Backlands NPC in Haxlyn.
 *===========================================================================*/

class ROTT_NPC_Haxlyn_Backlands_A extends ROTT_NPC_Container;

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
  `NEW_NODE(GREETING, NUETRAL)
    "whY aRe cycle. . . EaT FOe OR. . . PaD EaTTAM ROoFY ROTS?",
    "DEZIROT CEiVe?"
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "SNOw IS REar ViNk ICey IHPRO MOSILARU TAN. . .",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "ST(F,N)=<e1, e2, e3, ... eN>",
    "kEy MAx, taNk REm HaS IT hI?"
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "FaME Tie SYS ShULUC LACAD Be MALaChI Hi PaiRO. . . MY LOPe?",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Hi TURThuR ALUC ID NEar PREPEt TARGET NIght",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "GaNI giNO My MUSiNO sIThA NETACa NOCLARO PMET",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "STair NIght cASEs HiT FOrm Y GOaL nO PhOTo. . .",
    "shE HiT it here."
  `ENDNODE
  
  
  // ----------------------------------------------------------------------- //
  
  setInquiry(
    "What?",
    "Goodnight",
    "",
    "",
    
    BEHAVIOR_GOODBYE,
    BEHAVIOR_GOODBYE,
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
  begin object class=UI_Texture_Info Name=NPC_Background_Texture
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Gray'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Sprite_Texture
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Emissary_Black_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Sprite_Texture
  end object
  npcSprites=NPC_Sprites
}












