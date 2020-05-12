function wsk_Jakosci = model1fun(tabela_wsp)
%MODEL1FUN Summary of this function goes here
%   Detailed explanation goes here
tabela_wsp=zeros(1,7)
b1=tabela_wsp(1);
b2=tabela_wsp(2);
b3=tabela_wsp(3);
b4=tabela_wsp(4);
a1=tabela_wsp(5);
a2=tabela_wsp(6);
TD=tabela_wsp(7);

dU1=ones(300,1);
dU2=dU1*35;
dU1=dU1*30;
dU1(1:100)=20;
dU2(1:100)=25;

load('odp_skok_pobudzenie_G1.mat')
GT=zeros(300,1);
GT(:,1)=odp_skok_pobudzenie_G1(500:799,1);
Ymod1=zeros(300,1);
err=zeros(300,1);
for i=3+TD:300
   Ymod1(i)= b1*dU1(i-TD-1)+b2*dU1(i-TD-2)+b3*dU2(i-TD-1)+b4*dU2(i-TD-2)-a1*GT(i-1) - a2*GT(i-2);
   err(i)=(Ymod1(i)-GT(i))^2;
end;
wsk_Jakosci=sum(err)
end

