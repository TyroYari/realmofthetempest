/*=============================================================================
 * UI_Scene
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A scene is collection of UI components that is never drawn
 * simultaneously with other scenes.
 *===========================================================================*/

class UI_Scene extends object;

// Stores a list of references to cull sources for unculling purposes
var public array<UI_Component> cullReferences;

// Hide cursor setting
var protectedwrite bool bHideCursorOverride;

// References to selected components
var protectedwrite array<object> selectedObjects;

// Components with these tags will be hidden 
///var privatewrite array<string> culledTags;

// Include colored debug logs
`include(ROTTColorLogs.h)

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  
}

/*=============================================================================
 * loadScene()
 *
 * Called when switching to this scene
 *===========================================================================*/
event loadScene() {  

}

/*=============================================================================
 * drawScene()
 *
 * Called each frame to draw the scene
 *===========================================================================*/
public function drawScene(Canvas canvas);

/*=============================================================================
 * pushPageByTag()
 *
 * Finds a page, and pushes it to the stack
 *===========================================================================*/
public function pushPageByTag(string pageTag, optional bool bFocused = true) {
  
}

/*=============================================================================
 * pushPage()
 *
 * Adds an element to the top of the stack
 *===========================================================================*/
public function pushPage
(
  UI_Page pageComponent,
  optional bool bFocusMenu = true
) 
{
  
}

/*=============================================================================
 * popPage()
 *
 * Removes the top element from the stack (LIFO)
 *===========================================================================*/
public function popPage(optional string tag = "") {
  
}

/*=============================================================================
 * isMouseVisible()
 *
 * True if the mouse should be shown
 *===========================================================================*/
public function bool isMouseVisible() { 
  // Implemented where pagestack is available
}

/*=============================================================================
 * isCulled()
 *
 * True if the given tag is being hidden by a page above it
 *===========================================================================*/
/// public function bool isCulled(string targetTag) {
///   local int i;
///   
///   for (i = 0; i < culledTags.length; i++) {
///     if (culledTags[i] == targetTag) return true;
///   }
///   
///   return false;
/// }

/*=============================================================================
 * cullTag()
 *
 * Prevents the given tag from being drawn
 *===========================================================================*/
/// public function cullTag(string targetTag) {
///   culledTags.addItem(targetTag);
/// }
/// 
/// /*=============================================================================
///  * uncullTag()
///  *
///  * Removes a cull for the given tag.  (There may be more than one cull)
///  *===========================================================================*/
/// public function uncullTag(string targetTag) {
///   local int i;
///   
///   // Iterate through culled tag list
///   for (i = 0; i < culledTags.length; i++) {
///     if (culledTags[i] == targetTag) {
///       // Remove a cull
///       culledTags.remove(i, 1);
///       
///       // Do not remove multiple culls
///       return;
///     }
///   }
/// }


// algorithm outline
///# STORE ALL SELECTIONS IN SCENE
///# ALSO STORE SELECTIONS IN SCENE MANAGER
///# LOOK UP SELECTION IN SCENE, IF NOT FOUND THEN LOOK IN SCENE MANAGER
/*=============================================================================
 * findSelectedObject()
 *
 * This scans for a selected object of the given object class, and returns it.
 *===========================================================================*/
public function object findSelectedObject(class<object> searchType) {
  local int i;
  
  `log("Finding: " $ searchType);
  
  for (i = 0; i < selectedObjects.length; i++) {
    if (selectedObjects[i].class == searchType) return selectedObjects[i];
  }
}

/*=============================================================================
 * removeObjectSelection()
 *
 * Unmarks a component as selected in the scene. Returns true if successful.
 *===========================================================================*/
public function bool removeObjectSelection(class<object> searchType) {
  local int i;
  
  for (i = 0; i < selectedObjects.length; i++) {
    if (selectedObjects[i].class == searchType) {
      // Remove selected object
      selectedObjects.remove(i, 1);
      return true;
    }
  }
  return false;
}

/*=============================================================================
 * selectObject()
 *
 * Marks a component as selected in the scene.  Return value used for sound.
 *===========================================================================*/
final public function bool selectObject(object target) {
  // Check if selection exists
  if (target == none) return false;
  
  /// Check if already selected?
  //if (selectedObjects.length > 0) {
  //  if (target == selectedObjects[0]) {
  //    scriptTrace();
  //    return false;
  //  }
  //}
  
  // Remove selection to preserve single selection invariant
  //removeObjectSelection(target.class);
  selectedObjects.length = 0;
  
  `log("Selecting: " $ target.class);
  
  // Add target as new selection
  selectedObjects.addItem(target);
  
  // Call event for selection
  onSelectObject(target);
  
  return true;
}

/*=============================================================================
 * onSelectObject()
 *
 * Called after a new selection has been made.
 *===========================================================================*/
protected function onSelectObject(object selectedObject);

/*=============================================================================
 * Process an input key event routed through unrealscript from another object. 
 * This method is assigned as the value for the OnRecievedNativeInputKey
 * delegate so that native input events are routed to this unrealscript function.
 *
 * @param   ControllerId    the controller that generated this input key event
 * @param   Key             the name of the key which an event occured for (KEY_Up, KEY_Down, etc.)
 * @param   EventType       the type of event which occured (pressed, released, etc.)
 * @param   AmountDepressed for analog keys, the depression percent.
 *
 * @return  true to consume the key event, false to pass it on.
 *===========================================================================*/
public function bool onInputKey
(
  int ControllerId, 
  name inputName, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
)
{
  return true; // temporary
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Never show cursor if true
  bHideCursorOverride=false
}





















