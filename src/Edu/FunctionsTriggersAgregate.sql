--4 При помощи таблицы и набора процедур (или функций) реализуем
--структуру представления данных «Однонаправленная очередь»

--table, init
CREATE OR REPLACE FUNCTION init() RETURNS VOID AS $$ 
CREATE TABLE queue (
	id serial PRIMARY KEY,
	data varchar(64) NOT NULL );
$$ LANGUAGE sql;

--enqueue
CREATE OR REPLACE FUNCTION enqueue(new_data VARCHAR(64)) RETURNS INTEGER AS $$
BEGIN
	INSERT INTO queue(data) VALUES (new_data);
RETURN 1;
END;
$$ LANGUAGE plpgsql;

select enqueue('Mathematics'); 
select enqueue('Physics'); 
select enqueue('English');
select enqueue('Biology'); 
select enqueue('Social studies');

--dequeue
CREATE OR REPLACE FUNCTION dequeue() RETURNS VARCHAR(64) AS $$ 
DECLARE
	popped VARCHAR(64);
BEGIN
	SELECT data INTO popped FROM queue WHERE id = (SELECT min(id) FROM queue);
	DELETE FROM queue WHERE id = (SELECT min(id) FROM queue);
RETURN popped;
END;
$$ LANGUAGE plpgsql;

select dequeue() select * from queue;

--empty
CREATE OR REPLACE FUNCTION empty() RETURNS INTEGER AS $$
BEGIN
	DELETE FROM queue; 
RETURN 1;
END;
$$ LANGUAGE plpgsql;

select empty();

--top
CREATE OR REPLACE FUNCTION top() RETURNS VARCHAR(64) AS $$ 
	SELECT data FROM queue ORDER BY id LIMIT 1
$$ LANGUAGE sql;
select top();

--tail
CREATE OR REPLACE FUNCTION tail() RETURNS VARCHAR(64) AS $$ 
	(SELECT data FROM queue ORDER BY id DESC LIMIT 1)
$$ LANGUAGE sql;
select tail();

--0
--Триггер, который не позволяет добавлять на стеллаж больше товаров, 
--чем количество мест в нём и не позволяет изменять его максимальную нагрузку 
--на значение меньшее, чем суммарный вес все хранящихся на нём товаров
CREATE FUNCTION shelf_controller() RETURNS trigger AS $$
BEGIN
	IF ((SELECT posiUons_quanUty FROM public."Shelfs" WHERE id = new.id) < 0) 
	THEN
		RAISE EXCEPTION 'NO MORE POSITIONS';
	ELSE
		UPDATE public."Shelfs" set posiUons_quanUty = posiUons_quanUty-1 WHERE id = new.id;
	END IF;
	IF ((SELECT sum(g.googds_weigth) FROM public."Ledges" l JOIN public."PosiUons" p
		ON l.ledge_id = p.ledge_id LEFT JOIN public."Goods" g ON g.posiUon_id=p.posiUon_id
		WHERE l.shelf_id= new.id GROUP BY l.shelf_id) > new.total_load) 
	THEN
		RAISE EXCEPTION 'EXCEEDED THE MAXIMUM WEIGHT';
	END IF;
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER shelf_controller_tg BEFORE INSERT OR UPDATE ON public."Shelfs" FOR EACH ROW
EXECUTE PROCEDURE shelf_controller();

--Функция по указанному имени клиента и дате вычисляет количество товаров, 
--хранящихся на складе и принадлежащих данному клиенту, срок договора которых истекает до данной даты
--1
CREATE OR REPLACE FUNCTION term_controller(client varchar(255), term date) RETURNS integer as $$
DECLARE res integer;
BEGIN
	SELECT count(g.goods_id) INTO res FROM public."Goods" g JOIN public."Contracts" c
		on (g.contract_number = c.contract_id) JOIN public."Clients" cl on (cl.id = c.client_id)
		WHERE (client = cl.corporate_body and c.end_date < term);
RETURN res;
END;
$$ LANGUAGE plpgsql;

set datestyle to german;
select term_controller('OOO "Рога и копыта"','23.05.2025');

--Представление, отображающее описания клиентов (и ключевые поля таблицы клиенты) и их товаров 
--Реализуем возможность изменения описания клиентов через это представление в реальной таблице
--3
CREATE VIEW client_goods_view AS
	SELECT cl.corporate_ body, cl.bank_details, g.contract_number,
		g.goods_id, g.goods_width, g.goods_height, g.goods_length,g.googds_weigth 
		FROM public."Clients" cl JOIN public."Contracts" c ON cl.id = c.client_id
		JOIN public."Goods" g ON c.contract_id = g.contract_number;
		
CREATE OR REPLACE FUNCTION update_view() RETURNS TRIGGER AS $$
BEGIN
	UPDATE public."Clients" SET bank_details = NEW.bank_details WHERE id= OLD.id;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop trigger viewup on client_goods_view;
CREATE OR REPLACE TRIGGER viewup
INSTEAD OF UPDATE ON client_goods_view FOR EACH ROW EXECUTE PROCEDURE update_view();
UPDATE client_goods_view SET bank_details = 'OOO CHTOTO' WHERE id = 1 ;

--2
--Для множества строк, содержащих длину, ширину и высоту хранящихся на складе товаров, 
--вычисляем максимальные габариты места, необходимые для того, чтобы поместился любой из хранящихся товаров, 
--и представим их в виде одной строки в формате «высота X ширина X длина»
CREATE OR REPLACE AGGREGATE max_parameters()

CREATE OR REPLACE FUNCTION max_parameters_step(numeric[], numeric[]) RETURNS numeric[] AS $$
DECLARE
res numeric[];
BEGIN
	IF $1[1] > $2[1] 
	THEN 
		res[1] := $1[1];
	ELSE
		res[1] := $2[1];
	END IF;
	IF $1[2] > $2[2] 
	THEN 
		res[2] := $1[2];
	ELSE
		res[2] := $2[2];
	END IF;
	IF $1[3] > $2[3] 
	THEN 
		res[3] := $1[3];
	ELSE
		res[3] := $2[3];
	END IF;
RETURN res;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION max_parameters_final(numeric[]) RETURNS text AS $$
	SELECT (to_char($1[1],'99999999D999') || 'x' || to_char($1[2],'99999999D999') ||
			'x' ||to_char($1[3],'9999999999D999')); 
$$ LANGUAGE sql;
select max_parameters_final(max_parameters_step((SELECT ARRAY[g.goods_height,g.goods_width,g.goods_length] FROM public."Goods" g where goods_id=1),'{1,2,3}'))