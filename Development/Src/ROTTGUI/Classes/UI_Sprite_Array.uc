/*=============================================================================
 * UI_Sprite_Array
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class contains textures like UI_Sprite, but also offers the ability 
 * to override coordinates for each sprite 
 *===========================================================================*/

class UI_Sprite_Array extends UI_Sprite;

// Sprite coordinates
struct Coordinates2D {
  var int index;  // Index for corresponding images
  var int posX;
  var int posY;
  var int posXEnd;
  var int posYEnd;
};

// Coordinates provided by the programmer
var protectedwrite editinline instanced array<Coordinates2D> overrideCoords;

// Coordinates saved internally
var protectedwrite editinline instanced array<Coordinates2D> savedCoords;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *============================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  if (images.length == 0) return;
  
  savedCoords.length = images.length;
  
  // Initialize savedCoords to match base coordinates
  for (i = 0; i < savedCoords.Length; i++) {
    savedCoords[i].posX = getX();
    savedCoords[i].posY = getY();
    savedCoords[i].posXEnd = getXEnd();
    savedCoords[i].posYEnd = getYEnd();
  }
  
  // Initialize overrideCoords
  for (i = 0; i < overrideCoords.Length; i++) {
    // Calculate end coordinates
    overrideCoords[i].posXEnd = overrideCoords[i].posX;
    overrideCoords[i].posXEnd += images[overrideCoords[i].index].getSizeX();
    overrideCoords[i].posYEnd = overrideCoords[i].posY;
    overrideCoords[i].posYEnd += images[overrideCoords[i].index].getSizeY();
    
    // Override saved default savedCoords
    savedCoords[overrideCoords[i].index] = overrideCoords[i];
  }
  
  // Default end coordinates
  updatePosition(
    ,
    ,
    getX() + images[overrideCoords[drawIndex].index].getSizeX(),
    getY() + images[overrideCoords[drawIndex].index].getSizeY()
  );
  
  // Set initial coordinates for given drawIndex
  setSpriteIndex(drawIndex);
  
}

/*============================================================================= 
 * setDrawIndex()
 *
 * Sets a new index for which sprite to draw to the screen
 *============================================================================*/
public function bool setDrawIndex(byte index) {
  if (images.length == 0) return false;
  
  super.setDrawIndex(index);
  
  setSpriteIndex(index);
  return true; /// ?
}

/*============================================================================= 
 * setSpriteIndex()
 *
 * Sets a new index for which sprite to draw to the screen
 *============================================================================*/
public function setSpriteIndex(byte newSpriteIndex) {
  local Coordinates2D coords;
  
  // Assign new index
  drawIndex = newSpriteIndex;
  
  // Look for coordinate overrides
  foreach overrideCoords(coords) {
    if (coords.index == drawIndex) {
      updatePosition(
        coords.posX,
        coords.posY,
        coords.posXEnd,
        coords.posYEnd
      );
      return;
    }
  }
  
  // Assign default coordinates if no override coordinates were found
  updatePosition(
    savedCoords[drawIndex].posX,
    savedCoords[drawIndex].posY,
    savedCoords[drawIndex].posXEnd,
    savedCoords[drawIndex].posYEnd
  );
}

/*============================================================================= 
 * debugSavedCoords()
 *
 * Dumps all coordinate info for debug purposes
 *============================================================================*/
public function debugSavedCoords() {
  local int i;
  
  for (i = 0; i < savedCoords.Length; i++) {
    cyanlog("savedCoords " @i);
    cyanlog("posX: " @savedCoords[i].posX);
    cyanlog("posY: " @savedCoords[i].posY);
    cyanlog("posXEnd: " @savedCoords[i].posXEnd);
    cyanlog("posYEnd: " @savedCoords[i].posYEnd);
  }
}

defaultProperties
{
  
}









