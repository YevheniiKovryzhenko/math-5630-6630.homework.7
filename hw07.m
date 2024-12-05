% Author: Yevhenii Kovryzhenko / yzk0058@auburn.edu
% Date: 2024-09-01
% Assignment Name: hw07

classdef hw07
    
    methods (Static)
        function y = p1(func, y0, tspan, n_steps, method)
            % Solves the ODE y' = f(t, y) with initial condition y(t0) = y0 using the specified method (euler, rk4, midpoint).
            % over the interval tspan=[a, b] with n_steps. The function f(t, y) is provided as a function handle. 
            % 
            % :param func: function handle f(t, y) that defines the ODE y' = f(t, y)
            % :param y0: initial condition y(t0) = y0
            % :param tspan: interval [a, b] over which to solve the ODE
            % :param n_steps: number of steps to take to solve the ODE, interval size = (b-a)/n_steps.
            % :param method: string that specifies the method to use. It can be 'euler', 'midpoint', or 'rk4'
            %
            % :return: plots the solution y(t) over the interval tspan
            
            % Extract the time interval
            t0 = tspan(1); 
            tf = tspan(2); 
            
            % Step size
            h = (tf - t0) / n_steps; 
            
            % Time grid
            t = t0:h:tf; 
            
            % Initialize solution array
            y = zeros(1, length(t)); 
            y(1) = y0;  % Initial condition
        
            % Solver implementation based on the chosen method
            if strcmp(method, 'euler')
                % Euler Method
                for i = 1:n_steps
                    k1 = func(t(i), y(i));
                    y(i+1) = y(i) + h * k1;
                end
                
            elseif strcmp(method, 'midpoint')
                % Midpoint Method
                for i = 1:n_steps
                    k1 = func(t(i), y(i));
                    y_mid = y(i) + (h / 2) * k1;
                    k2 = func(t(i) + h / 2, y_mid);
                    y(i+1) = y(i) + h * k2;
                end
                
            elseif strcmp(method, 'rk4')
                % Runge-Kutta 4 Method
                for i = 1:n_steps
                    k1 = func(t(i), y(i));
                    k2 = func(t(i) + h / 2, y(i) + h / 2 * k1);
                    k3 = func(t(i) + h / 2, y(i) + h / 2 * k2);
                    k4 = func(t(i) + h, y(i) + h * k3);
                    y(i+1) = y(i) + h / 6 * (k1 + 2 * k2 + 2 * k3 + k4);
                end
                
            else
                error('Invalid method. Choose "euler", "rk4", or "midpoint".');
            end
        
            % Plot the solution
            plot(t, y, '-o', 'LineWidth', 1.5);
            xlabel('t'); ylabel('y(t)');
            title(['Solution using ', method, ' method']);
            grid on;
        end

        function p2(method)
            % Test the implemented methods on the ODE
            % y' = t(y - t sin(t)) with initial condition y(0) = 1 over the interval [0, 1], [0, 3], and [0, 5] with variable step lengths. 

            % 
            % Plot the solution y(t) over the interval for various step sizes h. And plot the 
            % exact solution y(t) = t sin(t) + cos(t) over the same interval.
            %
            % Run the commands below to test the implemented methods:
            %
            %> hw07.p2('euler');
            %> hw07.p2('midpoint');
            %> hw07.p2('rk4');
            %
            % Observe the solution and error plots for the numerical solutions with different step sizes. Write your observations in the comments. 

            % Your comment here (e.g, how does the error change with step size and the time span, etc.): 
            % Euler: demostrates 1st order convergence; 
            % increase in step size increases the convergence error; 
            % 3rd function solution diverges at the end of the interval from the true solution  
            % 
            % Midpoint: demostrates 2nd order convergence;
            % increase in step size increases the convergence error; 
            % 3rd function solution diverges at the end of the interval from the true solution  
            %
            % rk4: demostrates 4th order convergence;
            % increase in step size increases the convergence error;
            % 3rd function solution no longer diverges from the true
            % solution;
            % the error is much lower than for all previous methods is
            % closely aligned with theoretical O(h^4) error estimate
            %

            f = @(t, y) t * (y - t * sin(t));

            tf_values = [1,3,5];

            figure('Position', [0 0 1200 2000]);
            for tf_index = 1:length(tf_values)

                t0 = 0; tf = tf_values(tf_index); y0 = 1;
                exact_sol = @(t) t .* sin(t) + cos(t);
                error = zeros(1, 8);
                h = [1e-1, 1e-1 * 10/11, 1e-1*4/5, 1e-1*0.72, 1e-1*0.64, 1e-1*1/2, 1e-1*2/5, 1e-1*0.32];
                c = {'g--', 'g-.', 'b--', 'b-.', 'm--', 'm-.', 'k--', 'k-.'};

                subplot(length(tf_values),2, tf_index * 2 - 1);
                title(['Numerical', ' solution using ', method, ' method and Exact Solutions', ' on interval [', num2str(t0), ', ', num2str(tf), ']']);
                for i = 1:length(h)
                    n_steps = (tf - t0) / h(i);
                    y=hw07.p1(f, y0, [t0, tf], n_steps, method);
                    error(i) = max(abs(y - exact_sol(t0:h(i):tf)));
                    hold on;
                    plot(t0:h(i):tf, y, sprintf('%s', c{i}), 'DisplayName', ['h = ', num2str(h(i))]);
                end

                plot(t0:h(end):tf, exact_sol(t0:h(end):tf), 'r-', 'DisplayName', 'Exact Solution');
                hold off; legend("Location", 'best'); grid on; xlabel('t'); ylabel('y(t)')


                subplot(length(tf_values),2, tf_index * 2);
                loglog(h, error, 'b-o', 'DisplayName', 'Max Error vs. Step Size');
                hold on;
                loglog(h, h.^4 * error(1)/h(1)^4, 'r--', 'DisplayName', '4th order convergence');
                loglog(h, h.^3 * error(1)/h(1)^3, 'g--', 'DisplayName', '3rd order convergence');
                loglog(h, h.^2 * error(1)/h(1)^2, 'm--', 'DisplayName', '2nd order convergence');
                loglog(h, h.^1 * error(1)/h(1)^1, 'k--', 'DisplayName', '1st order convergence');
                hold off;
                title(['Error vs. Step Size for y'' = t(y - t sin(t))', ' on [', num2str(t0), ', ', num2str(tf), ']']); xlabel('Step Size (h)'); ylabel('Error'); grid on; legend("Location", 'best');
            end
        end

        function p3()
            % For 6630 ONLY
            % First implement the 3/8 rule for Runge Kutta method. 
            % 
            % The implementation should be done in the function rk4_38_rule below. It is a subfunction which can only be called within p3 method.
            % Then run hw07.p3() and compare the results with the 4th order Runge Kutta method. Write your observations in the comments. 
            %
            % Your comment here (e.g, how does the error change with step size and the time span, is there a clear difference in the running time and error (you may need to run a few times to conclude), etc.): 
            % 
            % It is clear that the 3/8 rule has much larger errors but
            % takes less time to compute. 3/8 rule no longer achieves 4th
            % order convergence.
            %
            %
            %

            function y = rk4_38_rule(func, y0, tspan, n_steps)
                % rk4_38_rule: Runge-Kutta method with 4th order and 3/8 rule for solving ODEs.
                %
                % :param func: function handle f(t, y) that defines the ODE y' = f(t, y)
                % :param y0: initial condition y(t0) = y0
                % :param tspan: interval [a, b] over which to solve the ODE
                % :param n_steps: number of steps to take to solve the ODE, interval size = (b-a)/n_steps
                %
                % :return: y - solution values at each time step

                % Extract interval
                t0 = tspan(1);
                tf = tspan(2);

                % Step size
                h = (tf - t0) / n_steps;

                % Time vector
                t = t0:h:tf;

                % Initialize solution vector
                y = zeros(1, length(t));
                y(1) = y0;

                % RK4 3/8 Rule implementation
                for i = 1:n_steps
                    % Compute stages
                    k1 = func(t(i), y(i));
                    k2 = func(t(i) + h/3, y(i) + h*k1/3);
                    k3 = func(t(i) + 2*h/3, y(i) + 2*h*k2/3);
                    k4 = func(t(i) + h, y(i) + h*k1 - h*k2 + h*k3);

                    % Update solution
                    y(i+1) = y(i) + (h/8) * (k1 + 3*k2 + 3*k3 + k4);
                end
            end


            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Do not modify the code below this line.
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            f = @(t, y) t * (y - t * sin(t));

            tf_values = [3, 5, 7];
            figure('Position', [0 0 1200 2000]);
            for tf_index = 1:length(tf_values)
                t0 = 0; tf = tf_values(tf_index); y0 = 1;
                exact_sol = @(t) t .* sin(t) + cos(t);
                error1 = zeros(1, 8);
                error2 = zeros(1, 8);
                runtime1 = zeros(1, 8);
                runtime2 = zeros(1, 8);
                hs = 2.^(-1:-1:-8) * 1e-1;

                for ind = 1:length(hs)
                    n_steps = (tf - t0) / hs(ind);

                    tic;% run 100 times and take the average time
                    for run = 1:100
                        y1=rk4_38_rule(f, y0, [t0, tf], n_steps);
                    end
                    runtime1(ind) = toc/100;
                    
                    tic;% run 100 times and take the average time
                    for run = 1:100
                        y2=hw07.p1(f, y0, [t0, tf], n_steps, 'rk4');
                    end                    
                    runtime2(ind) = toc/100;
                    
                    error1(ind) = max(abs(y1 - exact_sol(t0:hs(ind):tf)));
                    error2(ind) = max(abs(y2 - exact_sol(t0:hs(ind):tf)));
                end

                subplot(length(tf_values),2, tf_index * 2 - 1);
                loglog(hs, error1, 'b-o', 'DisplayName', 'Max Error (3/8 Rule) vs. Step Size');
                hold on;
                loglog(hs, error2, 'g-d', 'DisplayName', 'Max Error (RK4) vs. Step Size');
                loglog(hs, hs.^4 * error1(1)/hs(1)^4 , 'r--', 'DisplayName', '4th order convergence');
                hold off;
                title(['Error vs. Step Size for y'' = t(y - t sin(t))', ' on [', num2str(t0), ', ', num2str(tf), ']']); xlabel('Step Size (h)'); ylabel('Error'); grid on; legend("Location", 'best');
                subplot(length(tf_values),2, tf_index * 2);
                loglog(hs, runtime1, 'r-o', 'DisplayName', 'Runtime (3/8 Rule) vs. Step Size');
                hold on;
                loglog(hs, runtime2, 'm-d', 'DisplayName', 'Runtime (RK4) vs. Step Size');
                hold off;
                title(['Runtime vs. Step Size for y'' = t(y - t sin(t))', ' on [', num2str(t0), ', ', num2str(tf), ']']); xlabel('Step Size (h)'); ylabel('Runtime (s)'); grid on; legend("Location", 'best');
            end
            
        end
    end
end