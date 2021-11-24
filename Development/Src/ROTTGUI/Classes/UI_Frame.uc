/*=============================================================================
 * UI_Frame
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class draws sprites intended to border the HUD in FIXED_SCALE mode
 *===========================================================================*/

class UI_Frame extends UI_Sprite;

// Alignment for this piece
enum FrameOrientation {
  LEFT,
  RIGHT,
  TOP,
  BOTTOM,
  
  LEFT_NO_STRETCH,
  RIGHT_NO_STRETCH,
  TOP_NO_STRETCH,
  BOTTOM_NO_STRETCH,
  
  IGNORE_ORIENTATION
};

var private FrameOrientation orientation;

/*=============================================================================
 * start()
 *
 * Called to start setting the initial variables for this component.
 *===========================================================================*/
public function start() {
  local float x1, x2, y1, y2;
  local float scaleX, scaleY;
  local float xOffset, yOffset;
  
  // Use maximum scale
  scaleX = 5;
  scaleY = 5;

  // Get window scale (commented out because were using start() not update())
  ///scaleX = (hud.sizeX / NATIVE_WIDTH);
  ///scaleY = (hud.sizeY / NATIVE_HEIGHT);

  // Calculate offset from scaled to unscaled UI
  xOffset = NATIVE_WIDTH * scaleX - NATIVE_WIDTH;
  yOffset = NATIVE_HEIGHT * scaleY - NATIVE_HEIGHT;
  
  // Overwrite stretch with absolute frame points
  switch (orientation) {
    case LEFT: 
      x1 = -xOffset / 2.f;
      y1 = -yOffset / 2.f;
      x2 = 0;
      y2 = NATIVE_HEIGHT + yOffset / 2.f;
      break;
    case TOP: 
      x1 = 0;
      y1 = -yOffset / 2.f;
      x2 = NATIVE_WIDTH;
      y2 = 0;
      break;
    case RIGHT: 
      x1 = NATIVE_WIDTH;
      y1 = -yOffset / 2.f;
      x2 = NATIVE_WIDTH + xOffset / 2.f;
      y2 = NATIVE_HEIGHT + yOffset / 2.f;
      break;
    case BOTTOM: 
      x1 = 0;
      y1 = NATIVE_HEIGHT;
      x2 = NATIVE_WIDTH;
      y2 = NATIVE_HEIGHT + yOffset / 2.f;
      break;
  }
  
  updatePosition(
    x1,
    y1,
    x2,
    y2
  );
}

/*=============================================================================
 * update()
 *
 * Called each time the engine renders a frame.
 *===========================================================================*/
public function update() {
  local float x1, x2, y1, y2;
  local float scaleX, scaleY, scaleMin;
  local float xOffset, yOffset;
  
  // Get window scale
  scaleX = hud.sizeX / NATIVE_WIDTH;
  scaleY = hud.sizeY / NATIVE_HEIGHT;

  // Use smallest scaler
  scaleMin = (scaleX < scaleY) ? scaleX : scaleY;
  
  // Calculate offset from no stretch scale
  xOffset = (scaleX - scaleMin) * NATIVE_WIDTH / 2;
  yOffset = (scaley - scaleMin) * NATIVE_HEIGHT / 2;
  
  // Overwrite stretch with absolute frame points
  switch (orientation) {
    case LEFT_NO_STRETCH: 
      x1 = -xOffset / 2.f;
      y1 = -yOffset / 2.f;
      x2 = 0;
      y2 = NATIVE_HEIGHT + yOffset / 2.f;
      break;
    case TOP_NO_STRETCH: 
      x1 = 0;
      y1 = -yOffset / 2.f;
      x2 = NATIVE_WIDTH;
      y2 = 0;
      break;
    case RIGHT_NO_STRETCH: 
      x1 = 0;
      y1 = -yOffset / 2.f;
      x2 = NATIVE_WIDTH + xOffset / 2.f;
      y2 = NATIVE_HEIGHT + yOffset / 2.f;
      break;
    case BOTTOM_NO_STRETCH: 
      x1 = 0;
      y1 = 0;
      x2 = NATIVE_WIDTH;
      y2 = NATIVE_HEIGHT + yOffset / 2.f;
      break;
    default: 
      return;
  }
  
  updatePosition(
    x1,
    y1,
    x2,
    y2
  );
}

/*============================================================================= 
 * drawComponent
 *
 * Draws the component to the screen, every frame.
 *============================================================================*/
///protected function drawComponent(Canvas c) {
///  // Check if component is enabled
///  if (!bEnabled) return;
///  if (uiGameInfo.optionsCookie.scaleModeType == STRETCH_SCALE) return;
///  
///  // Check for out of bounds draw index
///  if (drawIndex >= images.length) return;
///  if (images[drawIndex] == none) return;
///  
///  // Draw sprite to screen
///  c.setClip(c.sizeX, c.sizeY);
///  images[drawIndex].drawTexture(c, getStartPosition(), getEndPosition(), getColor());
///}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  
}









