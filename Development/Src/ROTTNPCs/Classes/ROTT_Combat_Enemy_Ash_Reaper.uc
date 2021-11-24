/*=============================================================================
 * ROTT_Combat_Enemy_Ash_Reaper
 *
 * Lore:
 *  The ash reaper is a fairy demon that specializes in using a short bladed 
 *  scythe to drain the blood of their prey through intimate attacks.  Summoned
 *  and fueled by blood worship, ash reapers collect the blood of their prey,
 *  and wear a veil over their mouths.  Their attacks are so delicate and 
 *  precise, that their prey is often still standing long after death.  Like 
 *  all users of dark spell blood worship, ash reapers wear mouth veils infused
 *  with the ethereal stream to protect and contain their dark magic.  
 *  Otherwise the body purges it through their mouths, while it materializes in
 *  the form of blood.
 *
 * Ability:
 *  Lust.  If an ash reaper kills its target, it gains speed.
 *===========================================================================*/
class ROTT_Combat_Enemy_Ash_Reaper extends ROTT_Combat_Enemy
  dependsOn(ROTT_Worlds_Encounter_Info);

/*=============================================================================
 * initStats()
 *
 * Called before all other initialization functions
 *===========================================================================*/
public function initStats
(
  EnemyTypes enemyType, 
  SpawnTypes spawnerType
)
{
  // Sprite assignment handled in super class
  super.initStats(enemyType, spawnerType);
  
  // Set stat modifiers for individual clans here
  switch (clanColor) {
    case CLAN_BLUE:
    case CLAN_CYAN:
    case CLAN_GREEN:
    case CLAN_GOLD:
    case CLAN_ORANGE:
    case CLAN_RED:
    case CLAN_VIOLET:
    case CLAN_PURPLE:
    case CLAN_BLACK: 
    case CLAN_WHITE:
      // Fixed stat points per level
      armorPerLvl = 0;
      baseStatsPerLvl[PRIMARY_VITALITY] = 1;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 2;
      baseStatsPerLvl[PRIMARY_COURAGE] = 5;
      baseStatsPerLvl[PRIMARY_FOCUS] = 5;

      // Randomly rolled stat variation
      randStatsPerLvl = 2;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 45;
      statPreferences[PRIMARY_STRENGTH] = 20;
      statPreferences[PRIMARY_COURAGE] = 35;
      statPreferences[PRIMARY_FOCUS] = 0;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = AVERAGE;
      statAffinities[PRIMARY_STRENGTH] = AVERAGE;
      statAffinities[PRIMARY_COURAGE] = AVERAGE;
      statAffinities[PRIMARY_FOCUS] = AVERAGE;
      break;
      
    default:
      yellowLog("Warning (!) No " $ default.monsterName $ " constructor defined for class " $ enemyType);
      break;
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  monsterName="Ash Demon"
  
  // Double experience because these things are quick and nasty little demons
  expAmp=2
  
  // Positive drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Faerie_Bones',chanceOverride=,minOverride=,maxOverride=,chanceAmp=3,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Herb',chanceOverride=,minOverride=,maxOverride=,chanceAmp=3,quantityAmp=))
  
  // Negative drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Swamp_Husks',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  
  // Currency modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gold',chanceOverride=,minOverride=,maxOverride=,chanceAmp=,quantityAmp=5))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gem',chanceOverride=0,minOverride=,maxOverride=,chanceAmp=,quantityAmp=))
  
  // Sprites 240x240
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Blue_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Blue_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Blue_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Cyan_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Cyan_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Cyan_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Green_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Green_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Green_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Gold_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Gold_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Gold_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Orange_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Orange_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Orange_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Red_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Red_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Red_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Violet_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Violet_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Violet_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Purple_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Purple_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Purple_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Black_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Black_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_White_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_White_Black_240')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Enemy_Sprite_Container
    tag="Enemy_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Ash_Reaper_Blue_240
    images(CLAN_CYAN)=Enemy_Portrait_Ash_Reaper_Cyan_240
    images(CLAN_GREEN)=Enemy_Portrait_Ash_Reaper_Green_240
    images(CLAN_GOLD)=Enemy_Portrait_Ash_Reaper_Gold_240
    images(CLAN_ORANGE)=Enemy_Portrait_Ash_Reaper_Orange_240
    images(CLAN_RED)=Enemy_Portrait_Ash_Reaper_Red_240
    images(CLAN_VIOLET)=Enemy_Portrait_Ash_Reaper_Violet_240
    images(CLAN_PURPLE)=Enemy_Portrait_Ash_Reaper_Purple_240
    images(CLAN_BLACK)=Enemy_Portrait_Ash_Reaper_Black_240
    images(CLAN_WHITE)=Enemy_Portrait_Ash_Reaper_White_240
  end object
  enemySprites=Enemy_Sprite_Container
  
  // Sprites 360x360
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Blue_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Blue_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Blue_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Cyan_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Cyan_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Cyan_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Green_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Green_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Green_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Gold_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Gold_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Gold_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Orange_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Orange_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Orange_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Red_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Red_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Red_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Violet_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Violet_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Violet_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Purple_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Purple_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Purple_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_Black_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_Black_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Ash_Reaper_White_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Ash_Reaper_White_Black_360')
  end object
  
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Champ_Sprite_Container
    tag="Champ_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Ash_Reaper_Blue_360
    images(CLAN_CYAN)=Enemy_Portrait_Ash_Reaper_Cyan_360
    images(CLAN_GREEN)=Enemy_Portrait_Ash_Reaper_Green_360
    images(CLAN_GOLD)=Enemy_Portrait_Ash_Reaper_Gold_360
    images(CLAN_ORANGE)=Enemy_Portrait_Ash_Reaper_Orange_360
    images(CLAN_RED)=Enemy_Portrait_Ash_Reaper_Red_360
    images(CLAN_VIOLET)=Enemy_Portrait_Ash_Reaper_Violet_360
    images(CLAN_PURPLE)=Enemy_Portrait_Ash_Reaper_Purple_360
    images(CLAN_BLACK)=Enemy_Portrait_Ash_Reaper_Black_360
    images(CLAN_WHITE)=Enemy_Portrait_Ash_Reaper_White_360
  end object
  champSprites=Champ_Sprite_Container
  
}


















