%io_loadspec_rda_modified.m
%
%Jay Hennessy, McGill University 2016.
%Heiner N. Raum, UKM Münster 2024 (modification: adaption of geometry
%header fileds to VE in io_loadspec_rda_modified)
%
% USAGE:
% [out]=io_loadspec_rda(rda_filename);
%
% DESCRIPTION:
% Reads in siemens rda data (.rda file).
%
% op_loadspec_rda outputs the data in structure format, with fields corresponding to time
% scale, fids, frequency scale, spectra, and header fields containing
% information about the acquisition.  The resulting matlab structure can be
% operated on by the other functions in this MRS toolbox.
%
% INPUTS:
% pathname   = pathname of Siemens rda data to load. Can be folder or file,
% which will autmatically be distinguished.
%
% OUTPUTS:
% out        = Input dataset in FID-A structure format.

function [out] = io_loadspec_rda_modified(pathname)

    if isfile(pathname)
        filesInFolder{1} = pathname;
    else
        % Create list of complete filenames (incl. path) in the folder
        dirFolder = dir(pathname);
        filesInFolder = dirFolder(~[dirFolder.isdir]);
        filesInFolder = filesInFolder(~ismember({filesInFolder.name}, {'.','..','.DS_Store'}));
        %hidden = logical(ones(1,length(filesInFolder)));
        hidden = true(length(filesInFolder));
        for jj = 1:length(filesInFolder)
            if strcmp(filesInFolder(jj).name(1),'.')
                hidden(jj) = 0;
            end
        end
        filesInFolder = filesInFolder(hidden);%delete hidden files
        filesInFolder = fullfile(pathname, {filesInFolder.name});
    end
    
    fid = fopen(filesInFolder{1});
    
    head_start_text = '>>> Begin of header <<<';
    head_end_text   = '>>> End of header <<<';
    
    tline = fgets(fid);
    
    while ~contains(tline,head_end_text)
    %while (isempty(strfind(tline , head_end_text)))
    
        tline = fgets(fid);
    
        if ~contains(tline,head_end_text) && ~contains (tline,head_end_text)
        %if ( isempty(strfind (tline , head_start_text)) + isempty(strfind (tline , head_end_text )) == 2)
    
    
            % Store this data in the appropriate format
    
            occurence_of_colon = findstr(':',tline);
            variable = tline(1:occurence_of_colon-1) ;
            value    = tline(occurence_of_colon+1 : length(tline)) ;
    
            switch variable
                case { 'PatientID' , 'PatientName' , 'StudyDescription' , 'PatientBirthDate' , 'StudyDate' , 'StudyTime' , 'PatientAge' , 'SeriesDate' , ...
                        'SeriesTime' , 'SeriesDescription' , 'ProtocolName' , 'PatientPosition' , 'ModelName' , 'StationName' , 'InstitutionName' , ...
                        'DeviceSerialNumber', 'InstanceDate' , 'InstanceTime' , 'InstanceComments' , 'SequenceName' , 'SequenceDescription' , 'Nucleus' ,...
                        'TransmitCoil' }
                    eval(['rda.' , variable , ' = value; ']);
                case { 'PatientSex' }
                    % Sex converter! (int to M,F,U)
                    switch value
                        case 0
                            rda.sex = 'Unknown';
                        case 1
                            rda.sex = 'Male';
                        case 2
    
                            rda.sex = 'Female';
                    end
    
                case {  'SeriesNumber' , 'InstanceNumber' , 'AcquisitionNumber' , 'NumOfPhaseEncodingSteps' , 'NumberOfRows' , 'NumberOfColumns' , 'VectorSize' }
                    %Integers
                    eval(['rda.' , variable , ' = str2num(value); ']);
                case { 'PatientWeight' , 'TR' , 'TE' , 'TM' , 'DwellTime' , 'NumberOfAverages' , 'MRFrequency' , 'MagneticFieldStrength' , 'FlipAngle' , ...
                        'SliceThickness' ,  'FoVHeight' , 'FoVWidth' , 'PercentOfRectFoV' , 'PixelSpacingRow' , 'PixelSpacingCol', ...
                        'VOIRotationInPlane', 'VOINormalTra', 'VOINormalCor', 'VOINormalSag', 'VOIReadoutFOV', 'VOIPhaseFOV', 'VOIThickness', ...
                        'VOIPositionTra', 'VOIPositionCor', 'VOIPositionSag'}
                    %Floats
                    eval(['rda.' , variable , ' = str2num(value); ']);
                case {'SoftwareVersion[0]' }
                    rda.software_version = value;
                case {'CSIMatrixSize[0]' }
                    rda.CSIMatrix_Size(1) = str2num(value);
                case {'CSIMatrixSize[1]' }
                    rda.CSIMatrix_Size(2) = str2num(value);
                case {'CSIMatrixSize[2]' }
                    rda.CSIMatrix_Size(3) = str2num(value);
                case {'PositionVector[0]' }
                    rda.PositionVector(1) = str2num(value);
                case {'PositionVector[1]' }
                    rda.PositionVector(2) = str2num(value);
                case {'PositionVector[2]' }
                    rda.PositionVector(3) = str2num(value);
                case {'RowVector[0]' }
                    rda.RowVector(1) = str2num(value);
                case {'RowVector[1]' }
                    rda.RowVector(2) = str2num(value);
                case {'RowVector[2]' }
                    rda.RowVector(3) = str2num(value);
                case {'ColumnVector[0]' }
                    rda.ColumnVector(1) = str2num(value);
                case {'ColumnVector[1]' }
                    rda.ColumnVector(2) = str2num(value);
                case {'ColumnVector[2]' }
                    rda.ColumnVector(3) = str2num(value);
                %Modified HR%             
                case {'SlabThickness[0]' }
                    rda.SlabThickness(1) = str2num(value);
                case {'SlabThickness[1]' }
                    rda.SlabThickness(2) = str2num(value);
                case {'SlabThickness[2]' }
                    rda.SlabThickness(3) = str2num(value);
                case {'SlabOrientation[0,0]' }
                    rda.SlabOrientation(1,1) = str2num(value);
                case {'SlabOrientation[0,1]' }
                    rda.SlabOrientation(1,2) = str2num(value);
                case {'SlabOrientation[0,2]' }
                    rda.SlabOrientation(1,3) = str2num(value);
                case {'SlabOrientation[1,0]' }
                    rda.SlabOrientation(2,1) = str2num(value);
                case {'SlabOrientation[1,1]' }
                    rda.SlabOrientation(2,2) = str2num(value);
                case {'SlabOrientation[1,2]' }
                    rda.SlabOrientation(2,3) = str2num(value);
                case {'SlabOrientation[2,0]' }
                    rda.SlabOrientation(3,1) = str2num(value);
                case {'SlabOrientation[2,1]' }
                    rda.SlabOrientation(3,2) = str2num(value);
                case {'SlabOrientation[2,2]' }
                    rda.SlabOrientation(3,3) = str2num(value);    
                %mod. end%
                otherwise
                    % We don't know what this variable is.  Report this just to keep things clear
                    %disp(['Unrecognised variable ' , variable ]);
            end
    
        else
            % Don't bother storing this bit of the output
        end
    
    end
    %%
    
    % Get the header of the first file to make some decisions.
    seqtype = rda.SeriesDescription;
    
    
    % Prepare voxel geometry information
    % If a parameter is set to zero (e.g. if no voxel rotation is
    % performed), the respective field is left empty in the TWIX file. This
    % case needs to be intercepted. Setting to the minimum possible value.
    VoI_Params = {'VOIRotationInPlane', 'VOINormalTra', 'VOINormalCor', 'VOINormalSag', 'VOIReadoutFOV', 'VOIPhaseFOV', 'VOIThickness', ...
        'VOIPositionTra', 'VOIPositionCor', 'VOIPositionSag'};
    for pp = 1:length(VoI_Params)
        if ~isfield(rda, VoI_Params{pp})
            rda.(VoI_Params{pp}) = realmin('double');
        end
    end
    
    % Write them
    %Modified HR%
    if contains(rda.software_version,'XA30','IgnoreCase',true) && rda.VOINormalCor + rda.VOINormalSag + rda.VOINormalTra < 0.1
        geometry.size.VoI_RoFOV     = rda.SlabThickness(3); %TODO; Voxel size in readout direction [mm]
        geometry.size.VoI_PeFOV     = rda.SlabThickness(2); %TODO; Voxel size in phase encoding direction [mm]
        geometry.size.VoIThickness  = rda.SlabThickness(1); % Voxel size in slice selection direction [mm]
        geometry.pos.PosSag         = rda.PositionVector(1); % Sagittal coordinate of voxel [mm]
        geometry.pos.PosCor         = rda.PositionVector(2); % Coronal coordinate of voxel [mm]
        geometry.pos.PosTra         = rda.PositionVector(3); % Transversal coordinate of voxel [mm]
        geometry.rot.NormSag        = rda.SlabOrientation(1,1); % Sagittal component of normal vector of voxel
        geometry.rot.NormCor        = rda.SlabOrientation(1,2); % Coronal component of normal vector of voxel
        geometry.rot.NormTra        = rda.SlabOrientation(1,3); % Transversal component of normal vector of voxel
    
    
        %Calculate InPlaneRot (HR), adapted from coreg_siemens.m
        Norm = rda.SlabOrientation(1,:);
        [~, maxdir] = max([abs(Norm(1)) abs(Norm(2)) abs(Norm(3))]);
        switch maxdir
            case 1
                vox_orient = 's'; % 't' = transversal, 's' = sagittal', 'c' = coronal;
            case 2
                vox_orient = 'c'; % 't' = transversal, 's' = sagittal', 'c' = coronal;
            case 3
                vox_orient = 't'; % 't' = transversal, 's' = sagittal', 'c' = coronal;
        end
        Phase	= zeros(3, 1);
        switch vox_orient
            case 't'
                % For transversal voxel orientation, the phase reference vector lies in
                % the sagittal plane
                Phase(1)	= 0;
                Phase(2)	=  Norm(3)*sqrt(1/(Norm(2)*Norm(2)+Norm(3)*Norm(3)));
                Phase(3)	= -Norm(2)*sqrt(1/(Norm(2)*Norm(2)+Norm(3)*Norm(3)));
                VoxDims = [geometry.size.VoI_PeFOV geometry.size.VoI_RoFOV geometry.size.VoIThickness];
            case 'c'
                % For coronal voxel orientation, the phase reference vector lies in
                % the transversal plane
                Phase(1)	=  Norm(2)*sqrt(1/(Norm(1)*Norm(1)+Norm(2)*Norm(2)));
                Phase(2)	= -Norm(1)*sqrt(1/(Norm(1)*Norm(1)+Norm(2)*Norm(2)));
                Phase(3)	= 0;
                VoxDims = [geometry.size.VoI_PeFOV geometry.size.VoI_RoFOV geometry.size.VoIThickness];
            case 's'
                % For sagittal voxel orientation, the phase reference vector lies in
                % the transversal plane
                Phase(1)	= -Norm(2)*sqrt(1/(Norm(1)*Norm(1)+Norm(2)*Norm(2)));
                Phase(2)	=  Norm(1)*sqrt(1/(Norm(1)*Norm(1)+Norm(2)*Norm(2)));
                Phase(3)	= 0;
                VoxDims = [geometry.size.VoI_PeFOV geometry.size.VoI_RoFOV geometry.size.VoIThickness];
        end
        %Readout = cross(Norm, Phase)';
        if dot(cross(Phase,rda.SlabOrientation(2,:))',rda.SlabOrientation(1,:)') <= 0
            geometry.rot.VoI_InPlaneRot = acos(rda.SlabOrientation(2,:)*Phase);
        else
            geometry.rot.VoI_InPlaneRot = -acos(rda.SlabOrientation(2,:)*Phase);
        end
        %geometry.rot.VoI_InPlaneRot = asin(rda.SlabOrientation(3,:)*Phase); % Voxel rotation in plane
    else
        geometry.size.VoI_RoFOV     = rda.VOIReadoutFOV; % Voxel size in readout direction [mm]
        geometry.size.VoI_PeFOV     = rda.VOIPhaseFOV; % Voxel size in phase encoding direction [mm]
        geometry.size.VoIThickness  = rda.VOIThickness; % Voxel size in slice selection direction [mm]
        geometry.pos.PosCor         = rda.VOIPositionCor; % Coronal coordinate of voxel [mm]
        geometry.pos.PosSag         = rda.VOIPositionSag; % Sagittal coordinate of voxel [mm]
        geometry.pos.PosTra         = rda.VOIPositionTra; % Transversal coordinate of voxel [mm]
        geometry.rot.VoI_InPlaneRot = rda.VOIRotationInPlane; % Voxel rotation in plane
        geometry.rot.NormCor        = rda.VOINormalCor; % Coronal component of normal vector of voxel
        geometry.rot.NormSag        = rda.VOINormalSag; % Sagittal component of normal vector of voxel
        geometry.rot.NormTra        = rda.VOINormalTra; % Transversal component of normal vector of voxel
    end
    %mod. end%
    out.geometry = geometry;
    
    
    %
    % So now we should have got to the point after the header text
    %
    % Siemens documentation suggests that the data should be in a double complex format (8bytes for real, and 8 for imaginary?)
    %
    fclose(fid);
    bytes_per_point = 16;
    
    % Preallocate array in which the FIDs are to be extracted.
    fids = zeros(length(filesInFolder),rda.VectorSize);
    % Collect all FIDs and sort them into fids array
    for kk = 1:length(filesInFolder)
        fid = fopen(filesInFolder{kk});
        tline = fgets(fid);
        %while (isempty(strfind(tline , head_end_text)))
        while ~contains(tline , head_end_text)
            tline = fgets(fid);
        end
        complex_data = fread(fid , rda.CSIMatrix_Size(1) * rda.CSIMatrix_Size(1) *rda.CSIMatrix_Size(1) *rda.VectorSize * 2 , 'double');
        %fread(fid , 1, 'double');  %This was a check to confirm that we had read all the data (it passed!)
        fclose(fid);
    
        % Now convert this data into something meaningful
    
        %Reshape so that we can get the real and imaginary separated
        hmm = reshape(complex_data,  2 , rda.VectorSize , rda.CSIMatrix_Size(1) ,  rda.CSIMatrix_Size(2) ,  rda.CSIMatrix_Size(3) );
    
        %Combine the real and imaginary into the complex matrix
        fids(kk,:) = complex(hmm(1,:,:,:,:),hmm(2,:,:,:,:));
    end
    fids = fids';
    %Remove the redundant first element in the array
    % Time_domain_data = reshape(hmm_complex, rda.VectorSize , rda.CSIMatrix_Size(1) ,  rda.CSIMatrix_Size(2) ,  rda.CSIMatrix_Size(3));
    % Time_domain_data = fft(fft(fftshift(fftshift(padarray(fftshift(fftshift(ifft(ifft(Time_domain_data,[],2),[],3),2),3),[0 16 16],'both'),2),3),[],2),[],3);
    
    % rewind first point phase
    corrph = conj(fids(1,:))./abs(fids(1,:));
    corrph = repmat(corrph, [size(fids, 1), 1]);
    fids   = fids .* corrph;
    
    % get the spectrum from the fid
    specs = fftshift(fft(fids,[],1),1);
    
    % make calculations for the output mrs structure
    sz = size(fids);
    dwelltime = rda.DwellTime/1000000;
    spectralwidth=1/dwelltime;
    txfrq = rda.MRFrequency*1000000;
    dims.t = 1;
    dims.subSpecs = 0;
    dims.coils = 0;
    dims.extras = 0;
    dims.averages = 2;
    % Bo = rda.MagneticFieldStrength;
    Bo = rda.MRFrequency/42.577;
    rawAverages = rda.NumberOfAverages;
    if length(filesInFolder) >= rawAverages
        if contains(seqtype, 'edit')
            rawAverages = length(filesInFolder);
            averages = rda.NumberOfAverages;
            subspecs =  fix(rawAverages/averages);
            rawSubspecs = rda.NumberOfAverages;
        else
            rawAverages = length(filesInFolder);
            averages = rawAverages;
            subspecs = 1;
            rawSubspecs = 1;
        end
    elseif length(filesInFolder) == 1
        averages = 1;
        subspecs =1;
        rawSubspecs = 'na';
    else
        if contains(seqtype,'edit') || contains(seqtype,'mpress')
            subspecs = 2;
            rawSubspecs = 2;
            % Distinguish whether MEGA data have been averaged on-scanner or
            % not
            if length(filesInFolder) == 2
                dims.subSpecs = 3;
                dims.averages = 2;
                averages = 1;
                rawAverages = 1;
                fids = reshape(fids,[sz(1),averages,2 ]);
                specs = reshape(specs,[sz(1),averages,2 ]);
            else
                dims.subSpecs = 3;
                dims.averages = 2;
                averages = rawAverages/2;
                fids = reshape(fids,[sz(1),averages,2 ]);
                specs = reshape(specs,[sz(1),averages,2 ]);
            end
            sz = size(fids);
        end
    end
    
    date = rda.StudyDate;
    seq = rda.SequenceDescription;
    TE = rda.TE;
    TR = rda.TR;
    pointsToLeftShift = 0;
    
    %Calculate t and ppm arrays using the calculated parameters:
    f=[(-spectralwidth/2)+(spectralwidth/(2*sz(1))):spectralwidth/(sz(1)):(spectralwidth/2)-(spectralwidth/(2*sz(1)))];
    ppm=f/(Bo*42.577);
    % Siemens data assumes the center frequency to be 4.65 ppm:
    centerFreq = 4.65;
    ppm=ppm + centerFreq;
    
    t=[0:dwelltime:(sz(1)-1)*dwelltime];
    
    %FILLING IN DATA STRUCTURE
    out.fids=fids;
    out.specs=specs;
    out.sz=sz;
    out.ppm=ppm;
    out.t=t;
    out.spectralwidth=spectralwidth;
    out.dwelltime=dwelltime;
    out.txfrq=txfrq;
    out.date=date;
    out.dims=dims;
    out.Bo=Bo;
    out.averages=averages;
    out.rawAverages=rawAverages;
    out.subspecs=subspecs;
    out.rawSubspecs=rawSubspecs;
    out.seq=seq;
    out.te=TE;
    out.tr=TR;
    out.pointsToLeftshift=pointsToLeftShift;
    out.centerFreq = centerFreq;
    out.geometry = geometry;
    out.software = rda.software_version;
    
    %FILLING IN THE FLAGS
    out.flags.writtentostruct=1;
    out.flags.gotparams=1;
    out.flags.leftshifted=0;
    out.flags.filtered=0;
    out.flags.zeropadded=0;
    out.flags.freqcorrected=0;
    out.flags.phasecorrected=0;
    if out.averages == 1
        out.flags.averaged=1;
    else
        out.flags.averaged=0;
    end
    out.flags.addedrcvrs=1;
    out.flags.subtracted=0;
    out.flags.writtentotext=0;
    out.flags.downsampled=0;
    if out.dims.subSpecs==0
        out.flags.isFourSteps=0;
    else
        out.flags.isFourSteps=(out.sz(out.dims.subSpecs)==4);
    end
    
    % Add info for niiwrite
    out.PatientPosition = rda.PatientPosition;
    out.Manufacturer = 'Siemens';
    [~,filename,ext] = fileparts(filesInFolder{1});
    out.OriginalFile = [filename ext];
    
    % Sequence flags
    out.flags.isUnEdited = 0;
    out.flags.isMEGA = 0;
    out.flags.isHERMES = 0;
    out.flags.isHERCULES = 0;
    out.flags.isPRIAM = 0;
    out.flags.isMRSI = 0;
end
