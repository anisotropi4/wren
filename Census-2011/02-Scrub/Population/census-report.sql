drop table _tmp;

select i.postcode_sector as postcode_sector,
sum(i.all_people::integer) as population,
sum(males::integer) as males,
sum(females::integer) as females,
sum(household::integer) as household,
sum(communal_establishment::integer) as communal_establishment,
sum(child_or_student_non_term_time_address::integer) as child,
sum(cast(i.area_ha as double precision)) as area_ha
into _tmp
from 
(select * from table_scotland_mainland 
union select * from table_scotland_islands 
union select * from table_england_and_wales_data) as i
group by i.postcode_sector
order by postcode_sector;

\copy _tmp to 'gb-census-report-01.tsv' with csv delimiter E'\t' header;
