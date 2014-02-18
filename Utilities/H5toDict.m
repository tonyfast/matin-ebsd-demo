function postout = H5toDict( h5nm, postout, source );
% From and HDF5 file, the native variables are stripped to make a metadata
% registry that can be dynamically changed.

if ~exist( 'postout','var')
    postout = './_data/dictionary.yml';
end


% Initialize the file for writing

info = h5info( h5nm );
        
% Get root information

for rootid = 1 : numel( info.Groups )  % Iterate over the directories in the root
    
    % Write Datasets
    for dataid = 1 : numel( info.Groups( rootid ).Datasets )
        T = info.Groups( rootid ).Datasets( dataid );
        if strcmp( T.Name, 'Aggregate' )
            % Get variable fields
            if strcmp( T.Datatype.Class, 'H5T_COMPOUND' );
                Agg.names = { T.Datatype.Type.Member.Name };
            else
            end
            % Get attributes for fields
        elseif strcmp( T.Name, 'Spatial' )
            % Get variable fields
            if strcmp( T.Datatype.Class, 'H5T_COMPOUND' );
                Spa.names = { T.Datatype.Type.Member.Name };
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

c = clock;
[p, dnm, ext] = fileparts( postout );
dnm = 'A-Dictionary-Template';
dictout = fullfile( regexprep( p, 'data','posts'), sprintf( '%4i-%02i-%i-%s.markdown', c(1), c(2), c(3), dnm ));
[p, f, ext] = fileparts( h5nm );
% f = '~/my-awesome-site/_site/other';

fo = fopen(  postout, 'w' );

fprintf(fo,'url: %s\n', sprintf( '%4i/%02i/%i/%s.html', c(1), c(2), c(3), dnm ) );
fprintf(fo,'short: %s\n', sprintf( '%s', dnm ) );


% Select the template
fprintf( fo, 'source : \n','');
        fprintf( fo, ' - name: %s\n', source.name);
        if isfield( source, 'url')
            fprintf( fo, '   url: %s\n',source.url );
        else
            fprintf( fo, '   url: %s\n','');
        end

        fprintf( fo, 'converter : \n','');
        fprintf( fo, ' - name: \n', mfilename);
        fprintf( fo, '   sha: %s\n',strtok( evalc( 'git log --abbrev-commit --pretty=oneline' ) ));


if exist( 'Agg', 'var') & numel( Agg.names ) > 0 
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

if exist( 'Spa', 'var') & numel( Spa.names ) > 0 
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

fo = fopen(  dictout, 'w' );
fprintf( fo,'---\nlayout: dictionary-template-final\ntitle: Dictionary Template\n---\n');
fclose(fo);

%%