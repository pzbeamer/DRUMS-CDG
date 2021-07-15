%{ 
Get cell of file names:
Downloaded Google sheet in .csv form ---->>>>> Matlab cell
This section of code will create a Matlab cell that stores the names of
the data sets that are the first Valsalva from the first patient visit.

Cell has 5 "columns" - File name, vector of times (see spreadsheet),notes,
 flags - see below, and age/sex vector (age first entry, sex second entry
 0 = female, 1 = male
%}
% Open the file and read the first line using 'fgetl' command
file_name = 'PatientInfo_063021.csv';
fid = fopen(file_name);
header_line = fgetl(fid);
fclose(fid);
% Splitting the headerline when it encounters the delimiter ','
file_headers = strsplit(header_line,',');
% Now the size of the file_headers indicates the number of columns present
columnSize = length(file_headers);


save('File_name_cell_070821.mat','cewll_of_file_names')
