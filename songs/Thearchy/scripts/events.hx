import flixel.addons.display.FlxBackdrop;

var mask:FlxBackdrop = new FlxBackdrop();
mask.makeGraphic(FlxG.width, FlxG.height);

function onCreate()
{
    spawnNotes = startTime <= 0;

    skipCountdown = !spawnNotes;
}

function postCreate()
{
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
}

function onSongStart()
{
    camGame.fade(FlxColor.WHITE, (startTime > Conductor.crochet ? 1 : 32) * Conductor.secCrochet, true);

    camGame.targetZoom = camGame.zoom = 1;
    camGame.tweenZoom(0.5, 32 * Conductor.secCrochet, {ease: FlxEase.cubeOut});
}

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
    }
}

startTime = Conductor.beatsToTime(32);

var lastCam = null;

function onCameraMove(char:Character)
{
}