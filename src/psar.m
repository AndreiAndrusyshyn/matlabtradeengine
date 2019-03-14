function psar=psar(op,hi,lo,cl,chart,acc,step,maxv)
    %Parabolic SAR Indicator by Cansin Memis
    
    % chart == true for candlestick chart;
    % acc : acceleration parameter;
    % step : acceleration increase parameter;
    % max : max value of acceleration parameter;
    
    if(nargin==4)
        %default parameter values
        acc=0.02;
        step=0.02;
        maxv=0.2;
        cacc=0.02;
        chart=false;
    elseif(nargin==5)
        acc=0.02;
        step=0.02;
        maxv=0.2;
        cacc=0.02;
    elseif(nargin==8)
        acc=acc;
        step=step;
        maxv=maxv;
        cacc=0.02;
    else
        error('Wrong Number of Parameters...')
    end

    if(op(1)<=cl(1))
        trend(1)=1;
        ep(1)=hi(1);
    else
        trend(1)=2;
        ep(1)=lo(1);
    end

    cacc=acc;
    psar(1)=lo(1);
    dif(1)=(psar(1)-ep(1))*acc;

    for i=2:length(hi)
        if(trend(i-1)==1)
            initpsar(i)=min([psar(i-1)-dif(i-1),hi(i)]);
            if(lo(i)>initpsar(i))
                psar(i)=initpsar(i);
            elseif(lo(i)<=initpsar(i))
                psar(i)=ep(i-1);
            end
        elseif(trend(i-1)==2)
            initpsar(i)=max([psar(i-1)-dif(i-1),lo(i)]);
            if(hi(i)<initpsar(i))
                psar(i)=initpsar(i);
            elseif(hi(i)>=initpsar(i))
                psar(i)=ep(i-1);
            end
        end

        if(psar(i)<=cl(i))
            trend(i)=1;
            ep(i)=max(ep(i-1),hi(i));
        else
            trend(i)=2;
            ep(i)=min(ep(i-1),lo(i));
        end

        if(trend(i-1)==trend(i) && ep(i-1)~=ep(i) && acc<maxv)
            acc=acc+step;
        elseif(trend(i-1)==trend(i) && ep(i-1)==ep(i))
            acc=acc;
        elseif(trend(i-1)~=trend(i))
            acc=cacc;
        else
            acc=maxv;
        end

        dif(i)=(psar(i)-ep(i))*acc;    
    end

    if(chart==true)
        candle(hi,lo,cl,op);
        up=find(trend==1);
        down=find(trend==2);
        hold on
        uph=plot(up,psar(up),'o');
        set(uph,'Color','g');
        set(uph,'MarkerSize',2);
        downh=plot(down,psar(down),'o');
        set(downh,'Color','r');
        set(downh,'MarkerSize',2);
        title('Parabolic SAR');
        ylabel('Price');
        xlabel('Bars');
    end

end