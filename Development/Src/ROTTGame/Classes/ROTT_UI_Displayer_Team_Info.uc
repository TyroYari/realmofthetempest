/*=============================================================================
 * ROTT_UI_Displayer_Team_Info
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displays team info, like spiritual / hunting / botanical 
 * prowess
 *===========================================================================*/

class ROTT_UI_Displayer_Team_Info extends ROTT_UI_Displayer;

// Internal references
var privatewrite UI_Label header;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  header = findLabel("Team_Viewer_Header_1");
}

/*=============================================================================
 * validAttachment()
 *
 * Called to check if the displayer attachment is valid. Returns true if it is.
 *===========================================================================*/
protected function bool validAttachment() {
  // This displayer requires a team attachment
  return (party != none);
}

/*=============================================================================
 * updateDisplay()
 *
 * This updates the UI with the info of the attached combat unit.  
 * Returns true when there actually exists a unit to display, false otherwise.
 *===========================================================================*/
public function bool updateDisplay() {
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Update   
  header.setText("Team #" $ party.partyIndex + 1);
  
  // Prowess values
  findLabel("Team_Viewer_Spiritual_Prowess_Value").setText(party.getSpiritualProwess());
  findLabel("Team_Viewer_Hunting_Prowess_Value").setText(party.getHuntingProwess());
  findLabel("Team_Viewer_Botanical_Prowess_Value").setText(party.getBotanicalProwess());
  
  // Prowess values
  findLabel("Team_Viewer_Header_2").setText(party.getTeamHeader());
  
  // Successfully drew hero information
  return true;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Container draw settings
  bDrawRelative=true
  
  // Header 1
  begin object class=UI_Label Name=Team_Viewer_Header_1
    tag="Team_Viewer_Header_1"
    posX=720
    posY=112
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_LARGE_TAN
    AlignX=CENTER
    AlignY=TOP
    labelText="Team #X"
  end object
  componentList.add(Team_Viewer_Header_1)
  
  // Header 2
  begin object class=UI_Label Name=Team_Viewer_Header_2
    tag="Team_Viewer_Header_2"
    posX=720
    posY=151
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Of land and sky"
    fontStyle=DEFAULT_SMALL_GRAY
    /*
      "Of land and sky"
      "Of the blossom beneath the sea"
      "From the land of waves and flames"
      "From the howling coast"
      "Of the lunar lotus on the gnarled root"
      
      "From the land of ribbon skies"
      
      "Walkers of the nightlands"
      "From the land of scarlet song"
      "From the plane of twisted starlight"
      "Dancers of sky and storm"
      "From the land of quiet thunder"
      "From the river of whispers"
      "From the ocean of dream"
      "From the land buried in roots"
      "From the silver coast beyond"
      
      "Of the stormlands in the snow"
    */
  end object
  componentList.add(Team_Viewer_Header_2)
  
  // Prowess labels: Spiritual
  begin object class=UI_Label Name=Team_Viewer_Spiritual_Prowess_Label1
    tag="Team_Viewer_Spiritual_Prowess_Label1"
    posX=790
    posY=243
    fontStyle=DEFAULT_SMALL_CYAN
    posXEnd=983
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Spiritual"
  end object
  componentList.add(Team_Viewer_Spiritual_Prowess_Label1)
  begin object class=UI_Label Name=Team_Viewer_Spiritual_Prowess_Label2
    tag="Team_Viewer_Spiritual_Prowess_Label2"
    posX=790
    posY=270
    fontStyle=DEFAULT_SMALL_DARK_CYAN
    posXEnd=983
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Prowess"
  end object
  componentList.add(Team_Viewer_Spiritual_Prowess_Label2)
  
  // Prowess labels: Hunting
  begin object class=UI_Label Name=Team_Viewer_Hunting_Prowess_Label1
    tag="Team_Viewer_Hunting_Prowess_Label1"
    posX=983
    posY=243
    fontStyle=DEFAULT_SMALL_ORANGE
    posXEnd=1176
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Hunting"
  end object
  componentList.add(Team_Viewer_Hunting_Prowess_Label1)
  begin object class=UI_Label Name=Team_Viewer_Hunting_Prowess_Label2
    tag="Team_Viewer_Hunting_Prowess_Label2"
    posX=983
    posY=270
    fontStyle=DEFAULT_SMALL_DARK_ORANGE
    posXEnd=1176
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Prowess"
  end object
  componentList.add(Team_Viewer_Hunting_Prowess_Label2)
  
  // Prowess labels: Botanical
  begin object class=UI_Label Name=Team_Viewer_Botanical_Prowess_Label1
    tag="Team_Viewer_Botanical_Prowess_Label1"
    posX=1176
    posY=243
    fontStyle=DEFAULT_SMALL_GREEN
    posXEnd=1370
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Botanical"
  end object
  componentList.add(Team_Viewer_Botanical_Prowess_Label1)
  begin object class=UI_Label Name=Team_Viewer_Botanical_Prowess_Label2
    tag="Team_Viewer_Botanical_Prowess_Label2"
    posX=1176
    posY=270
    fontStyle=DEFAULT_SMALL_DARK_GREEN
    posXEnd=1370
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Prowess"
  end object
  componentList.add(Team_Viewer_Botanical_Prowess_Label2)
  
  // Prowess values: Spiritual
  begin object class=UI_Label Name=Team_Viewer_Spiritual_Prowess_Value
    tag="Team_Viewer_Spiritual_Prowess_Value"
    posX=790
    posY=297
    posXEnd=983
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="100"
    fontStyle=DEFAULT_SMALL_WHITE
  end object
  componentList.add(Team_Viewer_Spiritual_Prowess_Value)
  
  // Prowess values: Hunting
  begin object class=UI_Label Name=Team_Viewer_Hunting_Prowess_Value
    tag="Team_Viewer_Hunting_Prowess_Value"
    posX=983
    posY=297
    posXEnd=1176
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="50"
    fontStyle=DEFAULT_SMALL_WHITE
  end object
  componentList.add(Team_Viewer_Hunting_Prowess_Value)
  
  // Prowess values: Botanical
  begin object class=UI_Label Name=Team_Viewer_Botanical_Prowess_Value
    tag="Team_Viewer_Botanical_Prowess_Value"
    posX=1176
    posY=297
    posXEnd=1370
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="200"
    fontStyle=DEFAULT_SMALL_WHITE
  end object
  componentList.add(Team_Viewer_Botanical_Prowess_Value)
  
}














