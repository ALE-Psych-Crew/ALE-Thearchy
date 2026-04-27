import funkin.visuals.shaders.FXShader;

var wavyShader:FXShader = new FXShader('wavy');
wavyShader.set({amplitude: 0.1, frequency: 5, speed: 2.25});

function postCreate()
{
    gf.exists = false;

    for (obj in ['backCubes', 'cubes'])
        stage.get(obj).shader = wavyShader;

    shader.set({red: 0.8, green: 0.8});

    for (char in [dad, bf])
    {
        char.shader.angle = -90;
        char.shader.color = FlxColor.fromRGB(100, 100, 255);
    }
}

var curTime:Float = 0;

function onUpdate(elapsed:Float)
{
    curTime += elapsed;

    wavyShader.set({time: curTime});
}