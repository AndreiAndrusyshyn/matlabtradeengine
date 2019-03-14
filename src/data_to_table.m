function [Date_value,Open_value, High_value, Low_value, Close_value, Adj_close_value, Volume_value,Time, Open,High,Low,Close, tb_plt] = data_to_table(file)
Table_from_csv = readtable(file);

Date_value = Table_from_csv.Var1;
Open_value = Table_from_csv.Var2;
High_value = Table_from_csv.Var3;
Low_value = Table_from_csv.Var4;
Close_value = Table_from_csv.Var5;
Adj_close_value = Table_from_csv.Var5;
Volume_value = Table_from_csv.Var6;

Time = Date_value;
Open = Open_value;
High = High_value;
Low = Low_value;
Close = Close_value;

tb_plt = timetable(Time, Open,High,Low,Close);

end

