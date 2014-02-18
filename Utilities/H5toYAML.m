function postout = H5toDict( h5nm, dictdata, to_dir, source );

if ~exist( 'to_dir','var')
    to_dir = './';
end


% Initialize the file for writing

info = h5info( h5nm );

% Get root information
%% Scrape metadata from the HDF5 file.  Don't access any data yet.
h5 = H5F.open( h5nm )
description = H5O.get_comment_by_name( h5, '/','H5P_DEFAULT');

for rootid = 1 : numel( info.Groups )  % Iterate over the directories in the root
    
    % Write Datasets
    for dataid = 1 : numel( info.Groups( rootid ).Datasets )
        T = info.Groups( rootid ).Datasets( dataid );
        if strcmp( T.Name, 'Aggregate' )
            % Get variable fields
            if strcmp( T.Datatype.Class, 'H5T_COMPOUND' );
                Agg{rootid}.name = info.Groups( rootid ).Name;
                Agg{rootid}.vars = { T.Datatype.Type.Member.Name };
            else
            end
            % Get attributes for fields
        elseif strcmp( T.Name, 'Spatial' )
            % Get variable fields
            if strcmp( T.Datatype.Class, 'H5T_COMPOUND' );
                Spa{rootid}.name = info.Groups( rootid ).Name;
                Spa{rootid}.vars = { T.Datatype.Type.Member.Name };
                
                H5O.get_comment_by_name(h5,info.Groups( rootid ).Name,'H5P_DEFAULT');
            else
            end
            % Get attributes for fields
            % Get attibutes
            % Get comment
        else
        end
    end
    
    
    
    
    for workid = 1 : info.Groups( rootid ).Groups
        % Write Datasets
        for dataid = 1 : numel( info.Groups( rootid ).Groups( workid ).Datasets )
            
        end
        
    end
end

H5F.close(h5);

%% Parse Metadata and Dictionary to the datapage
dyml = ReadYaml(dictdata);


[p, f, ext] = fileparts( h5nm );
% f = '~/my-awesome-site/_site/other';
c = clock;
p = to_dir
postout = sprintf( '%s/%i-%i-%i-%s.markdown',p,c(1),c(2),c(3),f)


fo = fopen(  postout, 'w' );
fprintf( fo, '---\n');
fprintf( fo, 'layout: dataset-template-final\n');
fprintf( fo, 'description: %s\n',description);

fprintf( fo, 'aggregate: \n','');
if exist( 'Agg','var')
for dd = 1 : numel( Agg );
    fprintf( fo, ' - name: %s\n',regexprep( Agg{dd}.name, '/','Dataset '));
    native = [Agg{dd}.name,'/Aggregate'];
    fprintf( fo, '   native: %s\n',native);
    fprintf( fo, '   vars: \n');
    for gg = 1 : numel(dyml.aggregate)
        for jj = 1 : numel(dyml.aggregate{gg}.group)
            data = h5read( h5nm, native );
            if isfield( dyml.aggregate{gg}.group{jj}, 'native' )
                dyml.aggregate{gg}.group{jj}.native 
                if any( ismember( dyml.aggregate{gg}.group{jj}.native, Agg{dd}.vars ));
                    fprintf( fo, '    - native: %s\n', dyml.aggregate{gg}.group{jj}.native);
                    fprintf( fo, '      value: %f\n', getfield( data,dyml.aggregate{gg}.group{jj}.native) );
                end
            end
        end
    end
end
end

h5 = H5F.open( h5nm );  
fprintf( fo, 'spatial: \n','');
if exist( 'Spa','var')
for dd = 1 : numel( Spa );
    fprintf( fo, ' - name: %s\n',regexprep( Spa{dd}.name, '/','Dataset '));
    native = [Spa{dd}.name,'/Spatial'];
    fprintf( fo, '   native: %s\n',native);
    desc = H5O.get_comment_by_name( h5, Spa{dd}.name,'H5P_DEFAULT');
    fprintf( fo, '   description: %s\n',desc);
    fprintf( fo, '   vars: \n');
    for gg = 1 : numel(dyml.spatial)
        for jj = 1 : numel(dyml.spatial{gg}.group)
            if isfield( dyml.spatial{gg}.group{jj}, 'native' )
                dyml.spatial{gg}.group{jj}.native 
                if any( ismember( dyml.spatial{gg}.group{jj}.native, Spa{dd}.vars ));
                    fprintf( fo, '    - native: %s\n', dyml.spatial{gg}.group{jj}.native);
                end
            end
        end
    end
end
end


fprintf( fo, '---\n');
fclose(fo);


H5F.close(h5);

return
% Select the template
fprintf( fo, 'source : \n','');
        fprintf( fo, ' - name: \n', source.name);
        fprintf( fo, '   url: %s\n',source.url );

        fprintf( fo, 'converter : \n','');
        fprintf( fo, ' - name: \n', mfilename);
        fprintf( fo, '   sha: %s\n',strtok( evalc( 'git log --abbrev-commit --pretty=oneline' ) ));


if numel( Agg.names ) > 0 
        fprintf( fo, 'aggregate : \n','');
        fprintf( fo, ' - group : \n');
        fprintf( fo, '   - name : General\n');
        fprintf( fo, '     description : \n');
    for ii = 1 : numel( Agg.names )
        fprintf( fo, '   - native : %s\n', Agg.names{ii});
        fprintf( fo, '     pretty : %s\n', Agg.names{ii});
        fprintf( fo, '     units : %s\n', '');
        fprintf( fo, '     description : %s\n', '' );
        fprintf( fo, '     links : %s\n', '' );
        fprintf( fo, '      - url: %s\n', '' );
        fprintf( fo, '        name: %s\n', '' );
    end
end

if numel( Spa.names ) > 0 
        fprintf( fo, 'spatial : \n','');
        fprintf( fo, ' - group : \n');
        fprintf( fo, '   - name : General\n');
        fprintf( fo, '     description : \n');
    for ii = 1 : numel( Spa.names )
        fprintf( fo, '   - native : %s\n', Spa.names{ii});
        fprintf( fo, '     pretty : %s\n', Spa.names{ii});
        fprintf( fo, '     units : %s\n', '');
        fprintf( fo, '     description : %s\n', '' );
        fprintf( fo, '     links : %s\n', '' );
        fprintf( fo, '      - url: %s\n', '' );
        fprintf( fo, '        name: %s\n', '' );
        fprintf( fo, '     publish : %s\n', '' );
        fprintf( fo, '      - isplot: %s\n', 'true' );
        fprintf( fo, '      - isdisp: %s\n', 'true' );
    end
end

fclose( fo );

%%