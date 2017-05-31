function outputs = load_experiment()
    f = dir();
    outputs = [];
    for i = 1:length(f)
        f(i).name
        if f(i).name(1) ~= '.'
            cd(f(i).name)
            folder_data = load_data_current_folder_manual;
            outputs = [outputs, struct('experiment', f(i).name, 'data', folder_data)];
            cd ..
        end
    end