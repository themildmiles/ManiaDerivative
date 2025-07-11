package menu;

import backend.Utilities.ChartPreview;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Json;
import sys.FileSystem;

class SongSelectState extends FlxState {
    var titleText:FlxText;
	var songsText:FlxTypedGroup<FlxText>;
	var hasSelected:Bool = false;

	var time:Float = 0;

	var songs:Array<ChartPreview> = [];
	var songIndex:Int = 0;
	
	override public function create()
	{
		super.create();

        trace("fuck what isnt working");

		titleText = new FlxText(0, 100, FlxG.width, "Song Select", 80);
		titleText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 80, FlxColor.WHITE, CENTER);

		songsText = new FlxTypedGroup<FlxText>();

		add(titleText);
		add(songsText);

        for (path in FileSystem.readDirectory("assets/data/charts")) 
        {
            trace('Checking $path...');
            if (FileSystem.isDirectory('assets/data/charts/$path')) 
            {
                if (FileSystem.exists('assets/data/charts/$path/chart.json'))
                {
                    try
                    {
                        var chartData:Dynamic = Json.parse(File.getContent('assets/data/charts/$path/chart.json'));
                        var songPath:Null<String> = null;
                        if (FileSystem.exists('assets/data/charts/$path/${chartData.songPath}'))
                            songPath = chartData.songPath;
                        else
                            trace('$path: Chart has no song file');

                        songs.push({
                            path: 'assets/data/charts/$path',
                            title: chartData.title,
                            artist: chartData.artist,
                            difficulty: chartData.difficulty,
                            songFile: songPath,
                            chartData: chartData,
                            audioPreview: if (songPath != null) new FlxSound().loadEmbedded(songPath, true) else null
                        });
                    }
                    catch(error:haxe.Exception)
                    {
                        trace('$path has an invalid chart file. Ignoring...');
                    }
                }
                else
                    trace('$path has no chart file. Ignoring...');
            }
            else 
            {
                trace('$path is not a directory. Ignoring...');
            }
        } 
        
        if (songs.length > 0)
            for (SI in 0...songs.length)
            {
                var song:Dynamic = songs[SI];
                var songText:FlxText = new FlxText(0, 300 + SI * 40, FlxG.width, '${song.artist} - ${song.title} (${song.difficulty})');
                songText.setFormat(AssetPaths.font("Oswald-Regular.ttf"), 27, FlxColor.WHITE, CENTER);

                songsText.add(songText);
            }
        else
            add(new FlxText(0, 300, FlxG.width, 'No songs have been found :3'));
	}

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP)
		{
			songIndex--;
			if (songIndex < 0)
				songIndex = songs.length - 1;
		}
		else if (FlxG.keys.justPressed.DOWN)
			songIndex = (songIndex + 1) % songs.length;
		else if (FlxG.keys.justPressed.ENTER)
		{
            // fuck is this
		}

        for (SI in 0...songs.length)
        {
            var songText:FlxText = songsText.members[SI];

            songText.y = 300 + (SI - songIndex) * 40;
            songText.alpha = Math.max(0, 1 - Math.abs(SI - songIndex) * 0.2);

            if (songs[SI].audioPreview != null)
                if(SI == songIndex)
                    songs[SI].audioPreview.play(true);
                else 
                    songs[SI].audioPreview.pause();
        }
    }
}