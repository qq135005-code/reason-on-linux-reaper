local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
-- demo_song.lua : builds a ~24 s piece (A minor, 100 BPM) and renders MP3
local OUT = PROJ..""
local BPM, BARS = 100, 10
local bar = 240 / BPM
-- (launched with -new, so we work in the fresh project tab)
reaper.SetCurrentBPM(0, BPM, false)

local function mktrack(name, vol_db, pan)
  local idx = reaper.CountTracks(0)
  reaper.InsertTrackAtIndex(idx, true)
  local tr = reaper.GetTrack(0, idx)
  reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", name, true)
  reaper.SetMediaTrackInfo_Value(tr, "D_VOL", 10^(vol_db/20))
  reaper.SetMediaTrackInfo_Value(tr, "D_PAN", pan or 0)
  reaper.TrackFX_AddByName(tr, "ReaSynth", false, -1)
  local item = reaper.CreateNewMIDIItemInProj(tr, 0, BARS*bar, false)
  return tr, reaper.GetActiveTake(item)
end
local function note(take, t0, dur, pitch, vel)
  local s = reaper.MIDI_GetPPQPosFromProjTime(take, t0)
  local e = reaper.MIDI_GetPPQPosFromProjTime(take, t0+dur)
  reaper.MIDI_InsertNote(take, false, false, s, e, 0, pitch, vel, true)
end
local beat = 60/BPM
-- progression Am F C G (x2) then Am/E ending ... roots in MIDI
local prog = { {57,60,64}, {53,57,60}, {48,52,55}, {55,59,62} }
local roots = {45, 41, 48, 43}
local _, chords = mktrack("Chords", -12, -0.2)
local _, bass   = mktrack("Bass", -8, 0)
local _, mel    = mktrack("Melody", -9, 0.2)
for b = 0, BARS-1 do
  local i = (b % 4) + 1
  if b == BARS-1 then i = 1 end
  local t = b*bar
  for _, p in ipairs(prog[i]) do note(chords, t, bar*0.95, p, 70) end
  for k = 0, 3 do note(bass, t + k*beat, beat*0.8, roots[i] - 12 + ((k==2) and 12 or 0), 100) end
end
-- melody (A minor pentatonic-ish), bars 2..9, eighth/quarter phrases
local phrase = { {76,1},{74,0.5},{72,0.5},{69,1},{72,1},  {72,1},{69,0.5},{72,0.5},{74,2},
                 {67,1},{72,0.5},{74,0.5},{76,1},{79,1},  {78,0},{74,1},{72,1},{71,2} }
local t = bar
for rep = 1, 2 do
  for _, n in ipairs(phrase) do
    if n[2] > 0 then note(mel, t, n[2]*beat*0.9, n[1], 95); t = t + n[2]*beat end
  end
end
note(mel, (BARS-1)*bar, bar*0.95, 69, 90)
for _, tk in ipairs({chords,bass,mel}) do reaper.MIDI_Sort(tk) end
-- reverb on master
reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), "ReaVerbate", false, -1)

-- render settings
reaper.GetSetProjectInfo(0, "RENDER_SRATE", 44100, true)
reaper.GetSetProjectInfo(0, "RENDER_CHANNELS", 2, true)
reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", 1, true) -- entire project
reaper.GetSetProjectInfo(0, "RENDER_TAILFLAG", 0, true)
reaper.GetSetProjectInfo_String(0, "RENDER_FILE", OUT, true)
reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", "demo_song", true)
reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT", "bDNwbUABAAAAAAAAAgAAAP////8EAAAAQAEAAAAAAAA=", true) -- l3pm CBR 320 kbps
reaper.Main_SaveProjectEx(0, OUT .. "/demo_song.rpp", 0)
os.remove(OUT .. "/demo_song.mp3") -- avoid the blocking "file exists" Render Warning
reaper.Main_OnCommand(42230, 0) -- render using most recent settings, auto-close
-- Main_SaveProjectEx writes a copy but leaves the tab "unsaved"; reopen the saved
-- copy with noprompt: so the tab is clean and quitting shows no save dialog
reaper.Main_openProject("noprompt:" .. OUT .. "/demo_song.rpp")
reaper.Main_OnCommand(40004, 0) -- quit
