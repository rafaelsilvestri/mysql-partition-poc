\! echo 'Starting initdb script';

create table foo_part (
    `id` bigint default NULL,
    `name` varchar(30) default NULL,
    `created` date default NULL
)
PARTITION BY RANGE (year(created))
(
    PARTITION p0 VALUES LESS THAN (1995),
    PARTITION p1 VALUES LESS THAN (1996) , 
    PARTITION p2 VALUES LESS THAN (1997) ,
    PARTITION p3 VALUES LESS THAN (1998) , 
    PARTITION p4 VALUES LESS THAN (1999) ,
    PARTITION p5 VALUES LESS THAN (2000) , 
    PARTITION p6 VALUES LESS THAN (2001) ,
    PARTITION p7 VALUES LESS THAN (2002) , 
    PARTITION p8 VALUES LESS THAN (2003) ,
    PARTITION p9 VALUES LESS THAN (2004) , 
    PARTITION p10 VALUES LESS THAN (2010),
    PARTITION p11 VALUES LESS THAN MAXVALUE 
);


-- create a procedure to generate data 4M lines of random data
DELIMITER |
CREATE PROCEDURE load_table()
     begin
         declare v int default 0;
         while v < 4000000
         do
             insert into foo_part values (v,'testing partitions',adddate('1995-01-01',(rand(v)*36520) mod 3652));
             set v = v + 1;
         end while;
     end 
    |
DELIMITER ;

CALL load_table();


-- Create a non-partitioned table to compare
create table foo_non_part (
    `id` bigint default NULL,
    `name` varchar(30) default NULL,
    `created` date default NULL
);

-- copy data from previus table
insert into foo_non_part select * from foo_part;

\! echo 'Initdb script finished!';