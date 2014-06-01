PRO DWL_file_merge, nfiles, files, data

  ;alldata=DBLARR(
data=fltarr(1,201,4)
  FOR j=0, nfiles-1 DO BEGIN

    read_dwl, files[j], single_data, header, dim
    
    print,'finish reading'+ files[j]
    ;stop
    data=[data,single_data]
    if j eq 0 then data=data[1:-1,*,*]
    
  ENDFOR
  
  

END


FUNCTION colordata, data, scale
  
  ;66 bins (from CEILO _CT)
  ;divide domain into 66 bins
  
  ;get binsize
  ;the range of vertical wind velocity is from -4 to +4 m/s
  
  binsize=DOUBLE(6./scale)
  
  n_levels=-3.+findgen(scale)*binsize
  
  del_color=238./scale
  color_levels=(findgen(scale))*del_color+18
  
  ;databins=DBLARR(scale)
  
  ;bindummy=DBLARR()
  ;binvalue=0
  
  color_value=0.
  if data lt -3. then color_value=color_levels[0]
  
  if data gt 3. then color_value = color_levels[-1]
  
  FOR i=1, scale-2 DO BEGIN
  
    if data ge n_levels[i] and data lt n_levels[i+1] then begin
      
      color_value=color_levels[i]
    ;binvalue=binsize+binvalue
    ;bindummy[i]=binvalue
   endif
  
  ENDFOR
  
  ;set first bin eq 0
  ;there will be two 0 bins, velocities between -0.121212 and 0.121212.. will be grouped
  ;This can be easily changed by adjusting the number of colors to odd (65).
  ;Doesn't seem important though and would help keep near zero velocities grouped.

  

  ;maxbin=MIN(WHERE(databins GE data))
  
;  color_value=minbin

  RETURN, color_value
END

FUNCTION colordata_beta, data, scale
  
  ;66 bins (from CEILO _CT)
  ;divide domain into 66 bins
  
  ;get binsize
  ;the range of log10(beta) is from -3 to -8 m/s
  
  binsize=DOUBLE(5./scale)
  
  n_levels=-8.+findgen(scale)*binsize

  del_color=238./scale
  color_levels=(findgen(scale))*del_color+18
  
  ;databins=DBLARR(scale)
  
  ;bindummy=DBLARR()
  ;binvalue=0
  
  color_value=0.
  if data lt -8. then color_value=color_levels[0]
  
  if data gt -3. then color_value = color_levels[-1]
  
  FOR i=1, scale-2 DO BEGIN
  
    if data ge n_levels[i] and data lt n_levels[i+1] then begin
      
      color_value=color_levels[i]
    ;binvalue=binsize+binvalue
    ;bindummy[i]=binvalue
   endif
  
  ENDFOR
  
  ;set first bin eq 0
  ;there will be two 0 bins, velocities between -0.121212 and 0.121212.. will be grouped
  ;This can be easily changed by adjusting the number of colors to odd (65).
  ;Doesn't seem important though and would help keep near zero velocities grouped.

  

  ;maxbin=MIN(WHERE(databins GE data))
  
;  color_value=minbin

  RETURN, color_value
END


;------------------------------------------------------------------------
;PRO CEILO_CT
;;------------------------------------------------------------------------
;
;   ; create a color table where
;   ;   color 0 is white
;   ;   color 15 is black
;   ;   colors 1 - 15 are shades of gray
;   ;   colors 16 - 63 are shades of red
;
;   tvlct,r,g,b,/get
;   r=indgen(256)
;   g=indgen(256)
;   b=indgen(256)
;
;
;  r(0:65)=[255,238,221,204,187,170,153,136,119,102,85,68,51,34,17,0,198,177,163,$
;           136,105,88,56,0,7,15,23,31,38,46,54,62,86,110,134,158,182,206,$
;           230,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,$
;           255,255,255,255,255,255,255,255,255,255,250,255]
;
;  g(0:65)=[255,238,221,204,187,170,153,136,119,102,85,68,51,34,17,0,255,245,225,$
;           204,166,143,116,0,28,56,84,112,140,168,196,224,227,231,235,239,243,247,$
;           251,255,249,243,237,232,226,220,214,209,182,156,130,104,78,52,$
;           26,0,0,0,0,0,0,0,0,0,0,255]
;
;  b(0:65)=[255,238,221,204,187,170,153,136,119,102,85,68,51,34,17,0,255,255,$
;           255,255,255,255,255,255,223,191,159,127,95,63,31,0,0,0,0,0,0,0,$
;         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,31,63,95,127,159,191,223,255,250,255]
;
;
;        ;** The following two lines are needed if using pv-wave versions
;        ;** before 7.5
;        ;if !d.display_depth ge 24 then tvlct, b,g,r $
;        ;else tvlct,r,g,b
;  r(65) = 15
;  g(65) = 15
; 
; b(65) = 15
;tvlct,r,g,b
;END


PRO DWL_curtain

;files = FILE_SEARCH('/nas/rgroup1/atmchem/Brian_folder/Paper/entrainment_flux/data/20130604','*.hpl', count=nfiles)

;DWL_file_merge, nfiles, files, data 

file='C:\Users\Wes Cantrell\Dropbox\DWL\20130906\12-20\20130906_12-20.sav'
restore,filename=file,/verbose

time  = data[*,0,0]
  
;altitude = (range gate + 0.5) * gate length(meters)
alt = ((data[0,1:199,0] +0.5) * 30.)/1000.
azimuth = data[*,0,1]
elevation =data[*,0,2]

doppler = data[*,1:199,1]
intensity =  data[*,1:199,2]
beta  = alog10(data[*,1:199,3])

;SET_PLOT, 'WIN'

;!p.charsize=1.2 & !p.thick=2.0 & !x.thick=2.0 & !y.thick=2.0 
;!p.charthick=2.0 & 
;!p.multi=[0,1,1]

SNR_threshold=1.015

alt_range=[MIN(alt), MAX(alt)]
time_range=[MIN(time), MAX(time)]
doppler_range=[MIN(doppler), MAX(doppler)]
intensity_range=[MIN(intensity), MAX(intensity)]
beta_range=[MIN(beta), MAX(beta)]


ofile0='C:\Users\Wes Cantrell\Dropbox\DWL\20130906\12-20\20130906_12-20_stare_utc_rainbow.ps'

set_plot,'ps'
!p.thick=3.0 & !x.thick=1.5 & !y.thick=1.5 & !p.charsize=1.5  
device,filename=ofile0,/color


loadct,33
;
;loadct,4;,file='/nas/rgroup1/atmchem/Brian_folder/useful_IDL_program/brewer.tbl'
;myct,/buwhwhrd
;
;----------------------------------------------------
;Vertical Velocity
;
;Set doppler plot range

plot, time_range, alt_range $
    , xtitle='UTC' $
    , ytitle='Altitude (m)'  $
    , title='Vertical Velocity' $
    , xstyle=3 $
    ;, ystyle=2 $
    , /NODATA  $
    , XTICKINTERVAL=1  $
    , YTICKINTERVAL=.5  $
    ;, yminor=1 $
    ;, xminor=1  
    , yrange=[0,2.5],color=1 
    ;, clip=[time_range[0],-50,time_range[1], 100] $
        
   
FOR i=1, N_ELEMENTS(time)-1 DO BEGIN
  FOR z=1, N_ELEMENTS(alt[0,*])-1 DO BEGIN
   
	if alt[z] le 2.5 then begin
     IF intensity[i,z] GE 1.015 THEN BEGIN
	       polyfill, [time[i-1], time[i], time[i], time[i-1]]  $
                 , [alt[z-1], alt[z-1], alt[z], alt[z]]  $
                 , color=colordata(doppler[i,z],99.) 
     ENDIF ELSE BEGIN
         polyfill, [time[i-1], time[i], time[i], time[i-1]]  $
                 , [alt[z-1], alt[z-1], alt[z], alt[z]]  $
                 , color=FSC_COLOR('Black') 
     ENDELSE
	endif  
ENDFOR
ENDFOR

;-----------------------------------------------------
;Backscatter 


plot, time_range, alt_range $
    , xtitle='UTC' $
    , ytitle='Altitude (km)'  $
    , title='DWL Backscatter' $
    , xstyle=3 $
    ;, ystyle=2 $
    , /NODATA  $
    , XTICKINTERVAL=1  $
    , YTICKINTERVAL=.5  $
    ;, yminor=1 $
    ;, xminor=1  
    , yrange=[0,2.5],color=1 
    ;, clip=[time_range[0],-50,time_range[1], 100] $
        
   
FOR i=1, N_ELEMENTS(time)-1 DO BEGIN
  FOR z=1, N_ELEMENTS(alt[0,*])-1 DO BEGIN
   
   if alt[z] le 2.5 then begin
    
    IF intensity[i,z] GE SNR_threshold THEN BEGIN
      polyfill, [time[i-1], time[i], time[i], time[i-1]]  $
              , [alt[z-1], alt[z-1], alt[z], alt[z]]  $
              , color=colordata_beta(beta[i,z],99.) 
    ENDIF ELSE BEGIN
      polyfill, [time[i-1], time[i], time[i], time[i-1]]  $
              , [alt[z-1], alt[z-1], alt[z], alt[z]]  $
              , color=FSC_COLOR('Black')
    
    ENDELSE
   endif  
  ENDFOR
ENDFOR
;-----------------------------------------------------
device,/close 
   

;WRITE_PNG,ofile0, tvrd(), r,g,b


;window, 1
;;Doppler Histogram
;Histoplot, doppler $
;         , xtitle='Velocity (m/s)'  $
;         ;, xrange=[0,100] $
;         , yrange=[0,0.6] $
;         , /FREQUENCY $
;         , binsize=2 
;


stop

END
