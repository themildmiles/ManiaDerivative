package states;

import backend.OptionsData.Options;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import haxe.ds.Option;
import objects.HitErrorMeter;
import objects.Note;

using StringTools;

// temporary MWAHAHAHA
private class NoteDatas
{
	static public var chartLoaded:Chart;
	static public var unspawnedNotes:Array<Note>;
	static public function destroy()
	{
		chartLoaded = null;
		unspawnedNotes = null;
	}
}

class PlayState extends FlxState
{
    var chartLoaded:Chart;

	// yes.
	var autoplay:Bool = false;

    // lol
    var unspawnedNotes:Array<Note>;
    var notes:FlxTypedGroup<Note>;
	var laneHit:FlxTypedGroup<Note>;

	// scoring system
	var scoreObj:Score;
	var scoreTxt:FlxText;
	var comboTxt:FlxText;
	var accuracyTxt:FlxText;
	var hitErrorMeter:HitErrorMeter;

	var judgementSprite:FlxSprite;
	var judgementGraphics:Array<FlxGraphic>;

	var music:FlxSound;
	var musicDone:Bool = false;

    override public function create() {
		trace("Create!!");
        super.create();
		trace("Loading chart...again");
		chartLoaded = NoteDatas.chartLoaded;
		unspawnedNotes = NoteDatas.unspawnedNotes;

		NoteDatas.destroy();

		trace("Load music file");
		music = FlxG.sound.load(chartLoaded.songFile);

		trace("Init score!");
		scoreObj = new Score(unspawnedNotes.length);

		trace("Notes!");
		laneHit = new FlxTypedGroup<Note>();
		add(laneHit);

		for (i in 0...4)
		{
			var note:Note = new Note([0, 0, 0], 0, i);
			note.alpha = 0.5;
			note.x = FlxG.width / 2 + 125 * (i - 2);
			note.y = FlxG.height - 180;

			laneHit.add(note);
		}

		notes = new FlxTypedGroup<Note>();
		add(notes);

		judgementSprite = new FlxSprite(0, 200);
		judgementSprite.antialiasing = true;
		judgementSprite.alpha = 0;
		add(judgementSprite);

		scoreTxt = new FlxText(0, 0, 0, "00000000");
		scoreTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 40, FlxColor.WHITE, LEFT, OUTLINE);
		add(scoreTxt);

		accuracyTxt = new FlxText(0, 50, 0, "");
		accuracyTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 20, FlxColor.WHITE, LEFT, OUTLINE);
		add(accuracyTxt);

		comboTxt = new FlxText(0, 100, FlxG.width, "0");
		comboTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 60, FlxColor.WHITE, CENTER, OUTLINE);
		add(comboTxt);
		comboTxt.antialiasing = true;
		hitErrorMeter = new HitErrorMeter(-FlxG.height / 2 + 90, 300);
		add(hitErrorMeter);
    }

	var displayedScore:Float = 0;
	var toRemove:Array<Note> = []; // optimize
    override public function update(elapsed:Float) {
        super.update(elapsed);
		// trace(music.time);
		while (unspawnedNotes.length > 0)
		{
			var note = unspawnedNotes[0];
			if (note.hitTime - 1500 < music.time)
			{
				notes.add(note);
				unspawnedNotes.shift(); // remove first note
			}
			else
			{
				break; // remaining notes are too far in the future
			}
		}

		toRemove.resize(0);
		var judgmentLine = FlxG.height - 180;

		if (!autoplay)
		{
			if (FlxG.keys.justPressed.D)
				checkLane(0);
			if (FlxG.keys.justPressed.F)
				checkLane(1);
			if (FlxG.keys.justPressed.J)
				checkLane(2);
			if (FlxG.keys.justPressed.K)
				checkLane(3);
		}

		var centerX = FlxG.width / 2;
		notes.forEach((note) ->
		{
			note.y = ((music.time - note.hitTime) / 750 * FlxG.height * (Options.options.noteSpeed / 15)) + judgmentLine;

			note.x = centerX + 125 * (note.column - 2);

			if (music.time > note.hitTime && autoplay)
			{
				registerHit(note);
			}

			var timeDiff:Float = music.time - note.hitTime;
			if (timeDiff > 140 && !note.hit)
				registerMiss(note);

			if (note.hit)
				toRemove.push(note);
		});

		laneHit.forEach((note) -> note.alpha -= (note.alpha - 0.2) * 0.075);

		for (note in toRemove)
		{
			note.destroy();
			notes.remove(note, true);
		}

		if (music.playing || musicDone)
		{
			displayedScore += (scoreObj.score - displayedScore) * 0.2;
			scoreTxt.text = Std.string(Math.round(displayedScore)).lpad("0", 8);
			comboTxt.text = Std.string(scoreObj.combo);
			comboTxt.size = 60;
			accuracyTxt.text = '${Utilities.truncateFloat(Math.isNaN(scoreObj.accuracy) ? 100 : scoreObj.accuracy, 2)}%';
		}
		else
		{
			comboTxt.text = "Press any key to begin";
			comboTxt.size = 30;

			if (FlxG.keys.anyJustPressed([FlxKey.D, FlxKey.F, FlxKey.J, FlxKey.K]))
			{
				music.play(true, chartLoaded.crochet * -4);
				music.onComplete = () ->
				{
					musicDone = true;
					var flash = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					add(flash);
					flash.alpha = 0;
					FlxTween.tween(flash, {alpha: 1}, 0.4, {
						onComplete: t ->
						{
							EndScreenState.loadGameData(scoreObj, chartLoaded);
							FlxG.switchState(EndScreenState.new);
						}
					});
				}
			}
		}
	}

	inline function checkLane(lane:Int)
	{
		laneHit.members[lane].alpha = 0.9;
		var actuallyHit:Bool = false;
		notes.forEachAlive((note) ->
		{
			if (!note.hit && !actuallyHit)
			{
				var timeDiff = music.time - note.hitTime;
				if (note.column == lane && Math.abs(timeDiff) <= 140)
				{
					actuallyHit = true;
					registerHit(note);
					return;
				}
			}
		});
	}

	var comboPop:Null<FlxTween> = null;
	var judgePop:Null<FlxTween> = null;

	function registerHit(note:Note)
	{
		var judgeType:Int = 0;
		var timeDiff:Float = music.time - note.hitTime;
		if (autoplay)
			timeDiff = 0;

		if (Math.abs(timeDiff) > 25)
			judgeType = 1;
		if (Math.abs(timeDiff) > 50)
			judgeType = 2;
		if (Math.abs(timeDiff) > 85)
			judgeType = 3;
		if (Math.abs(timeDiff) > 120)
			judgeType = 4;

		scoreObj.addHit(judgeType);
		note.hit = true;

		if (judgeType < 3)
		{
			comboTxt.scale.x *= 1.1;
			comboTxt.scale.y *= 1.1;
			if (comboPop != null && !comboPop.finished)
				comboPop.cancel();
			comboPop = FlxTween.tween(comboTxt.scale, {x: 1, y: 1}, 0.5, {ease: FlxEase.expoOut});
		}
		if (judgeType > Options.options.hideMode - 1)
			popRating(judgeType);
		hitErrorMeter.registerError(timeDiff, judgeType);
	}

	inline function popRating(judgeType:Int)
	{
		judgementSprite.loadGraphic('assets/images/rating/$judgeType.png');
		judgementSprite.x = FlxG.width / 2 - judgementSprite.width / 2;
		judgementSprite.scale.set(2, 2);
		judgementSprite.alpha = 1;
		if (judgePop != null && !judgePop.finished)
			judgePop.cancel();
		judgePop = FlxTween.tween(judgementSprite.scale, {x: 1.5, y: 1.5}, 0.4, {
			ease: FlxEase.expoOut,
			onComplete: t ->
			{
				judgePop = FlxTween.tween(judgementSprite, {alpha: 0}, 0.2, {
					ease: FlxEase.expoIn
				});
			}
		});
	}

	function registerMiss(note:Note)
	{
		scoreObj.addHit(5);
		note.hit = true;
		popRating(5);
	}

	static public function loadChart(chartData:ChartPreview)
	{
		trace("Loading chart...");
		NoteDatas.chartLoaded = new Chart(chartData);

		NoteDatas.unspawnedNotes = NoteDatas.chartLoaded.notes; // NOT supposed to be added yet
    }
	override function onFocusLost() {}
}