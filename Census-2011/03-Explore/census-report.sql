drop table _tmp;

select i.id,
sum(i.population::integer) as population,
sum(males::integer) as males,
sum(females::integer) as females,
sum(household::integer) as household,
sum(communal_establishment::integer) as communal_establishment,
sum(child::integer) as child,
sum(cast(i.area_ha as double precision)) as area_ha
into _tmp
from table_gb_census_report_02 i
group by i.id
order by id;

\copy _tmp to 'gb-census-report.tsv' with csv delimiter E'\t' header;
