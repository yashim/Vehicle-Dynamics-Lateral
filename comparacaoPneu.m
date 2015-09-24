clear,clc,close all
%% Info
% IMPORTANTE!: Ver Info de simulacao.m!

%% Descri��o
% Este script tem como objetivo comparar o resultado das combina��es de modelos de pneu e ve�culos

% Vai ser o n�mero de figuras
veiculoModeloVet = [1 2 3];
veiculoModeloTxt = char(' Linear 2 GDL',' N�o linear 2 GDL',' N�o linear 3 GDL');
%veiculoModeloTitulo4 = 'veiculoNaoLinear3gdlExtendido';

veiculoDados = 1;

% Vai ser o n�mero de curvas em cada figura
pneuModeloVet = [1 2 3]; % Modelos 1-Linear; 2-Sadri; 3-Pacejka
pneuModeloTxt = char('Linar','Sadri','Pacejka');
pneuModeloCor = char('r','g','b');
pneuModeloMarcador = char('o','s','d');
pneuDadosVet = [1 2 3];

for i = 1:length(veiculoModeloVet)
	for j = 1:length(pneuModeloVet)
		
		veiculoModelo = veiculoModeloVet(i);

		pneuModelo = pneuModeloVet(j);
		pneuDados = pneuDadosVet(j);
		


		%% Dados b�sicos da integra��o (integrador � chamado mais abaixo)
		% 
		T = 3; % Tempo total de simula��o
		TSPAN = 0:T/40:T; % Vetor de tempo de an�lise

		r0 = 2; % velocidade angular [rad/s]
		vy0 = 0; % velocidade lateral [m/s]
		v = 20; % velocidade longitudinal [m/s] -> ATEN��O: Tem que estar de acordo com os dados dos ve�culos com 2 gdl
		ALPHAT0 = asin(vy0/v); % convers�o de vy0 para ALPHAT
		x0 = [r0 ; ALPHAT0]; % Condi��o inicial dos estados
		x0 = [x0 ; 0]; % Condi��o da orientacao
		x0 = [x0 ; 0 ; 0]; % Condi��o inicial da trajet�ria
		if veiculoModelo == 3
			% Para que o integrador consiga rodar no modelo com 3 gdl � necess�rio acrescentar uma
			% condi��o inicial referente ao estado velocidade "v".
			% Ou seja, a velocidade que era prescrita antes agora � condi��o inicial
			x0 = [x0 ; v]; % Condi��o inicial da velocidade
		end

		[pneuFun veiculoFun pneuDadosFrente pneuDadosTras veiculoDadosVet pneuTxt veiculoTxt] = seletor(pneuModelo,pneuDados,veiculoModelo,veiculoDados);

		[TOUT,XOUT] = ode45(@(t,x) veiculoFun(t,x,pneuFun,pneuDadosFrente,pneuDadosTras,veiculoDadosVet),TSPAN,x0); 

		figure(i)
		hold on
		H1 = plot(TOUT,XOUT(:,1)*180/pi,pneuModeloCor(j));
		set(H1,'Marker',pneuModeloMarcador(j),'MarkerFaceColor',pneuModeloCor(j),'MarkerSize',7)
		title('Velocidade angular X Tempo')
		title(strcat('Orienta��o X Tempo - Ve�culo: ',veiculoModeloTxt(i,:)));
		ylabel('dPSI [grau/s]')
		xlabel('Tempo [s]')
		if j == length(pneuModeloVet)
		legend(pneuModeloTxt(1,:),pneuModeloTxt(2,:),pneuModeloTxt(3,:))
		end
% Plotar o gr�fico com eixo vertical na esquerda e direita
%[AX,H1,H2] = plotyy(TOUT,XOUT(:,1)*180/pi,TOUT,XOUT(:,2)*180/pi); 
% Mudando as cores dos eixos (Padr�o vem com cores iguais aos eixos)
% set(AX(1),'YColor',[0 0 0]);
% set(AX(2),'YColor',[0 0 0]);
% set(H1,'Color',[1 0 0],'Marker','o','MarkerFaceColor',[1 0 0],'MarkerSize',7)
% set(H2,'Color',[0 1 0],'Marker','s','MarkerFaceColor',[0 1 0],'MarkerSize',7)
% title(strcat('Estados X Tempo - Pneu: ',pneuTxt,';',' Ve�culo: ',veiculoTxt));
% ylabel(AX(1),'dPSI [grau/s]')
% ylabel(AX(2),'ALPHAT [grau]')
% xlabel('Tempo [s]')
% legend('dPSI','ALPHAT');
	end
end