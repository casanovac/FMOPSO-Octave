model = CreateModel();
for i = 1:numel(model.interest_relation)
  req = cell2mat(model.interest_relation(i,:));
  for j = 1:size(req,2)
    disp([num2str(i), " . ", num2str(req(j))]);
  endfor
endfor
