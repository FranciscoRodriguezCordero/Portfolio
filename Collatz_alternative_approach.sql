drop table siracusa;
create table siracusa -- Ejercicio a - crear la tabla
(n number(38) primary key, s varchar2(1000),
grado number(5), peso float(38) );


declare  -- Ejercicio a - llenar la tabla con numeros del 2 al 255

begin
for i in 2..255 
loop

insert into siracusa (n) values(i);

end loop;
end;

/


declare  -- Ejercicio b - llenar la tabla con la secuencia para cada n 
cursor cursor_siracusa is
select n,s,peso from siracusa;
numero  number;
secuencia  varchar2(1000);
x number;
contador number;

begin
for numero_record in cursor_siracusa
loop 
numero:= numero_record.n;
secuencia :=  concat(to_char(numero),',') ;
x:=numero;

while x <> 1 
loop
    
     if  mod(x,2) = 0 then x:= x/2;
     
     else x:= (3*x) + 1;
     
    end if;
    secuencia :=  concat(secuencia,concat(to_char(x),','));
    
end loop;

update siracusa
set s = secuencia 
where n = numero;
end loop;
end;
/


select * from siracusa order by n; -- comprobando datos en la tabal siracusa


declare  -- Ejercicio c - llenando la tabla siracusa con el peso y el grado para cada n 

cursor cursor_peso is
select n,s,peso from siracusa order by n;
gradot int(38);
gradot2 int(38);
pesot float(38) :=0;
vsequencia varchar(10);
sequencia number(38);
begin

for secuencia_record in cursor_peso
    loop
    vsequencia := '';
    gradot:= 0;
    gradot2:= 0;
    pesot:=0;
    
            for i in 1..length(secuencia_record.s) - 1
            loop
            if substr(secuencia_record.s,i,1) = ',' then 
                        gradot2 := gradot2 + 1;
                        end if;
            end loop;
            
            gradot:= gradot2;
 
            for i in 1..length(secuencia_record.s) - 1            
            loop    
                if substr(secuencia_record.s,i,1) <> ',' then 
                vsequencia := vsequencia || substr(secuencia_record.s,i,1);
     
                else      
                sequencia := to_number(vsequencia);
                vsequencia := '';                                          
                pesot:= pesot + (sequencia * gradot);              
                gradot:= gradot - 1;
            end if;                                   
            end loop;
            pesot:= (pesot)/10;  
        update siracusa
        set peso = pesot, grado = gradot2
        where siracusa.n = secuencia_record.n;
    end loop;
    end;
/

declare
    numero_consultado number(3) := &numero;
    numero_record number(3);
    secuencia_record varchar2(1000);
    grado_record number(5);
    peso_record float(38);
begin
    if numero_consultado > 1 and numero_consultado < 256
    then
        select n, s, grado, peso into numero_record, secuencia_record, grado_record, peso_record
        from siracusa where n = numero_consultado;
        dbms_output.put_line(rpad('N = ' || numero_record, 20) || rpad('Grado = ' || grado_record, 20) || rpad('Peso = ' || peso_record, 20));
        dbms_output.put_line('S = ' || secuencia_record);
    else
        dbms_output.put_line('Numero invalido');
    end if;
end;
/

select * from siracusa order by n;


