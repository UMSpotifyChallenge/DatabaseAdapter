% A = csvread('playlist_num_followers.txt');
% t = A(:, 1);
% loglog(t, ".");
% print('Zipf plot','-dpng');

 A = csvread('track_num_appearances.txt');
 t = A(:, 1);
 loglog(t, ".");
 print('track_num_appearances','-dpng');

pdf = histcounts(t);
loglog(pdf, ".");
print('Power Law PDF','-dpng');
 
pareto = cumsum(pdf,'reverse');
loglog(pareto, ".");
print('Pareto','-dpng');


% c = polyfit([start:finish], data, 1);
%     x = linspace(start, finish, 2);
%     y = c(1)*x + c(2);
%     line(x,y,'Color','red','LineWidth',2.0);
%     
% 
% 
% plot(log10(1:4847571),log10(s))
% polyfit(log10(1:4847571)',log10(s),1)
% pfz = polyfit(log10(1:4847571)',log10(s),1)
% x = linspace(0, 7, 2)
% y = pfz(1)*x + pfz(2)
% line(x,y,'Color','red')
% loglog(s)
% plot(log10(1:4847571),log10(s))
% x = linspace(1, 7, 2)
% y = pfz(1)*x + pfz(2)
% line(x,y,'Color','red')
% plot(log10(1:4847571),log10(s))
% pfz = polyfit(log10(1:4847571),log10(s),1)
% size(s)
% size(log10(1:4847571))
% plot(log10(1:4847571)',log10(s))
% pfz = polyfit(1:6,log10(s),1)
% pfz = polyfit((1:6)',log10(s),1)
% figure(3)
% pfp = polyfit(log10(1:22888),log10(pareto),1)
% x = linspace(1, 4, 2)
% y = pfp(1)*x + pfp(2)
% line(x,y,'Color','red')
% pfp = plot(log10(1:22888),log10(pareto))
% pfp = polyfit(log10(1:22888),log10(pareto),1)
% line(x,y,'Color','red')
% figure(2)
