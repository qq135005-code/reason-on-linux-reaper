local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
for i=1,4 do reaper.InsertTrackAtIndex(i-1,true)
 local tr=reaper.GetTrack(0,i-1)
 reaper.GetSetMediaTrackInfo_String(tr,"P_NAME",({"Pad","Bass","Pluck","Drums"})[i],true)
 reaper.TrackFX_AddByName(tr,"VST3i:Reason Rack Plugin",false,-1) end
reaper.TrackFX_Show(reaper.GetTrack(0,0),0,3)
