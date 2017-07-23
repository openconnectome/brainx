% dependency: export_fig from mathworks exchange

%% spurious clusters
clc, clear
print_fig=1;
n=2000;


for jj=1:5
    x=2*rand(n,1);
    x=sort(x);
    [foo,bar]=hist(x,20);
    foo=foo/sum(foo)*100;
    
    
    
    %%
    [f,xi]=ksdensity(x);
    f=f/max(f);
    
    
    %%
    X=x(x>0.5);
    X=X(X<1.5);
    
    k = 1:10;
    nK = numel(k);
    % Sigma = {'diagonal','full'};
    % nSigma = numel(Sigma);
    % SharedCovariance = {true,false};
    % SCtext = {'true','false'};
    % nSC = numel(SharedCovariance);
    % RegularizationValue = 0.01;
    options = statset('MaxIter',10000);
    
    % Preallocation
    gm = cell(nK,1);
    % aic = zeros(nK,1);
    bic = zeros(nK,1);
    converged = false(nK,1);
    
    %
    % Mu = [0.75; 1.25];
    % Sigma(:,:,1) = [1];
    % Sigma(:,:,2) = [1];
    % PComponents = [1/2,1/2];
    % S = struct('mu',Mu,'Sigma',Sigma,'ComponentProportion',PComponents);
    
    
    % Fit all models
    for m = 1:nK
        gm{m} = fitgmdist(X,k(m),...
            'CovarianceType','full',...
            'SharedCovariance',false,...
            'Options',options);
        bic(m) = gm{m}.BIC;
        converged(m) = gm{m}.Converged;
    end
    
    
    % allConverge = (sum(converged(:)) == nK*nSigma*nSC);
    
    %%
    [~,minbic]=min(bic)
    gmBest=gm{minbic};
    
    t=linspace(-2,2,1000);
    for j=1:minbic
        y{j}=normpdf(t,gmBest.mu(j),sqrt(gmBest.Sigma(j))); %*gmBest.ComponentProportion(j);
        maxy(j)=max(y{j});
    end
    
    
    %%
    
    figure(1), clf, hold all
    gr=0.75*[1 1 1];
    stem(x,1*ones(n,1),'w','marker','none','linewidth',0.1)
    set(gcf,'Color','None')
    set(gca,'color','none')
    xlim([0.5,1.5])
    ylim([0,1.2])
    set(gca,'XTick',[],'YTick',[])
    tit=['$n=', num2str(n/2), ', \hat{k}=$', num2str(minbic)];
    title(tit,'interp','latex','color','k','fontsize',24)
    if print_fig, export_fig spikes.png; end
    
    plot(xi,f,'color',gr,'linewidth',2)
    if print_fig, export_fig spikes_kde.png; end
    
    for j=1:minbic
        fill(t,y{j}/max(maxy),gr,'EdgeColor',gr)
    end
    title(tit,'interp','latex','color','w','fontsize',24)
    if print_fig, export_fig(['spikes_bic', num2str(jj),'.png']); end
    
end


%% overlapping clusters

mu(1)=-1;
mu(2)=1;
Sigma(1)=1;
Sigma(2)=1;
lent=1000;
t=linspace(-5,5,lent);

figure(2), clf, hold all
for j=1:2
    y{j}=normpdf(t,mu(j),sqrt(Sigma(j))); %*gmBest.ComponentProportion(j);
    fill(t,y{j},gr,'EdgeColor',gr)
end
negs=((y{2}-y{1})>0);
cp=min(find(negs>0));
fill(t,[y{2}(1:cp),y{1}(cp+1:end)],'w','EdgeColor','w')
ht=-0.02;
text(mu(1)-0.1,ht,'$\mu_1$','interp','latex','fontsize',18,'color',gr)
text(mu(2)-0.1,ht,'$\mu_2$','interp','latex','fontsize',18,'color',gr)
stem(mu(1),ht+0.06,'k','marker','none')
stem(mu(2),ht+0.06,'k','marker','none')
set(gcf,'Color','None')
set(gca,'color','none')
xlim([-4,4])
ylim([0,0.4])
set(gca,'XTick',[],'YTick',[])
if print_fig, export_fig(['images/overlap.png']); end

%%

ls=10;
n=100;
a=zeros(ls,n);

a(1,:)=1;
a(1,n/2)=0;
imagesc(a)
colormap('gray')
% imwrite(a,'levels.png')
set(gcf,'Color','None')
set(gca,'color','none')
set(gca,'XTick',[],'YTick',[])
if print_fig, export_fig(['images/levels.png']); end

%%
a(2,:)=1;
a(2,[n/4,n/2,3*n/4])=0;
imagesc(a)
set(gcf,'Color','None')
set(gca,'color','none')
set(gca,'XTick',[],'YTick',[])
if print_fig, export_fig(['images/levels1.png']); end
