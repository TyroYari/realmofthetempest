/*=============================================================================
 * ROTT_UI_Screen_Frame
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This draws a frame around the screen when the HUD is set to
 * "No_scale" mode.
 *===========================================================================*/

class ROTT_UI_Screen_Frame extends UI_Container;

/*=============================================================================
 * isVisible()
 *
 * Returns true if this component should be drawn
 *===========================================================================*/
protected function bool isVisible() { 
  return super.isVisible() && hud.scaleMode != STRETCH_SCALE;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Scene border
  begin object class=UI_Texture_Info Name=Frame_Border_Color_Gray
    componentTextures.add(Texture2D'GUI.Frame_Border_Color_Gray')
  end object
  begin object class=UI_Texture_Info Name=Frame_Fill_Color_Dark_Gray
    componentTextures.add(Texture2D'GUI.Frame_Fill_Color_Dark_Gray')
  end object
  
  /** ===== Fixed Scale Frame ===== **/
  // Border fill (Left)
  begin object class=UI_Frame Name=Border_Sprite_Fill_Left
    tag="Border_Sprite_Fill_Left"
    orientation=LEFT
    posX=0
    posY=0
    posYEnd=NATIVE_HEIGHT
    images(0)=Frame_Fill_Color_Dark_Gray
  end object
  componentList.add(Border_Sprite_Fill_Left)
  
  // Border fill (Right)
  begin object class=UI_Frame Name=Border_Sprite_Fill_Right
    tag="Border_Sprite_Fill_Right"
    orientation=RIGHT
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Frame_Fill_Color_Dark_Gray
  end object
  componentList.add(Border_Sprite_Fill_Right)
  
  // Border fill (Top)
  begin object class=UI_Frame Name=Border_Sprite_Fill_Top
    tag="Border_Sprite_Fill_Top"
    orientation=TOP
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    images(0)=Frame_Fill_Color_Dark_Gray
  end object
  componentList.add(Border_Sprite_Fill_Top)
  
  // Border fill (Bottom)
  begin object class=UI_Frame Name=Border_Sprite_Fill_Bottom
    tag="Border_Sprite_Fill_Bottom"
    orientation=BOTTOM
    posX=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Frame_Fill_Color_Dark_Gray
  end object
  componentList.add(Border_Sprite_Fill_Bottom)
  
  /** ===== No Stretch Frame ===== **/
  // Border fill (Left)
  begin object class=UI_Frame Name=Border_Sprite_No_Stretch_Left
    tag="Border_Sprite_No_Stretch_Left"
    orientation=LEFT_NO_STRETCH
    posX=0
    posY=0
    posYEnd=NATIVE_HEIGHT
    images(0)=Frame_Fill_Color_Dark_Gray
  end object
  componentList.add(Border_Sprite_No_Stretch_Left)
  
  // Border fill (Right)
  begin object class=UI_Frame Name=Border_Sprite_No_Stretch_Right
    tag="Border_Sprite_No_Stretch_Right"
    orientation=RIGHT
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Frame_Fill_Color_Dark_Gray
  end object
  componentList.add(Border_Sprite_No_Stretch_Right)
  
  // Border fill (Top)
  begin object class=UI_Frame Name=Border_Sprite_No_Stretch_Top
    tag="Border_Sprite_No_Stretch_Top"
    orientation=TOP
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    images(0)=Frame_Fill_Color_Dark_Gray
  end object
  componentList.add(Border_Sprite_No_Stretch_Top)
  
  // Border fill (Bottom)
  begin object class=UI_Frame Name=Border_Sprite_No_Stretch_Bottom
    tag="Border_Sprite_No_Stretch_Bottom"
    orientation=BOTTOM
    posX=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Frame_Fill_Color_Dark_Gray
  end object
  componentList.add(Border_Sprite_No_Stretch_Bottom)
  
  /** ===== Frame Outline ===== **/
  // Border outline (Left)
  begin object class=UI_Sprite Name=Border_Sprite_Outline_Left
    tag="Border_Sprite_Outline_Left"
    posX=-8
    posY=-8
    posXEnd=0
    posYEnd=908
    images(0)=Frame_Border_Color_Gray
  end object
  componentList.add(Border_Sprite_Outline_Left)
  
  // Border outline (Right)
  begin object class=UI_Sprite Name=Border_Sprite_Outline_Right
    tag="Border_Sprite_Outline_Right"
    posX=NATIVE_WIDTH
    posY=-8
    posXEnd=1448
    posYEnd=908
    images(0)=Frame_Border_Color_Gray
  end object
  componentList.add(Border_Sprite_Outline_Right)
  
  // Border outline (Top)
  begin object class=UI_Sprite Name=Border_Sprite_Outline_Top
    tag="Border_Sprite_Outline_Top"
    posX=0
    posY=-8
    posXEnd=NATIVE_WIDTH
    posYEnd=0
    images(0)=Frame_Border_Color_Gray
  end object
  componentList.add(Border_Sprite_Outline_Top)
  
  // Border outline (Bottom)
  begin object class=UI_Sprite Name=Border_Sprite_Outline_Bottom
    tag="Border_Sprite_Outline_Bottom"
    posX=0
    posY=NATIVE_HEIGHT
    posXEnd=NATIVE_WIDTH
    posYEnd=908
    images(0)=Frame_Border_Color_Gray
  end object
  componentList.add(Border_Sprite_Outline_Bottom)
  
}











