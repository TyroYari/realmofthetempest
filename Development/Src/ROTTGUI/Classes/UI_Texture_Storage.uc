/*=============================================================================
 * UI_Texture_Storage
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class holds textures for UI_Sprite to access.
 *===========================================================================*/

class UI_Texture_Storage extends UI_Component;

// Sprite Textures 
var protectedwrite instanced array<UI_Texture_Info> images;

// The dimensions of the sprites in this container
var protectedwrite int textureWidth;
var protectedwrite int textureHeight;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *============================================================================*/
public function initializeComponent(optional string newTag = "") {
  local UI_Texture_Info curInfo;
  
  // Initialize textures
  foreach images(curInfo) {
    if (curInfo != none) {
      curInfo.initializeInfo();
    }
  }
  
  // This is never "enabled"
  setEnabled(false);
}

/**=============================================================================
 * getTextures()
 *
 * Retrieves all images textures from components of this object
 *===========================================================================*/
///public function array<UI_Texture_Info> getTextures() {
///  return append(images, super.getTextures());
///}

/*=============================================================================
 * moveIndexToZero()
 *
 * 
 *===========================================================================*/
public function moveIndexToZero(byte copyIndex) {
  images[0] = images[copyIndex];
}

/*=============================================================================
 * resetDrawInfo()
 *
 * 
 *===========================================================================*/
public function resetDrawInfo() {
  images.length = 0;
}

/*=============================================================================
 * addTexture()
 *
 * 
 *===========================================================================*/
public function addTexture
(
  UI_Texture_Info newTexture, 
  optional int index = images.length
) 
{
  images[index] = newTexture;
  initializeComponent();
}

/*=============================================================================
 * debugHierarchy()
 *
 * Shows the hierarchy as a tree, tabbed in console.
 *===========================================================================*/
public function debugHierarchy(int tabLength, bool bEnabledParent) {
  
}

defaultProperties
{

}









