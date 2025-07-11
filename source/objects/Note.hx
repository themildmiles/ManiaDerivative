package objects;

class Note extends FlxSprite {
    public var hitBeat:Array<Int>;
    public var hitTime:Float;
    public var column:Int;
    override public function new(hitBeat:Array<Int>, hitTime:Float, column:Int) {
        super(0, 0); // this is temporary LOL
        
        loadFallbackGraphic(); // this supposed to be 75x10
    }

    /**
        This is for testing phase.
        This will also trigger if the supposed graphic
        for the note failed to load, calling `makeGraphic()`
        to create a 75x10 white rectangle.
    **/
    function loadFallbackGraphic():FlxSprite
        return makeGraphic(75, 10, FlxColor.WHITE);
}