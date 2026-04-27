function onCreate()
{
    spawnNotes = startTime <= 0;

    skipCountdown = !spawnNotes;
}

function postCreate()
{
    botplay = startTime > 0;
}

startTime = 0.1 ?? Conductor.beatsToTime(88);