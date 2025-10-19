use hw2_dql;


-- 1) Напишіть SQL запит, який буде відображати таблицю order_details та поле customer_id з таблиці orders відповідно для кожного поля запису з таблиці order_details.

select od.*, 
	(
	 select o.customer_id
	 from orders as o
     where o.id = od.order_id
	) as customer_id
 from order_details as od;
 

--  2) Напишіть SQL запит, який буде відображати таблицю order_details. Відфільтруйте результати так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3
select * 
from order_details as od
where od.order_id in ( 
	select id 
    from orders as o 
    where o.shipper_id = 3
 );


-- 3) Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки з умовою quantity>10 з таблиці order_details.
select 
	temp_table.order_id, 
    round(avg(temp_table.quantity), 1) as avg_quantity
from (
	select order_id, quantity
    from order_details 
    where quantity > 10
    ) as temp_table
group by temp_table.order_id;


-- 4) Розв’яжіть завдання 3, використовуючи оператор WITH для створення тимчасової таблиці temp. 
with temp_table as (
	select order_id, quantity 
    from order_details 
    where quantity > 10
    )
select temp_table.order_id, avg(temp_table.quantity) as avg_quantity
from temp_table
group by temp_table.order_id;

-- 5)  Створіть функцію з двома параметрами, яка буде ділити перший параметр на другий. Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
DROP FUNCTION IF EXISTS myfunc;
DELIMITER  //
create function myfunc(num1 float, num2 float)
returns float
deterministic
no sql
begin
	declare res float;
	set res = num1 / num2;
    return res;    
end //
DELIMITER ;

select id, myfunc(quantity, 5) as calculated from order_details;
