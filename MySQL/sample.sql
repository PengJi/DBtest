-- 学生表
drop table if exists stu;
CREATE TABLE stu(
    id int primary key auto_increment comment '学生id',
    sno char(11) unique key comment '学号',  #二级唯一索引
    name varchar(11) default 'test' comment '学生姓名',
    age smallint default 25 comment '学生年龄',
    score int default 90 comment '学生分数',  #用于测试
    key `idx_name` (`name`), #二级非唯一索引
    key `idx_age` (`age`)  #二级非唯一索引
);

insert into stu values
(15, 'S0001', 'Bob', 25, 34),
(18, 'S0002', 'Alice', 24, 77),
(20, 'S0003', 'Jim', 24, 5),
(30, 'S0004', 'Eric', 23, 91),
(37, 'S0005', 'Tom', 22, 22),
(49, 'S0006', 'Tom', 25, 83),
(50, 'S0007', 'Rose', 23, 89);

replace into stu(sno) values ('S0008');
replace into stu(sno) values ('S0009');
replace into stu(sno) values ('S0010');
replace into stu(sno) values ('S0011');
replace into stu(sno) values ('S0012');
replace into stu(sno) values ('S0013');

insert into stu(sno) values
('S0014'),
('S0015'),
('S0016')
on duplicate key update
sno = values(sno);
 
-- 课程表
drop table if exists course;
CREATE TABLE course( 
    id int PRIMARY KEY comment '课程id', 
    cno char(11) unique key comment '课程编号',
    cname varchar(40) comment '课程名称',
    ceredit smallint comment '课程学分'
);

insert into course values(
);
 
-- 选课表
drop table if exists sc;
CREATE TABLE sc(
    sno char(11) comment '学生编号',
    cno char(11) comment '课程编号',
    grade smallint comment '学分',
    PRIMARY KEY(sno,cno), #主码有两个属性构成，必须作为表级完整性进行定义
    FOREIGN KEY (sno) REFERENCES stu(sno), #表级完整性约束条件
    FOREIGN KEY (cno) REFERENCES course(cno) #表级完整性约束条件
);

insert into sc values(
);
