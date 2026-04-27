import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;

import funkin.visuals.shaders.DropShadowShader;
import funkin.visuals.shaders.FXShader;

using StringTools;

public var shader:FXShader = new FXShader('global');
shader.set({bloom: 1, red: 1, green: 1, blue: 1});

function postCreate()
{
    camGame.setShaders([shader]);
}

public var ratingsText:FlxText;
public var stadisticsText:FlxText;

public var timeText:FlxText;

public var uiMargin:Float = 15;

function postHudInit()
{
    ratingsText = new FlxText(uiMargin * 2, 0, FlxG.width, '\n\n\n\n');

    stadisticsText = new FlxText(-uiMargin * 2, 0, FlxG.width, '\n\n\n\n');

    timeText = new FlxText(0, 0, FlxG.width, '');

    for (index => text in [ratingsText, stadisticsText, timeText])
    {
        text.setFormat(Paths.font('vcr.ttf'), 22, FlxColor.WHITE, ['left', 'right', 'center'][index], FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.y = ClientPrefs.data.downScroll ? uiMargin : FlxG.height - text.height - uiMargin;
        text.borderSize = 2;

        uiGroup.add(text);
    }

    timeText.y = uiMargin;
}

var shits:Int = 0;
var bads:Int = 0;
var goods:Int = 0;
var sicks:Int = 0;

function onScoreTextUpdate()
{
    ratingsText.text = [
        'Sicks!!: ' + sicks,
        'Goods!: ' + goods,
        'Bads: ' + bads,
        'Shits: ' + shits
    ].join('\n');

    stadisticsText.text = [
        combo + ' :Combo',
        score + ' :Score',
        misses + ' :Misses',
        CoolUtil.floorDecimal(accuracy, 1) + '% :Accuracy'
    ].join('\n');

    scoreText.text = 'ALE P | SC:R 1.0';

    return Function_Stop;
}

function onNoteHit(note:Note, rating:String)
{
    switch (rating)
    {
        case 'sick':
            sicks++;
        case 'good':
            goods++;
        case 'bad':
            bads++;
        case 'shit':
            shits++;
    }
}

function onUpdate(elapsed:Float)
{
    timeText.text = FlxStringUtil.formatTime(Math.max(0, Conductor.songPosition) / 1000) + ' / ' + FlxStringUtil.formatTime(FlxG.sound.music.length / 1000);
}

function onComboDisplay(rating:String)
{
    final path:String = 'hud/' + stage.config.hud + '/combo';

    final comboString:String = '${combo % 1000}'.lpad('0', 3);
    
    comboSprite.loadGraphic(Paths.image(path + '/' + Std.string(rating)));
    comboSprite.x = FlxG.width / 2 - comboSprite.width / 2;
    comboSprite.y = 100 - comboSprite.height / 2;

    for (index => number in comboNumbers)
    {
        number.loadGraphic(Paths.image(path + '/' + comboString.charAt(index)));
        number.color = switch (rating)
        {
            case 'sick':
                0xFFC864FF;
            case 'good':
                0xFF7319C8;
            case 'bad':
                0xFF3C1964;
            case 'shit':
                0xFF32323C;
        }
    }
    
    for (obj in comboNumbers.concat([comboSprite]))
    {
        obj.alpha = 1;
    }

    return Function_Stop;
}

function postCharacterAdd(char:Character)
{
    char.shader = new DropShadowShader(char);
}