local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
-- run in the instance where track 1 already has Reason Rack Plugin (Europa "Friendly Keys")
local OUT=PROJ..""
local BPM,BARS=96,10; local bar=240/BPM; local beat=60/BPM
reaper.SetCurrentBPM(0,BPM,false)
local tr=reaper.GetTrack(0,0)
reaper.GetSetMediaTrackInfo_String(tr,"P_NAME","Reason Rack - Europa",true)
local item=reaper.CreateNewMIDIItemInProj(tr,0,BARS*bar,false)
local take=reaper.GetActiveTake(item)
local function note(t0,dur,p,v)
  reaper.MIDI_InsertNote(take,false,false,reaper.MIDI_GetPPQPosFromProjTime(take,t0),reaper.MIDI_GetPPQPosFromProjTime(take,t0+dur),0,p,v,true) end
local prog={{57,60,64},{53,57,60},{48,52,55},{55,59,62}}; local roots={45,41,48,43}
for b=0,BARS-1 do local i=(b%4)+1; if b==BARS-1 then i=1 end; local t=b*bar
  for _,p in ipairs(prog[i]) do note(t,bar*0.95,p,70) end
  note(t,bar*0.95,roots[i]-12,85) end
local phrase={{76,1},{74,0.5},{72,0.5},{69,1},{72,1},{72,1},{69,0.5},{72,0.5},{74,2},{67,1},{72,0.5},{74,0.5},{76,1},{79,1},{74,1},{72,1},{71,2}}
local t=bar
for r=1,2 do for _,n in ipairs(phrase) do note(t,n[2]*beat*0.9,n[1],95); t=t+n[2]*beat end end
note((BARS-1)*bar,bar*0.95,81,90)
reaper.MIDI_Sort(take)
reaper.GetSetProjectInfo(0,"RENDER_SRATE",44100,true)
reaper.GetSetProjectInfo(0,"RENDER_CHANNELS",2,true)
reaper.GetSetProjectInfo(0,"RENDER_BOUNDSFLAG",1,true)
reaper.GetSetProjectInfo(0,"RENDER_TAILFLAG",1,true); reaper.GetSetProjectInfo(0,"RENDER_TAILMS",2000,true)
reaper.GetSetProjectInfo_String(0,"RENDER_FILE",OUT,true)
reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN","reason_demo",true)
reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT","bDNwbUABAAAAAAAAAgAAAP////8EAAAAQAEAAAAAAAA=",true)
reaper.Main_SaveProjectEx(0,OUT.."/reason_demo.rpp",0)
os.remove(OUT.."/reason_demo.mp3")
reaper.Main_OnCommand(42230,0)
reaper.Main_openProject("noprompt:"..OUT.."/reason_demo.rpp")
reaper.Main_OnCommand(40004,0)
