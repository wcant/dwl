PRO dwl_timeseries_analysis

file='C:\Users\Wes Cantrell\Dropbox\DWL\20130905\noon\20130905_17.sav'
RESTORE,filename=file,/verbose

SNR_threshold=1.015
max_alt=1.0

time  = data[*,0,0]  
;altitude = (range gate + 0.5) * gate length(meters)
alt = ((data[0,1:199,0] +0.5) * 30.)/1000.
azimuth = data[*,0,1]
elevation =data[*,0,2]
doppler = data[*,1:199,1]
intensity =  data[*,1:199,2]
beta  = alog10(data[*,1:199,3])

alt_indices = WHERE(alt LE max_alt)
alt = alt[alt_indices]
doppler = doppler[*,alt_indices]
intensity = intensity[*,alt_indices]
beta = beta[*,alt_indices]
stop

alt_range=[MIN(alt), max_alt]
time_range=[MIN(time), MAX(time)]
doppler_range=[MIN(doppler), MAX(doppler)]
intensity_range=[MIN(intensity), MAX(intensity)]
beta_range=[MIN(beta), MAX(beta)]


ofile0='C:\Users\Wes Cantrell\Dropbox\DWL\20130905\noon\20130905_17_stare_utc_rainbow.ps'

SET_PLOT,'ps'
!p.thick=3.0 & !x.thick=1.5 & !y.thick=1.5 & !p.charsize=1.5  
DEVICE,filename=ofile0,/color

END