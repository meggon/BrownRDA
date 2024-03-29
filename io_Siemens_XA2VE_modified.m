%io_Siemens_XA2VE_modified.m
%
%Steve C.N. Hui, Children's National Hospital, George Washington University 2023.
%Heiner N. Raum, UKM Münster 2024 (modification: adaption of geometry
%header fields of XA30 to VE in io_loadspec_rda_modified).
%
% USAGE:
% Run the script at the folder where the .rda data are stored.
% Require io_loadspec_rda from FID-A and io_writerda from Osprey
%
% DESCRIPTION:
% Takes Siemens MRS data acquired using XA20 or above and convert them into VE format that can be read by LCModel.
%
% INPUTS:
% .rda files acquired using XA software version
%
% OUTPUTS:
% .rda files that can be read by LCModel.
%
%
% UNCOMMENT SECTION BELOW AND ENTER IN YOUR FOLDER AND FILE NAMES
% folder = '/oscar/home/username/project/rawdata/sub-XXX/ses-01/mrs/sub-XXX_press_act'; 
% file = 'YOURSUBJECT_GLX.rda';
% rda_filename = fullfile(folder,file);
%  [in]=io_loadspec_rda(rda_filename);
%  
%  outfile = cat(2, 'io_',file);
%  RF=io_writerda(in,outfile);

 folder = pwd;
 files = dir('*.*');
 
 for k=1:length(files)
     
     fileNames = files(k).name;
     
     if startsWith(fileNames, '.') % avoid reading hidden copies of rda data starting with '._' || '.' || '..'
         continue;
     else
         if endsWith(fileNames,'.rda') % avoid reading data with other extensions e.g. .dcm
         rda_filename = fullfile(folder,fileNames);
         [in]=io_loadspec_rda_modified(rda_filename);
         
         outfile = cat(2, 'io_',fileNames);
         outfile2 = erase(outfile,".rda"); % avoid double extension
         RF=io_writedata_modified(in,outfile2);
         end
     end
     
 end
 
 % end
