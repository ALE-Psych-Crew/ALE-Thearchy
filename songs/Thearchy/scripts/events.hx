function onCreate()
{
    spawnNotes = startTime <= 0;

    skipCountdown = !spawnNotes;
}

function postCreate()
{
    botplay = startTime > 0;

    moveCamera(dad);
}

startTime = 0.1 ?? Conductor.beatsToTime(0);