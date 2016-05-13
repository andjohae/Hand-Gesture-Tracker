% This function predicts the position (x,y) and velocity (xDot,yDot)
% by using an adaptive Kalman filter explained in the article 
% "Hand gesture tracking using Adaptive Kalman filter". 
%
% statePrediction is a 4x1 vector [x_hat,y_hat,xDot_hat,yDot_hat].
% currentEstimate is a 4x1 vector with current estimated values of 
% [x_hat,y_hat,xDot_hat,yDot_hat].
%
% covariancePrediction is a prediction of P (Covariance estimates).
% currentCovariance is the current value of P.
function [statePrediction, estimatePrediction, covariancePrediction] = ...
  PredictState(currentState, currentEstimate, currentCovariance)

  % Temporary acceleration threshold
  T_a = 1;

  P = currentCovariance;
  % State transition matrix
  dt = 1; % $\Delta t$ in the article.
  A = [1 0 dt 0; 
       0 1 0 dt; 
       0 0 1 0;  
       0 0 0 1];
     
  % Observation matrix
  H = [1 0 0 0;
       0 1 0 0];
     
  % TODO: IS ACTUALLY BROWNIAN MOTION!
  statePrediction = A*currentState + 0.01*randi([-1,1]);
  
  measurementNoise = 0; % Is really the difference between true and estimate.
  z = H*statePrediction + measurementNoise;
  xHatMinus = A*currentEstimate;
  
  % Determining the acceleration and w* coefficients.
  ax = (statePrediction(3) - currentState(3))/dt;
  ay = (statePrediction(4) - currentState(4))/dt;
  wR = 7.5/T_a;
  wQ = 0.25/T_a;
  if T_a < ax || T_a < ay
    wR = 7.5/T-a^2;
    wQ = 0.57/T_a;
  end
  
  % Process noise covariance
  Q = wQ.*eye(4);
  
  % Priori Covariance estimates
  PMinus = A*P + Q; 
  
  % Measuremant noise covariance
  f = 0.1845; % Constant from article.. TODO: Check this further.
  R = wR.*[f f/40;f/40 f/4];
  
  % Kalman gain
  K = PMinus*H'*inv(H*PMinus*H' + R);
  
  % Updating state prediction   
  estimatePrediction = xHatMinus + K*(z-H*xHatMinus);
  
  % Updating covariance estimates.
  covariancePrediction = (eye(4) - K*H)*PMinus;

end