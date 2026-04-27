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

    camHUD.alpha = 0;

    stage.get('ground').color = FlxColor.fromRGB(50, 50, 50);

    dad.alpha = 0;

    dad.shader.brightness = bf.shader.brightness = -200;

    camGame.bopModulo = 0;
    camGame.position.set(1250, 650);
    camGame.snapToTarget();
    camGame.zoomSpeed = 2;
    
    camGame.fade(FlxColor.WHITE, 0);
}

function onSongStart()
{
    camGame.fade(FlxColor.WHITE, 1 * Conductor.secCrochet, true);

    camGame.targetZoom = camGame.zoom = 1;
    camGame.tweenZoom(0.5, 32 * Conductor.secCrochet, {ease: FlxEase.cubeOut});
}

function onBeatHit(curBeat:Int)
{
    switch (curBeat)
    {
        case 32:
            camGame.cancelZoomTween();
            camGame.targetZoom = 0.3;

            shouldMoveCamera = true;

            FlxTween.tween(dad, {alpha: 1}, 2 * Conductor.secCrochet, {ease: FlxEase.cubeOut});
    }
}

startTime = Conductor.beatsToTime(30);