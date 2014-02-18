data_dir = './Data'
dictdir = '~/Work/matin-ebsd-demo/_data/dictionary.yml'
dd = dir( fullfile( data_dir, '*.txt') );
todir = './Data/';
postdir = '~/Work/matin-ebsd-demo/_posts';

imdir = '~/Work/matin-ebsd-demo/assets';
vizdata = '~/Work/matin-ebsd-demo/_data/viz.yml';
% 
%     name: 'Electron Backscattered Diffraction'
%      url: 'http://www.equipment.materials.gatech.edu/tool?id=316291'
dictexist = false;

for ii = 1 : numel( dd)
    
    dl = fullfile( data_dir, dd(ii).name);
    [ DATA ] = Structure_Output_Data( dl );
    
    h5nm = BatchWrite( dl, DATA, [], regexprep( dl, '.txt','.h5'));
    if ~dictexist
        H5toDictMD( h5nm, dictdir, source )
        dictexist = true;
    end
    newpost = H5toYAML( h5nm, dictdir, postdir, source );
    CreateThumbnails( vizdata, h5nm, postdir, imdir);
end