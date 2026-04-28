import flixel.addons.display.FlxBackdrop;

import funkin.visuals.shaders.FXShader;

var mask:FlxBackdrop = new FlxBackdrop();
mask.makeGraphic(FlxG.width, FlxG.height);

function onCreate()
{
    spawnNotes = false;

    skipCountdown = !spawnNotes;
}

function postCreate()
{
    shader.set({
        blurWidth: 0.025,
        samples: 10,
        grayscale: 1
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

    camGame.position.set(1250, 650);
    camGame.snapToTarget();
    camGame.zoomSpeed = 2;
    
    camGame.fade(FlxColor.WHITE, 0);

    camHUD.alpha = 0.5;
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
        case 72:
            stepFunc = (curStep) -> {
                shader.set({blurWidth: 0.1, aberrationWidth: 0.05});
                shader.tween({blurWidth: 0.025, aberrationWidth: 0}, Conductor.secCrochet, FlxEase.cubeOut);

                camGame.zoom += 0.03;
                camHUD.zoom += 0.02;
            };

            stepFuncModulo = 64;
            stepFuncOffset = 32;
            stepFuncConfig = [
                0,
                4,
                8,
                12,
                16,
                20,
                24,
                28, 29, 30, 31,
                32,
                36, 38, 39,
                40,
                44,
                48, 50,
                52, 54,
                56,
                60
            ];
    }
}

startTime = Conductor.beatsToTime(72);

function onSafeStepHit(curStep:Int)
{
    if (stepFunc != null)
    {
        if (stepFuncModulo == null)
        {
            stepFunc(curStep);
        } else if (stepFuncConfig.contains((curStep + (stepFuncOffset ?? 0)) % stepFuncModulo)) {
            stepFunc(curStep);
        }
    }
}