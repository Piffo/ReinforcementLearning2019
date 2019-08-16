function reward = Rollout(state, W)
    global cart
    timeout = cart.tf;
    mu = cart.mu;
    sigma = cart.sigma;
    
    positionIndex = 1;
    angleIndex = 2;
    velocityIndex = 3;
    angularVelocityIndex = 4;
    
    R = 0;
    t= 0;
    isTerminal = 0; % State is terminal if the pole goes out of the angle bounds
    s_t = state;
    s_t1 = [0,0,0,0];
    
    plotRollout = rand < 0.01;
    
    while isTerminal == 0 && t < timeout
        %%%%%%%%%%%%%% Chose action %%%%%%%%%%%%%
        phi = PhiCalculation(state, mu, sigma);
        a_t = W * phi;
        %%%%%%%%%%%%%% Chose next state %%%%%%%%%%%%%       
        deltaState = cartDynamics(s_t, a_t);
        s_t1(positionIndex,1) = st(positionIndex,1) + cart.dT * deltaState(positionIndex,1) ; % Next position
        s_t1(angleIndex,1) = st(angleIndex,1) + cart.dT * deltaState(angleIndex,1) ; % Next angle
        s_t1(velocityIndex,1) = st(velocityIndex,1) + cart.dT * deltaState(velocityIndex,1) ; % Next velocity
        s_t1(angularVelocityIndex,1) = st(angularVelocityIndex,1) + cart.dT * deltaState(angularVelocityIndex,1) ; % Next angular velocity
        
        if isTerminal(s_t1) == 1 
            isTerminal = 1;
        else
            isTerminal = 0;
        end
        
        if plotRollout
            cartPlot(cart.fig1,[s_t1(positionIndex,1), s_t1(angleIndex,1)])
        end
        
        s_t = s_t1;
        t = t + cart.dT;
        reward = RewardCartPole() + R;
    end
end

