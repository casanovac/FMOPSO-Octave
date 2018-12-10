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
function [bG, fbG] = MetaheuristicaPSO_FC_NRP(num_particulas, cond_parada, arg_cond_parada)
  fi_m = 2.05;
  fi_c = fi_m;
  fi = fi_m + fi_c;
  fact_const_k = 1;
  fact_const_X = 2*fact_const_k/(fi-2+sqrt(fi^2-4*fi));
   
  fi_m_vector = fi_m * ones(num_particulas,1);
  fi_c_vector = fi_c * ones(num_particulas,1);
    
  model = CreateModel();
    
	dim_particulas = sum(model.n_requirements_in_level);
	% Inicialización de datos
  
  X = aplicar(zeros(num_particulas, dim_particulas), rand(num_particulas, dim_particulas), model);
  fX = zeros(num_particulas,1);
  for k=2:1:num_particulas
    fX(k) = Profit_Cost(X(k,:),model);
  endfor
  fb = fX;
  V = -ones(num_particulas, dim_particulas) + 2 .* rand(num_particulas, dim_particulas);
	b = X;
	bG = b(1, :);
  fbG = fb(1);
	for(k=2:1:num_particulas)
		if fX(k) > fbG
			bG = X(k,:);
      fbG = fX(k);
    end
  end
  
  fbG_it = [fbG];
	
	% bucle principal
	num_iteracion = 1;
	while((cond_parada==1 && num_iteracion <= arg_cond_parada) || (cond_parada==2 && abs(arg_cond_parada-feval(function_name, bG))>0.01))
		r1 = rand(num_particulas,dim_particulas);
		r2 = rand(num_particulas,dim_particulas);
		%for(l=1:1:dim_particulas) % hacemos de a 1 dimensión, todas las partículas juntas
		%	V(:,l) = fact_const_X * (V(:,l) + fi_m_vector(l)*r1(l)*(b(:,l)-X(:,l)) + fi_c_vector(l)*r2(l)*(bG(l)-X(:,l)));
		%	X(:,l) = X(:,l) + V(:,l);			
    %end
    %reemplazando las iteraciones por productos matriciales
    constriccion = repmat(fact_const_X,num_particulas,dim_particulas);
    V = constriccion.* (V + fi_m_vector.*r1.*(b-X) + fi_c_vector.*r2.*(repmat(bG,num_particulas,1)-X));
    %V = ajustar_maxima_velocidad(V,min_values,max_values);
    X = aplicar(X, V, model);
        
		for(k=1:1:num_particulas)
			fX(k) = Profit_Cost(X(k,:), model);
      if fX(k) > fb(k)
				b(k,:) = X(k,:);
        fb(k) = fX(k);
				if fX(k) > fbG
					bG = X(k,:);
          fbG = fX(k);
        end
      end
    end
    fbG_it = [fbG_it, fbG];
    plot([0:length(fbG_it)-1],fbG_it);
    pause(0.001);
    num_iteracion = num_iteracion + 1;
  end
	
end

function new_X = aplicar(X, V, model)
  new_X = X;
  for n=1:size(X,1)
    absV = [[1:size(X,2)];abs(V(n,:))];
    for i = 1:size(X, 2)
      %[minV, idx] = min(absV(2,:));
      idx = 1+floor(size(absV,2)*rand());
      %idx = 1;
      if X(n,absV(1,idx)) == 0 && V(n,absV(1,idx)) > 0
        test = rand() <= (V(n,absV(1,idx)));
        if test == 1
          new_X(n,:) = DoAction(new_X(n,:), [1, absV(1,idx)], model);
        endif
      elseif X(n,absV(1,idx)) == 1 && V(n,absV(1,idx)) < 0
        test = -rand() <= (V(n,absV(1,idx)));
        if test == 0
          new_X(n,:) = DoAction(new_X(n,:), [2, absV(1,idx)], model);
        endif
      endif
      absV(:,idx) = [];
    endfor
  endfor
endfunction