local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
local f=io.open(PROJ.."/sd_params.txt","w")
for t=0,reaper.CountTracks(0)-1 do local tr=reaper.GetTrack(0,t)
 local n=reaper.TrackFX_GetNumParams(tr,0)
 for p=0,n-1 do local _,nm=reaper.TrackFX_GetParamName(tr,0,p,"")
  local _,fv=reaper.TrackFX_GetFormattedParamValue(tr,0,p,"")
  if not nm:match("^Param") and not nm:match("^%s*$") then f:write(t,"\t",p,"\t",nm,"\t",reaper.TrackFX_GetParam(tr,0,p),"\t",fv,"\n") end end end
f:close()
