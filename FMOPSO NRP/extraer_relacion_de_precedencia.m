model = CreateModel();
for i = 1:size(model.precedence_relation, 1)
  disp([num2str(model.precedence_relation(i,1)), " . ", num2str(model.precedence_relation(i,2))]);
endfor