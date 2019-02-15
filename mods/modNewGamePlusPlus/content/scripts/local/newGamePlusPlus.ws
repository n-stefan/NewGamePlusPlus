/***********************************************************************/
/** 	New Game Plus Plus© 2018 DarkTar All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/



exec function NGPPStandardInit()
{
	NewGamePlusPlus(true, false);
}

exec function NGPPCustomInit()
{
	NewGamePlusPlus(false, false);
}

exec function NGPPCustomInitResetDiagrams()
{
	NewGamePlusPlus(false, true);
}

exec function NGPPLockVanillaEquipmentLeveling()
{
	LockVanillaEquipmentLeveling(true);
}

exec function NGPPUnlockVanillaEquipmentLeveling()
{
	LockVanillaEquipmentLeveling(false);
}

exec function NGPPClearOriginalEquipmentLevel()
{
    ClearOriginalEquipmentLevel();
}

function NewGamePlusPlus(standardInit: bool, resetDiagrams: bool)
{
	var witcher: W3PlayerWitcher;
	var inventory, horseInventory: CInventoryComponent;

	FactsSet("NewGamePlus", 0);
	theGame.EnableNewGamePlus(true);

	if (standardInit)
	{
		thePlayer.NewGamePlusInitialize();
	}
	else
	{
		witcher = GetWitcherPlayer();

		inventory = witcher.GetInventory();
		horseInventory = witcher.GetHorseManager().GetInventoryComponent();

		RemoveQuestItemsByName(inventory, horseInventory);

		inventory.RemoveItemByTag('Quest', -1);
		horseInventory.RemoveItemByTag('Quest', -1);

		inventory.RemoveItemByTag('NoticeBoardNote', -1);
		horseInventory.RemoveItemByTag('NoticeBoardNote', -1);

		inventory.RemoveItemByTag('ReadableItem', -1);
		horseInventory.RemoveItemByTag('ReadableItem', -1);

		inventory.RemoveItemByTag('GwintCard', -1);
		horseInventory.RemoveItemByTag('GwintCard', -1);

		RemoveQuestAlchemyRecipes(witcher);

		if (resetDiagrams)
		{
			witcher.RemoveAllCraftingSchematics();
			witcher.AddStartingSchematicsW();
		}

		inventory.AddAnItem('Clearing Potion', 1, true, false, false);

		witcher.NewGamePlusMarkItemsToNotAdjustW(inventory);
		witcher.NewGamePlusMarkItemsToNotAdjustW(horseInventory);

		thePlayer.GetInputHandler().ClearLocksForNGP();

		witcher.ClearBuffImmunities();
	}

	theGame.GetGuiManager().ShowUserDialogAdv(0, "", "mod_ngpp_initdone", true, UDB_Ok);
}

function RemoveQuestItemsByName(inventory: CInventoryComponent, horseInventory: CInventoryComponent)
{
	var questItems: array<name>;
	var i: int;

	questItems = theGame.GetDefinitionsManager().GetItemsWithTag('Quest');
	for (i = 0; i < questItems.Size(); i += 1)
	{
		inventory.RemoveItemByName(questItems[i], -1);
		horseInventory.RemoveItemByName(questItems[i], -1);
	}
}

function RemoveQuestAlchemyRecipes(witcher: W3PlayerWitcher)
{
	var recipe: SAlchemyRecipe;
	var recipes: array<name>;
	var i: int;

	recipes = witcher.GetAlchemyRecipes();

	for (i = 0; i < recipes.Size(); i += 1)
	{
		recipe = getAlchemyRecipeFromName(recipes[i]);
		if (recipe.cookedItemType == EACIT_Quest)
			witcher.RemoveAlchemyRecipeW(recipes[i]);
	}
}

function LockVanillaEquipmentLeveling(lock: bool)
{
	var witcher: W3PlayerWitcher;
	var inventory, horseInventory: CInventoryComponent;

	witcher = GetWitcherPlayer();
	inventory = witcher.GetInventory();
	horseInventory = witcher.GetHorseManager().GetInventoryComponent();

	if (lock)
	{
		witcher.NewGamePlusMarkItemsToNotAdjustW(inventory);
		witcher.NewGamePlusMarkItemsToNotAdjustW(horseInventory);

		theGame.GetGuiManager().ShowNotification(GetLocStringByKeyExt("mod_ngpp_inventorylocked"), 5000);
	}
	else
	{
		witcher.NewGamePlusMarkItemsToAdjust(inventory);
		witcher.NewGamePlusMarkItemsToAdjust(horseInventory);

		theGame.GetGuiManager().ShowNotification(GetLocStringByKeyExt("mod_ngpp_inventoryunlocked"), 5000);
	}
}

function ClearOriginalEquipmentLevel()
{
    var witcher: W3PlayerWitcher;
    var inventory: CInventoryComponent;

    witcher = GetWitcherPlayer();
    inventory = witcher.GetInventory();

    inventory.ClearOriginalEquipmentLevel();

    theGame.GetGuiManager().ShowNotification(GetLocStringByKeyExt("mod_ngpp_originalequipmentlevelcleared"), 5000);
}
