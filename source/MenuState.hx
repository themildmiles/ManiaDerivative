package;

class MenuState extends FlxState
{
	var titleText:FlxText;
	var enterText:FlxText;
	var allowEnter:Bool;

	var time:Float = 0;
	
	override public function create()
	{
		super.create();

		titleText = new FlxText(0, 100, FlxG.width, "Menu", 120);
		titleText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 120, FlxColor.WHITE, CENTER);

		enterText = new FlxText(0, 500, FlxG.width, "", 27);
		enterText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 27, FlxColor.WHITE, CENTER);

		add(titleText);
		add(enterText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
