clc
format
%%%%%%%%DATA HANDLER%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Date_value , Open_Value, High_value, Low_value, Close_value, Adj_close_value, Volume_value, Time,Open,High,Low,Close,tb_plt ] = data_to_table('output.csv');
%%%%%%%%%%%%%BACKTEST%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%hardcoded range%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%strt = 1;
%en = 10;
%hold off;
%figure;
%candle(tb_plt(strt:en,:))
%figure;
%tb_plt.Properties.VariableNames{'Close'} = 'Price';
%renko(tb_plt(strt:en,:), 0.3);

atr = indicators([High_value,Low_value,Close_value], 'atr');
threshold = 0.001;

count = size(tb_plt, 1);
table_sign = table(0);
dat_sign_buy = table();
dat_sign_sell = table();
Close_v_buy = table();
Close_v_sell = table();
i_s = 1;
i_b = 1;

for k = 1:count
    if k == count
        break
    else
    pip_t = abs(tb_plt.Close(k+1) - tb_plt.Close(k));
    pip = tb_plt.Close(k+1) - tb_plt.Close(k);
 
    if pip_t > threshold
        if pip > 0
            
            table_sign.Var1(k+1) = 1;
            dat_sign_buy.Var1(i_b) = Date_value(k);  
            Close_v_buy.Var1(i_b) = Close_value(k);
            i_b = i_b + 1;
            
        else
            if pip < 0
            table_sign.Var1(k+1) = -1;
            dat_sign_sell.Var1(i_s) = Date_value(k);
            Close_v_sell.Var1(i_s) = Close_value(k);
            i_s = i_s + 1 ;
            else 
            table_sign.Var1(k+1) = 0;
            end
        end
    end
    end
end

 %%%%%BACK TEST%%%%%%%%%%%%%
initial_capital = 10000;
shares = 10;
signals_back = table_sign.Var1*shares;
positions_back = table(Date_value,signals_back);


adj_positions = positions_back.signals_back.*Adj_close_value;
portfolio = table (Date_value, adj_positions);
portfolio_c = table (Date_value, adj_positions);

difference_shares_fn = diff(positions_back.signals_back);
difference_shares_fn= table(difference_shares_fn);
difference_shares = 0;
difference_shares = table(difference_shares);

for i = 1:size(Date_value,1)
    if i == size(Date_value,1)
        break
    end
   difference_shares.difference_shares(i+1) = difference_shares_fn.difference_shares_fn(i);
    
end

holdings = positions_back.signals_back.*Adj_close_value;

cash = initial_capital - cumsum(difference_shares.difference_shares.*Adj_close_value);
total = cash+holdings;



for j = 2:size(Date_value,1)
    
    return_prcnt(j) = (total(j)-total(j-1))./total(j-1);
    
end

return_prcnt =reshape(return_prcnt,size(Date_value,1),1);

portfolio_sum = table(Date_value,adj_positions,holdings,cash,total,return_prcnt);

%%%%%%%%BUY SIGNALS%%%%%%%%%%%%%
i = 1;

for tr = 1:size(Date_value,1)
    
    if table_sign.Var1(tr) == 1
        date_buy(i) = Date_value(tr);
        total_value_date_buy(i) = portfolio_sum.total(tr);
        i = i+1;
    end
    
end
%%%%%%%%SELL SIGNALS%%%%%%%%%%%%%
i = 1;
for tr = 1:size(Date_value,1)
    
    if table_sign.Var1(tr) == -1
        date_sell(i) = Date_value(tr);
        total_value_date_sell(i) = portfolio_sum.total(tr);
        i = i+1;
    end
    
end

%subplot(2,2,[3,4])
%plot(Date_value,total)

%hold on
%dat_sign_buy = table2array(dat_sign_buy);
%dat_sign_buy = reshape(dat_sign_buy, 1,size(dat_sign_buy,1));
%dat_sign_sell = table2array(dat_sign_sell);
%dat_sign_sell = reshape(dat_sign_sell, 1,size(dat_sign_sell,1));
%rang_s = 1;
%range_en = 500;
%plot(dat_sign_buy(rang_s:range_en),total_value_date_buy(rang_s:range_en), '^', 'MarkerSize',10,'MarkerFaceColor','r')

%plot(dat_sign_sell(rang_s:range_en),total_value_date_sell(rang_s:range_en), 'v', 'MarkerSize',10,'MarkerFaceColor','b')

[bear,bull] = par_sar(High_value,Low_value);

%plot(dat_sign_buy, Close_v_buy.Var1)
%hold on;
%plot(dat_sign_sell, Close_v_sell.Var1)

%hold off

%plot(Date_value,dat_sign_buy, '*', 'MarkerSize',10)
tb_plt.Properties.VariableNames{'Close'} = 'Price';
d  = table(renko(tb_plt))

%hold off
%plot(tb_plt.Time,bear.Var1)
%plot(tb_plt.Time,bull.Var1)
%if all_dot.Var1(i-1) == current_val
     %   i = i-1;
     %end







