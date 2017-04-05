-- Find quasars with a line width >2000 km/s and 2.5<redshift<2.7. 

/*
declare		qso     int;
set		qso = dbo.fSpecClass('QSO') ;
declare		hiZ_qso int;
set		hiZ_qso =dbo.fSpecClass('HIZ-QSO');
select         s.specObjID, 					-- object id
 		max(l.sigma*300000.0/l.wave) as veldisp, 	-- velocity disper-sion
 		avg(s.z) as z					-- redshift
from     SpecObj s, specLine l          	-- from the spectrum table and lines 
where  s.specObjID=l.specObjID 		-- line belongs to spectrum of this obj	
   and ( (s.specClass = qso) or   		-- quasar 
         (s.specClass = hiZ_qso)) 		-- or hiZ_qso. 
   and  s.z between 2.5 and 2.7   		-- redshift of 2.5 to 2.7
   and  l.sigma*300000.0/l.wave >2000.0	-- convert sigma to km/s         
   and  s.zConf > 0.9                     	-- high confidence on redshift estimate 
group by s.specObjID;
*/

declare qso int;
qso := fSpecClass('QSO') ;
declare hiZ_qso int;
hiZ_qso := fSpecClass('HIZ-QSO');
select s.specObjID,max(l.sigma*300000.0/l.wave) as veldisp,avg(s.z) as z
from SpecObj s, specLine l     
where  s.specObjID=l.specObjID 		
   and ((s.specClass = qso) or (s.specClass = hiZ_qso))  
   and  s.z between 2.5 and 2.7   
   and  l.sigma*300000.0/l.wave >2000.0	         
   and  s.zConf > 0.9        
group by s.specObjID;

/*
tables:
specObjAll

views:
SpecObj

functions:
fSpecClass
*/
