%% Distribución térmica del dinero en una sociedad
set(0,'defaultTextInterpreter','latex');

h=16*2;
% Condiciones iniciales
N = 40*h; %agentes interactuantes
M = 100*h; %constancia del dinero
C = 40; %clases del dinero
edges = linspace(0,10,41); % escala lineal, separada en número de clases
sep = edges(2)-edges(1);
deltam= [sep/2,sep,sep*2,sep*4]; %incrementos
t = 10000; %trials = tiempo

% Guardar espacio
S = zeros(length(deltam),t);
o21 = S; 
o22 = S; 
edges = linspace(0,5,C+1);

alpha = 0.1;

%% Iniciar simulación
for p= 1:4 %número de deltam 
    
ml = ones(1,N)*M/N; % distribución delta
%ml = edges(2:C+1)+0.0625;% distribución uniforme
k = round(rand(2,t)*(N-1))+1; %index
s = randi([0 1],1,t); %+1 -1 probabilidad
s(~s)=-1;

for n = 1:t % counter
    a = ml(k(1,n)) + deltam(p).*s(1,n);
    b = ml(k(2,n)) - deltam(p).*s(1,n);
    
    if k(1,n)==k(2,n)
        ml(k(1,n)) = ml(k(1,n));
        ml(k(2,n)) = ml(k(2,n)); 
    elseif a < 0 || b < 0
        ml(k(1,n)) = ml(k(1,n));
        ml(k(2,n)) = ml(k(2,n));
    else
        ml(k(1,n)) = a;
        ml(k(2,n)) = b;
    end
    
    % Entropía
    [counts1,~] = histcounts(ml,edges);
    counts = counts1;
    counts(~counts) = [];
    S(p,n) = N*log(N)-sum(counts.*log(counts));
    
    % Función objetivo
    o21(p,n) = sum(alpha*counts1.*counts1.*(edges(2:C+1)+0.0625));
    o22(p,n) = sum(counts1.*(1-exp(-alpha*counts1.*(edges(2:C+1)+0.0625))));

end
end
    
%% Plots

% Entropía
figure(4); 
x = 1:t;
plot(x,S(1,x),x,S(2,x),x,S(3,x),x,S(4,x));
title("Entrop\'ias; N="+string(N)+"; C="+string(C));
legend({'\Deltam='+string(deltam(1)),'\Deltam='+string(deltam(2)),'\Deltam='+string(deltam(3)),'\Deltam='+string(deltam(4))},'Location','southeast')
ylim([0 150]);
xlabel("$\Delta t$"); ylabel("S");

% Función objetivo
x = 1:t;
figure(5); plot(x,o21(1,x),x,o21(2,x),x,o21(3,x),x,o21(4,x));
title("Funci\'on objetivo 1; N="+string(N)+"; C="+string(C));
legend({'\Deltam='+string(deltam(1)),'\Deltam='+string(deltam(2)),'\Deltam='+string(deltam(3)),'\Deltam='+string(deltam(4))},'Location','southeast')
xlabel("$\Delta t$"); ylabel("$o_1$"); ylim([0 1000]);

figure(6); plot(x,o22(1,x),x,o22(2,x),x,o22(3,x),x,o22(4,x));
title("Funci\'on objetivo 2; N="+string(N)+"; C="+string(C));
legend({'\Deltam='+string(deltam(1)),'\Deltam='+string(deltam(2)),'\Deltam='+string(deltam(3)),'\Deltam='+string(deltam(4))},'Location','southeast')
xlabel("$\Delta t$"); ylabel("$o_2$"); ylim([0 1000]);

%%
% Funciones objetivo juntas
set(0,'defaultTextInterpreter','latex');
x = 1:t; p =2;
figure(7); plot(x,o21(p,x),x,o22(p,x));
title("Funci\'on objetivo; N="+string(N)+"; C= "+string(C)+"$, \Delta m=$"+string(deltam(p)));
legend({'o1, delta','o2, delta','o1, uniforme', 'o2, uniforme'})
xlabel("$\Delta t$"); ylabel("$o$");
xlabel("a"); ylabel("b");