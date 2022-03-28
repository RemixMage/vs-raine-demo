package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';
	var curMod:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitMiddle:FlxSprite;
	var portraitGhost:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'shortstack':
				FlxG.sound.playMusic(Paths.music('basementArcade', 'raine'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.5);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
					bgFade.alpha = .5;
					bgFade.alpha += (.05);
					if (bgFade.alpha > 0.7)
					bgFade.alpha = 0.7;
		}, 5);

	if (PlayState.SONG.song.toLowerCase(  ) == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
	{
		box = new FlxSprite(0, 0);
	}
	else
	{
		box = new FlxSprite(70, 370);
	}
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble');
				box.animation.addByPrefix('normal', 'speech bubble normal', 24);
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('center-normal', 'speech bubble middle', 24);
				box.setGraphicSize(Std.int(box.width * 0.9));
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
	if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
	{
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
	}
		else
	{
		portraitLeft = new FlxSprite(-250, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('port/rainePort', 'raine');
		portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.175));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
	}

	if (PlayState.SONG.song.toLowerCase() == 'senpai')
	{
		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
	}
	else
	{
		portraitRight = new FlxSprite(100, 40);
		portraitRight.frames = Paths.getSparrowAtlas('port/bfPort', 'raine');
		portraitRight.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.15));
		portraitRight.updateHitbox();
		portraitRight.flipX = true;
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
	}
		portraitMiddle = new FlxSprite(200, 40);
		portraitMiddle.frames = Paths.getSparrowAtlas('port/gfPort', 'raine');
		portraitMiddle.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
		portraitMiddle.setGraphicSize(Std.int(portraitMiddle.width * PlayState.daPixelZoom * 0.15));
		portraitMiddle.updateHitbox();
		portraitMiddle.scrollFactor.set();
		add(portraitMiddle);
		portraitMiddle.visible = false;

		portraitGhost = new FlxSprite(-250, 40);
		portraitGhost.frames = Paths.getSparrowAtlas('port/ghostHelloPort', 'raine');
		portraitGhost.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
		portraitGhost.setGraphicSize(Std.int(portraitGhost.width * PlayState.daPixelZoom * 0.175));
		portraitGhost.updateHitbox();
		portraitGhost.scrollFactor.set();
		add(portraitGhost);
		portraitGhost.visible = false;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * 1));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

	if (PlayState.SONG.song.toLowerCase(  ) == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
	{
		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox', 'week6'));
		add(handSelect);
	}

	if (PlayState.SONG.song.toLowerCase(  ) == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
	{
		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
	}
	else
	{
		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		remove(dropText);

		swagDialogue = new FlxTypeText(90, 500, Std.int(FlxG.width * 1), "", 32);
		swagDialogue.font = 'PhantomMuff 1.5';
		swagDialogue.color = 0xFF000000;
		add(swagDialogue);
	}

		dialogue = new Alphabet(0, 20, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'shortstack')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 10;
						bgFade.alpha -= 1 / 10 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 10;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(.5, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{		
			case 'dad':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitRight.frames = Paths.getSparrowAtlas('port/bfPort', 'raine');
				portraitRight.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitRight.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText', 'shared'), 0.6)];
				box.animation.play('normal');
				box.flipX = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
				else
				{
					portraitRight.animation.play('static');
				}
			case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGhost.visible = false;
				portraitMiddle.frames = Paths.getSparrowAtlas('port/gfPort', 'raine');
				portraitMiddle.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitMiddle.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText', 'shared'), 0.6)];
				portraitMiddle.visible = true;
				portraitMiddle.animation.play('static');
				box.animation.play('center-normal');
			case 'bftaunt':
				portraitLeft.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitRight.frames = Paths.getSparrowAtlas('port/bfTauntPort', 'raine');
				portraitRight.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitRight.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText', 'shared'), 0.6)];
				box.animation.play('normal');
				box.flipX = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
				else
				{
					portraitRight.animation.play('static');
				}
			case 'bfconf':
				portraitLeft.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitRight.frames = Paths.getSparrowAtlas('port/bfConfPort', 'raine');
				portraitRight.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitRight.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText', 'shared'), 0.6)];
				box.animation.play('normal');
				box.flipX = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
				else
				{
					portraitRight.animation.play('static');
				}
			case 'bfgf':
				portraitLeft.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitRight.frames = Paths.getSparrowAtlas('port/bfGfPort', 'raine');
				portraitRight.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText', 'shared'), 0.6)];
				box.animation.play('normal');
				box.flipX = false;
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			case 'raineclip':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('port/raineClipPort', 'raine');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitLeft.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('raineText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
				else
				{
					portraitLeft.animation.play('static');
				}
			case 'rainemiss':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('port/raineMissPort', 'raine');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('raineText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'rainehi':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('port/raineHelloPort', 'raine');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitLeft.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('raineText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
				else
				{
					portraitLeft.animation.play('static');
				}
			case 'raine':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('port/rainePort', 'raine');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitLeft.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('raineText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
				else
				{
					portraitLeft.animation.play('static');
				}
			case 'rainesing':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('port/raineSingPort', 'raine');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitLeft.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('raineText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
				else
				{
					portraitLeft.animation.play('static');
				}
			case 'rainelose':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('port/raineLosePort', 'raine');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('raineText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'rainemad':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('port/raineMadPort', 'raine');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitLeft.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('raineText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
				else
				{
					portraitLeft.animation.play('static');
				}
			case 'raineworr':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('port/raineWorryPort', 'raine');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				portraitLeft.animation.addByPrefix('static', 'fred', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('raineText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
				else
				{
					portraitLeft.animation.play('static');
				}
			case 'ghosthi':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.frames = Paths.getSparrowAtlas('port/ghostHelloPort', 'raine');
				portraitGhost.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ghostText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				portraitGhost.visible = true;
				portraitGhost.animation.play('enter');
			case 'ghostnerv':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.frames = Paths.getSparrowAtlas('port/ghostNervPort', 'raine');
				portraitGhost.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ghostText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				portraitGhost.visible = true;
				portraitGhost.animation.play('enter');
			case 'ghostmnerv':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.frames = Paths.getSparrowAtlas('port/ghostMoreNervPort', 'raine');
				portraitGhost.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ghostText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				portraitGhost.visible = true;
				portraitGhost.animation.play('enter');
			case 'ghostfour':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.frames = Paths.getSparrowAtlas('port/ghostFourPort', 'raine');
				portraitGhost.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ghostText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				portraitGhost.visible = true;
				portraitGhost.animation.play('enter');
			case 'ghostsmug':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitGhost.frames = Paths.getSparrowAtlas('port/ghostSmugPort', 'raine');
				portraitGhost.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ghostText'), 0.6)];
				box.animation.play('normal');
				box.flipX = true;
				portraitGhost.visible = true;
				portraitGhost.animation.play('enter');
			}
	switch (curMod)
		{
			case 'miss':
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
				camera.shake(0.02, 0.2);
				FlxG.sound.music.volume = 0;
			case 'revolume':
				FlxG.sound.music.fadeIn(1, 0, 0.5);
			case 'slowtext':
				swagDialogue.start(0.2, true);
			case 'fasttext':
				swagDialogue.start(0.04, true);
			case 'beep':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText', 'shared'), 0)];
				FlxG.sound.play(Paths.sound('bfBeep'));
			case 'nobeep':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('raineText', 'shared'), 0.6)];	
			case 'shakeymad':
				camera.shake(0.02, 0.2);
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curMod = splitName[0];
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[0].length + 2).trim();
	}
}