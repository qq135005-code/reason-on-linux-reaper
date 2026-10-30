local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
for t=0,3 do reaper.TrackFX_Show(reaper.GetTrack(0,t),0,2) end reaper.TrackFX_Show(reaper.GetTrack(0,3),0,3)
