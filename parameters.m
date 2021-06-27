
%learning parameters NN
global learnRate discount minibatchSize bufferSize Q_nn_size updateTargetSteps
learnRate = 0.1;
discount = 0.95;
minibatchSize = 32;
bufferSize = 200000;
Q_nn_size = [100 50 50];
updateTargetSteps = 150;

%greedy policy
global epsilon epsilonDecay min_epsilon
epsilon = 1;
epsilonDecay = 0.9;
min_epsilon = 0.1;

%simulation
global dt_RK substeps STOP_LEARNING
dt_RK = 0.03;
substeps = 1;
STOP_LEARNING = 0;

%% Experiment parameters
global dt_exp
dt_exp = 0.01;

%% HKB parameters
global a b g w
%each row is a player (this is in case of group)
a = [1; 1; 1; 1];
b = [2; 2; 2; 2];
g = [-1; -1; -1; -1];
% first column is the leader, second is the follower, third is joint improviser
%different VTs
w = [0.8 0.1 1;
     0.8 0.1 0.8;
     0.8 0.1 0.5;
     0.8 0.1 0.75];

global xa xb
xa = -0.5;
xb = 0.5;

%% MC parameters
global num_samples overlapping T dt_MC
num_samples = 60;
overlapping = 45;
% 15 seconds during the training, 60 seconds in the validation
T = 60; % lenght of the frame to generate with the MC (in seconds)
dt_MC = 0.03;

global  quantizer dequantizer num_symbols  naturalFrequencyPlayer
num_symbols = 256;
naturalFrequencyPlayer = 5;

% load codebook tools
load(['MarkovChains/codebook' num2str(num_symbols) '.mat'])
clear Entropy Err
quantizer = dsp.VectorQuantizerEncoder(...
    'Codebook', finalCB, ...
    'CodewordOutputPort', true, ...
    'QuantizationErrorOutputPort', true, ...
    'OutputIndexDataType', 'uint16');
dequantizer = dsp.VectorQuantizerDecoder('Codebook', finalCB);
