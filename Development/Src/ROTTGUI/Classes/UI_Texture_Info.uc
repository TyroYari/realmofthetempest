/*=============================================================================
 * UI_Texture_Info
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Stores textures and some drawing options
 *===========================================================================*/
 
class UI_Texture_Info extends object;

// Stored texture for UI use 
var public array<texture> componentTextures;

// Selected texture index
var privatewrite int textureIndex;

// Pixel offset to start and end the UV tiling
var privatewrite vector2d subUVStart;
var privatewrite vector2d subUVEnd;

// Color to be multiplied through the whole texture
var public color drawColor;

// Vertical "Alpha Mask" Ratio
var public float vertRatio;

// Horizontal "Alpha Mask" Ratio
var public float horizontalRatio;

// Mirrors texture horizontally when true
var public bool bMirroredHorizontal;

// Flips the vertical mask direction when true
var public bool bFlipVerticalMask;

/*===========================================================================*/

`include(ROTTColorLogs.h)

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
event initializeInfo() {
  // Check for a valid texture selection
  if (componentTextures.length == 0) return;
  if (componentTextures[textureIndex] == none) return;
  
  // Check for default end points
  if (subUVEnd.X == 0.0 || subUVEnd.Y == 0.0) {
    // Assign end points from texture size
    if (Texture2D(componentTextures[textureIndex]) != none) {
      subUVEnd.X = Texture2D(componentTextures[textureIndex]).sizeX;
      subUVEnd.Y = Texture2D(componentTextures[textureIndex]).sizeY;
    } else if (TextureRenderTarget2D(componentTextures[textureIndex]) != none) {
      subUVEnd.X = TextureRenderTarget2D(componentTextures[textureIndex]).sizeX;
      subUVEnd.Y = TextureRenderTarget2D(componentTextures[textureIndex]).sizeY;
    }
  }
}

/*============================================================================= 
 * getSizeX()
 *
 * 
 *============================================================================*/
public function int getSizeX() {
  if (componentTextures.length == 0) {
    yellowLog("Warning (!) Textures are blank for " $ self);
    return 0;
  }
  return Texture2D(componentTextures[textureIndex]).sizeX;
}

/*============================================================================= 
 * getSizeY()
 *
 * 
 *============================================================================*/
public function int getSizeY() {
  if (textureIndex >= componentTextures.length) {
    yellowLog("Warning (!) No texture info for " $ self);
    return 0;
  }
  return Texture2D(componentTextures[textureIndex]).sizeY;
}

/*============================================================================= 
 * getTexture()
 *
 * 
 *============================================================================*/
public function texture getTexture() {
  if (textureIndex >= componentTextures.length) {
    yellowLog("Warning (!) No texture info for " $ self);
    return none;
  }
  return componentTextures[textureIndex];
}

/*============================================================================= 
 * selectTexture()
 *
 * Given an index, a texture is selected
 *============================================================================*/
public function selectTexture(int index) {
  // Select texture
  textureIndex = index;
  
  // Check validity of selection
  if (getTexture() == none) {
    yellowLog("Warning (!) Selected invalid texture");
  }
}

/*============================================================================= 
 * randomizeTexture()
 *
 * Randomly selects a texture
 *============================================================================*/
public function randomizeTexture() {
  selectTexture(rand(componentTextures.length));
}

/*============================================================================= 
 * randomizeOrientation()
 *
 * Randomly selects an orientation (left or right)
 *============================================================================*/
public function randomizeOrientation() {
  bMirroredHorizontal = rand(3) % 2 != 1;
}

/*============================================================================= 
 * drawTexture()
 *
 * Draws the component to the screen, necessary for every frame.
 *============================================================================*/
public function drawTexture
(
  Canvas C, 
  vector2D topLeft, 
  vector2D bottomRight, 
  color parentColor
) 
{
  local Rotator r;
  local float width;
  local float height;
  
  width = abs(bottomRight.x - topLeft.x);
  height = abs(bottomRight.y - topLeft.y);
  
  // Check for a texture to draw
  if (componentTextures.length == 0) return;
  if (componentTextures[textureIndex] == none) return;
  
  // Setup color info
  c.setDrawColorStruct(
    class'UI_Component'.static.multiplyColors(parentColor, drawColor)
  );
  
  // Modify coordinates for vertical and horizontal masking
  if (bFlipVerticalMask) {
    topLeft.Y += height * (1.0 - vertRatio);
  }
  
  // Set starting coordinates
  if (bMirroredHorizontal || bFlipVerticalMask) {
    // Start from top right
    c.setPos(topLeft.X - width, topLeft.Y);
    
    // Stretch width to draw the mirror image
    width *= 2;
  } else {
    c.setPos(topLeft.X, topLeft.Y);
  }
  
  // Modify coordinates for mirroring
  if (bMirroredHorizontal || bFlipVerticalMask) {
    // Draw texture mirrored
    r.yaw = 0;
    r.roll = 0;
    r.pitch = 65536 / 2;
    c.drawRotatedTile(
      componentTextures[textureIndex], 
      r,
        
      width * horizontalRatio, 
      height * vertRatio,
      0, /// subUVStart.X + subUVEnd.X * (1.0 - horizontalRatio)
      subUVStart.Y + subUVEnd.Y * (1.0 - vertRatio),
      2 * subUVEnd.X * (horizontalRatio), 
      subUVEnd.Y * (vertRatio),
      
      // Reflection pivot point
      0.5,
      0.5
    );
    
  } else {
    // Draw texture standard
    c.drawTile(
      componentTextures[textureIndex], 
      width * horizontalRatio, // Width
      height * vertRatio,     // Height
      subUVStart.X,                                  // x1 (Left)
      subUVStart.Y,// * (1.0 - vertRatio) + subUVEnd.Y, // y1 (Top)
      subUVEnd.X * (horizontalRatio),                // UV Stretch, Width
      subUVEnd.Y * (vertRatio)                       // UV Stretch, Height
    );
  }
}

/*=============================================================================
 * deleteInfo()
 *===========================================================================*/
event deleteInfo() {
  componentTextures.length = 0;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  drawColor=(R=255,G=255,B=255,A=255)
  
  vertRatio=1.f
  horizontalRatio=1.f
}


















