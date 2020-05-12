close;
%Instrukcja Prescaler - wartosc przesuniecia odpowiedzi skokowej
%skalowanie jest odpowiednio 
%Prescaler(1) - G1T1
%Prescaler(2) - G1T3
%Prescaler(3) - G2T1
%Prescaler(4) - G2T3
%GT - Macierz 200x4 odpowiedzi skokowych


clear;
load('odp_skok_pobudzenie_G1.mat')
load('odp_skok_pobudzenie_G2.mat')
GT=zeros(200,4);
GT(:,1)=odp_skok_pobudzenie_G1(600:799,1);
GT(:,2)=odp_skok_pobudzenie_G1(600:799,2);
GT(:,3)=odp_skok_pobudzenie_G2(600:799,1);
GT(:,4)=odp_skok_pobudzenie_G2(600:799,2);
%%%wyswietlenie odpowiedzi skokowej
plot(GT(:,1)); hold on 
plot(GT(:,2)); plot(GT(:,3)); plot(GT(:,4)); hold off
%skalowanie
Prescaler=zeros(4,1);
Du=[10 10 10 10];
for i=1:4
    Prescaler(i)=GT(1,i);
    for j=1:200
        GT(j,i)=(GT(j,i)-Prescaler(i))/Du(i);
    end;
  GT(:,i)=  No_Negatives(GT(:,i));
end;

plot(GT(:,1)); hold on 
plot(GT(:,2)); plot(GT(:,3)); plot(GT(:,4)); hold off
clear i;
clear j;

G1T1=GT(:,1);
G1T3=GT(:,2);
G2T1=GT(:,3);
G2T3=GT(:,4);