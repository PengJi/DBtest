GreenPlum：
BEGIN;
        CREATE TABLE PART (
                P_PARTKEY               SERIAL8,
                P_NAME                  VARCHAR(55),
                P_MFGR                  CHAR(25),
                P_BRAND                 CHAR(10),
                P_TYPE                  VARCHAR(25),
                P_SIZE                  INTEGER,
                P_CONTAINER             CHAR(10),
                P_RETAILPRICE   DECIMAL,
                P_COMMENT               VARCHAR(23)
        ) with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (p_partkey);

        COPY part FROM '/tmp/dss-data/part.csv' WITH csv DELIMITER '|';

COMMIT;

BEGIN;

        CREATE TABLE REGION (
                R_REGIONKEY     SERIAL8,
                R_NAME          CHAR(25),
                R_COMMENT       VARCHAR(152)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (r_regionkey);

        COPY region FROM '/tmp/dss-data/region.csv' WITH csv DELIMITER '|';

COMMIT;

BEGIN;

        CREATE TABLE NATION (
                N_NATIONKEY             SERIAL8,
                N_NAME                  CHAR(25),
                N_REGIONKEY             BIGINT NOT NULL,  -- references R_REGIONKEY
                N_COMMENT               VARCHAR(152)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (n_nationkey);

        COPY nation FROM '/tmp/dss-data/nation.csv' WITH csv DELIMITER '|';

COMMIT;

BEGIN;

        CREATE TABLE SUPPLIER (
                S_SUPPKEY               SERIAL8,
                S_NAME                  CHAR(25),
                S_ADDRESS               VARCHAR(40),
                S_NATIONKEY             BIGINT NOT NULL, -- references N_NATIONKEY
                S_PHONE                 CHAR(15),
                S_ACCTBAL               DECIMAL,
                S_COMMENT               VARCHAR(101)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (s_suppkey);

        COPY supplier FROM '/tmp/dss-data/supplier.csv' WITH csv DELIMITER '|';

COMMIT;

BEGIN;

        CREATE TABLE CUSTOMER (
                C_CUSTKEY               SERIAL8,
                C_NAME                  VARCHAR(25),
                C_ADDRESS               VARCHAR(40),
                C_NATIONKEY             BIGINT NOT NULL, -- references N_NATIONKEY
                C_PHONE                 CHAR(15),
                C_ACCTBAL               DECIMAL,
                C_MKTSEGMENT    CHAR(10),
                C_COMMENT               VARCHAR(117)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (c_custkey);

        COPY customer FROM '/tmp/dss-data/customer.csv' WITH csv DELIMITER '|';

COMMIT;

BEGIN;

        CREATE TABLE PARTSUPP (
                PS_PARTKEY              BIGINT NOT NULL, -- references P_PARTKEY
                PS_SUPPKEY              BIGINT NOT NULL, -- references S_SUPPKEY
                PS_AVAILQTY             INTEGER,
                PS_SUPPLYCOST   DECIMAL,
                PS_COMMENT              VARCHAR(199)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (ps_partkey,ps_suppkey);

        COPY partsupp FROM '/tmp/dss-data/partsupp.csv' WITH csv DELIMITER '|';

COMMIT;

BEGIN;

        CREATE TABLE ORDERS (
                O_ORDERKEY              SERIAL8,
                O_CUSTKEY               BIGINT NOT NULL, -- references C_CUSTKEY
                O_ORDERSTATUS   CHAR(1),
                O_TOTALPRICE    DECIMAL,
                O_ORDERDATE             DATE,
                O_ORDERPRIORITY CHAR(15),
                O_CLERK                 CHAR(15),
                O_SHIPPRIORITY  INTEGER,
                O_COMMENT               VARCHAR(79)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (o_orderkey);

        COPY orders FROM '/tmp/dss-data/orders.csv' WITH csv DELIMITER '|';

COMMIT;

BEGIN;

        CREATE TABLE LINEITEM (
                L_ORDERKEY              BIGINT NOT NULL, -- references O_ORDERKEY
                L_PARTKEY               BIGINT NOT NULL, -- references P_PARTKEY (compound fk to PARTSUPP)
                L_SUPPKEY               BIGINT NOT NULL, -- references S_SUPPKEY (compound fk to PARTSUPP)
                L_LINENUMBER    INTEGER,
                L_QUANTITY              DECIMAL,
                L_EXTENDEDPRICE DECIMAL,
                L_DISCOUNT              DECIMAL,
                L_TAX                   DECIMAL,
                L_RETURNFLAG    CHAR(1),
                L_LINESTATUS    CHAR(1),
                L_SHIPDATE              DATE,
                L_COMMITDATE    DATE,
                L_RECEIPTDATE   DATE,
                L_SHIPINSTRUCT  CHAR(25),
                L_SHIPMODE              CHAR(10),
                L_COMMENT               VARCHAR(44)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (l_orderkey, l_linenumber);

        COPY lineitem FROM '/tmp/dss-data/lineitem.csv' WITH csv DELIMITER '|';
COMMIT;

MySql:
--
-- Table structure for table `customer`
--
DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `C_CUSTKEY` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `C_NAME` varchar(25) DEFAULT NULL,
  `C_ADDRESS` varchar(40) DEFAULT NULL,
  `C_NATIONKEY` bigint(20) NOT NULL,
  `C_PHONE` char(15) DEFAULT NULL,
  `C_ACCTBAL` decimal(10,0) DEFAULT NULL,
  `C_MKTSEGMENT` char(10) DEFAULT NULL,
  `C_COMMENT` varchar(117) DEFAULT NULL,
  UNIQUE KEY `C_CUSTKEY` (`C_CUSTKEY`)
) ENGINE=MyISAM AUTO_INCREMENT=150001 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lineitem`
--

DROP TABLE IF EXISTS `lineitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lineitem` (
  `L_ORDERKEY` bigint(20) NOT NULL,
  `L_PARTKEY` bigint(20) NOT NULL,
  `L_SUPPKEY` bigint(20) NOT NULL,
  `L_LINENUMBER` int(11) DEFAULT NULL,
  `L_QUANTITY` decimal(10,0) DEFAULT NULL,
  `L_EXTENDEDPRICE` decimal(10,0) DEFAULT NULL,
  `L_DISCOUNT` decimal(10,0) DEFAULT NULL,
  `L_TAX` decimal(10,0) DEFAULT NULL,
  `L_RETURNFLAG` char(1) DEFAULT NULL,
  `L_LINESTATUS` char(1) DEFAULT NULL,
  `L_SHIPDATE` date DEFAULT NULL,
  `L_COMMITDATE` date DEFAULT NULL,
  `L_RECEIPTDATE` date DEFAULT NULL,
  `L_SHIPINSTRUCT` char(25) DEFAULT NULL,
  `L_SHIPMODE` char(10) DEFAULT NULL,
  `L_COMMENT` varchar(44) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nation`
--

DROP TABLE IF EXISTS `nation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nation` (
  `N_NATIONKEY` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `N_NAME` char(25) DEFAULT NULL,
  `N_REGIONKEY` bigint(20) NOT NULL,
  `N_COMMENT` varchar(152) DEFAULT NULL,
  UNIQUE KEY `N_NATIONKEY` (`N_NATIONKEY`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `O_ORDERKEY` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `O_CUSTKEY` bigint(20) NOT NULL,
  `O_ORDERSTATUS` char(1) DEFAULT NULL,
  `O_TOTALPRICE` decimal(10,0) DEFAULT NULL,
  `O_ORDERDATE` date DEFAULT NULL,
  `O_ORDERPRIORITY` char(15) DEFAULT NULL,
  `O_CLERK` char(15) DEFAULT NULL,
  `O_SHIPPRIORITY` int(11) DEFAULT NULL,
  `O_COMMENT` varchar(79) DEFAULT NULL,
  UNIQUE KEY `O_ORDERKEY` (`O_ORDERKEY`)
) ENGINE=MyISAM AUTO_INCREMENT=6000001 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `part`
--

DROP TABLE IF EXISTS `part`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `part` (
  `P_PARTKEY` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `P_NAME` varchar(55) DEFAULT NULL,
  `P_MFGR` char(25) DEFAULT NULL,
  `P_BRAND` char(10) DEFAULT NULL,
  `P_TYPE` varchar(25) DEFAULT NULL,
  `P_SIZE` int(11) DEFAULT NULL,
  `P_CONTAINER` char(10) DEFAULT NULL,
  `P_RETAILPRICE` decimal(10,0) DEFAULT NULL,
  `P_COMMENT` varchar(23) DEFAULT NULL,
  UNIQUE KEY `P_PARTKEY` (`P_PARTKEY`)
) ENGINE=MyISAM AUTO_INCREMENT=200001 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `partsupp`
--

DROP TABLE IF EXISTS `partsupp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partsupp` (
  `PS_PARTKEY` bigint(20) NOT NULL,
  `PS_SUPPKEY` bigint(20) NOT NULL,
  `PS_AVAILQTY` int(11) DEFAULT NULL,
  `PS_SUPPLYCOST` decimal(10,0) DEFAULT NULL,
  `PS_COMMENT` varchar(199) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region` (
  `R_REGIONKEY` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `R_NAME` char(25) DEFAULT NULL,
  `R_COMMENT` varchar(152) DEFAULT NULL,
  UNIQUE KEY `R_REGIONKEY` (`R_REGIONKEY`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier` (
  `S_SUPPKEY` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `S_NAME` char(25) DEFAULT NULL,
  `S_ADDRESS` varchar(40) DEFAULT NULL,
  `S_NATIONKEY` bigint(20) NOT NULL,
  `S_PHONE` char(15) DEFAULT NULL,
  `S_ACCTBAL` decimal(10,0) DEFAULT NULL,
  `S_COMMENT` varchar(101) DEFAULT NULL,
  UNIQUE KEY `S_SUPPKEY` (`S_SUPPKEY`)
) ENGINE=MyISAM AUTO_INCREMENT=10001 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

DROP TABLE IF EXISTS `partsupp`;
CREATE TABLE `partsupp`(
   `PS_PARTKEY` bigint(20) unsigned NOT NULL,
   `PS_SUPPKEY` bigint(20) unsigned NOT NULL,
   `PS_AVAILQTY` int(11),
   `PS_SUPPLYCOST` decimal,
   `PS_COMMENT`  varchar(199)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
 

