--fk for g
CREATE OR REPLACE FUNCTION get_id_p(idd integer) RETURNS integer AS $$ 
DECLARE
	tmp integer;
BEGIN
	SELECT p.position_id INTO tmp FROM public."Positions" p JOIN public."Ledges" l 
	ON p.ledge_id=l.ledge_id JOIN public."Shelfs" s ON s.id = l.shelf_id
	JOIN public."Contracts" c ON c.client_id=s.client_id
	WHERE (c.contract_id=idd AND p.position_id NOT IN (SELECT g.position_id FROM public."Goods" g));
RETURN tmp;
END
$$ LANGUAGE plpgsql;

--pk for g
CREATE OR REPLACE FUNCTION get_id() RETURNS integer AS $$
DECLARE tmp integer;
BEGIN
	SELECT max(g.goods_id) + 1 INTO tmp FROM public."Goods" g ;
RETURN tmp;
END;
$$ language plpgsql;

--pk for p
CREATE OR REPLACE FUNCTION p_id() RETURNS integer AS $$
DECLARE tmp integer;
BEGIN
	SELECT max(p.position_id) + 1 INTO tmp FROM public."Positions" p ;
RETURN tmp;
END;
$$ language plpgsql;

--pk for l
CREATE OR REPLACE FUNCTION l_id() RETURNS integer AS $$
DECLARE tmp integer;
BEGIN
	SELECT max(l.ledge_id) + 1 INTO tmp FROM public."Ledges" l ;
RETURN tmp;
END;
$$ language plpgsql;

--pk for cl
CREATE OR REPLACE FUNCTION cl_id() RETURNS integer AS $$
DECLARE tmp integer;
BEGIN
	SELECT max(cl.id) + 1 INTO tmp FROM public."Clients" cl ;
RETURN tmp;
END;
$$ language plpgsql;

--pk for s
CREATE OR REPLACE FUNCTION s_id() RETURNS integer AS $$ DECLARE tmp integer;
BEGIN
	SELECT max(s.id) + 1 INTO tmp FROM public."Shelfs" s ; RETURN tmp;
END;
$$ language plpgsql;

DELETE FROM public."Clients";
INSERT INTO public."Clients" VALUES
(1, 'OOO "Рога и копыта"', '40702811138170109674'),
(cl_id(), 'ООО "Молочный рай"', '42754910138173401174'),
(cl_id(), 'ООО "Агрокультура"', '49464920138156109224'),
(cl_id(), 'OOO "Крупский"', '41813922249281210785'),
(cl_id(), 'OOO "Биофабрика"', '42924033350392321896') RETURNING *; 
INSERT INTO public."Clients" VALUES (cl_id(), 'ООО "КОНФЕТНЫЙ"','43924034350392321896');

INSERT INTO public."Shelfs" VALUES (1, 1, 100, 62500, 3),
(s_id(), 1, 50, 31250, 3),
(s_id(), 2, 100, 90000, 4),
(s_id(), 2, 200, 25000, 4),
(s_id(), 3, 300, 50000, 1),
(s_id(), 3, 400, 75000, 1),
(s_id(), 4, 100, 90000, 2),
(s_id(), 4, 50, 31250, 2),
(s_id(), 5, 200, 20000, 5),
(s_id(), 5, 100, 30000, 5) RETURNING *;
INSERT INTO public."Shelfs" VALUES (s_id(), 5, 100, 30000, 5); 

INSERT INTO public."Ledges" VALUES (1, 1),
(l_id(), 1),(l_id(), 1),
(l_id(), 1), (l_id(), 1), 
(l_id(), 2), (l_id(), 2), 
(l_id(), 2), (l_id(), 2),
(l_id(), 2),(l_id(), 3),
(l_id(), 3),(l_id(), 3),
(l_id(), 3),(l_id(), 3),
(l_id(), 4),(l_id(), 4),
(l_id(), 4),(l_id(), 4),
(l_id(), 4),(l_id(), 5),
(l_id(), 5),(l_id(), 5),
(l_id(), 5),(l_id(), 5),
(l_id(), 6),(l_id(), 6),
(l_id(), 6),(l_id(), 6),
(l_id(), 6),(l_id(), 7),
(l_id(), 7),(l_id(), 7),
(l_id(), 7),(l_id(), 7),
(l_id(), 8),(l_id(), 8),
(l_id(), 8),(l_id(), 8),
(l_id(), 8),(l_id(), 9),
(l_id(), 9),(l_id(), 9),
(l_id(), 9),(l_id(), 9),
(l_id(), 10),(l_id(), 10),
(l_id(), 10),(l_id(), 10),
(l_id(), 10) RETURNING *;

INSERT INTO public."PosiÇons" VALUES (1, 1, 4250, 5500, 6000),
(p_id(), 6, 5250, 7500, 2000),
(p_id(), 11, 3250, 1500, 9000),
(p_id(), 16, 2250, 7500, 1000),
(p_id(), 21, 350, 500, 850),
(p_id(), 26, 450, 700, 250),
(p_id(), 31, 250, 900, 150),
(p_id(), 36, 650, 900, 950),
(p_id(), 41, 350, 500, 850),
(p_id(), 46, 450, 700, 250),
(p_id(), 2, 250, 900, 150),
(p_id(), 7, 650, 900, 950),
(p_id(), 12, 4250, 5500, 6000),
(p_id(), 17, 5250, 7500, 2000),
(p_id(), 22, 3250, 1500, 9000),
(p_id(), 27, 2250, 7500, 1000),
(p_id(), 32, 5000, 4000, 6000),
(p_id(), 37, 7000, 3000, 2000),
(p_id(), 42, 2000, 3000, 1000),
(p_id(), 47, 3000, 2500, 1500) RETURNING *;

INSERT INTO public."Goods" VALUES 
(1,3,get_id_p(3),2000,3000,300,4000,98,90,8.8,1.9), 
(get_id(),3,get_id_p(3),3000,2000,250,1000,97,91,7.6,1.5), 
(get_id(),4,get_id_p(4),500,700,200,800,65,55,8.0,2.0), 
(get_id(),4,get_id_p(4),900,500,150,700,67,57,7.8,2.2), 
(get_id(),2,get_id_p(2),100,100,50,100,89,86,4.0,2.0), 
(get_id(),2,get_id_p(2),500,500,100,500,88,86,4.0,2.0), 
(get_id(),5,get_id_p(5),300,300,75,300,70,60,18.0,3.6), 
(get_id(),5,get_id_p(5),400,400,200,400,70,60,18.0,3.6), 
(get_id(),3,get_id_p(3),100,100,50,100,98,90,8.8,1.9), 
(get_id(),3,get_id_p(3),650,650,250,650,97,91,7.6,1.5), 
(get_id(),4,get_id_p(4),1000,1000,250,700,67,57,7.8,2.2), 
(get_id(),1,get_id_p(1),2230,1300,350,1200,80,75,2.0,0.5), 
(get_id(),1,get_id_p(1),950,350,100,400,79,75,2.0,0.5), 
(get_id(),2,get_id_p(2),1500,1500,400,1300,89,86,4.0,2.0), 
(get_id(),2,get_id_p(2),5000,2500,500,1500,88,86,4.0,2.0), 
(get_id(),5,get_id_p(5),2400,1400,200,1600,70,60,18.0,3.6) RETURNING *;

SET DATESTYLE TO GERMAN;

--0  суммарный вес товаров на складе
SELECT sum(googds_weigth) FROM public."Goods";

--1 выбираем 3 клиентов, хранящих наибольшее число товаров по суммарному объему
SELECT c. client_id FROM (SELECT g.contract_number, sum(g.goods_height*g.goods_width*g.goods_length) s1
FROM public."Goods" g GROUP BY g.contract_number ORDER BY s1 DESC LIMIT 3) tmp ,
public."Contracts" c WHERE c.contract_id=tmp.contract_number;

--2 выбираем все стеллажи с указанием их загруженности по количеству товаров, включая пустые стеллажи.
SELECT l.shelf_id, case when count(g.goods_id)>0 then count(g.goods_id) else 0 end FROM public."Ledges" l
JOIN public."Positions" p
ON l.ledge_id = p.ledge_id LEFT JOIN public."Goods" g ON g.position_id=p.position_id
GROUP BY l.shelf_id ORDER BY l.shelf_id ;

--3 удаляем все товары, лежащие на стеллажах с максимальной нагрузкой меньше 100 кг
DELETE FROM public."Goods" g WHERE g.posiÇon_id in
(SELECT position_id FROM public."Ledges" l JOIN public."Positions" p ON l.ledge_id = p.ledge_id
JOIN public."Shelfs" s ON s.id = l.shelf_id WHERE s.total_load<100)

--4 изменяем даты окончания договора у всех товаров фирмы «рога и копыта», добавив к ним один дополнительный месяц
UPDATE public."Contracts" SET end_date = end_date + interval'1 month'
WHERE client_id = (SELECT id FROM public."Clients" cl WHERE cl.corporate_body = 'OOO "Рога и копыта"')

--5 добавляем информацию о хрупкости товаров
ALTER TABLE public."Contracts" ADD COLUMN fragility varchar(250);

--6 добавляем в базу данных ограничение целостности, контролирующие, чтобы вес товара не превышал 500 кг
ALTER TABLE public."Goods" ADD CHECK (googds_weigth <= 500);