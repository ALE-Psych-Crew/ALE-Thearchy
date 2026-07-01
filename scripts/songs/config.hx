import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;

import funkin.visuals.shaders.DropShadowShader;
import funkin.visuals.shaders.FXShader;

import funkin.modchart.*;

using StringTools;

public var shader:FXShader = new FXShader(Paths.exists('shaders/${song.toLowerCase()}.frag') ? song.toLowerCase() : 'global');
shader.set({bloom: 1, red: 1, green: 1, blue: 1});

function postCreate()
    camGame.setShaders([shader]);

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
    if (ratingsText != null)
        ratingsText.text = [
            'Sicks!!: ' + sicks,
            'Goods!: ' + goods,
            'Bads: ' + bads,
            'Shits: ' + shits
        ].join('\n');

    if (stadisticsText != null)
        stadisticsText.text = [
            combo + ' :Combo',
            score + ' :Score',
            misses + ' :Misses',
            CoolUtil.floorDecimal(accuracy, 1) + '% :Accuracy'
        ].join('\n');

    scoreText.text = 'ALE P | SC:R 1.0 ' + (botplay ? ' - BOTPLAY' : '');

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
    if (Conductor.music != null)
        timeText.text = FlxStringUtil.formatTime(Math.max(0, Conductor.songPosition) / 1000) + ' / ' + FlxStringUtil.formatTime(Conductor.music.length / 1000);

final timer:FlxTimer;

function onComboDisplay(rating:Rating)
{
    final path:String = hudRoute + '/combo';

    final comboString:String = '${combo % 1000}'.lpad('0', 3);

    ratingSprite.loadGraphic(Paths.image(path + '/' + Std.string(rating.id)));
    ratingSprite.x = FlxG.width / 2 - ratingSprite.width / 2;
    ratingSprite.y = 100 - ratingSprite.height / 2;
    ratingSprite.visible = true;

    FlxTween.cancelTweensOf(ratingSprite);

    ratingSprite.alpha = 1;

    FlxTween.cancelTweensOf(ratingSprite.scale);

    ratingSprite.scale.set(0.9, 0.9);

    FlxTween.tween(ratingSprite.scale, {x: 0.8, y: 0.8}, Conductor.secCrochet / 2, {ease: FlxEase.cubeOut});

    while (comboString.length > comboNumbers.members.length)
    {
        final number:FlxSprite = new FlxSprite();

        comboNumbers.add(number);
    }

    for (index => number in comboNumbers.members)
    {
        number.loadGraphic(Paths.image(path + '/' + comboString.charAt(index)));
        number.color = switch (rating.id)
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

        number.x = ratingSprite.x + ratingSprite.width / 2 - number.width / 2 + 35 * (index - 1);
        number.y = 160 - number.height / 2;
        number.visible = true;

        FlxTween.cancelTweensOf(number);

        number.alpha = 1;

        FlxTween.cancelTweensOf(number.scale);

        number.scale.set(0.5, 0.5);

        FlxTween.tween(number.scale, {x: 0.4, y: 0.4}, Conductor.secCrochet / 2, {ease: FlxEase.cubeOut});
    }

    timer?.cancel();

    timer = FlxTimer.wait(Conductor.secCrochet, () -> {
        for (obj in comboNumbers.members.concat([ratingSprite]))
        {
            FlxTween.tween(obj, {alpha: 0}, Conductor.secCrochet, {ease: FlxEase.cubeIn});
            FlxTween.tween(obj.scale, {x: obj.scale.x / 2, y: obj.scale.y / 2}, Conductor.secCrochet, {ease: FlxEase.cubeIn});
        }
    });
    
    return Function_Stop;
}

function postCharacterAdd(char:Character)
    char.shader = new DropShadowShader(char);