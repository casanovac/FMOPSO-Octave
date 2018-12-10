%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA116
% Project Title: Implementation of Tabu Search for TSP
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function model = CreateModel()

    Cost_Req_L1 = [4 3 4 1 5 5 5 3 5 3 4 4 3 5 1 1 3 2 2 3];
    Cost_Req_L2 = [8 8 2 6 7 4 5 3 6 3 7 2 6 3 5 2 2 4 2 5 4 5 2 2 8 4 2 4 8 7 3 6 6 4 3 6 4 8 6 7];
    Cost_Req_L3 = [9 6 10 6 9 10 7 9 7 6 10 6 5 10 5 6 6 6 5 6 8 10 9 6 10 7 10 8 9 9 6 10 8 8 10 10 6 7 6 8 7 10 7 9 6 6 8 6 7 8 7 7 6 7 9 6 7 6 8 6 6 7 5 7 5 8 9 10 10 6 5 9 8 10 7 8 7 9 7 7 ];
    % Esto hay que hacerlo con celdas después, y leyendo desde el archivo del dataset directamente
    N_Req_L1 = length(Cost_Req_L1);
    N_Req_L2 = length(Cost_Req_L2);
    N_Req_L3 = length(Cost_Req_L3);
    
Dependencias = [1 85
%^ Id of RequirementA1	Id of RequirementB1 
2 98
%^ Id of RequirementA2	Id of RequirementB2
2 37
2 92
2 51
2 135
2 73
2 72
3 61
5 114
5 37
5 92
5 48
5 119
6 130
6 42
6 130
6 130
6 130
7 129
7 120
7 68
7 95
7 108
7 54
10 124
10 133
10 127
10 116
11 38
11 101
11 61
12 103
12 125
13 28
13 59
14 135
14 103
14 34
14 107
17 74
17 120
17 50
17 27
17 102
17 88
17 104
19 76
19 34
19 120
20 81
20 33
20 27
20 81
20 129
20 123
20 21
21 100
21 66
22 77
22 89
24 94
24 126
27 108
29 98
32 118
32 83
34 112
35 79
38 124
38 104
39 90
39 64
40 94
42 89
43 107
43 91
44 132
44 92
45 115
45 98
46 133
47 63
48 82
49 87
49 110
51 136
52 138
52 137
53 77
53 133
54 113
55 61
56 62
57 91
57 138
60 85];
    
    Profit_C = [36
29
33
22
33
34
27
26
35
36
28
31
29
30
29
36
28
31
20
24
35
33
26
34
26
34
25
34
26
29
27
26
34
28
28
37
32
23
30
26
27
31
36
38
29
30
28
29
19
25
31
36
30
28
24
29
35
23
26
25
26
40
23
25
33
23
31
35
35
27
41
32
39
21
37
27
18
27
25
32
28
29
28
28
23
32
22
25
22
24
35
23
31
21
35
27
27
33
28
22];

    N_C = length(Profit_C);
    Req_List = {[66]
[68,1,128,139,61]
[129,59]
[75,104]
[93]
[3,120]
[47,35,119,66]
[75,24]
[120,133,108,19]
[77,60]
[50]
[63,24,81,126,123]
[36,102,59]
[22,114,27,120,58]
[77,119,23,48,73]
[61]
[81]
[78]
[94,123,92]
[128]
[21,91,26,40,107]
[109,76,59]
[68,120,105,54]
[14,38,103,110,29]
[91,104,51]
[115,73,112,125,56]
[108,96]
[59,41,72]
[133,134,122,59]
[100,136,23,98,26]
[133]
[64,76,67,38]
[43,73,83,124,102]
[116]
[91,103,76,137,106]
[75,113,103]
[97,96,120,38]
[15]
[56,84,123]
[3,126]
[62,12,57,43,51]
[79,60,42,75]
[24]
[105,21]
[98,134,64,114]
[61,26,27,59,53]
[117]
[45,139]
[21,32,132]
[119,107,29]
[106,23,118,37,107]
[73,93]
[86,102]
[39,76,63,139,52]
[69,127,95]
[115,28,119,100,32]
[52,90,116]
[109,104,90,120,93]
[46,85]
[101,129]
[74]
[25,57]
[72]
[134]
[74,104,133]
[120]
[101,138,118,100,28]
[131,114,50,104]
[123]
[137]
[99,23]
[81,133]
[97,128,51]
[65,84,80,30]
[67]
[64]
[86,16,12,78,11]
[2]
[61,126,63,113]
[24,104]
[84,85,119,46]
[59,79,63,104,88]
[73]
[116,43,114,83,97]
[78,101]
[15,120]
[40,77]
[134]
[124,81,61,98]
[43,121]
[121,93,33]
[37,97,34,73,53]
[124,74,91]
[137,71,41]
[85,125,58,104,40]
[104]
[79,123,63,34,87]
[101,134]
[83,37,85]
[85]};
    requirement_cost_for_level = {};
    model.n_customers = N_C;
    model.customer_profit = Profit_C;
    model.n_requirement_levels = 3;
    model.n_requirements_in_level(1) = N_Req_L1;
    model.requirement_cost_for_level{1} = Cost_Req_L1;
    model.n_requirements_in_level(2) = N_Req_L2;
    model.requirement_cost_for_level{2} = Cost_Req_L2;
    model.n_requirements_in_level(3) = N_Req_L3;
    model.requirement_cost_for_level{3} = Cost_Req_L3;
    model.precedence_relation = Dependencias;
    model.interest_relation = Req_List;
    
end