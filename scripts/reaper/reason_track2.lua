local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
-- Reason Rack Plugin track 2. Tracks: 0 Lead(Polytone->Ripley) 1 Bass(Monotone->Scream4) 2 Drums(Redrum->Pulveriser)
-- 3 Keys(ID8 piano->The Echo->Audiomatic) 4 Pad(Malstrom->Synchronous->RV7000)
local OUT=PROJ..""
local BPM=120; local beat=60/BPM; local bar=4*beat; local BARS=52
reaper.SetCurrentBPM(0,BPM,false)
math.randomseed(2026)
local T={}; for i=0,4 do T[i]=reaper.GetTrack(0,i) end
local log=io.open(OUT.."/r2_settings.log","w")
local function P(tr,idx,v) reaper.TrackFX_SetParam(T[tr],0,idx,v)
  local _,n=reaper.TrackFX_GetParamName(T[tr],0,idx,""); local _,f=reaper.TrackFX_GetFormattedParamValue(T[tr],0,idx,"")
  log:write(tr,"\t",idx,"\t",n,"\t",v,"\t",f,"\n") end
for t=0,4 do for i=reaper.CountTrackMediaItems(T[t])-1,0,-1 do reaper.DeleteTrackMediaItem(T[t],reaper.GetTrackMediaItem(T[t],i)) end
  reaper.SetMediaTrackInfo_Value(T[t],"B_MUTE",0)
  for e=reaper.CountTrackEnvelopes(T[t])-1,0,-1 do local env=reaper.GetTrackEnvelope(T[t],e); reaper.DeleteEnvelopePointRange(env,-1,10000) end end
------------------------------------------------ 0 LEAD: Polytone (Reset) -> Ripley Space Delay
P(0,110,0)                         -- layer mode single (layer A)
P(0,19,0) P(0,39,0)                -- osc1/osc2 saw
P(0,13,0.18)                       -- osc1 shape (slight waveshaping)
P(0,37,0.535)                      -- osc2 tune + few cents (detune)
P(0,45,0.45) P(0,43,0.6)           -- osc mix, level
P(0,51,0.50) P(0,57,0.28) P(0,47,0.70) P(0,49,0.62) P(0,53,0.4) -- filter freq/reso/env amt/vel/kbd
P(0,67,0.0) P(0,69,0.42) P(0,73,0.35) P(0,71,0.40)   -- filter env
P(0,75,0.03) P(0,77,0.55) P(0,81,0.80) P(0,79,0.38)  -- amp env
P(0,100,0.35)                      -- voice spread
P(0,105,0.30) P(0,106,0) P(0,102,0.12) P(0,103,0.45) -- built-in chorus + small reverb
P(0,107,0.22)                      -- age (analog drift)
P(0,126,0.65)
-- Ripley
P(0,160,0)                         -- noise off
P(0,141,0.38) P(0,236,0.28) P(0,155,0.55) P(0,156,0.70) -- feedback, dry/wet, space amount/decay
P(0,239,1) P(0,238,0.45)           -- ducker: echoes duck under the lead
------------------------------------------------ 1 BASS: Monotone (Reset) -> Scream 4
P(1,16,0.0) P(1,19,1.0) P(1,14,0.35) P(1,13,0.53) -- osc1 saw, osc2 square, mix, detune
P(1,22,0.0)                        -- noise off
P(1,27,0.28) P(1,31,0.30) P(1,25,0.60) P(1,26,0.55) P(1,28,0.30) P(1,33,0.55) -- filter
P(1,23,0.0) P(1,24,0.30) P(1,32,0.20) P(1,30,0.25) -- filter env (pluck-ish)
P(1,34,0.0) P(1,35,0.55) P(1,37,0.75) P(1,36,0.12) P(1,38,0.45) -- amp env + vel
P(1,7,0.12) P(1,8,0.5)             -- short portamento
P(1,39,0.72)
-- Scream 4: Tape saturation
P(1,52,0.4444) P(1,51,0.38) P(1,53,0.55) P(1,54,0.5) P(1,59,0) P(1,56,0.55) P(1,57,0.5) P(1,58,0.42) P(1,64,0.62)
------------------------------------------------ 2 DRUMS: Redrum Hip Hop Kit 03 -> Pulveriser
P(2,110,0)                         -- pattern sequencer off (MIDI only)
P(2,78,0.46) P(2,94,0.30) P(2,68,0.80)  -- kick: lower pitch, darker tone, longer
P(2,80,0.45)                       -- clap pitch
P(2,85,0.62) P(2,55,0.50) P(2,56,0.45) P(2,75,0.6) -- hats
P(2,45,0.35) P(2,46,0.65) P(2,47,0.58)   -- hat/open-hat/ride pan
P(2,7,0.80)
P(2,123,0.50) P(2,125,0.25) P(2,126,0.65) P(2,130,0) P(2,143,0.55) P(2,145,0.62) -- Pulveriser: squash, dirt, tone, filter bypass, parallel blend
------------------------------------------------ 3 KEYS: ID8 Grand piano -> The Echo -> Audiomatic
P(3,9,1.0)
P(3,39,0.22) P(3,22,0.35) P(3,16,0.55) P(3,29,1) P(3,30,0.45) P(3,27,0.25) P(3,33,0.25) -- echo: wet, fb, time, filter, drive, wobble
P(3,11,0) P(3,14,0.30) P(3,15,0.55) P(3,13,0.68) -- Audiomatic "Tape" preset, transform, dry/wet
------------------------------------------------ 4 PAD: Malstrom (Reset) -> Synchronous -> RV7000
P(4,38,1) P(4,39,0.30) P(4,40,0.62) P(4,44,0.55)  -- osc A on, wavetable index, motion, shift
P(4,26,1) P(4,27,0.62) P(4,28,0.40) P(4,31,0.56) P(4,29,0.5) -- osc B on, index, motion, cent detune
P(4,45,0.45) P(4,46,0.85) P(4,47,1.0) P(4,48,0.55) P(4,49,0.62) -- osc A ADSR (slow swell)
P(4,33,0.50) P(4,34,0.85) P(4,35,1.0) P(4,36,0.55) P(4,37,0.55) -- osc B ADSR
P(4,62,1) P(4,63,0.0) P(4,64,0.42) P(4,65,0.25) P(4,66,1) P(4,67,0.4) -- filter A lp12
P(4,50,1) P(4,51,0.0) P(4,52,0.48) P(4,53,0.2) P(4,61,1) P(4,58,0.4) P(4,83,1) -- filter B lp12, osc B -> filter B
P(4,54,0.35) P(4,55,0.8) P(4,56,0.6) P(4,57,0.55) P(4,59,0.35) -- filter env
P(4,7,1) P(4,9,0.18) P(4,15,0.62)  -- mod A slow -> shift
P(4,16,1) P(4,18,0.12) P(4,23,0.60) -- mod B slow -> filter
P(4,91,0.75) P(4,90,0.85)          -- stereo spread, level
-- Synchronous: gentle rhythmic filter + level pulse
P(4,217,0) P(4,194,1) P(4,195,0.62) P(4,197,0.3333) P(4,196,0.25) P(4,225,0.62) P(4,263,1.0) P(4,264,0.62) -- Synchronous: LP filter swept by curve 1 (level lane off)
-- RV7000 Hall
P(4,99,0.2222) P(4,114,0.75) P(4,94,0.72) P(4,95,0.35) P(4,119,0.15) P(4,93,0.38)
for _,q in ipairs({39,27,64,90}) do log:write("readback 4 ",q," ",reaper.TrackFX_GetParam(T[4],0,q),"\n") end
log:close()
------------------------------------------------ MIDI
local tk={}
for t=0,4 do local it=reaper.CreateNewMIDIItemInProj(T[t],0,BARS*bar,false); tk[t]=reaper.GetActiveTake(it) end
local function hv(v,r) r=r or 7; v=v+math.random(-r,r); return math.max(1,math.min(127,math.floor(v))) end
local function N(t,b,st,len,p,v,jit) local s=(b*4+st)*beat + (jit and (math.random()-0.5)*0.008 or 0)
  if s<0 then s=0 end
  reaper.MIDI_InsertNote(tk[t],false,false,reaper.MIDI_GetPPQPosFromProjTime(tk[t],s),reaper.MIDI_GetPPQPosFromProjTime(tk[t],s+len*beat),0,p,hv(v),true) end
-- F minor. chord tables: pad voicing, piano voicing, bass root
local C={
 Fm={pad={53,56,60,65},pno={60,65,68,72},root=41},
 Db={pad={53,56,61,65},pno={61,65,68,73},root=37},
 Ab={pad={51,56,60,63},pno={60,63,68,72},root=44},
 Eb={pad={51,55,58,63},pno={58,63,67,70},root=39},
 Cm={pad={51,55,60,63},pno={60,63,67,72},root=36},
 Bbm={pad={53,58,61,65},pno={61,65,70,73},root=46},
}
local verse={"Fm","Db","Ab","Eb"}; local chorus={"Db","Eb","Cm","Fm"}; local brk={"Db","Ab","Bbm","Eb"}
local function sect(b)
  if b<8 then return "intro",verse[b%4+1]
  elseif b<16 then return "verse",verse[b%4+1]
  elseif b<20 then return "build",({"Db","Eb","Db","Eb"})[b-15]
  elseif b<32 then return "chorus",chorus[b%4+1]
  elseif b<40 then return "break",brk[b%4+1]
  elseif b<48 then return "chorus2",chorus[b%4+1]
  else return "outro",verse[b%4+1] end end
-- lead melody (2 x 4 bars) [pitch, start beat, length]
local melA={{{72,0,1.5},{68,1.5,.5},{70,2,.5},{72,2.5,.5},{73,3,1}},
            {{75,0,1.5},{73,1.5,.5},{72,2,1},{70,3,1}},
            {{72,0,1},{67,1,.5},{68,1.5,.5},{70,2,1},{72,3,.5},{75,3.5,.5}},
            {{77,0,2.5},{75,2.5,.5},{72,3,1}}}
local melB={melA[1],melA[2],melA[3],{{77,0,1},{79,1,1},{80,2,2}}}
for b=0,BARS-1 do
  local s,ch=sect(b); local c=C[ch]; local pb=b%4
  -- PAD
  local pv=({intro=62,verse=70,build=78,chorus=88,["break"]=80,chorus2=92,outro=60})[s]
  if s=="outro" then pv=math.max(35,70-(b-48)*8) end
  for _,p in ipairs(c.pad) do N(4,b,0,3.95,p,pv) end
  if s=="chorus" or s=="chorus2" then N(4,b,0,3.95,c.pad[#c.pad]+12,pv-15) end
  -- KEYS
  if s=="intro" then
    for i,p in ipairs(c.pno) do N(3,b,0+(i-1)*0.05,2.8,p,hv(60)) end
    if pb%2==1 then N(3,b,3,1,c.pno[4]+12,55) end
  elseif s=="verse" or s=="outro" then
    local arp={1,2,3,4,3,2,4,3}
    for e=0,7 do local v=(e%2==0) and 72 or 58; if s=="outro" then v=v-(b-48)*7 end
      N(3,b,e*0.5,0.45,c.pno[arp[e+1]],math.max(30,v),true) end
  elseif s=="build" then
    for e=0,7 do N(3,b,e*0.5,0.4,c.pno[(e%4)+1],60+(b-16)*6+e,true) end
  elseif s=="chorus" or s=="chorus2" then
    for _,st in ipairs({0.5,1.5,2.5,3.0,3.5}) do for _,p in ipairs(c.pno) do N(3,b,st,0.35,p,(st==3.0) and 60 or 76,true) end end
  elseif s=="break" then
    local arp={1,3,4,2+2}; for q=0,3 do N(3,b,q,0.9,c.pno[arp[q+1]]+12,64,true) end
    for _,p in ipairs(c.pno) do N(3,b,0,3.8,p-12,50) end
  end
  -- BASS
  if s=="verse" then
    N(1,b,0,1.4,c.root,100) N(1,b,1.5,0.4,c.root,80,true) N(1,b,2.5,0.4,c.root+12,88,true) N(1,b,3,0.9,c.root,84,true)
  elseif s=="build" then
    for e=0,7 do N(1,b,e*0.5,0.4,c.root,70+(b-16)*8,true) end
  elseif s=="chorus" or s=="chorus2" then
    for e=0,7 do local p=c.root; if e==3 or e==7 then p=c.root+12 end
      N(1,b,e*0.5+0.0,0.42,p,(e%2==1) and 110 or 92,true) end
  elseif s=="break" and b>=36 then N(1,b,0,3.8,c.root,80)
  elseif s=="outro" and b<50 then N(1,b,0,3.8,c.root,75) end
  -- DRUMS (Redrum: 36 kick,38 clap,39 snare,43 closed hat,44 open hat,45 ride)
  if s=="verse" then
    N(2,b,0,0.25,36,118) N(2,b,1.75,0.25,36,82,true) N(2,b,2,0.25,36,110) 
    N(2,b,1,0.25,39,100,true) N(2,b,3,0.25,39,106,true)
    for e=0,7 do N(2,b,e*0.5,0.2,43,(e%2==0) and 78 or 56,true) end
  elseif s=="build" then
    for q=0,3 do N(2,b,q,0.25,36,112) end
    local div=(b<18) and 2 or 4; if b==19 then div=8 end
    for k=0,4*div/ (b==19 and 1 or 1)-1 do if k*4/div<4 then N(2,b,k*4/div,0.1,39,55+math.floor((b-16)*12+k*40/(4*div)),true) end end
  elseif s=="chorus" or s=="chorus2" then
    for q=0,3 do N(2,b,q,0.25,36,120) end
    N(2,b,1,0.25,38,108,true) N(2,b,3,0.25,38,112,true) N(2,b,1,0.25,39,80,true) N(2,b,3,0.25,39,84,true)
    for x=0,15 do if x%4==2 then N(2,b,x*0.25,0.4,44,82,true) elseif x%4~=0 then N(2,b,x*0.25,0.1,43,(x%2==1) and 52 or 70,true) end end
    if b==20 or b==40 or b==28 then N(2,b,0,2,45,95) end
    if s=="chorus2" then N(2,b,3.75,0.25,36,70,true) end
    if b%4==3 then N(2,b,3.5,0.1,39,90,true) N(2,b,3.75,0.1,39,100,true) end
  elseif s=="break" and b>=36 then
    N(2,b,0,0.25,36,90) for e=0,7 do N(2,b,e*0.5,0.2,45,(e%2==0) and 60 or 45,true) end
    if b==39 then for k=0,7 do N(2,b,2+k*0.25,0.1,39,60+k*7,true) end end
  elseif s=="intro" and b>=4 then for e=0,7 do N(2,b,e*0.5,0.2,43,(e%2==0) and 50 or 36,true) end
  elseif s=="outro" and b<50 then N(2,b,0,0.25,36,96) N(2,b,2,0.25,36,90) for e=0,7 do N(2,b,e*0.5,0.2,43,50,true) end end
end
-- LEAD melody in chorus (b20-31) and chorus2 (40-47) + octave doubling in chorus2, breakdown echo phrase
local function phrase(b0,mel,tr,off,vel) for i=1,4 do for _,m in ipairs(mel[i]) do N(tr,b0+i-1,m[2],m[3]*0.92,m[1]+off,vel+(m[2]==0 and 10 or 0),true) end end end
phrase(20,melA,0,0,96) phrase(24,melB,0,0,98) phrase(28,melA,0,0,100)
phrase(40,melA,0,0,104) phrase(44,melB,0,0,108) phrase(44,melB,0,12,70)
-- breakdown: lead plays motif an octave lower softly (Ripley echoes)
phrase(36,melA,0,-12,72)
-- verse 2nd half: small call motif
for _,b in ipairs({12,14}) do N(0,b,2,0.5,72,74,true) N(0,b,2.5,0.5,75,70,true) N(0,b,3,1,77,80,true) end
for t=0,4 do reaper.MIDI_Sort(tk[t]) end
------------------------------------------------ automation
local function envpts(tr,fxp,pts) local env=reaper.GetFXEnvelope(T[tr],0,fxp,true)
  reaper.DeleteEnvelopePointRange(env,-1,10000)
  for _,pt in ipairs(pts) do reaper.InsertEnvelopePoint(env,pt[1]*bar,pt[2],0,0,false,true) end reaper.Envelope_SortPoints(env) end
envpts(4,64,{{0,0.22},{8,0.38},{16,0.40},{20,0.55},{32,0.36},{40,0.58},{48,0.45},{52,0.15}}) -- pad filter A
envpts(0,51,{{0,0.42},{20,0.48},{32,0.44},{40,0.56},{52,0.5}})      -- lead filter
envpts(1,27,{{0,0.25},{16,0.25},{19.9,0.42},{20,0.30},{40,0.33},{52,0.25}}) -- bass filter rise in build
------------------------------------------------ mix
local vols={[0]=0.55,[1]=0.85,[2]=0.75,[3]=0.55,[4]=0.42}; local pans={[0]=0.0,[1]=0,[2]=0,[3]=-0.22,[4]=0.12}
local vf=io.open(OUT.."/r2_vols.txt"); if vf then for t=0,4 do vols[t]=vf:read("*n") end vf:close() end
for t=0,4 do reaper.SetMediaTrackInfo_Value(T[t],"D_VOL",vols[t]) reaper.SetMediaTrackInfo_Value(T[t],"D_PAN",pans[t]) end
local M=reaper.GetMasterTrack(0)
while reaper.TrackFX_GetCount(M)>0 do reaper.TrackFX_Delete(M,0) end
local thr=-6; local tf=io.open(OUT.."/r2_thr.txt"); if tf then thr=tf:read("*n") tf:close() end
local li=reaper.TrackFX_AddByName(M,"JS:LOSER/masterLimiter",false,-1)
reaper.TrackFX_SetParam(M,li,0,thr) reaper.TrackFX_SetParam(M,li,5,-1.0) reaper.TrackFX_SetParam(M,li,4,120)
reaper.SetMediaTrackInfo_Value(M,"D_VOL",1.0)
------------------------------------------------ render
reaper.GetSetProjectInfo(0,"RENDER_SRATE",44100,true); reaper.GetSetProjectInfo(0,"RENDER_CHANNELS",2,true)
reaper.GetSetProjectInfo(0,"RENDER_BOUNDSFLAG",1,true)
reaper.GetSetProjectInfo(0,"RENDER_TAILFLAG",1,true); reaper.GetSetProjectInfo(0,"RENDER_TAILMS",4000,true)
reaper.GetSetProjectInfo_String(0,"RENDER_FILE",OUT,true)
reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN","reason_track2",true)
reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT","bDNwbUABAAAAAAAAAgAAAP////8EAAAAQAEAAAAAAAA=",true)
reaper.Main_SaveProjectEx(0,OUT.."/reason_track2.rpp",0)
local d=io.open(OUT.."/r2_done.txt","w") d:write("built\n") d:close()
