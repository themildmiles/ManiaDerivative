package states;

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
	// scoring system
	var scoreObj:Score;
	var scoreTxt:FlxText;
	var accuracyTxt:FlxText;

    override public function create() {
        super.create();

		scoreObj = GameDatas.scoreObj;

		scoreTxt = new FlxText(0, 40, FlxG.width, "00000000");
		scoreTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 120, FlxColor.WHITE, CENTER, OUTLINE);
		add(scoreTxt);

		FlxTween.num(0, scoreObj.score, 3, {ease: FlxEase.sineIn, onComplete: t -> FlxG.camera.flash(FlxColor.WHITE, 0.3)}, 
		n -> {
			scoreTxt.text = Std.string(Math.floor(n)).lpad("0", 8);
		});

		accuracyTxt = new FlxText(0, 200, FlxG.width, "");
		accuracyTxt.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 40, FlxColor.WHITE, CENTER, OUTLINE);
		add(accuracyTxt);

		FlxTween.num(0, scoreObj.accuracy, 1.5, {ease: FlxEase.sineIn, onComplete: t -> FlxG.camera.flash(FlxColor.WHITE, 0.3)}, 
		n -> {
			accuracyTxt.text = '${Utilities.truncateFloat(n, 2)}%';
		});

		FlxG.camera.flash(FlxColor.BLACK, 1/3);
    }

	public static function loadGameData(scoreObj:Score, chartLoaded:Chart) {
		GameDatas.scoreObj = scoreObj;
		GameDatas.chartLoaded = chartLoaded;
	}
}