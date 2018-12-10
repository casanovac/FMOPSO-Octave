% retorno = X, vector de posiciones de las partículas en la última iteración
% arg = num_particulas, cantidad de particulas del ejambre
% arg = criterio_mejora, 1 para max, -1 para min
% arg = cond_parada:
% 	1: cantidad de iteraciones
%	2: se llega a un valor objetivo
% arg = arg_cond_parada
% arg = arg_conf_factor_constr
% 1: fi_m = fi_c = 2.05, fi = 4.1, fact_const_k = 1, fact_const_X = 0.729
%	2: fi_m = fi_c = 2.8, fi =  5.6 fact_const_k = 1, fact_const_X = 0.303
% Probar con MetaheuristicaPSO_FC([-5 -5], [5 5], 10, 'test_function1', 1, 1, 100, 1)
function [b, fb] = MetaheuristicaFMOPSO_FC_VN_NRP_2(num_particulas, filas, columnas, cond_parada, arg_cond_parada)
  if filas * columnas ~= num_particulas
    error("Debe especificar las dos dimensiones del arreglo de partículas a construir, y el producto debe ser igual al número de partículas");
  endif
  FrenteParetoReal = [787   2909
    743   2865
    699   2783
    648   2657
    598   2507
    550   2295
    500   2094
    450   1921
    398   1730
    350   1560
    300   1381
    249   1177
    200    985
    150    784
    100    563
     50    320
     25    188
     12     91
      0      0];
  model = CreateModel();
  ProfitRange = [0 2909];
  CostRange = [0 787];
  
  FitnessFunction=@(Position, VNPosition) FuzzyFitness(Position, model, ProfitRange, CostRange, VNPosition, [filas, columnas]);    % Cost Function
  
	dim_particulas = sum(model.n_requirements_in_level);
  
  indices = [1:num_particulas];
  f = floor((indices-1)./columnas);
  c = rem(indices-1,columnas);
##  izq = 1+f*columnas+max(0,c-1);
##  der = 1+f*columnas+min(c+1,columnas-1);
##  arr = 1+mod(f-1,filas)*columnas+c;
##  aba = 1+mod(f+1,filas)*columnas+c;
  izq = 1+max(0,c-1);
  der = 1+min(c+1,columnas-1);
  primera_fila = repmat([1:columnas]',filas,1);
  
##  vecindario = [izq', der', arr', aba'];
  %vecindario = [arr', aba'];
  vecindario = [izq', der', primera_fila];
	% Inicialización de datos
  
  X = aplicar(zeros(num_particulas, dim_particulas), randi(2,num_particulas, dim_particulas)-1, model);
##  fX = zeros(num_particulas,1);
##  fX = zeros(num_particulas,columnas);
  fX = sparse(num_particulas,columnas);
  for k=1:1:num_particulas
    fX(k,c(k)+1) = FitnessFunction(X(k,:),[f(k)+1,c(k)+1]);
    if c(k) > 0
      fX(k,c(k)) = FitnessFunction(X(k,:),[f(k)+1,c(k)]);
    endif
    if c(k) < columnas - 1
      fX(k,c(k)+2) = FitnessFunction(X(k,:),[f(k)+1,c(k)+2]);
    endif
    % for j = 1: columnas
      %fX(k,j) = FitnessFunction(X(k,:),[f(k)+1,j]);
    % endfor
  endfor
  V = randi(2,num_particulas, dim_particulas)-1;
  
##  fb = fX(1:columnas);
##  b = X(1:columnas);
  
  [fb, ind_b] = max(fX);
  b = X(ind_b,:);
##	for k = columnas+1:num_particulas
##    if fX(k) > fb(1+c(k))
##        fb(1+c(k)) = fX(k);
##        b(1+c(k),:) = X(k,:);
##    endif  
##  endfor
  
  [fbG, ind_bG] = max(fb);
  bG = b(ind_bG, :);
##  for(k=2:1:num_particulas)
##	for(k=2:1:columnas)
##		if fb(k) > fbG
##			bG = b(k,:);
##      fbG = fb(k);
##    end
##  end
  
  fbG_it = [fbG];
  ObjPairIt = zeros(arg_cond_parada+1,2);
  ObjPairIt(1,:) = Profit_Cost2(bG, model);
  
  % Borrar despues
	[fbVN, mejor_vecino] = max(fb(vecindario),[],2);
  
  mapa_objetivos_X = zeros(num_particulas,2);
  mapa_objetivos_b = zeros(num_particulas,2);
  
	% bucle principal
	num_iteracion = 1;
  
	while((cond_parada==1 && num_iteracion <= arg_cond_parada) || (cond_parada==2 && abs(arg_cond_parada-feval(function_name, bG))>0.01))
    
    r1 = randi(2, num_particulas, dim_particulas) - 1;
		r2 = randi(2, num_particulas, dim_particulas) - 1;
		%for(l=1:1:dim_particulas) % hacemos de a 1 dimensión, todas las partículas juntas
		%	V(:,l) = fact_const_X * (V(:,l) + fi_m_vector(l)*r1(l)*(b(:,l)-X(:,l)) + fi_c_vector(l)*r2(l)*(bG(l)-X(:,l)));
		%	X(:,l) = X(:,l) + V(:,l);			
    %end
    [fbVN, mejor_vecino] = max(fb(vecindario),[],2);
    %reemplazando las iteraciones por productos matriciales
##    V = or(and(r1,xor(b,X)), and(r2,xor(b(vecindario(indices' + (mejor_vecino-1)*num_particulas),:),X)));

    V = or(and(r1,xor(repmat(b,filas,1),X)), and(r2,xor(b(vecindario(indices' + (mejor_vecino-1)*num_particulas),:),X)));
    %V = ajustar_maxima_velocidad(V,min_values,max_values);
    X = aplicar(X, V, model);
        
		for k=1:1:num_particulas
      fX(k,c(k)+1) = FitnessFunction(X(k,:),[f(k)+1,c(k)+1]);
      if c(k) > 0
        fX(k,c(k)) = FitnessFunction(X(k,:),[f(k)+1,c(k)]);
      endif
      if c(k) < columnas - 1
        fX(k,c(k)+2) = FitnessFunction(X(k,:),[f(k)+1,c(k)+2]);
      endif
      % for j = 1: columnas
        %fX(k,j) = FitnessFunction(X(k,:),[f(k)+1,j]);
      % endfor
    endfor
    
    [fb2, ind_b] = max(fX); % acá hay que preguntar si es mejor que el que ya está
    
    cambios = (fb2 >= fb)';
    b = repmat(cambios,1,dim_particulas) .* X(ind_b,:) + repmat(1 - cambios,1,dim_particulas) .* b;
    fb = cambios' .* fb2 + (1 - cambios)' .* fb;
    
    [fbG, ind_bG] = max(fb);
    bG = b(ind_bG, :);
##    for(k=1:1:num_particulas)
##			fX(k) = FitnessFunction(X(k,:),[f(k)+1,c(k)+1]);
##      if fX(k) > fb(1+c(k))
##        fb(1+c(k)) = fX(k);
##        b(1+c(k),:) = X(k,:);
##        
##				if fX(k) > fbG
##					bG = X(k,:);
##          fbG = fX(k);
##        end
##      end
##    end
##    for(k=1:1:num_particulas)
##			fX(k) = FitnessFunction(X(k,:), [f(k)+1,c(k)+1]);
##      if fX(k) > fb(k)
##				b(k,:) = X(k,:);
##        fb(k) = fX(k);
##				if fX(k) > fbG
##					bG = X(k,:);
##          fbG = fX(k);
##        end
##      end
##    end
    
    figure(1);
    plot(FrenteParetoReal(:,2),FrenteParetoReal(:,1));
    hold on;
    for k = 1:num_particulas
      mapa_objetivos_X(k,:) = Profit_Cost2(X(k,:),model);
    endfor
    plot(mapa_objetivos_X(:,1),mapa_objetivos_X(:,2),'ko');
    
    hold on;
##    for k = 1:num_particulas
    for k = 1:columnas
      mapa_objetivos_b(k,:) = Profit_Cost2(b(k,:),model);
    endfor
    plot(mapa_objetivos_b(:,1),mapa_objetivos_b(:,2),'r*');
    
    % además, buscar los mejores de cada columna y graficarlos, tambien se puede incorporar esto al algoritmo
    % otra idea es que la confianza en las particulas de la misma columna sea mayor que los demas
    axis([0, 3000, 0, 900]);
    xlabel("Profit");
    ylabel("Cost");
    grid on;
    
    hold off;
    
    pause(0.001);
    num_iteracion = num_iteracion + 1;
  end
	
end

function new_X = aplicar(X, V, model)
  new_X = X;
  for n=1:size(X,1)
    absV = [[1:size(X,2)];(V(n,:))];
    for i = 1:size(X, 2)
      %[minV, idx] = min(absV(2,:));
      %idx = 1+floor(size(absV,2)*rand());
      idx = 1;
      if X(n,absV(1,idx)) == 0 && V(n,absV(1,idx)) > 0
        new_X(n,:) = DoAction(new_X(n,:), [1, absV(1,idx)], model);
      elseif X(n,absV(1,idx)) == 1 && V(n,absV(1,idx)) > 0
        new_X(n,:) = DoAction(new_X(n,:), [2, absV(1,idx)], model);
      endif
      absV(:,idx) = [];
    endfor
  endfor
endfunction