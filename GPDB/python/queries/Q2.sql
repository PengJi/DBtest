-- Find all galaxies with blue surface brightness between and 23 and 25 magnitude per square arcseconds, and super galactic latitude (sgb) between (-10º, 10º), and declination less than zero.

select objID
from Galaxy
where ra between 170 and 190
and dec < 0
and g+rho between 23 and 25
