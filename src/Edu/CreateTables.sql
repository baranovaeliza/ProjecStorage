BEGIN;
CREATE TABLE IF NOT EXISTS public."Rooms" (
	id integer,
	useful_volume numeric NOT NULL,
	max_temperature numeric(3,1) NOT NULL,
	min_temperature numeric(3,1) NOT NULL,
	max_humidity numeric(2) NOT NULL,
	min_humidity numeric(2) NOT NULL,
	name character varying(250) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE(name));

CREATE TABLE IF NOT EXISTS public."Clients" (
	id integer NOT NULL,
	corporate_body character varying(250) NOT NULL,
	bank_details text NOT NULL,
	UNIQUE(corporate_body, bank_details),
	PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS public."Goods" (
	goods_id integer,
	contract_number integer NOT NULL,
	position_id integer NOT NULL,
	goods_height numeric(5) NOT NULL,
	goods_width numeric(5) NOT NULL,
	googds_weigth numeric(5) NOT NULL,
	goods_length numeric(5) NOT NULL,
	max_humidity numeric(2) NOT NULL,
	min_humidity numeric(2) NOT NULL,
	max_temp numeric(3,1) NOT NULL,
	min_temp numeric(3,1) NOT NULL,
	PRIMARY KEY (goods_id),
	UNIQUE (position_id,contract_number));

CREATE TABLE IF NOT EXISTS public."Shelfs" (
	id integer,
	room_id integer NOT NULL,
	positions_quantity integer NOT NULL,
	total_load numeric(5) NOT NULL,
	client_id integer NOT NULL,
	PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS public."Contracts" (
	contract_id integer,
	contract_number integer NOT NULL,
	client_id integer NOT NULL,
	start_date date NOT NULL,
	end_date date NOT NULL,
	PRIMARY KEY (contract_id),
	UNIQUE(client_id,contract_number) );

CREATE TABLE IF NOT EXISTS public."Ledges" (
	ledge_id integer,
	shelf_id integer NOT NULL,
	PRIMARY KEY (ledge_id));

CREATE TABLE IF NOT EXISTS public."Positions" (
	position_id integer,
	ledge_id integer NOT NULL,
	heigth numeric(5) NOT NULL,
	width numeric(5) NOT NULL,
	length numeric(5) NOT NULL,
	PRIMARY KEY (position_id));

ALTER TABLE IF EXISTS public."Goods"
    ADD FOREIGN KEY (contract_number)
    REFERENCES public."Contracts" (contract_id) MATCH SIMPLE ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public."Goods"
    ADD FOREIGN KEY (position_id)
    REFERENCES public."Positions" (position_id) MATCH SIMPLE ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public."Shelfs"
    ADD FOREIGN KEY (room_id)
    REFERENCES public."Rooms" (id) MATCH SIMPLE ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public."Shelfs"
    ADD FOREIGN KEY (client_id)
    REFERENCES public."Clients" (id) MATCH SIMPLE ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public."Contracts"
    ADD FOREIGN KEY (client_id)
    REFERENCES public."Clients" (id) MATCH SIMPLE ON UPDATE NO ACTION
    ON DELETE NO ACTION NOT VALID;

ALTER TABLE IF EXISTS public."Ledges"
    ADD FOREIGN KEY (shelf_id)
    REFERENCES public."Shelfs" (id) MATCH SIMPLE ON UPDATE NO ACTION
    ON DELETE NO ACTION NOT VALID;

ALTER TABLE IF EXISTS public."Positions"
    ADD FOREIGN KEY (ledge_id)
    REFERENCES public."Ledges" (ledge_id) MATCH SIMPLE ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
END;
