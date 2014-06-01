;this program is to processes dwl data
;by Guanyu Huang

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





pro dwl_data_pro

files = FILE_SEARCH('C:\Users\Wes Cantrell\Dropbox\DWL\20130906\12-20\','*.hpl', count=nfiles)

DWL_file_merge, nfiles, files, data

save_file='C:\Users\Wes Cantrell\Dropbox\DWL\20130906\12-20\20130906_12-20.sav'

save,filename=save_file,data









end
