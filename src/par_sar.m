function [psarbear,psarbull,psar] = par_sar(High_value,Low_value, Close_value)

psar = Close_value;
bull = true;
iaf  = 0.02;
maxaf = 0.2;
af = iaf;
hp = High_value(1);
lp = Low_value(1);
psarbear = NaN(size(High_value,1),1);
psarbull = NaN(size(High_value,1),1);
for k = 3:size(Low_value,1)
    if bull
        psar(k) = psar(k-1) + af * (hp - psar(k-1));
    else
        psar(k) = psar(k-1) + af * (lp - psar(k-1));
    end
    
    reverse = false;
    
    if bull
        if Low_value(k) < psar(k)
            bull = false;
            reverse = true;
            psar(k) = hp;
            lp = Low_value(k);
            af = iaf;
        end
    else
        if High_value(k) > psar(k)
            bull = true;
            reverse = true;
            psar(k) = lp;
            hp = High_value(k);
            af = iaf;
        end
    end
    
    if reverse ~= true
        if bull
            if High_value(k) > hp
                hp = High_value(k);
                af = min(af+iaf,maxaf);
                if Low_value(k-1) < psar(k)
                    psar(k) = Low_value(k-1);
                end
                if Low_value(k-2) < psar(k)
                    psar(k) = Low_value(k-2);
                end
            end
        else
            if Low_value(k) < lp
                lp = Low_value(k);
                af = min(af + iaf,maxaf);
            end
            if High_value(k-1) > psar(k)
                psar(k) = High_value(k-1);
            end
            if High_value(k-2) > psar(k)
                psar(k) = High_value(k-2);
            end
        end
    end
        if bull
            psarbull(k) = psar(k);
        else
            psarbear(k) = psar(k);
        end
end
            
%plot(Date_value, Close_value)
%hold on 
%plot(Date_value, psarbull.Var1)
%for k = 1:size(psarbear,1)
 %   if psarbear.Var1(k) == 0
  %      psarbear.Var1(k) = NaN;
   % end       
%end

%for k = size(psarbull,1)+1:size(psarbear,1)
 %   psarbull.Var1(k) = NaN;
        
%end

%for k = 1:size(psarbull,1)
 %   if psarbull.Var1(k) == 0
  %  psarbull.Var1(k) = NaN;
   % end
%end

%plot(Date_value, psarbear.Var1)
%plot(Date_value, psarbull.Var1)
end
    
    
    

