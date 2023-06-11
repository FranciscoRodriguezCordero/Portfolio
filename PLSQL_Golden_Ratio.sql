with cte1 (mes_cte1,cantidad_cte1,salario_cte1,sexo_cte1) --cantidad de empleados totales que nacieron en un mes 
as
(
select
to_char (dianacimiento, 'Month') as mes
,count(idemp) as cantidad
,salario
,sexo
from empleados
group by dianacimiento, salario, sexo
), cte2 (mes_cte2,catidad_cte2,salario_cte2,hombres_cte2,mujeres_cte2)
as
(select 
to_date(mes_cte1,'month')
,sum(cantidad_cte1)
,sum(salario_cte1)
,count(case when sexo_cte1 = 'M' then 1 end)
,count(case when sexo_cte1 = 'F' then 1 end)
from cte1
group by mes_cte1
), cte3 (idjefe_cte3)
as
(
select distinct idjefe
from empleados
where idjefe >0
),cte4 (cantidad_jefes_cte4,salario_jefe_cte4,mes_cte4)
as 
(
select 
count(cte3.idjefe_cte3) 
,empleados.salario 
,to_char (empleados.dianacimiento, 'Month')
from cte3
inner join empleados
on cte3.idjefe_cte3 = empleados.idemp 
group by empleados.dianacimiento,empleados.salario
),cte5 (mes_cte5,cantidad_jefes_cte5,salario_jefe_cte5)  --cantidad de jefes que nacieron en un mes
as
(
select 
to_date(mes_cte4,'month')
,sum(cantidad_jefes_cte4)
,sum(salario_jefe_cte4)
from cte4
group by mes_cte4)

select 
to_char(cte2.mes_cte2,'Month') as mes_nacimiento
,case
when cantidad_jefes_cte5 > 0
then cte2.catidad_cte2 - cantidad_jefes_cte5
else cte2.catidad_cte2 
end
as cantidad_empleados
,sum(
case when salario_jefe_cte5 > 0
then cte2.salario_cte2 - cte5.salario_jefe_cte5
else cte2.salario_cte2
end) as salario_empleado
,cte5.cantidad_jefes_cte5 as cantiodad_jefes 
,cte5.salario_jefe_cte5 as salario_jefe
,round (sum ((cte2.hombres_cte2)/ cte2.catidad_cte2)* 100, 2)  as porcentaje_hombres
,round (sum ((cte2.mujeres_cte2)/ cte2.catidad_cte2)* 100, 2)  as porcentaje_mujeres
from cte2
left join cte5
on cte2.mes_cte2 = cte5.mes_cte5
group by 
cte2.mes_cte2
,cte2.catidad_cte2 
,cte5.cantidad_jefes_cte5 
,cte5.salario_jefe_cte5
order by
cte2.mes_cte2
,cte2.catidad_cte2 
,cte5.cantidad_jefes_cte5 
,cte5.salario_jefe_cte5;