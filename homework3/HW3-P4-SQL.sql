-- (a)

-- Given: 3264
select count(*)
from cities CI 
	join countries CO on CI.CountryCode = CO.Code
where CI.Population <= 0.01 * CO.Population;

-- Answer: 14
select count(*)
from cities CI 
	join countries CO on CI.CountryCode = CO.Code
where CI.Population > 0.5 * CO.Population;

-- (b)

-- Given: 2
select count(*)
from (
	select CL.CountryCode
	from countries_languages CL
	group by CL.CountryCode
	having sum(CL.Percentage) > 100.0
) X;

-- Answer: 208
select count(*)
from (
	select CL.CountryCode
	from countries_languages CL
	group by CL.CountryCode
	having sum(CL.Percentage) < 100.0
	union all
	select CO.Code
	from countries CO
	where not exists (
		select *
		from countries_languages CL
		where CL.CountryCode = CO.Code
	)
) X;

-- (c)

-- Helper view
drop view if exists AllPairs;
create view AllPairs
as
select C1.ID, 1.0*C1.Population/C2.Population as Ratio
from cities C1
	join cities C2 on C1.CountryCode = C2.CountryCode and C1.ID <> C2.ID and C1.Population > C2.Population;

-- Answer: 456
select AP.ID
from AllPairs AP
where AP.Ratio = (select max(Ratio) from AllPairs);

-- (d) 

-- Helper views
drop view if exists sumCities;
create view sumCities
as
select CI.CountryCode, sum(Population) as Population
from cities CI
group by CI.CountryCode;

drop view if exists sumPopulation;
create view sumPopulation
as 
select CO.Code, CO.Population, SCI.Population as UrbanPopulation, 1.0*SCI.Population/CO.Population as ratio
from countries CO 
	join sumCities SCI on CO.Code = SCI.CountryCode;

-- Info on Netherlands
select SP.UrbanPopulation
from sumPopulation SP
where Code = 'NLD';

-- Answer: SGP
select Code 
from sumPopulation SP
where SP.Population > 1000000 
	and SP.ratio = (
		select max(ratio) 
		from sumPopulation
		where Population > 1000000
	);

