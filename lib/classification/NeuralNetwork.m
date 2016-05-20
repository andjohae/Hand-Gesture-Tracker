function [y1] = NeuralNetwork(x1)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 20-May-2016 15:36:48.
%
% [y1] = myNeuralNetworkFunction(x1) takes these arguments:
%   x = 10xQ matrix, input #1
% and returns:
%   y = 1xQ matrix, output #1
% where Q is the number of samples.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1_xoffset = [0.00575578238997641;1.80679133158526;0.429841897233202;0.222406364563278;10.088880663759;20.177761327518;30.266641991277;30.266641991277;60.5332839825539;40.355522655036];
x1_step1_gain = [53.4788250009466;0.414256136905087;3.15441268867286;2.75733691712572;0.327332334593081;0.163666167296541;0.109110778197695;0.109110778197694;0.0545553890988471;0.0818330836482706];
x1_step1_ymin = -1;

% Layer 1
b1 = [-1.6397108155364847892;-1.0625291668992935534;-0.789485560065746661;0.83402389442410795883;-0.17662020170712741662;-0.84655801092526272722;0.59589590441355355654;-0.75135091935533304675;-1.5744294069286790538;1.8027946666452285829];
IW1_1 = [0.0766169639390526791 0.73937824472892521577 0.31519357222165039767 -0.39321790174757215164 0.53816005896426544197 -0.34264225787655783195 -0.50067192111532787813 -0.87795904206752972687 -0.62521034661509555796 0.72203939757121327059;0.90289377048034646922 -0.40456100034926473219 0.11988423584870182281 0.68292016000345745486 -0.33666785986068548109 0.30248336981765072684 -0.56467227435597433516 -0.36243212455597706434 0.5414739666428325382 0.53073660814838918842;-0.12181848770120766445 0.9922239120622926567 0.053736775486202308094 -1.5181294582712374641 -0.04945884191524318324 0.77121724542475045272 -0.316685523339420405 0.60063096730575182836 0.5683834172999561174 0.83433499313641112938;0.6870926500740403009 1.1243599801785395531 0.19744381794257537255 0.053937839603998477545 0.71329806210163737568 -0.92977756598713268144 -0.69839262900504517351 0.41949499621298447227 0.56412202985423676171 -0.20939425110830553467;-1.3788309158703664359 1.8988089197653370555 -0.68304423345114062549 -0.10973774278738651633 -0.52618429547459677487 -0.45183227914815132786 0.020532632136033124315 0.3726560454466684158 0.43976765983019250328 0.23981512329949081219;-0.60045779956424072399 -2.0886517470956582621 0.013837864870039847526 0.57602985407081741531 0.69272830106890515012 0.69584859071823201848 -0.74830386176287100319 0.20735977074179784418 -0.83458995973786942457 -0.0050965280174398780097;0.63407704957536115131 -0.5662366526657234278 0.14400390170599433604 0.17226772126550216058 -0.47606807541741663625 0.45787687959827294559 0.92834992403500138369 0.94750734113230039579 1.0063395778459549579 -0.31462894707435751229;0.93479677127042803964 0.46448740839213376042 -0.13314270567036640136 0.19407011923892580896 0.17205335087051909504 -0.68138058360749587106 -0.94953960858438135606 -1.0268522003195097447 0.43295303276900953815 0.3324054594975673349;-0.028331198515685065975 -0.59749986281599776206 0.53485492850064542125 0.029193383864266179289 0.6056394515027160308 0.082674804185709549476 1.5878350404182568489 -0.20269208939162733363 -0.25332967794055138988 0.36966210683632605427;0.71762514553278999863 -0.22186780924915430746 1.2145593841015256409 -0.028362784482015859777 0.36233109377595057454 -0.84611418448776787304 -0.24090069375050382483 -1.0117921690949644997 0.075129010831498768685 0.30049268161783093678];

% Layer 2
b2 = -0.7323897718713768823;
LW2_1 = [0.22325388583833599698 0.46310029534995017508 1.1702536390816362655 -0.431975227125714345 1.5458995981445591283 1.2623801927849966908 0.31155939246052416491 -0.41537000324332307155 -0.87981940566453253894 1.1740683973798999862];

% Output 1
y1_step1_ymin = -1;
y1_step1_gain = 2;
y1_step1_xoffset = 0;

% ===== SIMULATION ========

% Dimensions
Q = size(x1,2); % samples

% Input 1
xp1 = mapminmax_apply(x1,x1_step1_gain,x1_step1_xoffset,x1_step1_ymin);

% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*xp1);

% Layer 2
a2 = repmat(b2,1,Q) + LW2_1*a1;

% Output 1
y1 = mapminmax_reverse(a2,y1_step1_gain,y1_step1_xoffset,y1_step1_ymin);

%%% Convert to binary output %%%
y1 = round(y1);

end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings_gain,settings_xoffset,settings_ymin)
y = bsxfun(@minus,x,settings_xoffset);
y = bsxfun(@times,y,settings_gain);
y = bsxfun(@plus,y,settings_ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings_gain,settings_xoffset,settings_ymin)
x = bsxfun(@minus,y,settings_ymin);
x = bsxfun(@rdivide,x,settings_gain);
x = bsxfun(@plus,x,settings_xoffset);
end
