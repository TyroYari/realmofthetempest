/*=============================================================================
 * ROTT_UI_Displayer_Skill_Preview
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displayer takes a skill descriptor and previews some of
 * the info.
 *===========================================================================*/
 
class ROTT_UI_Displayer_Skill_Preview extends UI_Container;

// Number of lines of text in this window
const LINE_COUNT = 9;

// Internal references
var private UI_Label descriptionLabels[LINE_COUNT];

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // Internal references
  for (i = 0; i < LINE_COUNT; i++) {
    descriptionLabels[i] = findLabel("Mgmt_Window_Label_" $ i);
  }
}

/*============================================================================= 
 * setDescriptor()
 *
 * This parses a descriptor to update the text displayed in this window
 *===========================================================================*/
public function setDescriptor(ROTT_Descriptor descriptor) {
  local int i;
  if (descriptor == none) {
    yellowLog("Warning (!) A descriptor still needs to be implemented.");
    return;
  }
  
  // Copy display information to the label components from the descriptor
  for (i = 0; i < LINE_COUNT; i++) {
    descriptionLabels[i].setText(descriptor.displayInfo[i].labelText);
    descriptionLabels[i].setFont(descriptor.displayInfo[i].labelFont);
  }
}

/*============================================================================= 
 * clearDescriptor()
 *
 * This clears the skill preview info
 *===========================================================================*/
public function clearDescriptor() {
  local int i;
  
  // Clear all
  for (i = 0; i < LINE_COUNT; i++) {
    descriptionLabels[i].setText("");
  }
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  /** ===== UI Components ===== **/
  // Mgmt Window - Title Label
  begin object class=UI_Label Name=Mgmt_Window_Label_0
    tag="Mgmt_Window_Label_0"
    posX=0
    posY=512
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_0)
  
  // Mgmt Window - Header 2
  begin object class=UI_Label Name=Mgmt_Window_Label_1
    tag="Mgmt_Window_Label_1"
    posX=0
    posY=551
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_1)
  
  // Paragraph 1, line 1
  begin object class=UI_Label Name=Mgmt_Window_Label_2
    tag="Mgmt_Window_Label_2"
    posX=0
    posY=589
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_2)
  
  // Paragraph 1, line 2
  begin object class=UI_Label Name=Mgmt_Window_Label_3
    tag="Mgmt_Window_Label_3"
    posX=0
    posY=616
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_3)
  
  // Paragraph 1, line 3
  begin object class=UI_Label Name=Mgmt_Window_Label_4
    tag="Mgmt_Window_Label_4"
    posX=0
    posY=643
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_4)
  
  // Paragraph 2 header
  begin object class=UI_Label Name=Mgmt_Window_Label_5
    tag="Mgmt_Window_Label_5"
    posX=0
    posY=697
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_5)
  
  // Paragraph 2, line 1
  begin object class=UI_Label Name=Mgmt_Window_Label_6
    tag="Mgmt_Window_Label_6"
    posX=0
    posY=724
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_6)
  
  // Paragraph 2, line 2
  begin object class=UI_Label Name=Mgmt_Window_Label_7
    tag="Mgmt_Window_Label_7"
    posX=0
    posY=751
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_7)
  
  // Paragraph 2, line 3
  begin object class=UI_Label Name=Mgmt_Window_Label_8
    tag="Mgmt_Window_Label_8"
    posX=0
    posY=778
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_8)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  