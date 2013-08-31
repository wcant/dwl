


FUNCTION colordata, data, scale
  
  ;66 bins (from CEILO _CT)
  ;divide domain into 66 bins
  
  ;get binsize
  ;the range of vertical wind velocity is from -4 to +4 m/s
  
  binsize=DOUBLE(6./scale)
  
  n_levels=-3.+findgen(scale)*binsize
  
  del_color=256./scale
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


PRO DWL_curtain_colorbar

;files = FILE_SEARCH('/nas/rgroup1/atmchem/Brian_folder/Paper/entrainment_flux/data/20130604','*.hpl', count=nfiles)

;DWL_file_merge, nfiles, files, data 

;window,0, xsize=1100, ysize=850
ofile0='C:\Users\Wes Cantrell\Dropbox\DWL\dwl_backscatter_colorbar.ps'
set_plot,'ps'
device,filename=ofile0,/color
;loadct,30,file='\\Uahdata\atmchem\Brian_folder\useful_IDL_program\brewer.tbl'
loadct,33
scale=99.
binsize=DOUBLE(5./scale)
  
  n_levels=-8.+findgen(scale)*binsize
  
  del_color=238./scale
  color_levels=(findgen(scale))*del_color+18

;Set doppler plot range
contour,[[n_levels],[n_levels]],[n_levels],indgen(2),levels=n_levels,c_color=color_levels,$
          /fill,ythick=2,/noerase,ystyle=4,POSITION=[0.1, 0.0, 0.9, 0.02],title='log(Beta)',$
          xtitle='m-1 sr-1',color=1,xrange=[-8,-3],xtickinterval=1


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
