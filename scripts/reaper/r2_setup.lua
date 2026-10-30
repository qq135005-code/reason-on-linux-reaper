local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
reaper.Main_openProject("noprompt:"..PROJ.."/r2_empty.rpp")
local names={"Lead","Bass","Drums","Keys","Pad"}
for i=1,#names do reaper.InsertTrackAtIndex(i-1,true)
 local tr=reaper.GetTrack(0,i-1)
 reaper.GetSetMediaTrackInfo_String(tr,"P_NAME",names[i],true)
 reaper.TrackFX_AddByName(tr,"VST3i:Reason Rack Plugin",false,-1) end
reaper.SetCurrentBPM(0,118,false)
reaper.Main_SaveProjectEx(0,PROJ.."/reason_track2.rpp",0)
reaper.Main_openProject("noprompt:"..PROJ.."/reason_track2.rpp")
reaper.TrackFX_Show(reaper.GetTrack(0,0),0,3)
