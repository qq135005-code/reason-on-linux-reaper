local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
local OUT=PROJ..""
os.remove(OUT.."/moonlight_reason.mp3"); reaper.Main_OnCommand(42230,0)
local d=io.open(OUT.."/r2_done.txt","w") d:write("rendered\n") d:close()
