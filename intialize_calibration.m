%%

instrreset;
clear all; close all; clc;

%% Initialization

global mydaq sampleRate close_data1 close_data2 open_data1 open_data2 ypr ...
Pitch_value data_Pitch_Middle data_Pitch_Left data_Pitch_Right flt_data_1 flt_data_3 flt_data_2 avg_data_1 avg_data_2 avg_data_3

ypr = [];


mydaq=daq.createSession('ni');
sampleRate=1000;
mydaq.Rate=sampleRate;
mydaq.DurationInSeconds = 10;
mydaq.NotifyWhenDataAvailableExceeds = mydaq.Rate /20;
mydaq.IsContinuous = true;

% ch1, ch2 ����ؼ� bending sensor �� �о����
ch1 = mydaq.addAnalogInputChannel('Dev1', 'ai0', 'Voltage'); %����
ch2 = mydaq.addAnalogInputChannel('Dev1', 'ai1', 'Voltage'); %����

%ch3 ����ؼ� Pitch_value �о����
ch3 = mydaq.addAnalogInputChannel('Dev1', 'ai2', 'Voltage'); 

ch1.Range = [-10.0 10.0];
ch1.TerminalConfig = 'SingleEnded';
ch2.Range = [-10.0 10.0];
ch2.TerminalConfig = 'SingleEnded';
ch3.Range = [-10.0 10.0];
ch3.TerminalConfig = 'SingleEnded';


'Completed'


%% Calibration


f=440; d=1; fs=44100; n=d*fs;
t=(1:n)/fs;

y=sin(2*pi*f*t);

sound(y,fs)
disp('calibration start');
disp('���� ȸ������ ���� �״�� �μ���')

pause(1)

data_Pitch=[];

for i=1:500
    data=inputSingleScan(mydaq);
    data_Pitch=[data_Pitch data(3)];
end

data_Pitch_Middle = mean(data_Pitch)*2*pi/5

sound(y,fs)
disp('calibration start')
disp('�������� �ִ��� ȸ�����ּ���')

pause(1)

data_Pitch=[];

for i=1:500
    data=inputSingleScan(mydaq);
    data_Pitch=[data_Pitch data(3)];
end

data_Pitch_Left = mean(data_Pitch)*2*pi/5

sound(y,fs)
disp('calibration start')
disp('���������� �ִ��� ȸ�����ּ���')

pause(1)
data_Pitch=[];

for i=1:500
    data=inputSingleScan(mydaq);
    data_Pitch=[data_Pitch data(3)];
end

data_Pitch_Right = mean(data_Pitch)*2*pi/5

%sound
f=440; d=1; fs=44100; n=d*fs;
t=(1:n)/fs; y=sin(2*pi*f*t);
sound(y,fs)
disp('calibration start')
disp('�޼��� �켼��')

pause(1)
data_bend1_calib=[];
data_bend2_calib=[];

for i=1:500
    data = inputSingleScan(mydaq);
    data_bend1_calib=[data_bend1_calib data(1)];
    data_bend2_calib=[data_bend2_calib data(2)];
end

open_data1 = mean(data_bend1_calib);
open_data2 = mean(data_bend2_calib);

sound(y,fs)
disp('�޼� �ָ��� �㼼��')

pause(1)
data_bend1_calib=[];
data_bend2_calib=[];

for i=1:500
    data = inputSingleScan(mydaq);
    data_bend1_calib=[data_bend1_calib data(1)];
    data_bend2_calib=[data_bend2_calib data(2)];
end

close_data1 = mean(data_bend1_calib);
close_data2 = mean(data_bend2_calib);

[open_data1 open_data2  close_data1 close_data2]


%% Filter �ʱⰪ ���� (7������)

ini_data = inputSingleScan(mydaq);

flt_data_1 = [];
for i=1:7
    data=inputSingleScan(mydaq);
    flt_data_1=[flt_data_1 ini_data(1)]
end

flt_data_2 = [];
for i=1:7
    data=inputSingleScan(mydaq);
    flt_data_2=[flt_data_2 ini_data(2)]
end


flt_data_3 = [];
for i=1:10
    data=inputSingleScan(mydaq);
    flt_data_3=[flt_data_3 ini_data(3)]
end



%% �ǽð����� ������ �޾ƿ���

lh = addlistener(mydaq,'DataAvailable', @listener_callback);

startBackground(mydaq);

%% �������� ����

breakout_mod