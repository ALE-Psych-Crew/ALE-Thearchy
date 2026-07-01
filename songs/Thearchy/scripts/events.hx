import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;

import funkin.visuals.shaders.FXShader;

import funkin.modchart.*;

final mask:FlxBackdrop = new FlxBackdrop();
mask.makeGraphic(FlxG.width, FlxG.height);

final subtitles:FlxText = new FlxText(0, 0, FlxG.width, '');
subtitles.setFormat(Paths.font('comicSans.ttf'), 60, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
subtitles.borderSize = subtitles.size / 10;
subtitles.y = FlxG.height * 0.7;
add(subtitles);

final upBar:FlxSprite = new FlxSprite(0, -FlxG.height / 2).makeGraphic(FlxG.width, FlxG.height / 2, FlxColor.BLACK);
add(upBar);

final downBar:FlxSprite = new FlxSprite(0, FlxG.height).makeGraphic(FlxG.width, FlxG.height / 2, FlxColor.BLACK);
add(downBar);

function epicBars(?offset:Float = 0, ?time:Float, ?hudAlpha:Float = 0, ?ease:FlxEase)
{
    time ??= Conductor.secCrochet;
    ease ??= FlxEase.cubeOut;

    FlxTween.cancelTweensOf(camHUD);

    FlxTween.tween(camHUD, {alpha: hudAlpha}, time, {ease: ease});

    for (index => bar in [upBar, downBar])
    {
        FlxTween.cancelTweensOf(bar);
        
        FlxTween.tween(bar, {y: index == 0 ? offset - FlxG.height / 2 : FlxG.height - offset}, time, {ease: ease});
    }
}

function postCreate()
{
    /*
    for (char in ['thearchyCutscene', 'thearchyBlood', 'opposition'])
        cacheCharacter(char);
    */

    subtitles.cameras = [camOther];

    shader.set({
        blurWidth: 0.025,
        samples: 10,
        grayscale: 0.5
    });

    botplay = startTime > 0;

    addBehindOpponents(mask);

    allowCameraMoving = false;

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
    camGame.angleSpeed = 0.2;

    upBar.cameras = [camOther];
    downBar.cameras = [camOther];
}

function onSongStart()
{
    camGame.fade(FlxColor.WHITE, (startTime > Conductor.crochet ? 1 : 32) * Conductor.secCrochet, true);

    camGame.targetZoom = camGame.zoom = 1;
    camGame.tweenZoom(0.5, 32 * Conductor.secCrochet, {ease: FlxEase.cubeOut});

    epicBars(100, Conductor.secCrochet * 2);
}

var stepFunc:Int -> Void;
var stepFuncModulo:Int;
var stepFuncConfig:Array<Int>;
var stepFuncOffset:Int;

var updateFunc:Float -> Void;
var curTime:Float = 0;

function onSafeBeatHit(curBeat:Int)
{
    switch (curBeat)
    {
        case 32:
            camGame.cancelZoomTween();
            camGame.targetZoom = 0.3;

            allowCameraMoving = true;

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

            epicBars(0, Conductor.secCrochet * 2, 0.5);
        case 64:
            shader.set({blurWidth: 0.05});

            camGame.speed = 3;
            camGame.targetZoom = 0.4;
            camGame.stopFX();

            FlxTween.cancelTweensOf(mask);
            FlxTween.color(mask, Conductor.secCrochet, mask.color ?? FlxColor.WHITE, 0xBF000000);

            epicBars(100, Conductor.secCrochet * 2, 0);
        case 72:
            stepFunc = curStep -> {
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
            camGame.angle = camGame.targetAngle = 0;

            epicBars(0, Conductor.secCrochet, 1);

            if (startTime < Conductor.crochet * 72)
                camOther.flash(FlxColor.WHITE, 4 * Conductor.secCrochet);
        case 88:
            camGame.targetZoom = 0.5;
        case 104:
            stepFunc = curStep -> {
                shader.set({blurWidth: 0.15, aberrationWidth: 0.15, red: 1.2});
                shader.tween({blurWidth: 0.05, aberrationWidth: 0.05, red: 0.8}, Conductor.secCrochet, FlxEase.cubeOut);

                camGame.zoom += 0.03;
                camHUD.zoom += 0.02;

                camGame.shake(0.01, Conductor.secCrochet / 2);
                camHUD.shake(0.0025, Conductor.secCrochet / 2);
            };

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
        case 128:
            camGame.targetZoom = 0.7;
        case 136:
            camGame.targetZoom = 0.3;
            camGame.position.set(0, 500);

            allowCameraMoving = false;

            stepFuncConfig = [0, 4, 8, 12, 16, 20, 24, 28, 29, 30, 31, 32, 36, 38, 39, 40, 44, 48, 50, 52, 54, 56, 60];

            shader.tween({grayscale: 0.5, bloom: 1, hue: 0}, Conductor.secCrochet);

            camHUD.targetZoom = 0.9;
        case 152:
            camGame.targetZoom = 0.4;
        case 160:
            stepFuncOffset = 0;

            stepFuncConfig = [0, 6, 12, 16, 18, 20, 22, 24, 28];

            camGame.speed = 5;

            allowCameraMoving = true;
        case 164:
            camGame.targetZoom = 0.5;
        case 166:
            camGame.tweenZoom(1, Conductor.secCrochet * 2, {ease: FlxEase.elasticIn});
            camHUD.tweenZoom(1.2, Conductor.secCrochet * 2, {ease: FlxEase.cubeIn});
        case 168:
            shader.set({grayscale: 0, bloom: 3, aberrationWidth: 0.1, blurWidth: 0.1});
            shader.tween({grayscale: 0.75, blurWidth: 0, aberrationWidth: 0, bloom: 0.75}, Conductor.secCrochet * 4, FlxEase.cubeOut);

            stepFuncModulo = stepFuncConfig = null;

            camGame.reset();
            camGame.targetZoom = 0.25;
            camGame.bopModulo = 0;

            camHUD.reset();
            camHUD.zoom = 1.2;

            epicBars(100, Conductor.secCrochet * 2);

            changeCharacter(dad, 'thearchyCutscene');

            dad.playSpecialAnim('intro');

            allowCameraMoving = false;
        case 172:
            camGame.tweenPosition(1200, 600, 8 * Conductor.secCrochet, {ease: FlxEase.cubeInOut});

            shader.tween({grayscale: 0.5, bloom: 1}, 8 * Conductor.secCrochet, FlxEase.cubeInOut);
        case 174:
            camGame.tweenZoom(0.7, 8 * Conductor.secCrochet, {ease: FlxEase.cubeInOut});
        case 180:
            bf.playSpecialAnim('bfCatch', true, false);
            bf.bopTimer = Conductor.secCrochet * 4;
        case 184:
            bf.playSpecialAnim('gfKiss', true, false);
            
            bf.bopTimer = Conductor.secCrochet * 3;

            camGame.tweenPosition(200, 600, 8 * Conductor.secCrochet, {ease: FlxEase.cubeInOut});
            camGame.tweenZoom(0.25, 8 * Conductor.secCrochet, {ease: FlxEase.cubeInOut});
            
            shader.tween({grayscale: 0.75, bloom: 0.75}, 8 * Conductor.secCrochet, FlxEase.cubeInOut);
        case 188:
            dad.config.bopAnimations = ['crazy-idle', null];

            dad.playSpecialAnim('crazy');
        case 196:
            camGame.tweenPosition(-1000, 400, 4 * Conductor.secCrochet, {ease: FlxEase.cubeIn});
            camGame.tweenZoom(0.75, 4 * Conductor.secCrochet, {ease: FlxEase.cubeIn});

            dad.playSpecialAnim('twirl');

            epicBars(50, Conductor.secCrochet * 4, 0, FlxEase.cubeIn);

            shader.tween({bloom: 2, grayscale: 0.5, aberrationWidth: 0.2, blurWidth: 0.5, hue: 0.5}, Conductor.secCrochet * 4, FlxEase.cubeIn);
        case 200:
            shader.tween({bloom: 1, grayscale: 0, blurWidth: 0, aberrationWidth: 0.01, hue: 0}, Conductor.secCrochet, FlxEase.cubeOut);
        
            epicBars(0, Conductor.secCrochet * 4, 1);

            changeCharacter(dad, 'opposition');

            camGame.cancelZoomTween();
            camGame.targetZoom = 0.25;
            camGame.zoomSpeed = 2;
            camGame.speed = 0.5;

            camGame.cancelPositionTween();

            allowCameraMoving = true;

            FlxTween.tween(game, {speed: 2}, Conductor.secCrochet, {ease: FlxEase.cubeOut});

            if (startTime <= Conductor.crochet * 200)
                camGame.flash(FlxColor.WHITE, Conductor.secCrochet * 4);
        case 232:
            CoolUtil.setProperties(stage.get('text'), {
                velocity: {
                    x: 5000,
                    y: -1000
                },
                angle: -5
            });

            wavyShader.set({speed: 10, frequency: 20});

            mask.alpha = 0;
            
            camHUD.zoomSpeed = camGame.zoomSpeed = 3;
            camGame.speed = 2;

            curTime = 0;

            updateFunc = elapsed -> {
                shader.setFloat('hue', Math.cos(curTime / 2) * 0.5 + 0.5);
            };
            
            FlxTween.tween(game, {speed: 3.2}, Conductor.secCrochet, {ease: FlxEase.cubeOut});

            changeCharacter(dad, 'thearchyBlood');
            
            if (startTime <= Conductor.crochet * 232)
                camGame.flash(FlxColor.WHITE, Conductor.secCrochet * 4);
    }
}

function onUpdate(elapsed:Float)
{
    curTime += elapsed;

    if (updateFunc != null)
        updateFunc(elapsed);
}

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
            camGame.angle = camGame.targetAngle = -25;

            FlxTween.cancelTweensOf(camHUD);

            moveCamera(bf);

            camGame.snapToTarget();
        case 286:
            subtitles.text = 'LASKDLÑm4shaPOS';

            mask.color = FlxColor.BLACK;

            shader.set({hue: 0.75, aberrationWidth: 0.2});

            camGame.targetZoom = camGame.zoom = 0.5;
            camGame.angle = camGame.targetAngle = 25;

            moveCamera(dad);

            camGame.snapToTarget();

            dad.beatHit(0);
        case 288:
            subtitles.text = '';
    }
}

// spawnNotes = false;

skipCountdown = true;