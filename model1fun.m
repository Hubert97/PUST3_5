function wsk_Jakosci = model1fun(tabela_wsp)
%MODEL1FUN Summary of this function goes here
%   Detailed explanation goes here
b1=tabela_wsp(1);
b2=tabela_wsp(2);
a1=tabela_wsp(3);
a2=tabela_wsp(4);
TD=round(tabela_wsp(5));



% load('odp_skok_pobudzenie_G1.mat', 'odp_skok_pobudzenie_G1');
% GT=odp_skok_pobudzenie_G1(602:801,1);
% Ymod1=zeros(size(GT,1),1);
% err=zeros(size(GT,1),1);

load('dane_do_aproksymacji.mat', 'odp_skok');
GT=odp_skok(:,1);
Ymod1=zeros(size(GT,1),1);
err=zeros(size(GT,1),1);

dU1=ones(size(GT,1),1);
%dU1*35;
%dU1=dU1*30;
% dU1(1:100)=20;
% dU2(1:100)=25;


for i=3+TD:size(GT,1)
   Ymod1(i)= b1*dU1(i-TD-1)+b2*dU1(i-TD-2)-a1*Ymod1(i-1)-a2*Ymod1(i-2);
   err(i)=(Ymod1(i)-GT(i))^2;
end;
wsk_Jakosci=sum(err);
save('Y_aproksym_z_fmincon.mat', 'Ymod1');
end