
clear;
%Constants
T1=1
dU1=ones(200,1);
dU2=dU1*35;
dU1=dU1*30;
dU1(1)=20;
dU2(1)=25;

load('odp_skok_pobudzenie_G1.mat')
load('odp_skok_pobudzenie_G2.mat')
GT=zeros(200,4);
GT(:,1)=odp_skok_pobudzenie_G1(600:799,1);
GT(:,2)=odp_skok_pobudzenie_G1(600:799,2);
GT(:,3)=odp_skok_pobudzenie_G2(600:799,1);
GT(:,4)=odp_skok_pobudzenie_G2(600:799,2);
Td=0;
%fun =@(u1,u2) b1*u1(k-Td-1)+b2*u2(k-Td-1) +
% b3*u1(k-Td-2)+b4*u2(k-Td-2)-a1*y(k-1)-a2*y(k-2)
M=[dU1(2+Td:200) dU2(2+Td:200) dU1(1+Td:199) dU2(1+Td:199) GT(2:200,1) GT(1:199,1)];
W=M\GT(2:200,1);


itEnd=(size(W));
itEnd=itEnd(1);
y=zeros(1,200);
for j=3:200
    for i=1:itEnd
        y(j)=W(1)*dU1(j-Td-1);
    end;
end;