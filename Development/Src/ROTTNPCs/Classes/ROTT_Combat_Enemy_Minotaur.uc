/*=============================================================================
 * ROTT_Combat_Enemy_Minotaur
 *
 * Lore:
 *  Minotaurs are summoned by blood worship and moon worship, because their
 *  essence comes from the labrynth within, and the world beyond.  They serve
 *  as guardians of the land they were summoned from.
 *
 * Abilities:
 *  Trample.  An attack that ignores half of opponents armor.
 *  Roar. Removes some armor from all heroes.
 *===========================================================================*/
class ROTT_Combat_Enemy_Minotaur extends ROTT_Combat_Enemy
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
      baseStatsPerLvl[PRIMARY_VITALITY] = 4;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 3;
      baseStatsPerLvl[PRIMARY_COURAGE] = 2;
      baseStatsPerLvl[PRIMARY_FOCUS] = 1;

      // Randomly rolled stat variation
      randStatsPerLvl = 3;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 25;
      statPreferences[PRIMARY_STRENGTH] = 25;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = AVERAGE;
      statAffinities[PRIMARY_STRENGTH] = MAJOR;
      statAffinities[PRIMARY_COURAGE] = MAJOR;
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
  monsterName="Minotaur"
  
  // Positive drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Flail',chanceOverride=,minOverride=,maxOverride=,chanceAmp=8,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Herb',chanceOverride=,minOverride=,maxOverride=,chanceAmp=3,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Charm_Eluvi',chanceOverride=,minOverride=,maxOverride=,chanceAmp=3,quantityAmp=))
  
  // Negative drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Harrier_Claws',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Faerie_Bones',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Swamp_Husks',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  
  // Currency modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gold',chanceOverride=,minOverride=,maxOverride=,chanceAmp=,quantityAmp=1.5))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gem',chanceOverride=0,minOverride=,maxOverride=,chanceAmp=,quantityAmp=))
  
  // Sprites 240x240
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Blue_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Blue_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Blue_Yellow_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Cyan_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Cyan_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Green_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Green_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Green_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Gold_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Gold_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Orange_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Orange_Yellow_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Red_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Red_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Red_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Violet_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Violet_Black_240')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Cyan_Yellow_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Purple_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Purple_Yellow_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Black_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_White_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_White_Yellow_240')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Enemy_Sprite_Container
    tag="Enemy_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Minotaur_Blue_240
    images(CLAN_CYAN)=Enemy_Portrait_Minotaur_Cyan_240
    images(CLAN_GREEN)=Enemy_Portrait_Minotaur_Green_240
    images(CLAN_GOLD)=Enemy_Portrait_Minotaur_Gold_240
    images(CLAN_ORANGE)=Enemy_Portrait_Minotaur_Orange_240
    images(CLAN_RED)=Enemy_Portrait_Minotaur_Red_240
    images(CLAN_VIOLET)=Enemy_Portrait_Minotaur_Violet_240
    images(CLAN_PURPLE)=Enemy_Portrait_Minotaur_Purple_240
    images(CLAN_BLACK)=Enemy_Portrait_Minotaur_Black_240
    images(CLAN_WHITE)=Enemy_Portrait_Minotaur_White_240
  end object
  enemySprites=Enemy_Sprite_Container
  
  // Sprites 360x360
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Blue_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Blue_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Blue_Yellow_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Cyan_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Cyan_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Green_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Green_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Green_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Gold_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Gold_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Orange_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Orange_Yellow_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Red_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Red_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Red_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Violet_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Violet_Black_360')
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Cyan_Yellow_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Purple_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Purple_Yellow_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_Black_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Minotaur_White_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Minotaur_White_Yellow_360')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Champ_Sprite_Container
    tag="Champ_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Minotaur_Blue_360
    images(CLAN_CYAN)=Enemy_Portrait_Minotaur_Cyan_360
    images(CLAN_GREEN)=Enemy_Portrait_Minotaur_Green_360
    images(CLAN_GOLD)=Enemy_Portrait_Minotaur_Gold_360
    images(CLAN_ORANGE)=Enemy_Portrait_Minotaur_Orange_360
    images(CLAN_RED)=Enemy_Portrait_Minotaur_Red_360
    images(CLAN_VIOLET)=Enemy_Portrait_Minotaur_Violet_360
    images(CLAN_PURPLE)=Enemy_Portrait_Minotaur_Purple_360
    images(CLAN_BLACK)=Enemy_Portrait_Minotaur_Black_360
    images(CLAN_WHITE)=Enemy_Portrait_Minotaur_White_360
  end object
  champSprites=Champ_Sprite_Container
  
}




















