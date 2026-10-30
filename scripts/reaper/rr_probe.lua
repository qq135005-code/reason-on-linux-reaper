local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
reaper.InsertTrackAtIndex(0, true)
local tr = reaper.GetTrack(0,0)
local i = reaper.TrackFX_AddByName(tr, "VST3:Reason Rack Plugin", false, -1)
local f=io.open(PROJ.."/rr_probe.txt","w")
f:write("fx idx "..i.."\n")
if i>=0 then local _,n=reaper.TrackFX_GetFXName(tr,i,"") f:write(n.." params "..reaper.TrackFX_GetNumParams(tr,i).."\n") reaper.TrackFX_Show(tr,i,3) end
f:close()
reaper.Main_SaveProjectEx(0,PROJ.."/rr_probe.rpp",0)
