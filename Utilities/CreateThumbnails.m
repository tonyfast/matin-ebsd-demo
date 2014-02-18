function CreateThumbnails( vizdata,h5nm, postdir, imdir )
% Using the YAML portion of my Jekyll site, I am creating thumbnails based
% on the syntax given in the datapage viz.yml.

c = clock;
[p, f, ext] = fileparts( h5nm );
p = postdir
dataloc = sprintf( '%s/%i-%i-%i-%s.markdown',p,c(1),c(2),c(3),f);

vyml = ReadYaml(vizdata);
% Make it work right?
fo = fopen( dataloc );ct=0; while ~feof(fo) ct=ct+1;s{ct} = fgetl(fo);end; fclose(fo);

tfl = 'temp.yml';
fo = fopen( tfl,'w' ); for ii = 1 : numel( s) if ~all(s{ii}=='-') fprintf(fo,'%s\n',s{ii}); end;end;fclose(fo);
fo = fopen( tfl );ct=0; while ~feof(fo) ct=ct+1;s2{ct} = fgetl(fo);end; fclose(fo);
dyml = ReadYaml(tfl);

vars = {'X','Y','Z','C'};
lastim = 0;
for dd = 1 : numel(dyml.spatial)
    imnm = sprintf('%s-*.png', f,lastim);
    delete( fullfile( imdir, imnm ) );
    for vv = 1 : numel( vyml )
        sd = vyml{vv}.data{1};
        
        nms = fieldnames( sd );
        
        args = struct2cell(sd);
        
        nargs = cellfun(@(x)numel(x), args );
        
        cdid = find(cellfun( @(x)strcmp( x, 'Cdata'), nms ))    ;
        xyz = setdiff(1:numel(nms), cdid);
        dims = max(2,sum(nargs(xyz)))
        xyzi = xyz( nargs(xyz)>0 );
        % if all the variable names are the same then it is gridded data
        ispoint = numel( unique({args{xyzi}}) ) > 1;
        isgridded = ~ispoint;
        
        [ Xdata, Ydata, Zdata, Cdata ] = deal( [] );
        for ii = xyzi
            eval(sprintf('%s = struct2array(h5read( ''%s'', ''%s'', ''%s''));', nms{ii}, h5nm, dyml.spatial{dd}.native, args{ii} ));
        end
        
        if numel(args{cdid}) > 0
            eval(sprintf('%s = struct2array(h5read( ''%s'', ''%s'', ''%s''));', 'Cdata', h5nm, dyml.spatial{dd}.native, args{cdid} ));
        end
        
        if numel(Cdata) > 0
            xx = linspace( min(Cdata), max(Cdata), size(colormap,1));
            co = colormap;
        else
            xx = [ 2 2];
            co = 'c';
        end
        
        switch dims
            case 2
                if ispoint
                    
                    for ii = 1 : (numel(xx)-1)
                        if numel(xx) == 2
                            b= ones(size(Xdata))==1;
                        else
                            b = Cdata>=xx(ii) & Cdata<=xx(ii+1);
                        end
                        plot( Xdata(b),Ydata(b),'ko','MarkerFaceColor',co(ii,:));
                        if ii == 1
                            hold on
                        end
                    end
                    hold off
                else
                    pcolor( Cdata );
                    axis equal; axis tight;
                end
                
            case 3
                if ispoint
                    
                    for ii = 1 : (numel(xx)-1)
                        if numel(xx) == 2
                            b= ones(size(Xdata))==1;
                        else
                            b = Cdata>=xx(ii) & Cdata<=xx(ii+1);
                        end
                        
                        plot3( Xdata(b),Ydata(b),Zdata(b),'ko','MarkerFaceColor',co(ii,:));
                        if ii == 1
                            hold on
                        end
                    end
                    hold off
                    
                    
                    
                end
                
                
            otherwise
        end
        axis equal
        if numel(Cdata) > 0
            colorbar;
        end
        axis tight
        set( gca,'Fontsize',14)
        
        lastim = lastim + vv;
        
        imnm = sprintf('%s-%i.png', f,lastim);
        saveas(gcf,fullfile( imdir, imnm));
        [IM ] = imread( fullfile( imdir, imnm) );
        BIM = cat(3,all(IM == IM(1) ,3),all(IM == IM(end) ,3));
        tr = find( ~all( BIM(:,:,1), 2), 1, 'first');
        if numel( tr ) == 0 verttrim(1) = 1; else; verttrim(1) = tr; end
        tr = find( ~all( BIM(:,:,2), 2), 1, 'last');
        if numel( tr ) == 0 verttrim(2) = size(IM,1); else; verttrim(2) = tr; end
        tr = find( ~all( BIM(:,:,1), 1), 1, 'first');
        if numel( tr ) == 0 horztrim(1) = 1; else; horztrim(1) = tr; end
        tr = find( ~all( BIM(:,:,2), 1), 1, 'last');
        if numel( tr ) == 0 horztrim(2) = size(IM,2); else; horztrim(2) = tr; end
        horztrim = [ 1 size(IM,2)];
        verttrim = [ max( 1, verttrim(1)-20), min( size(IM,1), verttrim(2)+20)];
        imwrite( IM( verttrim(1):verttrim(2), horztrim(1):horztrim(2),: ), fullfile( imdir, imnm));
        dyml.spatial{dd}.viz{vv}.url= imnm;
        dyml.spatial{dd}.viz{vv}.name= vyml{vv}.name;
        dyml.spatial{dd}.viz{vv}.description= vyml{vv}.description;
%         dyml.spatial{1}.viz{vv}.description = [];
    end
    lastim = lastim;
end

Struct2YMLMD( dyml, dataloc );