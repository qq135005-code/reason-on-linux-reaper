local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
local f=io.open(PROJ.."/ml_params.txt","w")
local tl={}
for t=0,reaper.CountTracks(0)-1 do tl[#tl+1]={t,reaper.GetTrack(0,t)} end
tl[#tl+1]={"M",reaper.GetMasterTrack(0)}
for _,x in ipairs(tl) do local t,tr=x[1],x[2]
 local n=reaper.TrackFX_GetNumParams(tr,0)
 for p=0,n-1 do local _,nm=reaper.TrackFX_GetParamName(tr,0,p,"")
  local _,fv=reaper.TrackFX_GetFormattedParamValue(tr,0,p,"")
  if not nm:match("^Param") and not nm:match("^%s*$") then f:write(t,"\t",p,"\t",nm,"\t",string.format("%.4f",reaper.TrackFX_GetParam(tr,0,p)),"\t",fv,"\n") end end end
f:close()
local d=io.open(PROJ.."/r2_done.txt","w") d:write("dumped\n") d:close()
