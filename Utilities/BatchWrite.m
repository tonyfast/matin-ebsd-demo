function h5nm = BatchWrite( fn, Data, writeloc )
% Write a structure generated from a single Polymer MD output to an HDF5
% using h5writecomposite


if ~exist( 'writeloc', 'var');
    writeloc = '.';
end

stripnm = @(x)regexprep( fliplr(strtok(fliplr(x),'/')),'dump.','');


h5nm = fullfile( writeloc, horzcat( stripnm(fn), '.h5' ) )
assignin( 'base','h5nm',h5nm)

if ~exist( h5nm,'file' )
    h5 = H5F.create( h5nm );
    H5F.close( h5 );
end

h5 = H5F.open( h5nm,'H5F_ACC_RDWR','H5P_DEFAULT' );

h5writeattcompound( h5nm, '/', 'SHA', strtok(evalc( 'git log --pretty=oneline')) );
h5writeattcompound( h5nm, '/', 'origin_file', fliplr(strtok(fliplr(fn),'/')) );
H5O.set_comment_by_name( h5, '/', 'Tony Fast updated these datasets.','H5P_DEFAULT');
for ii = 1 : numel( Data.Aggregate )
    
    try
    gid = H5G.create( h5, ['/',num2str(ii)],'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT' );
    H5G.close( gid );
    catch
        warning('The group name already exists.');
    end
    h5writecompound( h5nm, ['/',num2str(ii),'/Aggregate'], Data.Aggregate(ii));
    if all ( structfun( @(x)numel(x), Data.Spatial(ii)) == Data.Aggregate(ii).Natoms )
        h5writecompound( h5nm, ['/',num2str(ii),'/Spatial'], Data.Spatial(ii));
    end
end


H5F.close( h5 );
