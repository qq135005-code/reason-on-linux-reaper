local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
-- Moonlight Sonata mvt1 bars 1-14 + final C#m chord. Tracks: 0 Melody(Polytone->RV7000) 1 Arp(Europa->RV7000) 2 Bass(Subtractor->RV7000); Master: Rack Effect MClass Maximizer
local OUT=PROJ..""
local notes=dofile(OUT.."/ml_notes.lua")
reaper.SetCurrentBPM(0,60,false)
local T={}; for i=0,2 do T[i]=reaper.GetTrack(0,i) end
local names={[0]="Melody (Polytone)",[1]="Arp (Europa)",[2]="Bass (Subtractor)"}
for i=0,2 do reaper.GetSetMediaTrackInfo_String(T[i],"P_NAME",names[i],true) end
local log=io.open(OUT.."/moonlight_settings.log","w")
local function P(tr,idx,v) local t=(tr=="M") and reaper.GetMasterTrack(0) or T[tr]; reaper.TrackFX_SetParam(t,0,idx,v)
  local _,n=reaper.TrackFX_GetParamName(t,0,idx,""); local _,f=reaper.TrackFX_GetFormattedParamValue(t,0,idx,"")
  log:write(tostring(tr),"\t",idx,"\t",n,"\t",v,"\t",f,"\n") end
local cfg=io.open(OUT.."/moonlight_cfg.lua") and dofile(OUT.."/moonlight_cfg.lua") or {}
for t=0,2 do for i=reaper.CountTrackMediaItems(T[t])-1,0,-1 do reaper.DeleteTrackMediaItem(T[t],reaper.GetTrackMediaItem(T[t],i)) end
  reaper.SetMediaTrackInfo_Value(T[t],"B_MUTE",0) end
---------------- 0 MELODY: Polytone Init -> soft sine-ish lead with delayed vibrato
P(0,110,0)                    -- layer mode: single (A)
P(0,19,cfg.w1 or 0.6) P(0,39,cfg.w2 or 0.6)   -- osc waves (soft wave, verified on screenshot)
P(0,13,0.0) P(0,33,0.0)       -- no shaping
P(0,37,0.508)                 -- osc2 +few cents
P(0,45,0.5) P(0,43,0.55) P(0,41,0.0)  -- mix 50/50, level, no noise
P(0,51,0.40) P(0,57,0.08) P(0,47,0.62) P(0,49,0.60) P(0,53,0.5) P(0,59,0.0) -- filter LP, gentle env/vel/kbd
P(0,67,0.15) P(0,69,0.55) P(0,73,0.55) P(0,71,0.5) -- filter env
P(0,75,0.14) P(0,77,0.60) P(0,81,0.72) P(0,79,0.52) -- amp env: soft attack, long release
P(0,98,0.62)                  -- amp velocity
P(0,65,0) P(0,63,0.42) P(0,61,0.45)  -- mod LFO sine, ~5Hz, delayed
P(0,11,cfg.vib or 0.535) P(0,31,cfg.vib or 0.535)  -- osc pitch mod <- LFO (vibrato depth)
P(0,105,0.18) P(0,106,1) P(0,102,0.0) P(0,107,0.08) P(0,126,0.70)
P(0,100,0.0)
-- RV7000: Hall, long, darkish
P(0,134,0.2222) P(0,128,0.24) P(0,129,0.62) P(0,130,0.45) P(0,149,0.62) P(0,154,0.12)
---------------- 1 ARP: Europa Init -> warm bell/e-piano keys
P(1,16,0.10) P(1,30,0.0) P(1,32,0.5) -- eng1 near-sine, unison count 1
P(1,34,0.0) P(1,35,0.625) P(1,36,0.52) P(1,38,0.0) P(1,52,0.0) -- eng2 +1 oct sine (bell overtone), slightly detuned
P(1,78,0.70) P(1,80,0.28) P(1,82,0.0) -- levels: eng3 off
P(1,79,0.42) P(1,81,0.60)      -- slight spread
P(1,85,0.42) P(1,86,0.05) P(1,88,0.30) P(1,89,0.40) P(1,84,0.15) -- filter
P(1,94,0.06) P(1,95,0.55) P(1,96,0.32) P(1,97,0.42) P(1,92,0.45) P(1,91,0.75) -- amp env + vel
P(1,99,0.45)                   -- env2 rate (filter env)
P(1,142,1) P(1,144,0) P(1,145,0) P(1,148,1) P(1,154,0) P(1,155,0.25) P(1,156,0.15) P(1,157,0.4) -- Europa FX: gentle chorus only
P(1,90,0.70)
P(1,185,0.2222) P(1,179,0.30) P(1,180,0.66) P(1,181,0.40) P(1,200,0.66) P(1,205,0.10) -- RV7000 Hall
---------------- 2 BASS: Subtractor Init -> warm, slow-attack octave bass (string-like)
P(2,33,0.0) P(2,40,1) P(2,41,cfg.b2w or 0.0) P(2,44,0.53) P(2,48,0.42) -- osc1 saw, osc2 saw detuned
P(2,28,1.0) P(2,25,0.30) P(2,26,0.10) P(2,27,0.25)   -- LP24, low cutoff, kbd track
P(2,23,0.22) P(2,19,0.25) P(2,20,0.60) P(2,21,0.35) P(2,22,0.5) -- filter env swell
P(2,7,0.30) P(2,8,0.85) P(2,9,0.85) P(2,10,0.55)  -- amp env: slow attack, long release
P(2,77,0.62) P(2,82,0.60)
P(2,51,0.30) P(2,52,0.10) P(2,54,0.5)  -- LFO1 slow, subtle (dest ~ filter)
P(2,11,0.62)
P(2,94,0.2222) P(2,88,0.18) P(2,89,0.55) P(2,90,0.55) P(2,109,0.60)  -- RV7000 Hall (less wet on bass)
---------------- MASTER: MClass Maximizer
P("M",9,1) P("M",10,1) P("M",11,0.5) P("M",12,1.0) P("M",14,0)
P("M",8,cfg.ing or 0.5039) P("M",13,cfg.outg or 0.45)
log:close()
---------------- MIDI with ritardando (bars 13-14: 60 -> 44 BPM), then final C#m chord
local function qt(q) -- quarter position -> seconds
  if q<=48 then return q end
  local t=48; local step=0.01; local x=48
  while x<q-1e-9 do local h=math.min(step,q-x); local bpm=(x<56) and (60-16*(x+h/2-48)/8) or 44; t=t+h*60/bpm; x=x+h end
  return t end
local ENDQ=56+5
local tk={}
for t=0,2 do local it=reaper.CreateNewMIDIItemInProj(T[t],0,qt(ENDQ),false); tk[t]=reaper.GetActiveTake(it) end
math.randomseed(14)
local function N(t,q,d,p,v)
  local s=qt(q)+(math.random()-0.5)*0.006; if s<0 then s=0 end; local e=qt(q+d)
  v=math.max(1,math.min(127,math.floor(v+math.random(-3,3))))
  reaper.MIDI_InsertNote(tk[t],false,false,reaper.MIDI_GetPPQPosFromProjTime(tk[t],s),reaper.MIDI_GetPPQPosFromProjTime(tk[t],e),0,p,v,true) end
local function dyn(q) -- gentle hairpin shape
  if q<16 then return 0.9 elseif q<40 then return 1.0 elseif q<48 then return 1.05 else return 1.0-0.25*(q-48)/8 end end
for _,n in ipairs(notes) do local t,q,d,p=n[1],n[2],n[3],n[4]
  if t==1 then local first=(math.abs((q*3)-math.floor(q*3+0.5))<0.01) and (math.floor(q*3+0.5)%3==0)
    N(1,q,d*1.05,p,(first and 60 or 50)*dyn(q))
  elseif t==0 then N(0,q,d*0.97,p,82*dyn(q))
  else N(2,q,d*0.98,p,72*dyn(q)) end end
-- final C#m (bar 15 replacement): rolled arpeggio + bass octave + melody G#
N(2,56,4.6,25,62) N(2,56,4.6,37,62)
N(1,56,4.4,56,48) N(1,56.33,4.1,61,44) N(1,56.67,3.8,64,42)
N(0,56,4.0,68,64)
for t=0,2 do reaper.MIDI_Sort(tk[t]) end
---------------- mix
local vols=cfg.vols or {[0]=0.55,[1]=0.6,[2]=0.6}; local pans={[0]=0.05,[1]=-0.12,[2]=0.08}
for t=0,2 do reaper.SetMediaTrackInfo_Value(T[t],"D_VOL",vols[t]) reaper.SetMediaTrackInfo_Value(T[t],"D_PAN",pans[t]) end
local M=reaper.GetMasterTrack(0)
-- master volume fade-out over the last chord (REAPER envelope, not a limiter)
local env=reaper.GetTrackEnvelopeByName(M,"Volume"); 
if not env then for i=0,2 do reaper.SetTrackSelected(T[i],false) end reaper.SetTrackSelected(M,true); reaper.Main_OnCommand(40406,0); env=reaper.GetTrackEnvelopeByName(M,"Volume") end
if env then reaper.DeleteEnvelopePointRange(env,-1,10000)
  local sc=reaper.GetEnvelopeScalingMode(env)
  local function pt(t,g) reaper.InsertEnvelopePoint(env,t,reaper.ScaleToEnvelopeMode(sc,g),0,0,false,true) end
  pt(0,1) pt(qt(57),1) pt(qt(ENDQ)+3.5,0.0) reaper.Envelope_SortPoints(env) end
---------------- render settings
reaper.GetSetProjectInfo(0,"RENDER_SRATE",44100,true); reaper.GetSetProjectInfo(0,"RENDER_CHANNELS",2,true)
reaper.GetSetProjectInfo(0,"RENDER_BOUNDSFLAG",0,true)
reaper.GetSetProjectInfo(0,"RENDER_STARTPOS",0,true); reaper.GetSetProjectInfo(0,"RENDER_ENDPOS",qt(ENDQ)+3.6,true)
reaper.GetSetProjectInfo_String(0,"RENDER_FILE",OUT,true)
reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN","moonlight_reason",true)
reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT","bDNwbUABAAAAAAAAAgAAAP////8EAAAAQAEAAAAAAAA=",true)
reaper.Main_SaveProjectEx(0,OUT.."/moonlight_reason.rpp",0)
local d=io.open(OUT.."/r2_done.txt","w") d:write("built "..tostring(env~=nil).." "..qt(ENDQ).."\n") d:close()
