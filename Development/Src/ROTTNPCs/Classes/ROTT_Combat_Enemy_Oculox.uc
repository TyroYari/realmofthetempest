/*=============================================================================
 * ROTT_Combat_Enemy_Oculox
 *
 * Lore:
 *  The Oculox is a tentacle monster with a single eye, spawned when ocules
 *  coalesce to evolve into the Oculox.  Their single eye represents a loss of
 *  perspective.  They serve as judgement from the world beyond.
 *
 * Ability:
 *  Mana Throb - 100% damage to mana.
 *  Ethereal Haze - Drains mana over time from all opponents, for some time.
 *===========================================================================*/
class ROTT_Combat_Enemy_Oculox extends ROTT_Combat_Enemy
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
      baseStatsPerLvl[PRIMARY_VITALITY] = 3;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 3;
      baseStatsPerLvl[PRIMARY_COURAGE] = 2;
      baseStatsPerLvl[PRIMARY_FOCUS] = 1;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 3;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 20;
      statPreferences[PRIMARY_STRENGTH] = 30;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = MAJOR;
      statAffinities[PRIMARY_STRENGTH] = MINOR;
      statAffinities[PRIMARY_COURAGE] = AVERAGE;
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
  monsterName="Oculox"
  
  // Positive drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Charm_Kamita',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Charm_Bayuta',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Harrier_Claws',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  
  // Negative drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Faerie_Bones',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Herb',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Charm_Eluvi',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  
  // Currency modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gem',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  
  // Sprites 240x240
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Blue_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Blue_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Cyan_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Cyan_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Green_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Green_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Gold_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Gold_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Orange_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Orange_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Red_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Red_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Violet_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Violet_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Purple_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Purple_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Black_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_White_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_White_240')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Enemy_Sprite_Container
    tag="Enemy_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Oculox_Blue_240
    images(CLAN_CYAN)=Enemy_Portrait_Oculox_Cyan_240
    images(CLAN_GREEN)=Enemy_Portrait_Oculox_Green_240
    images(CLAN_GOLD)=Enemy_Portrait_Oculox_Gold_240
    images(CLAN_ORANGE)=Enemy_Portrait_Oculox_Orange_240
    images(CLAN_RED)=Enemy_Portrait_Oculox_Red_240
    images(CLAN_VIOLET)=Enemy_Portrait_Oculox_Violet_240
    images(CLAN_PURPLE)=Enemy_Portrait_Oculox_Purple_240
    images(CLAN_BLACK)=Enemy_Portrait_Oculox_Black_240
    images(CLAN_WHITE)=Enemy_Portrait_Oculox_White_240
  end object
  enemySprites=Enemy_Sprite_Container
  
  // Sprites 360x360
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Blue_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Blue_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Cyan_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Cyan_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Green_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Green_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Gold_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Gold_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Orange_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Orange_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Red_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Red_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Violet_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Violet_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Purple_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Purple_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_Black_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Oculox_White_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Oculox_White_360')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Champ_Sprite_Container
    tag="Champ_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Oculox_Blue_360
    images(CLAN_CYAN)=Enemy_Portrait_Oculox_Cyan_360
    images(CLAN_GREEN)=Enemy_Portrait_Oculox_Green_360
    images(CLAN_GOLD)=Enemy_Portrait_Oculox_Gold_360
    images(CLAN_ORANGE)=Enemy_Portrait_Oculox_Orange_360
    images(CLAN_RED)=Enemy_Portrait_Oculox_Red_360
    images(CLAN_VIOLET)=Enemy_Portrait_Oculox_Violet_360
    images(CLAN_PURPLE)=Enemy_Portrait_Oculox_Purple_360
    images(CLAN_BLACK)=Enemy_Portrait_Oculox_Black_360
    images(CLAN_WHITE)=Enemy_Portrait_Oculox_White_360
  end object
  champSprites=Champ_Sprite_Container
  
}
