package objects;

class Note extends FlxSprite {
    public var hitBeat:Array<Int>;
    public var hitTime:Float;
    public var column:Int;
	public var hit:Bool;
    override public function new(hitBeat:Array<Int>, hitTime:Float, column:Int) {
        super(0, 0); // this is temporary LOL
		this.hitBeat = hitBeat;
		this.hitTime = hitTime;
		this.column = column;
		this.hit = false;
        
		loadFallbackGraphic(); // this supposed to be 125x30
    }

    /**
        This is for testing phase.
        This will also trigger if the supposed graphic
        for the note failed to load, calling `makeGraphic()`
        to create a 75x10 white rectangle.
    **/
    function loadFallbackGraphic():FlxSprite
		return makeGraphic(125, 30, FlxColor.WHITE);
}