/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Blank
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This management window allows player to allocate unspent stat 
 * points 
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Blank extends ROTT_UI_Page_Mgmt_Window;

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA();

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Number of menu options
  selectOptionsCount=0
  
  /** ===== Textures ===== **/
  // Mgmt
  ///begin object class=UI_Texture_Info Name=Mgmt_Window_Default
  ///  componentTextures.add(Texture2D'GUI.Mgmt_Window_Default')
  ///end object
  
  /** ===== UI Components ===== **/
  // Window backgrounds
  ///begin object class=UI_Texture_Storage Name=Menu_Portraits
  ///  tag="Background_Container"
  ///  images(0)=Mgmt_Window_Default
  ///  textureWidth=720
  ///  textureHeight=900
  ///end object
  ///componentList.add(Menu_Portraits)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  