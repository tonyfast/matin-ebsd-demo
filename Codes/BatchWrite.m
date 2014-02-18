function h5nm = BatchWrite( fn, Data, writeloc, h5nm )
% Write a structure generated from a single Polymer MD output to an HDF5
% using h5writecomposite


if ~exist( 'writeloc', 'var') || numel( writeloc ) ==0;
    writeloc = '.';
end

if exist( 'h5nm','var')
    h5nm = fullfile( writeloc, h5nm );
end

if ~exist( h5nm,'file' )
    h5 = H5F.create( h5nm );
    H5F.close( h5 );
end


h5 = H5F.open( h5nm,'H5F_ACC_RDWR','H5P_DEFAULT' );



try h5writeattcompound( h5nm, '/', 'SHA', strtok(evalc( 'git log --pretty=oneline')) );catch; end

try h5writeattcompound( h5nm, '/', 'origin_file', fliplr(strtok(fliplr(fn),'/')) ); catch; end
H5O.set_comment_by_name( h5, '/', 'Tony Fast updated these datasets.','H5P_DEFAULT');
if isfield(Data, 'Aggregate');
    for ii = 1 : numel( Data.Aggregate )
        
        try
            gid = H5G.create( h5, ['/',num2str(ii)],'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT' );
            H5G.close( gid );
        catch
            warning('The group name already exists.');
        end
        h5writecompound( h5nm, ['/',num2str(ii),'/Aggregate'], Data.Aggregate(ii));
        
        h5writecompound( h5nm, ['/',num2str(ii),'/Spatial'], Data.Spatial(ii));
    end
end


if isfield(Data, 'Spatial');
    for ii = 1 : numel( Data.Spatial )
        
        try
            gid = H5G.create( h5, ['/',num2str(ii)],'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT' );
            H5G.close( gid );
        catch
            warning('The group name already exists.');
        end
        
        h5writecompound( h5nm, ['/',num2str(ii),'/Spatial'], Data.Spatial(ii));
    end
end


H5F.close( h5 );
