/*=============================================================================
 * ROTT_Combat_Enemy_Gatekeeper
 *
 * Lore:
 *  The gatekeepers fall from the ethereal stream into the world as a side
 *  effect of spell pollution.  They lose their unbaised perspective once they
 *  enter the real world, and they can become dangerous.
 *
 * Ability:
 *  Demi gate.  Drains life from all opponents, while slowing their atb 
 *              progression.
 *===========================================================================*/
class ROTT_Combat_Enemy_Gatekeeper extends ROTT_Combat_Enemy
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
    case CLAN_GOLD:
    case CLAN_VIOLET:
    case CLAN_BLACK: 
    case CLAN_WHITE:
    case CLAN_RED:
      // Fixed stat points per level
      armorPerLvl = 0;
      baseStatsPerLvl[PRIMARY_VITALITY] = 5;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 5;
      baseStatsPerLvl[PRIMARY_COURAGE] = 2;
      baseStatsPerLvl[PRIMARY_FOCUS] = 2;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 1;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 25;
      statPreferences[PRIMARY_STRENGTH] = 25;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = MAJOR;
      statAffinities[PRIMARY_STRENGTH] = MAJOR;
      statAffinities[PRIMARY_COURAGE] = MAJOR;
      statAffinities[PRIMARY_FOCUS] = MAJOR;
      break;
      
    case CLAN_ORANGE:
      // Fixed stat points per level
      armorPerLvl = 0;
      baseStatsPerLvl[PRIMARY_VITALITY] = 5;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 2;
      baseStatsPerLvl[PRIMARY_COURAGE] = 5;
      baseStatsPerLvl[PRIMARY_FOCUS] = 2;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 1;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 25;
      statPreferences[PRIMARY_STRENGTH] = 25;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = MAJOR;
      statAffinities[PRIMARY_STRENGTH] = MAJOR;
      statAffinities[PRIMARY_COURAGE] = MAJOR;
      statAffinities[PRIMARY_FOCUS] = MAJOR;
      break;
      
    case CLAN_GREEN:
      // Fixed stat points per level
      armorPerLvl = 0;
      baseStatsPerLvl[PRIMARY_VITALITY] = 2;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 5;
      baseStatsPerLvl[PRIMARY_COURAGE] = 5;
      baseStatsPerLvl[PRIMARY_FOCUS] = 2;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 1;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 25;
      statPreferences[PRIMARY_STRENGTH] = 25;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = MAJOR;
      statAffinities[PRIMARY_STRENGTH] = MAJOR;
      statAffinities[PRIMARY_COURAGE] = MAJOR;
      statAffinities[PRIMARY_FOCUS] = MAJOR;
      break;
      
    case CLAN_CYAN:
      // Fixed stat points per level
      armorPerLvl = 0;
      baseStatsPerLvl[PRIMARY_VITALITY] = 5;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 2;
      baseStatsPerLvl[PRIMARY_COURAGE] = 2;
      baseStatsPerLvl[PRIMARY_FOCUS] = 5;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 1;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 25;
      statPreferences[PRIMARY_STRENGTH] = 25;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = MAJOR;
      statAffinities[PRIMARY_STRENGTH] = MAJOR;
      statAffinities[PRIMARY_COURAGE] = MAJOR;
      statAffinities[PRIMARY_FOCUS] = MAJOR;
      break;
      
    case CLAN_BLUE:
      // Fixed stat points per level
      armorPerLvl = 0;
      baseStatsPerLvl[PRIMARY_VITALITY] = 2;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 5;
      baseStatsPerLvl[PRIMARY_COURAGE] = 2;
      baseStatsPerLvl[PRIMARY_FOCUS] = 5;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 1;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 25;
      statPreferences[PRIMARY_STRENGTH] = 25;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = MAJOR;
      statAffinities[PRIMARY_STRENGTH] = MAJOR;
      statAffinities[PRIMARY_COURAGE] = MAJOR;
      statAffinities[PRIMARY_FOCUS] = MAJOR;
      break;
      
    case CLAN_PURPLE:
      // Fixed stat points per level
      armorPerLvl = 0;
      baseStatsPerLvl[PRIMARY_VITALITY] = 2;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 2;
      baseStatsPerLvl[PRIMARY_COURAGE] = 5;
      baseStatsPerLvl[PRIMARY_FOCUS] = 5;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 1;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 25;
      statPreferences[PRIMARY_STRENGTH] = 25;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = MAJOR;
      statAffinities[PRIMARY_STRENGTH] = MAJOR;
      statAffinities[PRIMARY_COURAGE] = MAJOR;
      statAffinities[PRIMARY_FOCUS] = MAJOR;
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
  monsterName="Gatekeeper"
  
  // Positive drop rate modifiers
  
  // Negative drop rate modifiers
  
  // Currency modifiers
  
  // Sprites 240x240
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Blue_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Blue_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Cyan_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Cyan_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Green_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Green_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Gold_240
    //componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Gold_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Orange_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Orange_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Red_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Red_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Violet_240
    //componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Violet_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Purple_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Purple_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Black_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_White_240
    //componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_White_240')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Enemy_Sprite_Container
    tag="Enemy_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Gatekeeper_Blue_240
    images(CLAN_CYAN)=Enemy_Portrait_Gatekeeper_Cyan_240
    images(CLAN_GREEN)=Enemy_Portrait_Gatekeeper_Green_240
    images(CLAN_GOLD)=Enemy_Portrait_Gatekeeper_Gold_240
    images(CLAN_ORANGE)=Enemy_Portrait_Gatekeeper_Orange_240
    images(CLAN_RED)=Enemy_Portrait_Gatekeeper_Red_240
    images(CLAN_VIOLET)=Enemy_Portrait_Gatekeeper_Violet_240
    images(CLAN_PURPLE)=Enemy_Portrait_Gatekeeper_Purple_240
    images(CLAN_BLACK)=Enemy_Portrait_Gatekeeper_Black_240
    images(CLAN_WHITE)=Enemy_Portrait_Gatekeeper_White_240
  end object
  enemySprites=Enemy_Sprite_Container
  
  // Sprites 360x360
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Blue_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Blue_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Cyan_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Cyan_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Green_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Green_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Gold_360
    //componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Gold_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Orange_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Orange_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Red_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Red_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Violet_360
    //componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Violet_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Purple_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Purple_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_Black_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Gatekeeper_White_360
    //componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_White_360')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Champ_Sprite_Container
    tag="Champ_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Gatekeeper_Blue_360
    images(CLAN_CYAN)=Enemy_Portrait_Gatekeeper_Cyan_360
    images(CLAN_GREEN)=Enemy_Portrait_Gatekeeper_Green_360
    images(CLAN_GOLD)=Enemy_Portrait_Gatekeeper_Gold_360
    images(CLAN_ORANGE)=Enemy_Portrait_Gatekeeper_Orange_360
    images(CLAN_RED)=Enemy_Portrait_Gatekeeper_Red_360
    images(CLAN_VIOLET)=Enemy_Portrait_Gatekeeper_Violet_360
    images(CLAN_PURPLE)=Enemy_Portrait_Gatekeeper_Purple_360
    images(CLAN_BLACK)=Enemy_Portrait_Gatekeeper_Black_360
    images(CLAN_WHITE)=Enemy_Portrait_Gatekeeper_White_360
  end object
  champSprites=Champ_Sprite_Container
  
}




















