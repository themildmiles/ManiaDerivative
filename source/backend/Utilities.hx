package backend;

import backend.OptionsData.Options;
import objects.Note;

/**
	Will contain a bunch of helper functions.
**/
class Utilities
{
	/**
		Truncates floats to n decimals.
		```haxe
		var result = Utilities.truncateFloat(123.456, 1);
		trace(result); // 123.4
		```
	**/
	inline public static function truncateFloat(m:Float, n:Int)
		return Math.floor(m * Math.pow(10, n)) / Math.pow(10, n);
}

/**
	Used in `SongSelectState` and is required when making a `Chart`.
**/
typedef ChartPreview = 
{
	/**
		The path to the chart folder.
	**/
    var path:String;
    var title:String;
    var artist:String;
    var difficulty:String;
	/**
		Path to the song file. Does not include `path` folder.
	**/
    var songFile:Null<String>;
	/**
		The chart data from the chart file. Do not adjust this in any circumstances.
	**/
	var chartData:Dynamic;
}

/**
    This just helps setup the chart and handle information. 
**/
class Chart {
    public var title:String;
    public var artist:String;
    public var difficulty:String;

	public var bpm:Float;
	public var offset:Float;

	public var crochet(get, never):Float;

    public var notes:Array<Note>;

    public var songFile:Null<String>;

    /**
        This just helps setup the chart and handle information.
        Needs a `ChartPreview`.
    **/
    public function new(chartData:ChartPreview) 
    {
		trace("New chart!!!");
        this.title = chartData.title;
        this.artist = chartData.artist;
        this.difficulty = chartData.difficulty;

        var chartNotes:Array<Dynamic> = chartData.chartData.notes; // lmao

        this.notes = [];
		this.bpm = chartData.chartData.bpm;

		this.songFile = chartData.path + chartData.songFile;
		if (chartData.chartData.version < 2)
		{
			for (noteData in chartNotes)
				this.notes.push(new Note(noteData.beat,
					this.crochet * (noteData.beat[0] + noteData.beat[1] / noteData.beat[2]) + Options.options.offset + chartData.chartData.offset,
					noteData.column));
			this.offset = chartData.chartData.offset;
		}
		else
		{
			for (noteData in chartNotes)
				this.notes.push(new Note(noteData.beat,
					this.crochet * (noteData.beat[0] + noteData.beat[1] / noteData.beat[2]) + Options.options.offset + chartData.chartData.offset,
					noteData.column));
			this.offset = -chartData.chartData.offset;
		}
	}

	function get_crochet():Float
		return 60000 / bpm;
}

class Score
{
	var amtOfNotes:Int;

	public var combo:Int = 0;

	var maxCombo:Int = 0;
	var maxScoringCombo:Float;
	var currentScoringCombo:Float;

	var accuracyHit:Float = 0;
	var shownAccuracyHit:Float = 0;
	var accuracyCurrentTotal:Int = 0;

	public var judgementCounter:Array<Int>;
	private var missCombo:Int = 0;

	/**
		From 0 to 10,000,000 heheh
	**/
	public var score(get, never):Float;

	/**
		0-100%.
	**/
	public var accuracy(get, never):Float;

	/**
		0-100%, but more accurate.
	**/
	public var accuracyReal(get, never):Float;

	/**
		The rank.
	**/
	public var rank(get, never):String;

	/**
		Health :P
	**/
	public var health:Float = 100;

	public function new(amtOfNotes:Int)
	{
		this.amtOfNotes = amtOfNotes;
		this.judgementCounter = [0, 0, 0, 0, 0, 0];
		for (i in 0...amtOfNotes)
		{
			maxScoringCombo += Math.pow(1.002, Math.pow(i + 1, 0.9)) - 1;
		}
	}

	/**
		Register hit.
	**/
	public function addHit(type:Int)
	{
		combo++;
		maxCombo = maxCombo < combo ? combo : maxCombo;
		accuracyCurrentTotal++;
		switch (type)
		{
			case 0: // MARVELOUS!!!
				currentScoringCombo += Math.pow(1.00201, Math.pow(maxCombo, 0.9)) - 1;
				accuracyHit += 1.02;
				shownAccuracyHit++;
				health += 2;
				missCombo = 0;

			case 1: // PERFECT!!
				currentScoringCombo += Math.pow(1.0020075, Math.pow(maxCombo, 0.9)) - 1;
				accuracyHit++;
				shownAccuracyHit++;
				health += 1.75;
				missCombo = 0;

			case 2: // GREAT!
				currentScoringCombo += Math.pow(1.002005, Math.pow(maxCombo, 0.9)) - 1;
				accuracyHit += 0.75;
				shownAccuracyHit += 0.75;
				health += 1;
				missCombo = 0;

			case 3: // GOOD
				combo--; // revert adding combo but not reset it
				currentScoringCombo += Math.pow(1.002, Math.pow(maxCombo, 0.9)) - 1;
				accuracyHit += 0.4;
				shownAccuracyHit += 0.4;
				missCombo = 0;

			case 4: // BAD
				combo = 0;
				currentScoringCombo += Math.pow(1.002, Math.pow(maxCombo, 0.9)) - 1;
				accuracyHit += 0.1;
				shownAccuracyHit += 0.1;

				health -= 5 * Math.pow(1.05, missCombo / 2);

			case 5: // MISS!
				combo = 0;
				missCombo++;
				health -= 10 * Math.pow(1.1, (missCombo - 1) / 3);
		}

		health = Math.min(health, 100);

		judgementCounter[type]++;
	}

	function get_score():Float
	{
		return ((currentScoringCombo / maxScoringCombo) * 0.5 + (accuracyHit / amtOfNotes) * 0.5) * 1e7;
	}

	function get_accuracy():Float
	{
		return (shownAccuracyHit / accuracyCurrentTotal) * 100;
	}

	function get_accuracyReal():Float
	{
		return (accuracyHit / accuracyCurrentTotal) * 100;
    }

	function get_rank():String
	{
		var accuracyReal:Float = accuracyReal / 100;
		var accuracy:Float = accuracy / 100;
		if (accuracyReal == 1)
			return "SSS";
		if (accuracy == 1)
			return "SS+";
		if (accuracy >= 0.9975)
			return "SS";
		if (accuracy >= 0.995)
			return "SS-";
		if (accuracy >= 0.99)
			return "S+";
		if (accuracy >= 0.98)
			return "S";
		if (accuracy >= 0.95)
			return "A+";
		if (accuracy >= 0.9)
			return "A";
		if (accuracy >= 0.85)
			return "B";
		if (accuracy >= 0.8)
			return "C";
		return "F";
	}
}