/*=============================================================================
 * UI_Scene_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *  A scene is an independent collection of menus. 
 *  Only one scene can be rendered at a time.
 *  The scene manager is the interface for selecting which scene to render.
 *  + We also must be able to access information from any scene at any time?
 *===========================================================================*/

class UI_Scene_Manager extends object;

// The scene currently being rendered
var protectedwrite UI_Scene currentScene;

// Include colored debug logs
`include(ROTTColorLogs.h)

/*=============================================================================
 * initSceneManager()
 *===========================================================================*/
event initSceneManager() {
  
}

/*=============================================================================
 * renderScene()
 *===========================================================================*/
event renderScene(Canvas C) {
  
}

/*=============================================================================
 * setInitScene()
 *===========================================================================*/
public function setInitScene() {
  
}

/*=============================================================================
 * deleteSceneManager()
 *===========================================================================*/
public function deleteSceneManager() {
  
}

/*=============================================================================
 * getCursorType()
 *
 * Returns the type of icon the mouse should have for whatever component it
 * may be hovering over.
 *===========================================================================*/
public function byte getCursorType() {
  return 0;
}

defaultProperties
{

}





















