function y = quasi(data_stack)
mydaq.Rate = 1000; % [Hz] 
dt=1/mydaq.Rate;
a =1;
b =27.32;
c =178.4;
K =36.84;
A = (a/(dt^2)) + (b/dt) +c;
B = -(2*(a/dt^2) +(b/dt));
C = a/dt^2;
y = zeros(length(data_stack),1);
y(1,1) = 0;
y(2,1) = 0;

x=20 * abs(data_stack); % Rectify & Amplify
 
for i = 3:1:length(data_stack) % LPF(Quai-tension filter)
    y(i,1) = (K*x(i,1) -(B*y(i-1,1) + C*y(i-2,1))) / A;
end
end