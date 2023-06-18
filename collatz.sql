drop table collatz_sequence;
create table collatz_sequence
(id number generated always as identity, sequence number(38)
,grade float, oposite_grade number);
declare 
x number := &number; 
counter number := 0;
j number;
i number := 0;
weight float;

begin 

dbms_output.put_line('Secuencia: ' ||'  '||x);
insert into collatz_sequence (sequence,grade) values (x,counter);

while x <> 1 
loop 
    if  mod(x,2) = 0 then x:= x/2;
        counter := counter +1;
        insert into collatz_sequence (sequence,grade) values (x,counter);
    
        
        
        else x:= (3*x) + 1;
        counter := counter +1;
        insert into collatz_sequence (sequence,grade) values (x,counter);
        
        
    end if;
dbms_output.put_line('Secuencia: ' ||'  '||x);
end loop;
dbms_output.put_line('Grado: '||counter);

for i in 1..counter
loop
update collatz_sequence set oposite_grade = counter where i = id;
counter := counter -1 ;
end loop;

select sum(sequence * oposite_grade)/10 into weight
from collatz_sequence;
dbms_output.put_line('Peso: '||weight);

end;
