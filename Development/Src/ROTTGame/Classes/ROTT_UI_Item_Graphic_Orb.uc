/*=============================================================================
 * ROTT_UI_Item_Graphic_Orb
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 *  
 *===========================================================================*/
 
class ROTT_UI_Item_Graphic_Orb extends UI_Container;

var private UI_Sprite orbOverlayGraphic;
var private UI_Sprite orbSphereGraphic;
var private UI_Sprite orbAuraGraphic;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  // Get sprite references
  orbOverlayGraphic = findSprite("Orb_Overlay_Graphic");
  orbSphereGraphic = findSprite("Orb_Sphere_Graphic");
  orbAuraGraphic = findSprite("Orb_Aura_Graphic");
  
  // Adjust start coordinates
  orbOverlayGraphic.updatePosition(getX(), getY());
  orbSphereGraphic.updatePosition(getX(), getY());
  orbAuraGraphic.updatePosition(getX(), getY());
  
  super.initializeComponent(newTag);
}

/*=============================================================================
 * renderItem()
 *
 * This renders an orb graphic to the inventory UI.
 *===========================================================================
public function renderItem(optional ROTT_Inventory_Item item = none) {
  local UI_Component comp;
  if (item == none) {
    // Draw empty slot
    foreach componentList(comp) { 
      comp.setEnabled(false);
    }
  } else {
    // Draw orb graphics
    foreach componentList(comp) { 
      comp.setEnabled(true);
    }
    orbOverlayGraphic.setDrawIndex(item.overlayIndex);
    orbSphereGraphic.setDrawIndex(item.auraIndex);
    orbAuraGraphic.images[0].drawColor = item.orbColor;
  }
}
*/
/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{  
  /** ===== Textures ===== **/
  // Orb Sphere
  begin object class=UI_Texture_Info Name=Orb_Sphere_Texture
    componentTextures.add(Texture2D'GUI_Orbs.Orb')
  end object
  
  // Orb Auras
  begin object class=UI_Texture_Info Name=Orb_Aura_1
    componentTextures.add(Texture2D'GUI_Orbs.Orb_Aura_1')
  end object
  begin object class=UI_Texture_Info Name=Orb_Aura_2
    componentTextures.add(Texture2D'GUI_Orbs.Orb_Aura_2')
  end object
  begin object class=UI_Texture_Info Name=Orb_Aura_3
    componentTextures.add(Texture2D'GUI_Orbs.Orb_Aura_3')
  end object
  begin object class=UI_Texture_Info Name=Orb_Aura_4
    componentTextures.add(Texture2D'GUI_Orbs.Orb_Aura_4')
  end object
  begin object class=UI_Texture_Info Name=Orb_Aura_5
    componentTextures.add(Texture2D'GUI_Orbs.Orb_Aura_5')
  end object
  begin object class=UI_Texture_Info Name=Orb_Aura_6
    componentTextures.add(Texture2D'GUI_Orbs.Orb_Aura_6')
  end object
  begin object class=UI_Texture_Info Name=Orb_Aura_7
    componentTextures.add(Texture2D'GUI_Orbs.Orb_Aura_7')
  end object
  
  // Orb Overlays
  begin object class=UI_Texture_Info Name=Orb_Overlay_1
    componentTextures.add(Texture2D'GUI_Orbs.Orb_Overlay_1')
  end object
  begin object class=UI_Texture_Info Name=Orb_Overlay_2
    componentTextures.add(Texture2D'GUI_Orbs.Orb_Overlay_2')
  end object
  
  /** ===== GUI Components ===== **/
  // Orb Aura
  begin object class=UI_Sprite Name=Orb_Aura_Graphic
    tag="Orb_Aura_Graphic"
    images(0)=Orb_Aura_1
    images(1)=Orb_Aura_1
    images(2)=Orb_Aura_2
    images(3)=Orb_Aura_3
    images(4)=Orb_Aura_4
    images(5)=Orb_Aura_5
    images(6)=Orb_Aura_6
    images(7)=Orb_Aura_7
  end object
  componentList.add(Orb_Aura_Graphic)
  
  // Orb Sphere
  begin object class=UI_Sprite Name=Orb_Sphere_Graphic
    tag="Orb_Sphere_Graphic"
    images(0)=Orb_Sphere_Texture
  end object
  componentList.add(Orb_Sphere_Graphic)
  
  // Orb Overlay
  begin object class=UI_Sprite Name=Orb_Overlay_Graphic
    tag="Orb_Overlay_Graphic"
    images(0)=Orb_Overlay_1
    images(1)=Orb_Overlay_1
    images(2)=Orb_Overlay_2
  end object
  componentList.add(Orb_Overlay_Graphic)
  
}