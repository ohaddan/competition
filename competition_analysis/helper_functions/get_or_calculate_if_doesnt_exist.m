function result = get_or_calculate_if_doesnt_exist(mat_path, func_path, var_name)
% Check if the mat file exists
if exist(mat_path, 'file') == 2
    % If it exists, load the result variable
    mat_file = load(mat_path, var_name);
    result = mat_file.(var_name);
else
    % If it doesn't exist, run the function to calculate the result
    run(func_path);
    % The result variable should be defined in the function
    result = eval(var_name);
    % Save the result to the mat file
    save(mat_path, var_name);
end
end