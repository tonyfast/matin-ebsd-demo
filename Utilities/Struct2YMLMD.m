function fn = Stuct2YMLMD( D, fn)

fo = fopen( fn,'w');
fprintf( fo,'---\n');
fldsii = cellfun(@(x)char(x),fieldnames( D )','UniformOutput',false);
recurseii = [];
indent = '';
for ii = 1 : numel( fldsii )
    data = getfield( D, fldsii{ii} );
    if ~iscell( data )
        if ischar( data )
            fprintf( fo,'%s%s: %s\n',indent,char(fldsii{ii}),data);
        else
            fprintf( fo,'%s%s: %f\n',indent,char(fldsii{ii}),data);
        end
    else
        %%
        indent = '';
        fprintf( fo,'%s%s: \n',indent,char(fldsii{ii}));
        for dd = 1 : numel( data)
            indent = ' - ';
            flddata = getfield( D, fldsii{ii},{dd} );
            fldsjj = cellfun(@(x)char(x),fieldnames( flddata{1} )','UniformOutput',false);
            for jj = 1 : numel(fldsjj)
                data = getfield( flddata{1}, fldsjj{jj});
                if ~iscell( data )
                    if ischar( data )
                        fprintf( fo,'%s%s: %s\n',indent,char(fldsjj{jj}),data);
                    else
                        fprintf( fo,'%s%s: %f\n',indent,char(fldsjj{jj}),data);
                    end
                    indent = regexprep(indent, '-',' ');
                else
                    indent = '   ';
                    %%
                    fprintf( fo,'%s%s: \n',indent,char(fldsjj{jj}));
                    for ee = 1 : numel( data)
                        indent = '    - ';
                        flddatajj = getfield( flddata{1}, fldsjj{jj},{ee} );
                        fldskk = cellfun(@(x)char(x),fieldnames( flddatajj{1} )','UniformOutput',false);
                        for kk = 1 : numel(fldskk)
                            data = getfield( flddatajj{1}, fldskk{kk});
                            %%
                            
                            if ~iscell( data )
                                if ischar( data )
                                    fprintf( fo,'%s%s: %s\n',indent,char(fldskk{kk}),data);
                                else
                                    fprintf( fo,'%s%s: %f\n',indent,char(fldskk{kk}),data);
                                end
                                indent = regexprep(indent, '-',' ');
                            else
                                indent = '         ';
                                %%
                                fprintf( fo,'%s%s: \n',indent,char(fldskk{kk}));
                                for ff = 1 : numel( data)
                                    indent = '    - ';
                                    flddatakk = getfield( flddatajj{1}, fldskk{kk},{ff} );
                                    fldsll = cellfun(@(x)char(x),fieldnames( flddatakk{1} )','UniformOutput',false);
                                    for ll = 1 : numel(fldsll)
                                        data = getfield( flddatakk{1}, fldsll{ll});
                                        %%
                                        
                                        if ~iscell( data )
                                            if ischar( data )
                                                fprintf( fo,'%s%s: %s\n',indent,char(fldsll{ll}),data);
                                            else
                                                fprintf( fo,'%s%s: %f\n',indent,char(fldsll{ll}),data);
                                            end
                                            indent = regexprep(indent, '-',' ');
                                        else
                                            indent = '            ';
                                            %%
                                            fprintf( fo,'%s%s: \n',indent,char(fldsll{ll}));
                                            for gg = 1 : numel( data)
                                                indent = '    - ';
                                                flddatall = getfield( flddatakk{1}, fldsll{ll},{gg} );
                                                fldsmm = cellfun(@(x)char(x),fieldnames( flddatall{1} )','UniformOutput',false);
                                                for mm = 1 : numel(fldsmm)
                                                    data = getfield( flddatamm{1}, fldskk{mm});
                                                    %%
                                                    
                                                    if ~iscell( data )
                                                        if ischar( data )
                                                            fprintf( fo,'%s%s: %s\n',indent,char(fldsmm{mm}),data);
                                                        else
                                                            fprintf( fo,'%s%s: %f\n',indent,char(fldsmm{mm}),data);
                                                        end
                                                        indent = regexprep(indent, '-',' ');
                                                    else
                                                        indent = '            ';
                                                        %%
                                                        
                                                        
                                                        %%
                                                    end
                                                    
                                                    %%
                                                end
                                            end
                                            
                                            
                                            %%
                                        end
                                        
                                        %%
                                    end
                                end
                                %%
                            end
                            
                            %%
                        end
                    end
                    
                    %%
                end
                
            end
        end
        %         fldsjj = cellfun(@(x)char(x),fieldnames( D )','UniformOutput',false);
        recurseii = [ recurseii, ii];
        indent = '';
        
        %%
    end
end

fprintf( fo,'---\n');
fclose(fo);