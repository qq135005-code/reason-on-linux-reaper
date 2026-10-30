local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
reaper.Main_SaveProjectEx(0,PROJ.."/reason_track2.rpp",0)
reaper.Main_openProject("noprompt:"..PROJ.."/reason_track2.rpp")
