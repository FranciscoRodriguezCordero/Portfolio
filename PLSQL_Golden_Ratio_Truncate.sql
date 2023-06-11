declare
    a number := 2;
    b number := 3;
    temp number;
    golden float;   
    n number := &number;
    decimal_n number := 0;
  
begin  
    for j in 1..n
    loop
        temp:=a+b;
  
        a := b;
        b := temp;
        golden := b/a;
		
		declare
			  phi constant number := 1.6180339887498948482045868343;
			  phi_str varchar(100);
			  golden_str varchar(100);
			  matching_decimals varchar(100);
			  result number;
		begin
		  phi_str := to_char(phi);
		  golden_str := to_char(golden);
		  
		  for i in 1..least(length(phi_str), length(golden_str)) 
          loop
			if substr(phi_str, i, 1) <> substr(golden_str, i, 1) then
			  exit;
                end if;
			
                matching_decimals := matching_decimals || substr(golden_str, i, 1);
		  end loop;
		  
		  result := to_number(matching_decimals);
		  dbms_output.put_line('golden = ' || to_char(result));
		end;		
    end loop;
end;