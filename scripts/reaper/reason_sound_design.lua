local PROJ = os.getenv("REASON_PROJ") or ((os.getenv("HOME") or ".").."/reaper_projects")
-- Reason Rack Plugin sound design song. Run in the instance that has reason_sound_design.rpp open
-- (track1 Europa(reset), track2 Subtractor(reset), track3 Thor(reset), track4 Kong(default kit)).
local OUT=PROJ..""
local BPM=124; local beat=60/BPM; local bar=4*beat; local BARS=36
reaper.SetCurrentBPM(0,BPM,false)
local T={}; for i=0,3 do T[i+1]=reaper.GetTrack(0,i) end
local log=io.open(OUT.."/sd_settings.log","w")
local function P(tr,idx,v) reaper.TrackFX_SetParam(T[tr],0,idx,v)
  local _,n=reaper.TrackFX_GetParamName(T[tr],0,idx,""); local _,f=reaper.TrackFX_GetFormattedParamValue(T[tr],0,idx,"")
  log:write(tr,"\t",idx,"\t",n,"\t",v,"\t",f,"\n") end
-- clear old items/envelopes
for t=1,4 do for i=reaper.CountTrackMediaItems(T[t])-1,0,-1 do reaper.DeleteTrackMediaItem(T[t],reaper.GetTrackMediaItem(T[t],i)) end
  reaper.SetMediaTrackInfo_Value(T[t],"B_MUTE",0) end
------------------------------------------------ 1 PAD: Europa (from Reset Device)
P(1,8,0.47)      -- voices
P(1,13,0.5)      -- Eng1 Oct 0
P(1,16,0.30) P(1,17,0.35)  -- Eng1 wavetable position (Shape) + shape amount
P(1,30,0.67) P(1,31,1.0) P(1,32,0.62) P(1,33,1.0) -- Unison count / blend / detune / spread (supersaw-ish)
P(1,29,0.25)     -- Harmonics amt
P(1,23,0.55)     -- Eng1 spectral filter freq
P(1,85,0.42) P(1,86,0.25) P(1,84,0.25) -- main filter freq / reso / drive
P(1,94,0.55) P(1,95,0.70) P(1,96,0.80) P(1,97,0.62) -- Amp ADSR slow (pad)
P(1,90,0.75)
P(1,142,1) P(1,148,1) P(1,154,0) P(1,155,0.45) P(1,156,0.15) P(1,157,0.6) P(1,158,0.9) -- chorus/mod fx
P(1,144,1) P(1,174,0.85) P(1,175,0.7) P(1,176,0.45) P(1,173,0.4) -- reverb
P(1,145,0) P(1,146,0) P(1,147,0)
------------------------------------------------ 2 BASS: Subtractor reese/sub (from Reset Device)
P(2,33,0.0) P(2,34,0.3333)              -- osc1 saw, octave 3
P(2,40,1) P(2,41,0.0) P(2,42,0.3333) P(2,44,0.535) -- osc2 on, saw, oct3, fine +detune => reese beating
P(2,48,0.45)                            -- osc mix
P(2,28,1.0) P(2,25,0.32) P(2,26,0.30) P(2,27,0.3) -- LP24 (1.0), cutoff, reso, kbd
P(2,23,0.40) P(2,19,0.0) P(2,20,0.32) P(2,21,0.25) P(2,22,0.2) -- filter env
P(2,7,0.0) P(2,8,0.6) P(2,9,0.85) P(2,10,0.12)  -- amp env
P(2,51,0.25) P(2,52,0.12) P(2,54,0.4) -- LFO1 slow triangle -> Filter Freq
P(2,61,0)                               -- key mode
P(2,11,0.62)
------------------------------------------------ 3 PLUCK: Thor (from Reset Device)
P(3,26,0.0)                         -- analog osc1 saw
P(3,89,0.30) P(3,90,0.40) P(3,83,0.62) P(3,85,0.45) P(3,86,0.35) P(3,87,0.55) -- ladder LP: freq, res, env amt, vel, kbd, drive
P(3,143,0.0) P(3,144,0.36) P(3,145,0.0) P(3,146,0.30) -- filter env (pluck)
P(3,148,0.0) P(3,149,0.48) P(3,150,0.0) P(3,151,0.32) -- amp env
P(3,153,0.35)
P(3,175,1) P(3,180,1) P(3,176,0.5) P(3,179,0.45) P(3,181,0.28) -- delay synced
P(3,169,1) P(3,171,0.35) P(3,174,0.35) -- chorus
P(3,19,0.85)
------------------------------------------------ 4 DRUMS: Kong default kit, tweaked
P(4,18,0.44) P(4,19,0.32)  -- kick: lower pitch, longer decay
P(4,13,0.80)
P(4,30,0.54) P(4,31,0.40)  -- snare pitch up, tighter
P(4,37,1.0) P(4,49,0.6)    -- hats level
P(4,7,0.80)
log:close()
------------------------------------------------ MIDI
local function item(t) local it=reaper.CreateNewMIDIItemInProj(T[t],0,BARS*bar,false); return reaper.GetActiveTake(it) end
local tk={item(1),item(2),item(3),item(4)}
local function N(t,b,st,len,p,v) local s=(b*4+st)*beat
  reaper.MIDI_InsertNote(tk[t],false,false,reaper.MIDI_GetPPQPosFromProjTime(tk[t],s),reaper.MIDI_GetPPQPosFromProjTime(tk[t],s+len*beat),0,p,v,true) end
-- Am - F - C - G (A minor)
local chords={{57,60,64,67},{53,57,60,64},{48,52,55,60},{55,59,62,67}}; local roots={33,29,36,31}
local arp={{69,72,76,72,79,76,72,76},{69,72,77,72,81,77,72,77},{67,72,76,72,79,76,72,76},{67,71,74,71,79,74,71,74}}
local mel={{76,0,2},{74,2,1},{72,3,1},{72,4,1.5},{69,5.5,0.5},{72,6,2},{71,12,1},{72,13,1},{74,14,2}}
for b=0,BARS-1 do local c=(b%4)+1
  local intro=b<8; local groove=b>=8 and b<16; local drop=b>=16 and b<28; local outro=b>=28
  -- pad
  local pv=intro and 70 or (drop and 92 or 78); if outro then pv=math.max(40,85-(b-28)*6) end
  for _,p in ipairs(chords[c]) do N(1,b,0,3.9,p,pv) end
  -- bass
  if groove or drop then
    for e=0,7 do local st=e*0.5; local v=(e%2==1) and 110 or 85
      if drop or e%2==1 then N(2,b,st,0.45,roots[c],v) end end
    if drop and c==4 then N(2,b,3.5,0.45,roots[c]+12,115) end
  elseif outro and b<32 then N(2,b,0,3.5,roots[c],80) end
  -- pluck arp (16ths in drop, 8ths otherwise)
  if b>=4 then local step=drop and 0.25 or 0.5; local n=0
    for s=0,4-step/2,step do n=n+1; local a=arp[c][((n-1)%8)+1]; if drop then a=a-12 end
      local v=(intro and 60 or 85)+((n%2==1) and 15 or 0); if outro then v=math.max(35,v-(b-28)*6) end
      N(3,b,s,step*0.8,a,v) end end
  if drop and b%2==0 then end
  -- drums (Kong pads: 36 kick, 37 snare, 41 clap, 38 closed hat, 39 open hat, 48 shaker, 47 crash)
  if groove or drop or (outro and b<32) then
    for q=0,3 do N(4,b,q,0.25,36,120) end
    N(4,b,1,0.25,37,105) N(4,b,3,0.25,37,110)
    if drop then N(4,b,1,0.25,41,90) N(4,b,3,0.25,41,95) end
    for e=0,7 do if e%2==1 then N(4,b,e*0.5,0.2,39,85) else N(4,b,e*0.5,0.2,38,70) end end
    if drop then for s=0,15 do if s%2==1 then N(4,b,s*0.25,0.1,48,55+(s%4==3 and 20 or 0)) end end end
    if b==8 or b==16 then N(4,b,0,1,47,110) end
    if (b%8==7) and not outro then for s=12,15 do N(4,b,s*0.25,0.2,37,70+s*3) end end
  elseif intro and b>=6 then N(4,b,0,0.25,36,100) N(4,b,2,0.25,36,100) end
end
-- lead melody on Thor octave above arp during drop (bars 16-27, phrase every 4 bars)
for ph=0,2 do for _,m in ipairs(mel) do N(3,16+ph*4,m[2],m[3]*0.95,m[1]+12,108) end end
for t=1,4 do reaper.MIDI_Sort(tk[t]) end
------------------------------------------------ automation: pad filter opens in intro, closes in outro
local env=reaper.GetFXEnvelope(T[1],0,85,true)
reaper.DeleteEnvelopePointRange(env,0,1000)
for _,pt in ipairs({{0,0.18},{8*bar,0.42},{16*bar,0.55},{28*bar,0.55},{36*bar,0.2}}) do reaper.InsertEnvelopePoint(env,pt[1],pt[2],0,0,false,true) end
reaper.Envelope_SortPoints(env)
local env3=reaper.GetFXEnvelope(T[3],0,89,true)
reaper.DeleteEnvelopePointRange(env3,0,1000)
for _,pt in ipairs({{0,0.18},{16*bar,0.32},{16*bar+0.01,0.36},{28*bar,0.40},{36*bar,0.18}}) do reaper.InsertEnvelopePoint(env3,pt[1],pt[2],0,0,false,true) end
reaper.Envelope_SortPoints(env3)
------------------------------------------------ mix
local vols={0.42,0.85,1.3,0.8}; local pans={0,0,0.15,0}
for t=1,4 do reaper.SetMediaTrackInfo_Value(T[t],"D_VOL",vols[t]) reaper.SetMediaTrackInfo_Value(T[t],"D_PAN",pans[t]) end
local M=reaper.GetMasterTrack(0)
while reaper.TrackFX_GetCount(M)>0 do reaper.TrackFX_Delete(M,0) end
local li=reaper.TrackFX_AddByName(M,"JS:LOSER/masterLimiter",false,-1)
local f=io.open(OUT.."/sd_master.log","w"); f:write("limiter idx ",li,"\n")
if li>=0 then for p=0,reaper.TrackFX_GetNumParams(M,li)-1 do local _,n=reaper.TrackFX_GetParamName(M,li,p,""); local _,fv=reaper.TrackFX_GetFormattedParamValue(M,li,p,""); f:write(p," ",n," = ",fv,"\n") end end
if li>=0 then reaper.TrackFX_SetParam(M,li,0,-4) reaper.TrackFX_SetParam(M,li,5,-1.0) local _,a=reaper.TrackFX_GetFormattedParamValue(M,li,0,"") local _,b=reaper.TrackFX_GetFormattedParamValue(M,li,5,"") f:write("set thr ",a," limit ",b,"\n") end
f:close()
reaper.SetMediaTrackInfo_Value(M,"D_VOL",1.0)
------------------------------------------------ render
reaper.GetSetProjectInfo(0,"RENDER_SRATE",44100,true); reaper.GetSetProjectInfo(0,"RENDER_CHANNELS",2,true)
reaper.GetSetProjectInfo(0,"RENDER_BOUNDSFLAG",1,true)
reaper.GetSetProjectInfo(0,"RENDER_TAILFLAG",1,true); reaper.GetSetProjectInfo(0,"RENDER_TAILMS",3000,true)
reaper.GetSetProjectInfo_String(0,"RENDER_FILE",OUT,true)
reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN","reason_sound_design",true)
reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT","bDNwbUABAAAAAAAAAgAAAP////8EAAAAQAEAAAAAAAA=",true)
reaper.Main_SaveProjectEx(0,OUT.."/reason_sound_design.rpp",0)
if not os.getenv("SD_NORENDER") then os.remove(OUT.."/reason_sound_design.mp3"); reaper.Main_OnCommand(42230,0) end
