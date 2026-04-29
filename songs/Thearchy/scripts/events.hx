import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;

import funkin.visuals.shaders.FXShader;

var mask:FlxBackdrop = new FlxBackdrop();
mask.makeGraphic(FlxG.width, FlxG.height);

var subtitles:FlxText = new FlxText(0, 0, FlxG.width, '');
subtitles.setFormat(Paths.font('comicSans.ttf'), 60, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
subtitles.borderSize = subtitles.size / 10;
subtitles.y = FlxG.height * 0.7;
add(subtitles);

function postCreate()
{
    subtitles.cameras = [camOther];

    shader.set({
        blurWidth: 0.025,
        samples: 10,
        grayscale: 0.5
    });

    botplay = startTime > 0;

    addBehindOpponents(mask);

    shouldMoveCamera = false;

    stage.get('ground').color = FlxColor.fromRGB(50, 50, 50);

    for (obj in uiGroup)
    {
        obj.y -= 200;

        obj.alpha = 0;
    }

    dad.alpha = 0;

    dad.y -= 125;

    FlxTween.tween(dad, {y: dad.y + 250}, 8 * Conductor.secCrochet, {ease: FlxEase.cubeInOut, type: FlxTweenType.PINGPONG});

    dad.shader.brightness = bf.shader.brightness = -200;

    camHUD.bopModulo = camGame.bopModulo = 0;
    camHUD.alpha = 0.5;

    camGame.position.set(1250, 650);
    camGame.snapToTarget();
    camGame.zoomSpeed = 2;
    camGame.angleSpeed = 0.2;    
    camGame.fade(FlxColor.WHITE, 0);

    iconP2.config.bopScale.x = 2;
    iconP2.config.bopScale.y = 0.5;
}

function onSongStart()
{
    camGame.fade(FlxColor.WHITE, (startTime > Conductor.crochet ? 1 : 32) * Conductor.secCrochet, true);

    camGame.targetZoom = camGame.zoom = 1;
    camGame.tweenZoom(0.5, 32 * Conductor.secCrochet, {ease: FlxEase.cubeOut});
}

var stepFunc:Int -> Void;
var stepFuncModulo:Int;
var stepFuncConfig:Array<Int>;
var stepFuncOffset:Int;

function onSafeBeatHit(curBeat:Int)
{
    switch (curBeat)
    {
        case 32:
            camGame.cancelZoomTween();
            camGame.targetZoom = 0.3;

            shouldMoveCamera = true;

            FlxTween.tween(dad, {alpha: 1}, 2 * Conductor.secCrochet, {ease: FlxEase.cubeOut});

            FlxTween.color(mask, 2 * Conductor.secCrochet, mask.color ?? FlxColor.WHITE, 0x80000000);

            FlxTween.color(stage.get('ground'), 2 * Conductor.secCrochet, FlxColor.fromRGB(50, 50, 50), FlxColor.fromRGB(100, 100, 100));

            for (char in [dad, bf])
                FlxTween.tween(char.shader, {brightness: -100}, 2 * Conductor.secCrochet);

            for (obj in uiGroup)
                FlxTween.tween(obj, {y: obj.y + 200, alpha: 1}, 4 * Conductor.secCrochet, {ease: FlxEase.cubeOut});

            shader.set({blurWidth: 0.1});

            camGame.shake(0.01, 32 * Conductor.secCrochet);
            camHUD.shake(0.0025, 32 * Conductor.secCrochet);
        case 64:
            shader.set({blurWidth: 0.05});

            camGame.targetZoom = 0.4;
            camGame.stopFX();

            FlxTween.cancelTweensOf(mask);
            FlxTween.color(mask, Conductor.secCrochet, mask.color ?? FlxColor.WHITE, 0xBF000000);

            FlxTween.tween(camHUD, {alpha: 0}, Conductor.secCrochet);
        case 72:
            stepFunc = (curStep) -> {
                shader.set({blurWidth: 0.1, aberrationWidth: 0.1, red: 1.2});
                shader.tween({blurWidth: 0.025, aberrationWidth: 0, red: 0.8}, Conductor.secCrochet, FlxEase.cubeOut);

                camGame.zoom += 0.03;
                camHUD.zoom += 0.02;

                camGame.shake(0.01, Conductor.secCrochet / 2);
                camHUD.shake(0.0025, Conductor.secCrochet / 2);
            };

            stepFunc(0);

            stepFuncModulo = 64;
            stepFuncOffset = 32;
            stepFuncConfig = [0, 4, 8, 12, 16, 20, 24, 28, 29, 30, 31, 32, 36, 38, 39, 40, 44, 48, 50, 52, 54, 56, 60];

            for (char in [dad, bf])
            {
                FlxTween.cancelTweensOf(char.shader);

                char.shader.brightness = -50;
            }
            
            FlxTween.cancelTweensOf(stage.get('ground'));

            stage.get('ground').color = FlxColor.WHITE;

            FlxTween.cancelTweensOf(mask);

            mask.color = FlxColor.BLACK;
            mask.alpha = 0.25;
            
            shader.setFloat('hue', 0);

            camGame.targetZoom = 0.3;
            camGame.angle = 0;

            FlxTween.cancelTweensOf(camHUD);

            camHUD.alpha = 1;

            if (startTime < Conductor.crochet * 72)
                camHUD.flash(FlxColor.WHITE, 4 * Conductor.secCrochet);
        case 88:
            camGame.targetZoom = 0.5;
        case 104:
            camGame.zoomSpeed = 3;

            camGame.targetZoom = 0.3;
            
            stepFuncConfig = [0, 6, 16, 22, 28, 29, 30, 31, 32, 38, 44, 48, 50, 52, 53, 54, 56, 60];

            shader.tween({grayscale: 0.75, bloom: 0.75, hue: 0.1}, Conductor.secCrochet);
        case 106:
            camGame.targetZoom = 0.4;
            
            camGame.targetAngle = 5;
        case 108:
            camGame.targetZoom = 0.3;

            camGame.targetAngle = 0;
        case 110:
            camGame.targetZoom = 0.2;

            camGame.targetAngle = -5;
        case 112:
            camGame.targetZoom = 0.7;

            camGame.targetAngle = 0;
        case 120:
            camGame.targetZoom = 0.3;
        case 136:
            stepFuncConfig = [0, 4, 8, 12, 16, 20, 24, 28, 29, 30, 31, 32, 36, 38, 39, 40, 44, 48, 50, 52, 54, 56, 60];
        case 160:
            stepFuncOffset = 0;

            stepFuncConfig = [0, 6, 12, 16, 18, 20, 22, 24, 28];
        case 168:
            stepFuncModulo = stepFuncConfig = null;
    }
}

startTime = Conductor.beatsToTime(0);

function onSafeStepHit(curStep:Int)
{
    if (stepFunc != null)
    {
        if (stepFuncConfig == null)
        {
            if (stepFuncModulo != null && curStep % stepFuncModulo == 0)
                stepFunc(curStep);
        } else if (stepFuncConfig.contains((curStep + (stepFuncOffset ?? 0)) % stepFuncModulo)) {
            stepFunc(curStep);
        }
    }

    switch (curStep)
    {
        case 256:
            FlxTween.shake(subtitles, 0.005, 8 * Conductor.secCrochet);

            subtitles.text = 'you';
        case 261:
            subtitles.text = 'you BU-';
        case 264:
            subtitles.text = 'you BULL-';
        case 265:
            subtitles.text = 'you BULLIN\'';
        case 266:
            subtitles.text = 'you BULLIN\' me';
        case 268:
            subtitles.text = 'you';
        case 272:
            subtitles.text = 'you TRO-';
        case 273:
            subtitles.text = 'you TROLL-';
        case 275:
            subtitles.text = 'you TROLLIN\'';
        case 278:
            subtitles.text = 'you TROLLIN\' me';
        case 284:
            subtitles.text = 'ASDJosoKJKSADL';

            FlxTween.cancelTweensOf(mask);

            mask.color = FlxColor.WHITE;
            mask.alpha = 0.75;

            shader.set({hue: 0.25, aberrationWidth: -0.2});

            camGame.targetZoom = camGame.zoom = 0.7;
            camGame.angle = -25;

            FlxTween.cancelTweensOf(camHUD);

            camHUD.alpha = 0.25;

            moveCamera(bf);

            camGame.snapToTarget();
        case 286:
            subtitles.text = 'LASKDLÑm4shaPOS';

            mask.color = FlxColor.BLACK;

            shader.set({hue: 0.75, aberrationWidth: 0.2});

            camGame.targetZoom = camGame.zoom = 0.5;
            camGame.angle = 25;

            camHUD.alpha = 0.5;

            moveCamera(dad);

            camGame.snapToTarget();

            dad.beatHit(0);
        case 288:
            subtitles.text = '';
    }
}

spawnNotes = false;

skipCountdown = true;