% load data given filenames
function output = loader(filenames, labels, norm, length, channels)
    if norm ~= ""
                ranges = { % [amin amax ; gmin gmax]
                    [0.345728371800269 39.7047344635759; 1.9962881523604 555.803931697052],  % U1
                    [1.21581533040363 41.6495339481341; 0.551648140554445 533.261818814418], % U2
                    [1.12687774146127 38.6617047107348; 0.644026375676632 587.904318225094],
                        [0.248908572606793 42.5714848846258; 0.902333264482043 569.440359311625],
                        [0.822960897141466 37.0213590882006; 0.352105240053744 525.089353825878]
                        };

                meanstd = { % [amean astddev ; gmean gstddev]
                [12.629859443887135 5.738365620992473; 163.49229325326618 96.74042606392025],
                [11.777983949638422 3.977903265327697; 143.41084227513744 89.40506678202725],
                [11.95367744554427 4.605674262216766; 136.1571538121075 84.66152113974925],
                [12.848753561964747 5.709960951749006; 168.40407116679668 109.24140341174476],
                [11.956030376280081 4.810568933834056; 130.58126471037482 87.22253286321497]
                };
        end

    datamtx = zeros(length, channels, numel(filenames));
    for i = 1:numel(filenames)
        mtx = readmatrix(filenames(i));

                if norm ~= ""
                        % user
                        ustr = filenames(i).split("_");
                        ustr = ustr(end-3).split('r');
                        u = str2double(ustr(2));

                        if norm == "linear"
                                % linear normalization by user
                                mtx(:,1) = (mtx(:,1)-ranges{u}(1,1)) ./ (ranges{u}(1,2)-ranges{u}(1,1));
                                mtx(:,2) = (mtx(:,2)-ranges{u}(2,1)) ./ (ranges{u}(2,2)-ranges{u}(2,1));
                        end

                        if norm == "zscore"
                                % zscore normalization by user
                                mtx(:,1) = (mtx(:,1)-meanstd{u}(1,1)) ./ meanstd{u}(1,2);
                                mtx(:,2) = (mtx(:,2)-meanstd{u}(2,1)) ./ meanstd{u}(2,2);
                        end
                end

                datamtx(:,:,i) = mtx;
    end

    sequences = squeeze(num2cell(datamtx, [1 2]));
    labels = categorical(labels);
    output = table(sequences, labels);
end
