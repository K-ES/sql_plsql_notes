-- 01 создаем пользователя скриптами от Ильи Хохлова https://www.youtube.com/watch?v=lw_gny4zoEI
			alter session set "_ORACLE_SCRIPT"=true;
			CREATE USER developer identified by 123;
			grant create session to developer;
			grant create table to developer;
			grant create procedure to developer;
			grant create trigger to developer;
			grant create view to developer;
			grant create sequence to developer;
			grant alter any table to developer;
			grant alter any procedure to developer;
			grant alter any trigger to developer;
			grant alter profile to developer;
			grant delete any table to developer;
			grant drop any table to developer;
			grant drop any procedure to developer;
			grant drop any trigger to developer;
			grant drop any view to developer;
			grant drop profile to developer;

			grant select on sys.v_$session to developer;
			grant select on sys.v_$sesstat to developer;
			grant select on sys.v_$statname to developer;
			grant SELECT ANY DICTIONARY to developer;

-- 02 Дропаем польовазеля, чтобы дать другое табличное пространство
		-- выяснилось, что все объекты созданы не в новоиспеченном табличном пространстве
		-- дропаем юзера (под sys)

		alter session set "_ORACLE_SCRIPT"=true;
		drop user developer cascade;

		--SQL> alter session set "_ORACLE_SCRIPT"=true;
		--Session altered
		--SQL> drop user developer cascade;
		--User dropped
		
-- 03 Решаем пролему с кодировкой		
		-- Решил проблему с некорректной кодировкой
		
-- 04 Ради фана создаем минимальное табличное пространство		
		-- Ржаки ради создаем минимальное табличное пространство для того, чтобы проверить ошибку создания таблиц
		-- https://docs.oracle.com/cd/E11882_01/server.112/e41084/clauses008.htm#SQLRF30012
		CREATE TABLESPACE tbs_perm_02 DATAFILE 'tbs_perm_02.dbf' SIZE 1 ONLINE;
		https://community.oracle.com/tech/developers/discussion/2367544/create-tablespace-and-ora-03214
		  
		
-- 05 Докручиваем PL SQL Developer (навигатор объектов)

-- 06 Хоткей на форматирование. Хоткей на комментирование

-- 07 Поиск минимального размера через скрипт


	declare
	begin
	  for i in 1 .. 10 loop -- поиграться
		declare
		begin
		  execute immediate 'CREATE TABLESPACE tbs_perm_02 DATAFILE ''tbs_perm_02.dbf'' SIZE ' || i || ' ONLINE';
		  dbms_output.putline('[#]' || ':' || ''); 
		  
		  exit;
		exception
		  when others then
			dbms_output.put_line(i || ' ' || sqlerrm);
		end;
	--    if (i = 3)
	--    then
	--      exit;
	--    end if;
	  end loop;
	end;


	--Остановились на значении:81921
	--Завершили выполнение

	-- Hf
	CREATE TABLESPACE tbs_perm_06 DATAFILE 'tbs_perm_06.dbf' SIZE 81921 ONLINE -- создаст 11 блоков по 8192 (итого 90112)
	CREATE TABLESPACE tbs_perm_07 DATAFILE 'tbs_perm_07.dbf' SIZE 90112 ONLINE -- создаст 11 блоков по 8192 (итого 90112)
	CREATE TABLESPACE tbs_perm_08 DATAFILE 'tbs_perm_08.dbf' SIZE 90113 ONLINE -- создаст 12 блоков по 8192 (итого 98304)
	
	drop tablespace TBS_PERM_02;
	drop tablespace TBS_PERM_03;
	drop tablespace TBS_PERM_05;
	drop tablespace TBS_PERM_06;
	drop tablespace TBS_PERM_07;
	drop tablespace TBS_PERM_08;
		
	CREATE TABLESPACE tbs_perm_02 DATAFILE 'tbs_perm_02.dbt' SIZE 20M ONLINE;

-- 08 Пересоздаем пользователя и новоиспеченным табличным пространством

		alter session set "_ORACLE_SCRIPT"=true;
		CREATE USER developer identified by 123 default tablespace tbs_perm_02;
		grant create session to developer;
		grant create table to developer;
		grant create procedure to developer;
		grant create trigger to developer;
		grant create view to developer;
		grant create sequence to developer;
		grant alter any table to developer;
		grant alter any procedure to developer;
		grant alter any trigger to developer;
		grant alter profile to developer;
		grant delete any table to developer;
		grant drop any table to developer;
		grant drop any procedure to developer;
		grant drop any trigger to developer;
		grant drop any view to developer;
		grant drop profile to developer;

		grant select on sys.v_$session to developer;
		grant select on sys.v_$sesstat to developer;
		grant select on sys.v_$statname to developer;
		grant SELECT ANY DICTIONARY to developer;


-- 09 Зашли под новым юзером

-- 10 https://sql-ex.ru/db_script_download.php Oracle

-- 11 Дать права на tablespace
	ALTER USER developer quota unlimited on tbs_perm_02;

-- 12 Не взлетели скрипты с футболом. Но это не важно. Остальные установлены. 

