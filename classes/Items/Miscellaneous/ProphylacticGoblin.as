﻿package classes.Items.Miscellaneous
{
	import classes.ItemSlotClass;
	import classes.GLOBAL;
	import classes.Creature;
	import classes.kGAMECLASS;	
	import classes.Characters.PlayerCharacter;
	import classes.GameData.TooltipManager;
	import classes.StringUtil;
	
	public class ProphylacticGoblin extends ItemSlotClass
	{
		
		//constructor
		public function ProphylacticGoblin()
		{
			this._latestVersion = 1;
			
			this.quantity = 1;
			this.stackSize = 20;
			this.type = GLOBAL.DRUG;
			
			//Used on inventory buttons
			this.shortName = "Goblin P.";
			
			//Regular name
			this.longName = "goblin prophylactic";
			
			TooltipManager.addFullName(this.shortName, StringUtil.toTitleCase(this.longName));
			
			//Longass shit, not sure what used for yet.
			this.description = "a prophylactic designed to repel goblins";
			
			//Displayed on tooltips during mouseovers
			this.tooltip = "A tubular aerosol canister with the outline of a goblin on it. Once sprayed on, it should detract any goblin from approaching you for a time. It doesn’t feel particularly full; you suspect you’ll only get one use out of it.";
			
			TooltipManager.addTooltip(this.shortName, this.tooltip);
			
			this.attackVerb = "";
			
			//Information
			this.basePrice = 400;
			this.attack = 0;
			this.damage = 0;
			this.damageType = GLOBAL.KINETIC;
			this.defense = 0;
			this.shieldDefense = 0;
			this.shields = 0;
			this.sexiness = 0;
			this.critBonus = 0;
			this.evasion = 0;
			this.fortification = 0;
			this.bonusResistances = new Array(0, 0, 0, 0, 0, 0, 0, 0);
			
			this.version = _latestVersion;
		}
		
		//METHOD ACTING!
		override public function useFunction(target:Creature, usingCreature:Creature = null):Boolean
		{
			kGAMECLASS.clearOutput();
			if(target is PlayerCharacter) {
				kGAMECLASS.output("You take out the aerosol canister and spray yourself all over with it. It doesn’t smell of anything but wet solvent... but then, you aren’t a goblin.");
				if(!target.hasStatusEffect("Goblin Prophylactic")) target.createStatusEffect("Goblin Prophylactic", 0, 0, 0, 0, false, "Radio", "The spray currently effecting you will reduce encounters with goblins.", false, 1200);
				else target.setStatusMinutes("Goblin Prophylactic",1200);
			}
			else {
				kGAMECLASS.output(target.capitalA + target.short + " seems uninterested in the spray.");
			}
			return false;			
		}
	}
}
