/*=============================================================================
 * ROTT_UI_Statistic_Labels
 *
 * Author: Otay
 * Bramble Gate Studios (All Downs reserved)
 *
 * Description: A collection of labels for the stats page.
 *===========================================================================*/
 
class ROTT_UI_Statistic_Labels extends UI_Container;

/*============================================================================*
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Container draw settings
  bDrawRelative=true
  
  /** ===== UI Components ===== **/
  // Primary Stat: Vitality
  begin object class=UI_Label Name=VitalityPrimeStat
    tag="VitalityPrimeStat"
    posY=201
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Vitality"
  end object
  componentList.add(VitalityPrimeStat)
  
  // Primary Stat: Strength
  begin object class=UI_Label Name=StrengthPrimeStat
    tag="StrengthPrimeStat"
    posY=261
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Strength"
  end object
  componentList.add(StrengthPrimeStat)
  
  // Primary Stat: Courage
  begin object class=UI_Label Name=CouragePrimeStat
    tag="CouragePrimeStat"
    posY=345
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Courage"
    end object
  componentList.add(CouragePrimeStat)
  
  // Primary Stat: Focus
  begin object class=UI_Label Name=FocusPrimeStat
    tag="FocusPrimeStat"
    posY=575
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Focus"
  end object
  componentList.add(FocusPrimeStat)
  
  // Substat: Health
  begin object class=UI_Label Name=VitalitySubStats
    tag="VitalitySubStats"
    posX=260
    posY=201
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Health"
  end object
  componentList.add(VitalitySubStats)
  
  // Substat: Strength
  begin object class=UI_Label Name=StrengthSubStats
    tag="StrengthSubStats"
    posX=260
    posY=261
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Physical\nDamage"
  end object
  componentList.add(StrengthSubStats)
  
  // Substat: Courage
  begin object class=UI_Label Name=CourageSubStats
    tag="CourageSubStats"
    posX=260
    posY=345
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Attack Interval\n\nCritical Chance\n\nCritical Rolls\n\nAccuracy"
  end object
  componentList.add(CourageSubStats)
  
  // Substat: Focus
  begin object class=UI_Label Name=FocusSubStats
    tag="FocusSubStats"
    posX=260
    posY=575
    AlignX=Left
    AlignY=Top
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Mana\n\nDodge\n\nSpiritual Burden"
  end object
  componentList.add(FocusSubStats)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  