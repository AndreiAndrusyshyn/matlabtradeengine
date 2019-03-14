[Date_value , Open_Value, High_value, Low_value, Close_value, Adj_close_value, Volume_value, Time,Open,High,Low,Close,tb_plt ] = data_to_table('output.csv');
black_sq = 0;
empty_sq = table(0);
all_dot = table(0);
log_val = table(0);
i = 1;
h= 1;
l = 1;
hi = 0;
lo = 0;
index_h = 0;
index_l = 0;
count = size(Date_value, 1);

threshold = 1;
current_val = Close_value(1);
tr = 2;
for k = 1:count
    if k == count
        break;
    else
        
        lev = Close_value(k+1) - current_val ;
        if abs(lev) >= threshold
            
            if lev > 0
                
                black_sq = current_val:threshold:Close_value(k+1);
                
                for u = 1:size(black_sq,2)
                    
                    all_dot.Var1(i) = black_sq(u);
                    log_val.Var1(i) = 1;
                    hi(h) = black_sq(u);
                    lo(h) = 0;
                    
                    index_h(i) = i;
                    index_l(i) = 0;
                    h = h +1 ;
                    i = i + 1;
                    
                end
            end
            
            if lev < 0
                
                empty_sq.Var1 =  fliplr(Close_value(k+1):threshold:current_val);
                
                
                for u = 1:size(empty_sq.Var1,2)
                    
                    all_dot.Var1(i) = empty_sq.Var1(u);
                    log_val.Var1(i) = 0;
                    lo(h) = empty_sq.Var1(u);
                    hi(h) = 0;
                    
                    index_l(i) = i;
                    index_h(i) = 0;
                    h = h+ 1;
                    i = i + 1;
                    
                end
                
            end
            
            current_val = Close_value(k+1);
            if all_dot.Var1(i-1) == current_val
                i = i-1;
                h = h-1;
            end
        end
        
    end
end

index = table(0);
for w = 1:size(all_dot,1)
    index.Var1(w) = w;
end

hi = hi';
lo = lo';

for fg = 1:size(hi,1)
    
   if hi(fg) == 0
            hi(fg) = NaN;
   end
end
for fg = 1:size(lo,1)
    
    if lo(fg) == 0
       lo(fg) = NaN;
   end
end
[pBear,pBull,psar] = par_sar(all_dot.Var1,all_dot.Var1,all_dot.Var1);

plot(index.Var1, hi, 's' , 'MarkerFacecolor' , 'r')
hold on
plot(index.Var1, lo, 's' , 'MarkerFacecolor' , 'g')
hold on
plot(index.Var1, pBear)
hold on
plot(index.Var1, pBull)


