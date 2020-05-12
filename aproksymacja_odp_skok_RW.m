clear all
x0 = ones(1, 5);
lb=[];
%lb(1,7)=0;

tablica_wsp=zeros(4, 5);
load('rozdzielone_odp_skokowe.mat', 'GT');

GT_aproksym=zeros(size(GT,1),4);
for i=1:4
    odp_skok=GT(:,i);
    save('dane_do_aproksymacji.mat', 'odp_skok');
    [lista_wsp,E]=fmincon((@(parameters) model1fun(parameters)),x0,[],[],[],[],lb,[]);
    model1fun(lista_wsp);
    tablica_wsp(i,:)=lista_wsp;  %i-ty wiersz jest wspolczynnikami dla i-tej kolumny w GT
    load('Y_aproksym_z_fmincon.mat');
    
    GT_aproksym(:,i)=Ymod1;
    figure
    plot(Ymod1, '--');
    hold on
    plot(GT(:,i));
    hold off
end
save('odp_skok_aproks', 'GT_aproksym');