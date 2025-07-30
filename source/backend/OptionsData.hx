package backend;

/**
    Used to represent what options the user has preferred to set.
**/
typedef OptionsData =
{
    /**
        The note speed. 
        Default: 15
    **/
    var noteSpeed:Float;

    /**
        The offset. Higher means later notes and vice versa.
        Default: 0
    **/
    var offset:Int;

    /**
        Hide a specific judgement.
        Default: None
    **/
    var hideMode:Int; // can have "Hide Marvelous!!! = 1" and "Hide Perfect!! and above = 2",
	/**
		On autoplay.
		Default: Off
	**/
	var autoplay:Bool;
}

class Options {
    static public var options:OptionsData;
    public static function load() {
		try
		{
			if (FlxG.save.data.options == null)
				FlxG.save.data.options = {
					noteSpeed: 15,
					offset: 0,
					hideMode: 0,
					autoplay: false
				};
			options = FlxG.save.data.options;
		}
		catch (error)
		{
			trace("Error loading option data :(");
			options = {
				noteSpeed: 15,
				offset: 0,
				hideMode: 0,
				autoplay: false
			};
		}
    }

    public static function save() 
        FlxG.save.data.options = options;
}