% G1T3_5=odp_skok_pobudzenie_G1(201:400,2)'
% G1T3_10=odp_skok_pobudzenie_G1(601:800,2)'
% G1T3_minus5=odp_skok_pobudzenie_G1(1001:1200,2)'
% G1T3_minus10=odp_skok_pobudzenie_G1(1401:1600,2)'
% 
% G2T1_5=odp_skok_pobudzenie_G2(201:400,1)'
% G2T1_10=odp_skok_pobudzenie_G2(601:800,1)'
% G2T1_minus5=odp_skok_pobudzenie_G2(1001:1200,1)'
% G2T1_minus10=odp_skok_pobudzenie_G2(1401:1600,1)'
% 
% G2T3_5=odp_skok_pobudzenie_G2(201:400,2)'
% G2T3_10=odp_skok_pobudzenie_G2(601:800,2)'
% G2T3_minus5=odp_skok_pobudzenie_G2(1001:1200,2)'
% G2T3_minus10=odp_skok_pobudzenie_G2(1401:1600,2)'

%%%ZAPIS DO PLIKU%%%%%%%
for k=1:200       
       j=j+1;
       table_Ystat(1,k)=double(j);
%        table_Ustat(1,k)=double(j);
end
%macierze wykorzystane do zapisu
table_Ystat(2,:)=GT_aproksym(1:1:200,4);
table_Ystat(1,:)=linspace(1,200,200);
% table_Ustat(2,:)=linspace(1,100,100);

fname_Ystat = sprintf('G2T3.txt');
% fname_Ustat = sprintf('UstatG22.txt');
mkdir_status=mkdir(sprintf('C:\\Users\\Kuba\\Desktop\\PUST lab 3.5\\odp_skok_aprox\\'));
if mkdir_status
   savdir = sprintf('C:\\Users\\Kuba\\Desktop\\PUST lab 3.5\\odp_skok_aprox\\');

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