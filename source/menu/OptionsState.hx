package menu;

import backend.OptionsData.Options;
import flixel.group.FlxGroup;

class OptionsState extends FlxState {
    var options:Array<Dynamic> = [
        {
            name: "Note Speed",
            desc: "How fast notes go the hitpoint. Pretty self explanatory.",

            vb: "noteSpeed",
            type: "number",
            scrollSpeed: 0.1,
            min: 1, max: 30
        },

        {
            name: "Chart Offset",
            desc: "How late the notes will be. Go to negative values for them to appear earlier.",

            vb: "offset",
            type: "number",
            scrollSpeed: 5,
            min: -10000, max: 10000 // idk
        },

        {
            name: "Show Judgement",
            desc: "How late the notes will be. Go to negative values for them to appear earlier.",

            vb: "hideMode",
            type: "str",
            options: [
                "Show all",
                "Hide \"MARVELOUS!!!\" judgements",
                "Hide \"PERFECT!!\" judgements"
            ]
        }
    ];
    var optionIndex:Int = 0;

    var titleText:FlxText;
	var optionTexts:FlxTypedGroup<FlxText>;

    override function create() {
        super.create();

        titleText = new FlxText(0, 100, FlxG.width, "Options", 80);
		titleText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 80, FlxColor.WHITE, CENTER);

		optionTexts = new FlxTypedGroup<FlxText>();

        // lol im over here grabbing my code from song select
        for (OI in 0...options.length)
        {
            var option:Dynamic = options[OI];
            var optionText:FlxText = new FlxText(0, 300 + OI * 40, FlxG.width, '${option.name}: ${Reflect.field(Options.options, option.vb)}');
            optionText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 27, FlxColor.WHITE, CENTER);

            if (option.type == "str")
                optionText.text = '${option.name}: ${option.options[Reflect.field(Options.options, option.vb)]}';

            optionTexts.add(optionText);
        }

        add(titleText);
        add(optionTexts);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP)
		{
			optionIndex--;
			if (optionIndex < 0)
				optionIndex = options.length - 1;
		}
		else if (FlxG.keys.justPressed.DOWN)
			optionIndex = (optionIndex + 1) % options.length;

        var option:Dynamic = options[optionIndex];
        if (FlxG.keys.justPressed.LEFT)
        {
            switch(option.type) {
                case "number":
                    Reflect.setField(Options.options, option.vb, Math.max(Reflect.field(Options.options, option.vb) - option.scrollSpeed, option.min));
                
                case "str":
                    var vari:Float = Reflect.field(Options.options, option.vb) - 1;
                    if (vari < 0)
                        vari = option.options.length-1;

                    Reflect.setField(Options.options, option.vb, vari);
            }
        }
        else if (FlxG.keys.justPressed.RIGHT)
        {
            switch(option.type) {
                case "number":
                    Reflect.setField(Options.options, option.vb, Math.min(Reflect.field(Options.options, option.vb) + option.scrollSpeed, option.max));
                
                case "str":
                    var vari:Float = (Reflect.field(Options.options, option.vb) + 1) % option.options.length;
                    Reflect.setField(Options.options, option.vb, vari);
            }
        }

        for (OI in 0...options.length)
        {
            var optionText:FlxText = optionTexts.members[OI];
            var option:Dynamic = options[OI];

            optionText.text = '${option.name}: ${Reflect.field(Options.options, option.vb)}';
            if (option.type == "str")
                optionText.text = '${option.name}: ${option.options[Reflect.field(Options.options, option.vb)]}';

            optionText.y = 300 + (OI - optionIndex) * 40;
            optionText.alpha = Math.max(0, 1 - Math.abs(OI - optionIndex) * 0.2);
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            Options.save();
            FlxG.switchState(MenuState.new);
        }
    }
}