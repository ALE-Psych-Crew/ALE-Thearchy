package;

import utils.TweenUtil;

class CircleModifier extends scripting.haxe.ScriptedModchartModifier
{
    override public function init()
    {
        updateData = {
            x: 10,
            y: 10,
            speed: 5
        };

        bopData = {
            max: {
                x: 5,
                y: 5
            },
            min: {
                x: 2.5,
                y: 2.5
            },
            speed: 1,
            ease: FlxEase.cubeOut
        }
    }

    public var multX:Float = 1;
    public var multY:Float = 1;
    
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        x = baseX + Math.sin(curTime * updateData.speed + strum.data) * updateData.x * multX;
        y = baseY + Math.cos(curTime * updateData.speed + strum.data) * updateData.y * multY;
    }

    var tweenX:FlxTween;
    var tweenY:FlxTween;
    
    override public function bop()
    {
        super.bop();

        tweenX?.cancel();
        tweenY?.cancel();

        tweenX = FlxTween.num(FlxG.random.float(bopData.min.x, bopData.max.x), 1, Conductor.secCrochet / bopData.speed, {ease: bopData.ease}, (val) -> { multX = val; });
        tweenY = FlxTween.num(FlxG.random.float(bopData.min.y, bopData.max.y), 1, Conductor.secCrochet / bopData.speed, {ease: bopData.ease}, (val) -> { multY = val; });
    }
}