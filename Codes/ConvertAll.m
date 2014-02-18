data_dir = './Data'
dictdir = '~/Work/matin-ebsd-demp/_data/dictionary.yml'
dd = dir( fullfile( data_dir, '*.txt') );
todir = './Data/';
postdir = '~/Work/matin-ebsd-demp/_posts';

imdir = '~/Work/matin-ebsd-demp/assets';
vizdata = '~/Work/matin-ebsd-demp/_data/viz.yml';


dictexist = false;

for ii = 1 : numel( dd)
    
    dl = fullfile( data_dir, dd(ii).name);
    [ DATA ] = Structure_Output_Data( dl );
    
    h5nm = BatchWrite( dl, DATA, todir);
    if ~dictexist
        H5toDictMD( h5nm, dictdir )
        dictexist = true;
    end
    newpost = H5toYAML( h5nm, dictdir, postdir );
    CreateThumbnails( vizdata, h5nm, postdir, imdir);
end