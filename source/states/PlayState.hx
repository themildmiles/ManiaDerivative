package states;

import flixel.group.FlxGroup.FlxTypedGroup;
import objects.Note;

using StringTools;

// temporary MWAHAHAHA
private class NoteDatas
{
	static public var chartLoaded:Chart;
	static public var unspawnedNotes:Array<Note>;
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

	var music:FlxSound;

    override public function create() {
		trace("Create!!");
        super.create();
		trace("Loading chart...again");
		chartLoaded = NoteDatas.chartLoaded;
		unspawnedNotes = NoteDatas.unspawnedNotes;

		trace("Load music file");
		music = FlxG.sound.load(chartLoaded.songFile);
		music.play(true, chartLoaded.crochet * -4);

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
    }

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

		var toRemove:Array<Note> = [];
		var judgmentLine = FlxG.height - 180;

		if (FlxG.keys.justPressed.D)
			checkLane(0);
		if (FlxG.keys.justPressed.F)
			checkLane(1);
		if (FlxG.keys.justPressed.J)
			checkLane(2);
		if (FlxG.keys.justPressed.K)
			checkLane(3);

		notes.forEach((note) ->
		{
			note.y = ((music.time - note.hitTime) / 750 * FlxG.height) + judgmentLine;

			note.x = FlxG.width / 2 + 125 * (note.column - 2);

			if (music.time > note.hitTime && autoplay)
			{
				registerHit(note);
			}

			var timeDiff:Float = music.time - note.hitTime;
			if (timeDiff > 140)
				registerMiss(note);

			if (note.hit)
				toRemove.push(note);
		});

		laneHit.forEach((note) -> note.alpha -= (note.alpha - 0.5) * 0.05);

		for (note in toRemove)
		{
			note.destroy();
			notes.remove(note);
		}

		scoreTxt.text = Std.string(Math.floor(scoreObj.score)).lpad("0", 8);
		comboTxt.text = Std.string(scoreObj.combo);
		accuracyTxt.text = '${Utilities.truncateFloat(scoreObj.accuracy, 2)}%\n${Utilities.truncateFloat(scoreObj.accuracyReal, 2)}%';
	}

	function checkLane(lane:Int)
	{
		laneHit.members[lane].alpha = 0.75;
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

	function registerHit(note:Note)
	{
		var judgeType:Int = 0;
		var timeDiff:Float = music.time - note.hitTime;

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
			if (comboPop != null)
				comboPop.cancel();
			comboPop = FlxTween.tween(comboTxt.scale, {x: 1, y: 1}, 0.5, {ease: FlxEase.expoOut, onComplete: t -> comboPop = null});
		}
	}

	function registerMiss(note:Note)
	{
		scoreObj.addHit(5);
		note.hit = true;
	}

	static public function loadChart(chartData:ChartPreview)
	{
		trace("Loading chart...");
		NoteDatas.chartLoaded = new Chart(chartData);

		NoteDatas.unspawnedNotes = NoteDatas.chartLoaded.notes; // NOT supposed to be added yet
    }
}