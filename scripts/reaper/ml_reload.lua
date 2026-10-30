local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
reaper.Main_SaveProjectEx(0,PROJ.."/moonlight_reason.rpp",0)
reaper.Main_openProject("noprompt:"..PROJ.."/moonlight_reason.rpp")
local d=io.open(PROJ.."/r2_done.txt","w") d:write("reloaded\n") d:close()
