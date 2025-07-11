package states;

import backend.Utilities.Chart;
import backend.Utilities.ChartPreview;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.Note;

class PlayState extends FlxState {
    var chartLoaded:Chart;

    // lol
    var unspawnedNotes:Array<Note>;
    var notes:FlxTypedGroup<Note>;

    override public function create() {
        super.create();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }

    public function loadChart(chartData:ChartPreview)
    {
        chartLoaded = new Chart(chartData);

        unspawnedNotes =  chartLoaded.notes; // NOT supposed to be added yet
    }
}