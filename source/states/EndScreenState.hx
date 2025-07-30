package states;

import flixel.group.FlxGroup.FlxTypedGroup;
import menu.SongSelectState;

using StringTools;

// temporary MWAHAHAHA
private class GameDatas
{
	static public var scoreObj:Score;
	static public var chartLoaded:Chart;
	static public function destroy()
	{
		chartLoaded = null;
		scoreObj = null;
	}
}

class EndScreenState extends FlxState {
	var chartLoaded:Chart;
	// scoring system
	var scoreObj:Score;
	var scoreTxt:FlxText;
	var accuracyTxt:FlxText;
	var judgementTexts:FlxTypedGroup<FlxText>;
	var rankTxt:FlxText;
	var continueTxt:FlxText;
	var allowExit:Bool = false;

    override public function create() {
        super.create();

		scoreObj = GameDatas.scoreObj;
		chartLoaded = GameDatas.chartLoaded;
		GameDatas.destroy();

		var chartTxt:FlxText = new FlxText(0, 40, 0, '${chartLoaded.title}\n${chartLoaded.difficulty}\n${chartLoaded.artist}');
		chartTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 40, FlxColor.WHITE, LEFT, OUTLINE);
		add(chartTxt);

		scoreTxt = new FlxText(0, 40, FlxG.width, "00000000");
		scoreTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 120, FlxColor.WHITE, CENTER, OUTLINE);
		add(scoreTxt);

		FlxTween.num(0, scoreObj.score, 1.5, {ease: FlxEase.expoOut},                                         
		n -> {
			scoreTxt.text = Std.string(Math.floor(n)).lpad("0", 8);
		});

		accuracyTxt = new FlxText(0, 200, FlxG.width, "");
		accuracyTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 40, FlxColor.WHITE, CENTER, OUTLINE);
		add(accuracyTxt);

		FlxTween.num(0, scoreObj.accuracy, 1, {ease: FlxEase.expoOut},                                        
		n -> {
			accuracyTxt.text = '${Utilities.truncateFloat(n, 2)}%';
		});

		judgementTexts = new FlxTypedGroup<FlxText>();
		var judgementNames = ["MARVELOUS!!!", "PERFECT!!", "GREAT!", "GOOD", "BAD...", "MISS!"];

		for (i in 0...6)
		{
			var judgementTxt:FlxText = new FlxText(-400, 400 + i * 42.5, 0, "");
			judgementTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 30, FlxColor.WHITE, LEFT, OUTLINE);
			judgementTexts.add(judgementTxt);

			judgementTxt.alpha = 0;
			judgementTxt.text = '${judgementNames[i]} - ${scoreObj.judgementCounter[i]}';

			FlxTween.tween(judgementTxt, {x: FlxG.width / 2 - 300, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: 0.75 + i * 0.1});
		}

		rankTxt = new FlxText(100, 400, FlxG.width, scoreObj.rank);
		rankTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 120, FlxColor.WHITE, CENTER, OUTLINE);
		add(rankTxt);

		rankTxt.antialiasing = true;
		rankTxt.scale.set(1.25, 1.25);
		rankTxt.alpha = 0;

		FlxTween.tween(rankTxt, {'scale.x': 1, 'scale.y': 1, alpha: 1}, 1,
			{ease: n -> Math.pow(n, 10 / 3), startDelay: 1, onComplete: t -> FlxG.camera.flash()});

		add(judgementTexts);

		continueTxt = new FlxText(0, FlxG.height, FlxG.width, "Press ENTER to continue . . .");
		continueTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 40, FlxColor.WHITE, CENTER, OUTLINE);
		add(continueTxt);
		continueTxt.alpha = 0;

		FlxTween.tween(continueTxt, {y: FlxG.height - continueTxt.height, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: 2, onStart: t -> allowExit = true});

		FlxG.camera.flash(FlxColor.BLACK, 1/3);
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (allowExit && FlxG.keys.justPressed.ENTER)
			FlxG.switchState(SongSelectState.new);
	}

	public static function loadGameData(scoreObj:Score, chartLoaded:Chart) {
		GameDatas.scoreObj = scoreObj;
		GameDatas.chartLoaded = chartLoaded;
	}
}