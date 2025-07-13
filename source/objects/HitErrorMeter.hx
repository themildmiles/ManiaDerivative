package objects;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

// The hit error meter from FNF-ManiaEngine
class HitErrorMeter extends FlxSpriteGroup {
    private var errors:Array<FlxSprite> = [];
    private static var errorGraphic:flixel.graphics.FlxGraphic;

    public var errorWidth:Int;
    public function new(y:Float, width:Int) {
        super(FlxG.width / 2 - width / 2, FlxG.height / 2 - y);
        this.errorWidth = width;
        add(new FlxSprite().makeGraphic(width, 50, 0x80000000));
        var bar:FlxSprite;

        bar = new FlxSprite(15,20).makeGraphic(Std.int(width - 30), 10, 0xFF7F00FF);
        add(bar);

        bar = new FlxSprite(15,20).makeGraphic(Std.int(width - 30), 10, 0xFF2020FF);
        bar.scale.x = 120 / 140;
        add(bar);
        
        bar = new FlxSprite(15,20).makeGraphic(Std.int(width - 30), 10, 0xFF80FF00);
        bar.scale.x = 85 / 140;
        add(bar);
        
        bar = new FlxSprite(15,20).makeGraphic(Std.int(width - 30), 10, 0xFF00FFC8);
        bar.scale.x = 50 / 140;
        add(bar);

        bar = new FlxSprite(15,20).makeGraphic(Std.int(width - 30), 10, 0xFFFFFFFF);
        bar.scale.x = 25 / 140;
        add(bar);
    }

    public function registerError(noteDev:Float, judgeType:Int) {
        errorGraphic = FlxG.bitmap.add("assets/images/bar_error.png");
        var errorSprite:Null<FlxSprite>;
        try
        {
            errorSprite = new FlxSprite(errorWidth / 2 + (errorWidth / 2 - 15) * (noteDev / 140) - 2.5, 0).loadGraphic(errorGraphic);
            errorSprite.color = switch(judgeType) {
                case 0: 0xFFFFFFFF;
                case 1: 0xFF00FFFF;
                case 2: 0xFF00FFC8;
                case 3: 0xFF2020FF;
                case 4: 0xFF7F00FF;
                default: 0xFFFFFFFF;
            };
            
            FlxTween.tween(errorSprite, {alpha: 0}, 1, {startDelay: 1, ease: FlxEase.expoIn, onComplete: T -> remove(errorSprite).destroy()});

            add(errorSprite);
        }
        catch(error)
        {
            trace(error);
        }
    }
}