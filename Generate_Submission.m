subjects = {'Dog_1', 'Dog_2', 'Dog_3', 'Dog_4', 'Dog_5', 'Patient_1', 'Patient_2'};

labels = cell(0,2);
for i = 1:size(subjects,1)
    display(['Training on subject ' subjects{i}]);
    theta = Train(subjects{i});
    display(['Testing on subject ' subjects{i}]); 
    test_labels = Test(subjects{i}, theta);
    labels = [labels' test_labels']';
    cell2csv('submission.csv', labels, ',', '2011', '.');
end