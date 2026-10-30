local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
reaper.Main_openProject("noprompt:"..PROJ.."/r2_empty.rpp")
local names={"Arp","Melody","Bass"}
for i=1,#names do reaper.InsertTrackAtIndex(i-1,true)
 local tr=reaper.GetTrack(0,i-1)
 reaper.GetSetMediaTrackInfo_String(tr,"P_NAME",names[i],true)
 reaper.TrackFX_AddByName(tr,"VST3i:Reason Rack Plugin",false,-1) end
local M=reaper.GetMasterTrack(0)
reaper.TrackFX_AddByName(M,"VST3:Reason Rack Plugin Effect",false,-1)
reaper.SetCurrentBPM(0,60,false)
reaper.Main_SaveProjectEx(0,PROJ.."/moonlight_reason.rpp",0)
reaper.Main_openProject("noprompt:"..PROJ.."/moonlight_reason.rpp")
reaper.TrackFX_Show(reaper.GetTrack(0,0),0,3)
local d=io.open(PROJ.."/r2_done.txt","w") d:write("setup\n") d:close()
