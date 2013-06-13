PRO DWL_file_merge, nfiles, files, alldata

  alldata=DBLARR(nfiles,4000, 201,4)  ;4000 because hourly data has ~4000 lines (for 5000 averages)
  alldata[*,*,*,*]=!VALUES.D_NAN
  
  FOR j=0, nfiles-1 DO BEGIN

    read_dwl, files[j], data, header, dim
    alldata[j,0:dim[0]-1,*,*]=data

  ENDFOR
  
END


FUNCTION colordata, data, scale
  
  ;66 bins (from CEILO_CT)
  ;divide domain into 66 bins
  
  ;get binsize
  binsize=DOUBLE(8./66.)
  
  databins=DBLARR(66)
  
  bindummy=DBLARR(33)
  binvalue=0
  FOR i=0, 33-1 DO BEGIN
  
    binvalue=binsize+binvalue
    bindummy[i]=binvalue
  ENDFOR
  
  ;set first bin eq 0
  ;there will be two 0 bins, velocities between -0.121212 and 0.121212.. will be grouped
  ;This can be easily changed by adjusting the number of colors to odd (65).
  ;Doesn't seem important though and would help keep near zero velocities grouped.
  bindummy[0]=0.
  databins[0:32]=(-1)*REVERSE(bindummy)
  databins[33:65]=bindummy
  
  minbin=MAX(WHERE(databins LE data))
  ;maxbin=MIN(WHERE(databins GE data))
  
  color_value=minbin
 
  RETURN, color_value
END

;------------------------------------------------------------------------
PRO CEILO_CT, r, g, b
;------------------------------------------------------------------------

   ; create a color table where
   ;   color 0 is white
   ;   color 15 is black
   ;   colors 1 - 15 are shades of gray
   ;   colors 16 - 63 are shades of red

   tvlct,r,g,b,/get
   r=indgen(256)
   g=indgen(256)
   b=indgen(256)


  r(0:65)=[255,238,221,204,187,170,153,136,119,102,85,68,51,34,17,0,198,177,163,$
           136,105,88,56,0,7,15,23,31,38,46,54,62,86,110,134,158,182,206,$
           230,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,$
           255,255,255,255,255,255,255,255,255,255,250,0]

  g(0:65)=[255,238,221,204,187,170,153,136,119,102,85,68,51,34,17,0,255,245,225,$
           204,166,143,116,0,28,56,84,112,140,168,196,224,227,231,235,239,243,247,$
           251,255,249,243,237,232,226,220,214,209,182,156,130,104,78,52,$
           26,0,0,0,0,0,0,0,0,0,0,0]

  b(0:65)=[255,238,221,204,187,170,153,136,119,102,85,68,51,34,17,0,255,255,$
           255,255,255,255,255,255,223,191,159,127,95,63,31,0,0,0,0,0,0,0,$
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,31,63,95,127,159,191,223,255,250,0]


        ;** The following two lines are needed if using pv-wave versions
        ;** before 7.5
        ;if !d.display_depth ge 24 then tvlct, b,g,r $
        ;else tvlct,r,g,b
  r(65) = 15
  g(65) = 15
 
 b(65) = 15
tvlct,r,g,b
END


PRO RedBlue_velocity_scale, r, g, b




END


PRO DWL_curtain

;/////////////////////////////////////////////////////////////////////////////////////
;/////////////Read in data ///////////////////////////////////////////////////////////
;Option 1: Reading data from files and merging to a single array
    ;files = FILE_SEARCH('C:\Users\Wes Cantrell\Dropbox\DWL\20130604','*.hpl', count=nfiles)
    ;DWL_file_merge, nfiles, files, data
    ;SAVE, data, nfiles, files, FILENAME='C:\Users\Wes Cantrell\Dropbox\DWL\20130604\20130604.sav'
;/////////////////////////////////////////////////////////////////////////////////////
;Option 2: Restore previously saved data
    RESTORE, FILENAME='C:\Users\Wes Cantrell\Dropbox\DWL\20130604\20130604.sav'
;/////////////////////////////////////////////////////////////////////////////////////


time  = data[*,*,0,0]-5.                  ;Decimal time - fraction of hour
alt = (data[*,0,1:199,0] +0.5) * 30.      ;altitude = (range gate + 0.5) * gate length(meters)
azimuth = data[*,*,0,1]                   ;Irrelevant for stares
elevation =data[*,*,0,2]                  
doppler = data[*,*,1:199,1]
intensity =  data[*,*,1:199,2]
beta  = data[*,*,1:199,3]


SET_PLOT, 'WIN'


;!p.charsize=1.2 & !p.thick=2.0 & !x.thick=2.0 & !y.thick=2.0 
;!p.charthick=2.0 & 
!p.multi=[0,1,1]

;define color table
ceilo_ct, r, g, b


alt_range=[MIN(alt), 3000]
time_range=[MIN(time), MAX(time)]
doppler_range=[MIN(doppler), MAX(doppler)]
intensity_range=[MIN(intensity), MAX(intensity)]
beta_range=[MIN(beta), MAX(beta)]

window,0, xsize=1100, ysize=850
ofile0='C:\Users\Wes Cantrell\Dropbox\DWL\201305\20130521_stare.png'

;Set doppler plot range
plot, time_range, alt_range $
    , xtitle='Local Time' $
    , ytitle='Altitude (m)'  $
    , xstyle=3 $
    ;, ystyle=2 $
    , /NODATA  $
    , XTICKINTERVAL=0.10  $
    , YTICKINTERVAL=500  $
    ;, yminor=1 $
    ;, xminor=1  
    , yrange=alt_range  $
    ;, clip=[time_range[0],-50,time_range[1], 100] $
    , background=FSC_COLOR('White') $
    , color=65
    
    
FOR i=1, N_ELEMENTS(time)-1 DO BEGIN
  FOR z=1, N_ELEMENTS(alt[0,*])-1 DO BEGIN
   polyfill, [time[i-1], time[i], time[i], time[i-1]]  $
           , [alt[z-1], alt[z-1], alt[z], alt[z]]  $
           , color=colordata(doppler[i,z])  
  ENDFOR
ENDFOR

    
WRITE_PNG,ofile0, tvrd(), r,g,b


window, 1
;Doppler Histogram
Histoplot, doppler $
         , xtitle='Velocity (m/s)'  $
         ;, xrange=[0,100] $
         , yrange=[0,0.6] $
         , /FREQUENCY $
         , binsize=2 



stop




END