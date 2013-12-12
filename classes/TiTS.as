﻿package classes
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.display.MovieClip;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import classes.RoomClass;

	import classes.GUI;
	import classes.Mapper;

	//Build the bottom drawer
	public class TiTS extends MovieClip
	{
		// Smoosh all the included stuff into the TiTS class
		// this is a HORRIBLE way of architecting the system, but it's better then not
		// using classes at all
		
		include "../includes/combat.as";
		include "../includes/celise.as";
		include "../includes/flahne.as";
		include "../includes/itemData.as";
		include "../includes/items.as";
		include "../includes/penny.as";
		include "../includes/scrapyard.as";
		include "../includes/creation.as";
		include "../includes/data.as";
		include "../includes/engine.as";
		include "../includes/game.as";
		include "../includes/masturbation.as";
		include "../includes/NPCTemplates.as";
		include "../includes/input.as";
		include "../includes/burt.as";
		include "../includes/appearance.as";
		include "../includes/rooms.as";
		include "../includes/zilMale.as";
		include "../includes/zilFemale.as";
		include "../includes/cuntSnakes.as";
	
		//include "../includes/zilMale.as";
		
		

		var characters:Array;
		var foes:Array;
			
		var pc:Creature;
		var celise:Creature;
		var rival:Creature;
		var geoff:Creature;
		var flahne:Creature;
		var zilpack:Creature;
		var zil:Creature;
		var penny:Creature;
		var burt:Creature;
		var zilFemale:Creature;

		// These are all floating around in the TiTS namespace. Really
		// they should be stored in an item Object() or something
		// Also, *ideally*, they should all be sub-classes of ItemSlotClass, not instances of ItemSlotClass
		// with some of their parameters overridden procedurally
		var holdOutPistol:ItemSlotClass
		var eagleClassHandgun:ItemSlotClass
		var scopedPistol:ItemSlotClass
		var laserPistol:ItemSlotClass
		var knife:ItemSlotClass
		var dressClothes:ItemSlotClass
		var spacePanties:ItemSlotClass
		var spaceBriefs:ItemSlotClass
		var spaceBra:ItemSlotClass
		var undershirt:ItemSlotClass

		var eventBuffer:String;
		var eventQueue:Array;

		var version:String;

		var rooms:Object;

		var temp:int;
		var items:Object;
		//Toggles
		var silly:Boolean;
		var easy:Boolean;
		var debug:Boolean;


		//Lazy man state checking
		var saveHere:Boolean;
		var currentLocation:String;
		var shipLocation:String;

		//PERVINEER HERE!
		var testBool:Boolean;
		var testString:String;
		var testInt:int;
		//Pervineer here!
		var parser:ScriptParser;

		var userInterface:GUI;

		var shopkeep:Creature;
		var itemScreen:*;
		var lootScreen:*;
		var lootList:Array;
		var useItemFunction;
		var itemUser:Creature;
		var itemTarget:Creature;

		var flags:Dictionary;

		var combatStage;
		public function TiTS()
		{

			trace("TiTS Constructor")

			version = "0.01c";

			//temporary nonsense variables.
			temp = 0;
			combatStage = 0;

			import classes.Creature;
			import classes.ItemSlotClass;
			import flash.net.registerClassAlias;
			import classes.ScriptParser;
			import classes.ShipClass;

			registerClassAlias("Creature", Creature);
			registerClassAlias("ItemSlotClass", ItemSlotClass);
			registerClassAlias("shipClass", ShipClass);
			registerClassAlias("CockClass", CockClass);
			registerClassAlias("VaginaClass", VaginaClass);
			registerClassAlias("BreastRowClass",BreastRowClass);
			registerClassAlias("ItemSlotClass",ItemSlotClass);
			registerClassAlias("roomClass",RoomClass);
			registerClassAlias("StorageClass",StorageClass);


			characters = new Array();
			foes = new Array();
			
			//What inventory screen is up?
			shopkeep = undefined;
			itemScreen = undefined;
			lootScreen = undefined;
			lootList = new Array();
			useItemFunction = undefined;
			itemUser = undefined;
			itemTarget = undefined;


			eventQueue = new Array();

			eventBuffer = "";


			//Toggles
			silly = false;
			easy = false;
			debug = false;


			//Lazy man state checking
			saveHere = false;
			currentLocation = "SHIP HANGAR";
			shipLocation = "SHIP HANGAR";

			//Pervineer here!
			parser = new ScriptParser(this);



			//Lazy man shortcuts! Need reset after reinitialization of data.
			//pc = characters[0];

			// CHRIST WHY?
			pc = characters[0];
			celise = characters[GLOBAL.CELISE];
			rival = characters[GLOBAL.RIVAL];
			geoff = characters[GLOBAL.GEOFF];
			flahne = characters[GLOBAL.CELISE];
			zilpack = characters[GLOBAL.ZILPACK];
			zil = characters[GLOBAL.ZIL];
			penny = characters[GLOBAL.PENNY];
			burt = characters[GLOBAL.BURT];
			zilFemale = characters[GLOBAL.ZILFEMALE];

			flags = new Dictionary();
			initializeFlags();


			this.userInterface = new GUI(this, stage)
			
			include "../includes/weaponVariables.as";


			// Major class variable setup: ------------------------------------------------------------
			setupCharacters();
			initializeRooms();
			initializeItems();



			// dick about with mapper: ------------------------------------------------------------
			var mapper:Mapper = new Mapper(this.rooms)
			var map:*;
			map = mapper.generateMap("NORTH ESBETH 2")
			mapper.printMap(map)



			// set up the user interface: ------------------------------------------------------------
			this.userInterface.clearMenu();
			//this.userInterface.addButton(0,"Horsecock",horsecock);
			this.userInterface.addButton(14,"CLEAR!",clearOutput);
			//this.userInterface.addButton(16,"2Horse4Me",horsecock);

			setupInputEventHandlers()

			
			this.addFrameScript( 0, mainMenu );
			//mainMenu();
		}
		
		
		public function setupInputEventHandlers():void
		{
			this.userInterface.upScrollButton.addEventListener(MouseEvent.MOUSE_DOWN,clickScrollUp);
			this.userInterface.downScrollButton.addEventListener(MouseEvent.MOUSE_DOWN,clickScrollDown);
			this.addEventListener(MouseEvent.MOUSE_WHEEL,wheelUpdater);
			this.userInterface.scrollBar.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			this.userInterface.scrollBG.addEventListener(MouseEvent.CLICK,scrollPage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPress);
			this.userInterface.leftSideBar.mainMenuButton.addEventListener(MouseEvent.CLICK,mainMenuToggle);
			this.userInterface.leftSideBar.appearanceButton.addEventListener(MouseEvent.CLICK,pcAppearance);
			this.userInterface.leftSideBar.dataButton.addEventListener(MouseEvent.CLICK,dataRouter);

			this.userInterface.updateScroll(this.userInterface.tempEvent);
		}


		public function mainMenuToggle(e:MouseEvent):void {
			if(this.userInterface.leftSideBar.mainMenuButton.alpha < 1) return;
			if(this.userInterface.titleDisplay.visible) 
				this.userInterface.hideMenus();
			else mainMenu();
		}

		
		public function buttonClick(evt:MouseEvent):void {
			if(!inCombat()) 
				this.userInterface.showBust(0);
			if(evt.currentTarget.func == undefined) {
				trace("ERROR: Active button click on " + evt.currentTarget.caption.text + " with no associated public function!");
				return;
			}
			trace("Button " + evt.currentTarget.caption.text + " clicked.");
			if(evt.currentTarget.arg == undefined) evt.currentTarget.func();
			else evt.currentTarget.func(evt.currentTarget.arg);
			updatePCStats();
		}

		public function bufferButtonUpdater():void {
			//If you can go right still.
			if(this.userInterface.textPage < 4) {
				if(this.userInterface.pageNext.alpha != 1) {
					this.userInterface.pageNext.addEventListener(MouseEvent.CLICK,this.userInterface.forwardBuffer);
					this.userInterface.pageNext.alpha = 1;
					this.userInterface.pageNext.buttonMode = true;
				}
			}
			//If you can't go right but the button aint turned off.
			else if(this.userInterface.pageNext.alpha != .3) {
				this.userInterface.pageNext.removeEventListener(MouseEvent.CLICK,this.userInterface.forwardBuffer);
				this.userInterface.pageNext.alpha = .3;
				this.userInterface.pageNext.buttonMode = false;
			}
			//Left hooo!
			if(this.userInterface.textPage > 0) {
				if(this.userInterface.pagePrev.alpha != 1) {
					this.userInterface.pagePrev.addEventListener(MouseEvent.CLICK,this.userInterface.backBuffer);
					this.userInterface.pagePrev.alpha = 1;
					this.userInterface.pagePrev.buttonMode = true;
				}
			}
			//If you can't go right but the button aint turned off.
			else if(this.userInterface.pagePrev.alpha != .3) {
				this.userInterface.pagePrev.removeEventListener(MouseEvent.CLICK,this.userInterface.backBuffer);
				this.userInterface.pagePrev.alpha = .3;
				this.userInterface.pagePrev.buttonMode = false;
			}
		}


		//2. KEYBOARD STUFF
		//Handle all key presses!
		public function keyPress(evt:KeyboardEvent):void {
			if(stage.contains(this.userInterface.textInput)) 
				return;
			var keyTemp;
			switch (evt.keyCode) {
				//Up
				case 38:
					upScrollText();
					break;
				//Down
				case 40:
					downScrollText();
					break;
				//PgDn
				case 34:
					if(stage.focus == null) { 
						trace("OUT OF FOCUS SCROLL");
						keyTemp = this.userInterface.mainTextField.bottomScrollV - this.userInterface.mainTextField.scrollV + 1;
						this.userInterface.mainTextField.scrollV += keyTemp;
					}
					wheelUpdater(this.userInterface.tempEvent);
					break;
				//PgUp
				case 33:
					//Scroll if text field isn't actively selected, like a BAWS.
					if(stage.focus == null) { 
						trace("OUT OF FOCUS SCROLL");
						keyTemp = this.userInterface.mainTextField.bottomScrollV - this.userInterface.mainTextField.scrollV + 1;
						this.userInterface.mainTextField.scrollV -= keyTemp;
					}
					wheelUpdater(this.userInterface.tempEvent);
					break;
				//Home
				case 36:
					this.userInterface.mainTextField.scrollV = 1;
					this.userInterface.updateScroll(this.userInterface.tempEvent);
					break;
				//End
				case 35:
					this.userInterface.mainTextField.scrollV = this.userInterface.mainTextField.maxScrollV;
					this.userInterface.updateScroll(this.userInterface.tempEvent);
					break;
				//New page (6)
				case 54:
					if(this.userInterface.buttonPageNext.alpha == 1) this.userInterface.pageButtons();
					break;
				//Back page (5)
				case 89:
					if(this.userInterface.buttonPagePrev.alpha == 1) this.userInterface.pageButtons(false);
					break;
				//1
				case 49:
					pressButton(0);
					break;
				//2
				case 50:
					pressButton(1);
					break;
				//3
				case 51:
					pressButton(2);
					break;
				//4
				case 52:
					pressButton(3);
					break;
				//5
				case 53:
					pressButton(4);
					break;
				//q
				case 81:
					pressButton(5);
					break;
				//w
				case 87:
					pressButton(6);
					break;
				//e
				case 69:
					pressButton(7);
					break;
				//r
				case 82:
					pressButton(8);
					break;
				//t
				case 84:
					pressButton(9);
					break;
				//a
				case 65:
					pressButton(10);
					break;
				//s
				case 83:
					pressButton(11);
					break;
				//d
				case 68:
					pressButton(12);
					break;
				//f
				case 70:
					pressButton(13);
					break;
				//g
				case 71:
					pressButton(14);
					break;
				//Space = Back/Next
				case 32:
					//Space pressed
					if(this.userInterface.buttons[0].caption.text == "Next") pressButton(0);
					else if(this.userInterface.buttons[14].caption.text == "Back") pressButton(14);
					else if(this.userInterface.buttons[14].caption.text == "Leave") pressButton(14);
					break;
				default:
					trace("Key pressed! Keycode: " + evt.keyCode);
					break;
			}
		}

		public function pressButton(arg:int = 0):void {
			if(arg >= this.userInterface.buttons.length || arg < 0) return;
			if(this.userInterface.buttons[arg].func == undefined) 
			{
				trace("Undefined button pressed! Something went wrong!");
				return;
			}
			if(!inCombat()) 
				this.userInterface.showBust(0);
			if(this.userInterface.buttons[arg].arg == undefined) this.userInterface.buttons[arg].func();
			else this.userInterface.buttons[arg].func(this.userInterface.buttons[arg].arg);
			updatePCStats();
		}

		//3. SCROLL WHEEL STUFF
		//Scroll up or down a page based on click position!
		public function scrollPage(evt:MouseEvent):void {
			if(evt.stageY > this.userInterface.scrollBar.y) {
				this.userInterface.mainTextField.scrollV += this.userInterface.mainTextField.bottomScrollV - this.userInterface.mainTextField.scrollV;
			}
			else {
				this.userInterface.mainTextField.scrollV -= this.userInterface.mainTextField.bottomScrollV - this.userInterface.mainTextField.scrollV;
			}
			this.userInterface.updateScroll(this.userInterface.tempEvent);
		}

		//Puts a listener on the next frame that removes itself and updates to fix the laggy bar updates
		public function wheelUpdater(evt:MouseEvent):void {
			this.addEventListener(Event.ENTER_FRAME,wheelUpdater2);
		}
		public function wheelUpdater2(evt:Event):void {
			this.removeEventListener(Event.ENTER_FRAME,wheelUpdater2);
			this.userInterface.updateScroll(this.userInterface.tempEvent);
		}

		//CLICK/SCROLL UP/DOWN VIA UP/DOWN ARROWS
		//Button the up arrow!
		public function upScrollText():void {
			this.userInterface.mainTextField.scrollV--;
			this.userInterface.updateScroll(this.userInterface.tempEvent);
		}
		//Button the down arrow!
		public function downScrollText():void {
			this.userInterface.mainTextField.scrollV++;
			this.userInterface.updateScroll(this.userInterface.tempEvent);
		}


		public function clickScrollUp(evt:MouseEvent):void {
			this.userInterface.upScrollButton.addEventListener(Event.ENTER_FRAME,continueScrollUp);
			stage.addEventListener(MouseEvent.MOUSE_UP,clearScrollUp);
		}
		public function clickScrollDown(evt:MouseEvent):void {
			this.userInterface.downScrollButton.addEventListener(Event.ENTER_FRAME,continueScrollDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,clearScrollDown);
		}
		public function continueScrollUp(evt:Event):void {
			this.userInterface.mainTextField.scrollV--;
			this.userInterface.updateScroll(this.userInterface.tempEvent);
		}
		public function continueScrollDown(evt:Event):void {
			this.userInterface.mainTextField.scrollV++;
			this.userInterface.updateScroll(this.userInterface.tempEvent);
		}
		public function clearScrollDown(evt:MouseEvent):void {
			this.userInterface.downScrollButton.removeEventListener(Event.ENTER_FRAME,continueScrollDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP,clearScrollDown);
		}
		public function clearScrollUp(evt:MouseEvent):void {
			this.userInterface.upScrollButton.removeEventListener(Event.ENTER_FRAME,continueScrollUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP,clearScrollUp);
		}

		//Turn dragging on and off!
		public function mouseDownHandler(evt:MouseEvent):void{
			var myRectangle:Rectangle = new Rectangle(this.userInterface.scrollBG.x, this.userInterface.scrollBG.y, 0, this.userInterface.scrollBG.height - this.userInterface.scrollBar.height);
			this.userInterface.scrollBar.startDrag(false,myRectangle);
			if(!this.userInterface.scrollBar.hasEventListener(Event.ENTER_FRAME)) this.userInterface.scrollBar.addEventListener(Event.ENTER_FRAME,scrollerUpdater);
		}
		public function mouseUpHandler(evt:MouseEvent):void{
			this.userInterface.scrollBar.stopDrag();
			this.userInterface.scrollBar.removeEventListener(Event.ENTER_FRAME,scrollerUpdater);
		}

		//Used to set position of bar while being dragged!
		public function scrollerUpdater(evt:Event):void {
			var progress:Number = (this.userInterface.scrollBar.y-this.userInterface.scrollBG.y) / (this.userInterface.scrollBG.height - this.userInterface.scrollBar.height - 1);
				//trace("FRAME UPDATE: " + progress);
				//trace("SCROLLBARY: " + scrollBar.y + " SCROLLBGY: " + scrollBG.y);
				//trace("SCROLLBAR: " + scrollBar.height + " SCROLLBG: " + scrollBG.height);
			var min = this.userInterface.mainTextField.scrollV;
			var max = this.userInterface.mainTextField.maxScrollV;
			this.userInterface.mainTextField.scrollV = progress * this.userInterface.mainTextField.maxScrollV;
				//trace("SCROLL V: " + this.userInterface.mainTextField.scrollV + " SHOULD BE: " + progress * this.userInterface.mainTextField.maxScrollV);
			scrollChecker();
		}



		//Turn up/down buttons on and off
		public function scrollChecker():void {
			var target = this.userInterface.mainTextField;
			if(!target.visible) target = this.userInterface.mainTextField2;
			//Turn off scroll button as appropriate.
			if(target.scrollV >= target.maxScrollV) {
				this.userInterface.downScrollButton.alpha = .50;
				this.userInterface.downScrollButton.buttonMode = false;
				this.userInterface.downScrollButton.removeEventListener(MouseEvent.MOUSE_DOWN,clickScrollDown);
			}
			else if(this.userInterface.downScrollButton.alpha == .5) {
				this.userInterface.downScrollButton.alpha = 1;
				this.userInterface.downScrollButton.buttonMode = true;
				this.userInterface.downScrollButton.addEventListener(MouseEvent.MOUSE_DOWN,clickScrollDown);
			}
			if(target.scrollV == 1) {
				this.userInterface.upScrollButton.alpha = .50;
				this.userInterface.upScrollButton.buttonMode = false;
				this.userInterface.upScrollButton.removeEventListener(MouseEvent.MOUSE_DOWN,clickScrollUp);
			}
			else if(this.userInterface.upScrollButton.alpha == .5) {
				this.userInterface.upScrollButton.alpha = 1;
				this.userInterface.upScrollButton.buttonMode = true;
				this.userInterface.upScrollButton.addEventListener(MouseEvent.MOUSE_DOWN,clickScrollUp);
			}
		}


		public function mainMenu():void 
		{
			trace("Main Menu called!");
			if(this.userInterface.leftSideBar.currentFrame >= 11) 
			{
				trace("HideMenus")
				this.userInterface.hideMenus();
			}
			
			//Hide all current buttons
			this.userInterface.hideNormalDisplayShit();
			
			//Show menu shits
			trace("Making everything visible:")
			this.userInterface.creditText.visible = true;
			this.userInterface.warningText.visible = true;
			this.userInterface.titleDisplay.visible = true;
			this.userInterface.warningBackground.visible = true;
			this.userInterface.websiteDisplay.visible = true;
			//if(leftSideBar.mainMenuButton.alpha == 1) 
			if(this.userInterface.leftSideBar.currentFrame >= 11) 
				this.userInterface.leftSideBar.mainMenuButton.filters = [this.userInterface.myGlow];
			
			//Texts
			this.userInterface.warningText.htmlText = "This is an adult game meant to be played by adults. Do not play this game\nif you are under the age of 18, and certainly don't\nplay this if exotic and strange fetishes disgust you. <b>You've been warned!</b>";
			this.userInterface.creditText.htmlText = "Created by Fenoxo, Text Parser written by Pervineer.\nEdited by Zeikfried, Prisoner416, and many more.\n<b>Game Version: " + this.version + "</b>";
			
			this.userInterface.addMainMenuButton(0,"New Game",creationRouter);
			this.userInterface.addMainMenuButton(1,"Data",dataRouter);
			this.userInterface.addMainMenuButton(2,"Credits",credits);
			this.userInterface.addMainMenuButton(3,"Easy Mode:\nOff",toggleEasy);
			this.userInterface.addMainMenuButton(4,"Debug Mode:\nOff",toggleDebug);
			this.userInterface.addMainMenuButton(5,"Silly Mode:\nOff",toggleSilly);
		}


		public function credits():void {
			this.userInterface.hideMenus();
			clearOutput2();
			output2("\nThis is a placeholder. Keep your eye on the 'Scene by:\' box in the lower left corner of the UI for information on who wrote scenes as they appear. Thank you!");
			this.userInterface.clearGhostMenu();
			this.userInterface.addGhostButton(0,"Back to Menu",mainMenu);
		}
		public function toggleSilly():void {
			if(silly) {
				silly = false;
				this.userInterface.mainMenuButtons[5].gotoAndStop(1);
				this.userInterface.mainMenuButtons[5].caption.text = "Silly Mode:\nOff"
			}
			else {
				silly = true;
				this.userInterface.mainMenuButtons[5].gotoAndStop(2);
				this.userInterface.mainMenuButtons[5].caption.text = "Silly Mode:\nOn"
			}
		}
		public function toggleDebug():void {
			if(debug) {
				debug = false;
				this.userInterface.mainMenuButtons[4].gotoAndStop(1);
				this.userInterface.mainMenuButtons[4].caption.text = "Debug Mode:\nOff"
			}
			else {
				debug = true;
				this.userInterface.mainMenuButtons[4].gotoAndStop(2);
				this.userInterface.mainMenuButtons[4].caption.text = "Debug Mode:\nOn"
			}
		}
		public function toggleEasy():void {
			if(easy) {
				easy = false;
				this.userInterface.mainMenuButtons[3].gotoAndStop(1);
				this.userInterface.mainMenuButtons[3].caption.text = "Easy Mode:\nOff"
			}
			else {
				easy = true;
				this.userInterface.mainMenuButtons[3].gotoAndStop(2);
				this.userInterface.mainMenuButtons[3].caption.text = "Easy Mode:\nOn"
			}
		}



	}
}