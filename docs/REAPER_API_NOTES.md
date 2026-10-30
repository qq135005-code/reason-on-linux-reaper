# REAPER scripting notes (REAPER 7.84, Linux, headless box) — 2026-10-30

## Working headless method
    DISPLAY=:99 reaper -nosplash -newinst -new ~/reaper_projects/demo_song.lua
REAPER 6.80+ runs a .lua/.eel/.py given on the command line (`reaper project.rpp script.lua`;
`-nonewinst script.lua` sends it to an already-running instance). The whole run (build, render,
quit) takes about 5 s. Xvfb is still needed because REAPER is a GUI app.
Alternative: `~/.config/REAPER/Scripts/__startup.lua` (two underscores) runs on every start.
CLI-only render of an existing project: `reaper -renderproject file.rpp` (uses the project's render settings).

## Key API calls (Lua)
- SetCurrentBPM(0, bpm, false)
- InsertTrackAtIndex / GetTrack / GetSetMediaTrackInfo_String(tr,"P_NAME",..) / SetMediaTrackInfo_Value(tr,"D_VOL"|"D_PAN",..)
- TrackFX_AddByName(tr, "ReaSynth", false, -1); master: TrackFX_AddByName(GetMasterTrack(0),"ReaVerbate",false,-1)
- CreateNewMIDIItemInProj(tr, start_s, end_s, false) -> GetActiveTake(item)
- MIDI_GetPPQPosFromProjTime(take, t), MIDI_InsertNote(take, sel, mute, ppqStart, ppqEnd, chan, pitch, vel, noSort=true), MIDI_Sort(take)
- Render: GetSetProjectInfo(0,"RENDER_SRATE"/"RENDER_CHANNELS"/"RENDER_BOUNDSFLAG",v,true);
  GetSetProjectInfo_String(0,"RENDER_FILE"/"RENDER_PATTERN"/"RENDER_FORMAT",s,true)
- Main_SaveProjectEx(0, path, 0); Main_OnCommand(42230,0) = render with the most recent settings and auto-close; 40004 = quit

## MP3 RENDER_FORMAT (base64 config blob, starts with "l3pm")
- CBR 320: bDNwbUABAAAAAAAAAgAAAP////8EAAAAQAEAAAAAAAA=
- CBR 192: bDNwbcAAAAAAAAAAAgAAAP////8EAAAAwAAAAAAAAAA=
- A bare "l3pm" (bDNwbQ==) also works but falls back to 128 kbps.
The LAME encoder is built in. libmp3lame.so.0 was already on the box, so no apt install was needed.

## Gotchas
1. Main_SaveProjectEx writes a *copy*, so the tab stays "[unsaved project]" and quitting shows
   the "Save unsaved project?" dialog, which blocks. Fix: Main_openProject("noprompt:"..rpp) before 40004.
2. If the output file exists, a blocking "File already exists" Render Warning appears. Fix: os.remove() it first.
3. Do not call 40859 (new project tab) when you launch with -new; it adds a second, dirty tab.
4. A Lua syntax error shows a modal "ReaScript Error" window, and the process just hangs. Always wrap runs in `timeout`
   and check the windows with `xwininfo -root -tree` / `import -window <id>` on :99.
5. Audio: I set `linux_audio_mode=3` in [reaper] of reaper.ini, with the aim of selecting Dummy Audio. The value is a guess
   and was not verified in the preferences. Rendering is offline and worked anyway, and no audio-error dialog blocked the run.
   The evaluation nag did not block the scripted run.
6. You must pass "-newinst" when another REAPER is already running, or the script goes to that instance.

## Sources opened
- https://www.reaper.fm/sdk/reascript/reascript.php
- https://forum.cockos.com/showthread.php?p=2680230 (v6.80: run scripts from the command line)
- https://forum.cockos.com/showthread.php?p=2689965 (X-Raym: -nonewinst + Main_OnCommand)
- https://forum.cockos.com/showthread.php?t=222833 (__startup.lua)
- https://forum.cockos.com/archive/index.php/t-287195.html (Debian 12 REAPER CLI headless)
- https://github.com/Ultraschall/ultraschall-and-reaper-docs/blob/master/Docs/render-codes-decoded-base64-strings-14-February-2019.txt (MP3 blob layout)
- https://forum.cockos.com/showthread.php?page=16&t=265145 (MP3 192/320 render preset strings)
