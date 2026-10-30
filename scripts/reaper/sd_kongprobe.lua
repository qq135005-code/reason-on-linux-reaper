local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
reaper.SetCurrentBPM(0,120,false)
local tr=reaper.GetTrack(0,3)
for t=0,2 do reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,t),"B_MUTE",1) end
local it=reaper.CreateNewMIDIItemInProj(tr,0,16,false); local tk=reaper.GetActiveTake(it)
for i=0,15 do reaper.MIDI_InsertNote(tk,false,false,reaper.MIDI_GetPPQPosFromProjTime(tk,i),reaper.MIDI_GetPPQPosFromProjTime(tk,i+0.5),0,36+i,110,true) end
reaper.MIDI_Sort(tk)
reaper.GetSetProjectInfo(0,"RENDER_SRATE",44100,true); reaper.GetSetProjectInfo(0,"RENDER_CHANNELS",2,true)
reaper.GetSetProjectInfo(0,"RENDER_BOUNDSFLAG",1,true)
reaper.GetSetProjectInfo_String(0,"RENDER_FILE",PROJ.."",true)
reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN","kongprobe",true)
reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT","ZXZhdxgAAA==",true)
os.remove(PROJ.."/kongprobe.wav")
reaper.Main_OnCommand(42230,0)
reaper.DeleteTrackMediaItem(tr,it)
for t=0,2 do reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,t),"B_MUTE",0) end
