/*=============================================================================
 * ROTT_UI_Scene_Npc_Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene is displayed when the player talks to an NPC.
 *===========================================================================*/

class ROTT_UI_Scene_Npc_Dialog extends ROTT_UI_Scene;

// NPC interface
var privatewrite ROTT_UI_Page_NPC_Dialogue npcDialoguePage;
var privatewrite ROTT_UI_Page_Naming_Interface namingPage;

// Transitions
var privatewrite ROTT_UI_Page_Control_Sheet controlSheet;


/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  // NPC interface
  npcDialoguePage = ROTT_UI_Page_NPC_Dialogue(findComp("Page_NPC_Dialogue"));
  namingPage = ROTT_UI_Page_Naming_Interface(findComp("Page_Naming_Interface"));
  
  // Player's guide to Game Controller
  controlSheet = ROTT_UI_Page_Control_Sheet(findComp("Page_Control_Sheet"));
  
  super.initScene();
  
  // Initial display
  pushPage(npcDialoguePage);
}

/*=============================================================================
 * loadScene()
 *
 * Called when switching to this scene
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  // Execute transition opening NPC screen
  gameInfo.sceneManager.transitioner.setTransition(
    TRANSITION_IN,                               // Transition direction
    DOOR_PORTAL_TRANSITION_OUT,                  // Sorting config
    true,                                        // Pattern reversal
    ,                                            // Destination scene
    ,                                            // Destination page
    ,                                            // Destination world
    ,                                            // Color
    8,                                           // Tile speed
    0.f,                                         // Delay
    false,
    "Page_Transition_In"
  );
}

/*=============================================================================
 * unloadScene()
 * 
 * Called when this scene will no longer be rendered
 *===========================================================================*/
event unloadScene() {
  super.unloadScene();
}

/*=============================================================================
 * openNPCDialog()
 * 
 * Opens npc screen with the given NPC
 *===========================================================================*/
public function openNPCDialog(class<ROTT_NPC_Container> npcType) {
  npcDialoguePage.launchNPC(npcType);
  
}

/*=============================================================================
 * openNamingInterface()
 * 
 * Opens the naming page, letting the player input a profile name
 *===========================================================================*/
public function openNamingInterface() {
  pushPage(namingPage);
}

/*=============================================================================
 * combatTransition()
 * 
 * This pushes an effect to transition into combat
 *===========================================================================*/
public function combatTransition() {
  // Execute transition to combat
  gameInfo.sceneManager.transitioner.setTransition(
    TRANSITION_OUT,                              // Transition direction
    DOOR_PORTAL_TRANSITION_OUT,                  // Sorting config
    ,                                            // Pattern reversal
    SCENE_COMBAT_ENCOUNTER,                      // Destination scene
    ,                                            // Destination page
    ,                                            // Destination world
    ,                                            // Color
    10,                                          // Tile speed
    0.4f,                                        // Delay
    true,
    "Page_Combat_Transition"
  );
}

/*=============================================================================
 * deleteScene()
 *
 * Deletes scene references for garbage collection
 *===========================================================================*/
public function deleteScene() {
  super.deleteScene();
  
  npcDialoguePage = none;
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties 
{
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  // NPC Dialogue Page
  begin object class=ROTT_UI_Page_NPC_Dialogue Name=Page_NPC_Dialogue
    tag="Page_NPC_Dialogue"
    bEnabled=true
  end object
  pageComponents.add(Page_NPC_Dialogue)

  // Naming Interface Page
  begin object class=ROTT_UI_Page_Naming_Interface Name=Page_Naming_Interface
    tag="Page_Naming_Interface"
    bEnabled=true
  end object
  pageComponents.add(Page_Naming_Interface)

  // Control Sheet
  begin object class=ROTT_UI_Page_Control_Sheet Name=Page_Control_Sheet
    tag="Page_Control_Sheet"
    bEnabled=false
  end object
  pageComponents.add(Page_Control_Sheet)
  
}










