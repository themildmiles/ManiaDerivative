package objects;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import openfl.display.BlendMode;

// The hit error meter from FNF-ManiaEngine
class HitErrorMeter extends FlxSpriteGroup {
    private var errors:Array<FlxSprite> = [];
    private static var errorGraphic:flixel.graphics.FlxGraphic;

    public var errorWidth:Int;
    public function new(y:Float, width:Int) {
        super(FlxG.width / 2 - width / 2, FlxG.height / 2 - y);
		this.blend = BlendMode.ADD;
        this.errorWidth = width;
		add(new FlxSprite().makeGraphic(width, 50, 0x20000000));
		add(new FlxSprite(width / 2 - 2.5, 25).makeGraphic(5, 20, 0xFFFFFFFF));
        var bar:FlxSprite;

		bar = new FlxSprite(15, 30).makeGraphic(Std.int(width - 30), 10, 0xFFFF0000);
        add(bar);

		bar = new FlxSprite(15, 30).makeGraphic(Std.int(width - 30), 10, 0xFFFFFB20);
        bar.scale.x = 120 / 140;
        add(bar);
        
		bar = new FlxSprite(15, 30).makeGraphic(Std.int(width - 30), 10, 0xFF00FF00);
        bar.scale.x = 85 / 140;
        add(bar);
        
		bar = new FlxSprite(15, 30).makeGraphic(Std.int(width - 30), 10, 0xFF00D9FF);
        bar.scale.x = 50 / 140;
        add(bar);

		bar = new FlxSprite(15, 30).makeGraphic(Std.int(width - 30), 10, 0xFFFFFFFF);
        bar.scale.x = 25 / 140;
        add(bar);
    }

    public function registerError(noteDev:Float, judgeType:Int) {
        errorGraphic = FlxG.bitmap.add("assets/images/bar_error.png");
        var errorSprite:Null<FlxSprite>;
        try
        {
			errorSprite = new FlxSprite(errorWidth / 2 + (errorWidth / 2 - 15) * (noteDev / 140) - 2.5, 5).loadGraphic(errorGraphic);
			errorSprite.alpha = 0.875;
            errorSprite.color = switch(judgeType) {
				case 0: 0xAAFFFFFF;
				case 1: 0xAA00D9FF;
				case 2: 0xAA00FF00;
				case 3: 0xAAFFFB20;
				case 4: 0xAAFF0000;
				default: 0xAAFFFFFF;
            };
			errorSprite.blend = BlendMode.ADD;
            
			FlxTween.tween(errorSprite, {alpha: 0}, 1, {startDelay: 3, onComplete: T -> remove(errorSprite).destroy()});

            add(errorSprite);
        }
        catch(error)
        {
            trace(error);
        }
    }
}