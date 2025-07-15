package menu;

import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

class MenuState extends FlxState
{
	var titleText:FlxText;
	var optionText:FlxText;
	var hasSelected:Bool = false;

	var time:Float = 0;

	var options:Array<String> = ["Play", "Options", "Quit"];
	var optionsIndex:Int = 0;
	var optionMarkdown:Array<FlxTextFormatMarkerPair> = [];
	
	override public function create()
	{
		super.create();

		titleText = new FlxText(0, 100, FlxG.width, "ManiaDerivative", 120);
		titleText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 120, FlxColor.WHITE, CENTER);

		optionText = new FlxText(0, 500, FlxG.width, "", 27);
		optionText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 27, FlxColor.WHITE, CENTER);

		add(titleText);
		add(optionText);

		optionMarkdown.push(new FlxTextFormatMarkerPair(new FlxTextFormat(0xffffff00), "|"));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.UP)
		{
			optionsIndex--;
			if (optionsIndex < 0)
				optionsIndex = options.length - 1;
		}
		else if (FlxG.keys.justPressed.DOWN)
			optionsIndex = (optionsIndex + 1) % options.length;
		else if (FlxG.keys.justPressed.ENTER)
		{
			switch (optionsIndex)
			{
				case 0:
					FlxG.switchState(SongSelectState.new);

				case 1:
					FlxG.switchState(OptionsState.new);

				case 2:
					trace("See you next time");
					Sys.exit(0);
			}
		}

		var optionStr:String = "";
		for (index in 0...options.length)
			if (index == optionsIndex)
				optionStr += '|> ${options[index]} <|\n';
			else
				optionStr += '${options[index]}\n';

		optionText.applyMarkup(optionStr, optionMarkdown);
	}
}
