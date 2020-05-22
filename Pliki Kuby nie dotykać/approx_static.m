% figure;
% hold on;
% x=linspace(10,50,400);
% coefficientsG11 = polyfit(x, char_stat_G1(101:500,1)', 1);
% coefficientsG12 = polyfit(x, char_stat_G1(101:500,2)', 1);
% coefficientsG21 = polyfit(x, char_stat_G2(101:500,1)', 1);
% coefficientsG22 = polyfit(x, char_stat_G2(101:500,2)', 1);
% 
% plot(x,coefficientsG11(1)*x+coefficientsG11(2))
% plot(x,coefficientsG12(1)*x+coefficientsG12(2))
% plot(x,coefficientsG21(1)*x+coefficientsG21(2))
% plot(x,coefficientsG22(1)*x+coefficientsG22(2))
% plot(x,char_stat_G1(101:500,1));
% plot(x,char_stat_G1(101:500,2));

%%%ZAPIS DO PLIKU%%%%%%%
for k=1:200       
       j=j+1;
       table_Ystat(1,k)=double(j);
%        table_Ustat(1,k)=double(j);
end
%macierze wykorzystane do zapisu
table_Ystat(2,:)=G2T3(1:1:200,1);
table_Ystat(1,:)=linspace(1,200,200);
% table_Ustat(2,:)=linspace(1,100,100);

fname_Ystat = sprintf('harshG2T3.txt');
% fname_Ustat = sprintf('UstatG22.txt');
mkdir_status=mkdir(sprintf('C:\\Users\\Kuba\\Desktop\\PUST lab 3.5\\harsh\\'));
if mkdir_status
   savdir = sprintf('C:\\Users\\Kuba\\Desktop\\PUST lab 3.5\\harsh\\');

   fileID = fopen([savdir fname_Ystat],'w');
   fprintf(fileID,'%6.3f %6.3f\r\n',table_Ystat);
   fclose(fileID);
%    fileID = fopen([savdir fname_Ustat],'w');
%    fprintf(fileID,'%6.3f %6.3f\r\n',table_Ustat);
%    fclose(fileID);
else 
   disp('Nie udalo sie stworzyc folderów')
end
warning('on','all') %wlaczenie warningow
