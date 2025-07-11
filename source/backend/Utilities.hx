package backend;

import objects.Note;

typedef ChartPreview = 
{
    var path:String;
    var title:String;
    var artist:String;
    var difficulty:String;
    var songFile:Null<String>;
    var chartData:Dynamic;
    var audioPreview:Null<FlxSound>;
}

/**
    This just helps setup the chart and handle information. 
**/
class Chart {
    public var title:String;
    public var artist:String;
    public var difficulty:String;

    public var notes:Array<Note>;

    public var songFile:Null<String>;

    /**
        This just helps setup the chart and handle information.
        Needs a `ChartPreview`.
    **/
    public function new(chartData:ChartPreview) 
    {
        this.title = chartData.title;
        this.artist = chartData.artist;
        this.difficulty = chartData.difficulty;

        var chartNotes:Array<Dynamic> = chartData.chartData.notes; // lmao

        this.notes = [];

        var crochet:Float = 60000 / chartData.chartData.bpm;

        for (noteData in chartNotes) {
            this.notes.push(new Note(noteData.beat, 
                crochet * (noteData.beat[0] + noteData.beat[1] / noteData.beat[2]),
                noteData.column
                ));
        }

        this.songFile = chartData.songFile;
    }
}