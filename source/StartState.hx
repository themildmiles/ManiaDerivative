package;

class StartState extends FlxState
{
	var titleText:FlxText;
	var enterText:FlxText;
	var escaped:Bool = false;
	var time:Float = 0;
	
	override public function create()
	{
		super.create();

		titleText = new FlxText(0, 100, FlxG.width, "ManiaDerivative", 120);
		titleText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 120, FlxColor.WHITE, CENTER);

		enterText = new FlxText(0, 500, FlxG.width, "Press any key to begin", 27);
		enterText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 27, FlxColor.WHITE, CENTER);

		add(titleText);
		add(enterText);

		FlxG.camera.flash(FlxColor.WHITE);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		time += elapsed;

		enterText.scale.set(1 + 0.1 * Math.sin(time), 1 + 0.1 * Math.sin(time));

		if (FlxG.keys.justPressed.ESCAPE && !escaped)
		{
			escaped = true;
			Sys.exit(0);
		}
		
		if (FlxG.keys.justPressed.ANY && !escaped) 
			FlxG.switchState(MenuState.new);
	}
}
