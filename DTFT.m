%===============ready====================
Excel1=[1906;2033;2174;1979;2106;2247;2061;2188;2329;2277;2150;2418];
% Since the sum of the frequencies of the numbers is unique, the sum of the frequencies is used to calculate.
NUMBER={'1';'2';'3';'4';'5';'6';'7';'8';'9';'0';'*';'#'};
% Create Mapping
NU = containers.Map(Excel1,NUMBER);
Excel3=[0; 697; 0 ;770; 0; 852 ;0 ;941 ;0 ;1209 ;0 ;1336 ;0 ;1477 ;0];
phonenumber=blanks(14);
dataC1=zeros(500,1);
dataB=zeros(100,1);
dataC2=dataC1;

%======================Sound Extraction=================================
% Read the sound file, the file should be in the same folder as the program.
[data,fs]=audioread('phonenumber.m4a');
% Extract one channel, if not, skip this step.
data(:,1)=[];
L1=length(data);
Excel2=[0;662; 732 ;735; 805 ;817 ;897 ;906 ;976 ;1159 ;1259 ;1286 ;1386; 1427; 1527; L1];
data1=data;
E=mean(data.^2);
% The average amplitude of the samples is obtained.
E_average=E.^0.5;
L3=length(dataC1);
i=0;
p=1;
L4=100;
m=0;
%=========================signal=========================
while((i+1)*L4<L1)
    m=max(data1(1+i*L4:(1+i)*L4));
    dataB(1+i*L4:(1+i)*L4)=data1(1+i*L4:(1+i)*L4)*0+m;
    i=i+1;
end
m=max(data1(1+i*L4:L1));
dataB(1+i*L4:L1)=data1(1+i*L4:L1)*0+m;
%==================================================================

%=====================First extraction of noise================================
i=0;
j=0;
data_no1=zeros(100,1);
while((i+1)*L3<L1)
    dataC1(1:L3)=dataB(1+i*L3:(1+i)*L3);
    dataC2(1:L3)=data(1+i*L3:(1+i)*L3);
    if(max(dataC1)<E_average)
        data_no1(1+j*L3:(1+j)*L3)=dataC2(1:L3);
        j=j+1;
    end
    i=i+1;
end
E_no=mean(data_no1.^2);
E_no_average=E_no.^0.5;% The average amplitude of the bottom noise part is obtained.
dataC2=dataC2*0;
%==================Withdrawal of phone numbers===========================
i=0;
while((i+1)*L3<L1)
    j=0;
    dataC1=dataB((1+i*L3):((i+1)*L3));
    while(mean(dataC1)>2*E_no_average)% Determine if the segment signal is the background noise.
        dataC2(1+j*L3:L3*(j+1))=data((1+i*L3):((i+1)*L3));
        j=j+1;
        i=i+1;
        dataC1=dataB((1+i*L3):((i+1)*L3));% Extracting a sound
    end
    if(max(dataC2)>E_average)% Ignore burr signals.
        D1=fft(dataC2,fs);
        D2=abs(D1(1:fs/2));
        [~,f1]=max(D2);% The frequency corresponding to the peak is obtained.
        excel1=Excel2-f1;
        k=1;
        while(k<16)
            excel1(k)=excel1(k)*excel1(k+1);
            k=k+1;
        end
        [~,n1]=min(excel1);% Find where the peak frequency falls in the band.
        f1=Excel3(n1);% find the closest one
        if(f1>1000&&f1<1600)
            D2(976:1527)=0;
        end
        if(f1<1000&&f1>666)% Blocking a largeband
            D2(666:1159)=0;
        end
        [~,f2]=max(D2);% Detecting the second peak.
        excel1=Excel2-f2;
        k=1;
        while(k<16)
            excel1(k)=excel1(k)*excel1(k+1);
            k=k+1;
        end
        [~,n2]=min(excel1);
        f2=Excel3(n2);
        if(f1~=0&&f2~=0)% ignore the frequences which not in the range
            N1=NU(f1+f2);% find the corresponding number
        end
        phonenumber(p)=N1;% Put the number in the number field.
        p=p+1;
    end 
     dataC2=dataC1*0;
     i=i+1;
end
phonenumber
sound(data,fs);
%figure(4)
%plot(1:L1,dataB,1:L1,dataB*0+2*E_no_average)

