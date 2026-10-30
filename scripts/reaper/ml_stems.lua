local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
local OUT=PROJ..""
reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT","ZXZhdxgAAA==",true)
for s=0,2 do for t=0,2 do reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,t),"B_MUTE",t==s and 0 or 1) end
 reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN","mlstem"..s,true); os.remove(OUT.."/mlstem"..s..".wav"); reaper.Main_OnCommand(42230,0) end
for t=0,2 do reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,t),"B_MUTE",0) end
reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN","moonlight_reason",true)
reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT","bDNwbUABAAAAAAAAAgAAAP////8EAAAAQAEAAAAAAAA=",true)
local d=io.open(OUT.."/r2_done.txt","w") d:write("stems\n") d:close()
