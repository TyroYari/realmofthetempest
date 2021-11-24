/*=============================================================================
 * ROTT_Combat_Enemy_Zombie
 *
 * Lore:
 *  Zombies are produced as a byproduct of nether worship, because the nether's
 *  hunger for souls leaks into the world, potentially draining any minds 
 *  nearby.
 *
 * Ability:
 *  Howl.  Briefly demoralizes opponents.
 *===========================================================================*/
class ROTT_Combat_Enemy_Zombie extends ROTT_Combat_Enemy
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
      baseStatsPerLvl[PRIMARY_STRENGTH] = 2;
      baseStatsPerLvl[PRIMARY_COURAGE] = 2;
      baseStatsPerLvl[PRIMARY_FOCUS] = 0;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 4;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 25;  
      statPreferences[PRIMARY_STRENGTH] = 25;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;
      
      // Affinities
      statAffinities[PRIMARY_VITALITY] = AVERAGE;
      statAffinities[PRIMARY_STRENGTH] = AVERAGE;
      statAffinities[PRIMARY_COURAGE] = MAJOR;
      statAffinities[PRIMARY_FOCUS] = MINOR;
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
  monsterName="Zombie"
  
  // Positive drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Swamp_Husks',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  
  // Negative drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Herb',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Harrier_Claws',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Faerie_Bones',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  
  // Currency modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gold',chanceOverride=,minOverride=,maxOverride=,chanceAmp=,quantityAmp=1.50))
  
  // Sprites 240x240
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Blue_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Blue_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Blue_Black_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Blue_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Cyan_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Cyan_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Cyan_Black_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Cyan_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Green_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Green_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Green_Black_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Green_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Gold_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Gold_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Gold_Pale_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Gold_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Orange_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Orange_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Orange_Black_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Orange_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Red_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Red_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Red_Black_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Red_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Violet_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Pink_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Pink_Black_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Pink_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Purple_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Purple_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Purple_Black_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Purple_Pale_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Black_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Black_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Black_Pale_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Black_White_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_White_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Brown_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Brown_Pale_240')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_White_Black_240')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Enemy_Sprite_Container
    tag="Enemy_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Zombie_Blue_240
    images(CLAN_CYAN)=Enemy_Portrait_Zombie_Cyan_240
    images(CLAN_GREEN)=Enemy_Portrait_Zombie_Green_240
    images(CLAN_GOLD)=Enemy_Portrait_Zombie_Gold_240
    images(CLAN_ORANGE)=Enemy_Portrait_Zombie_Orange_240
    images(CLAN_RED)=Enemy_Portrait_Zombie_Red_240
    images(CLAN_VIOLET)=Enemy_Portrait_Zombie_Violet_240
    images(CLAN_PURPLE)=Enemy_Portrait_Zombie_Purple_240
    images(CLAN_BLACK)=Enemy_Portrait_Zombie_Black_240
    images(CLAN_WHITE)=Enemy_Portrait_Zombie_White_240
  end object
  enemySprites=Enemy_Sprite_Container
  
  // Sprites 360x360
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Blue_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Blue_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Blue_Black_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Blue_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Cyan_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Cyan_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Cyan_Black_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Cyan_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Green_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Green_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Green_Black_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Green_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Gold_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Gold_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Gold_Pale_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Gold_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Orange_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Orange_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Orange_Black_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Orange_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Red_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Red_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Red_Black_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Red_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Violet_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Pink_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Pink_Black_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Pink_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Purple_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Purple_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Purple_Black_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Purple_Pale_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_Black_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Black_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Black_Pale_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Black_White_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Zombie_White_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Brown_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_Brown_Pale_360')
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Zombie_White_Black_360')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Champ_Sprite_Container
    tag="Champ_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Zombie_Blue_360
    images(CLAN_CYAN)=Enemy_Portrait_Zombie_Cyan_360
    images(CLAN_GREEN)=Enemy_Portrait_Zombie_Green_360
    images(CLAN_GOLD)=Enemy_Portrait_Zombie_Gold_360
    images(CLAN_ORANGE)=Enemy_Portrait_Zombie_Orange_360
    images(CLAN_RED)=Enemy_Portrait_Zombie_Red_360
    images(CLAN_VIOLET)=Enemy_Portrait_Zombie_Violet_360
    images(CLAN_PURPLE)=Enemy_Portrait_Zombie_Purple_360
    images(CLAN_BLACK)=Enemy_Portrait_Zombie_Black_360
    images(CLAN_WHITE)=Enemy_Portrait_Zombie_White_360
  end object
  champSprites=Champ_Sprite_Container

}












