--1)
-- In the database there are 3,264 cities which have a population that is less than 1% of
-- the population of their country. How many cities in the database have a population
-- that is more than 50% of the population of their country?
select count(*) from countries co
	join cities ci on co.code = ci.countrycode
	where ci.population > co.population/2
--14

--2)
select count(*) from (select countrycode, sum(percentage) from countries_languages
	group by countrycode
	having sum(percentage) < 100) as foo
--202

--3)

drop view if exists ratioView;
create view ratioView as
	select countrycode, cast(MAX(population) as decimal)/cast(MIN(population) as decimal) as Ratio from cities
		group by countrycode

select * from ratioView

select countrycode
from ratioView
where ratio = (select max(Ratio) from ratioView);
--GBR

--4)
drop view if exists urbanPop;
create view urbanPop as
	select * from (select countrycode, sum(population) as popInCities from cities
		group by countrycode) as citiesUrban
	inner join (select * from  countries where population > 1000000) as bigCountries
		on bigCountries.code = citiesUrban.countrycode

create view urbanRatioView as
	select countrycode, cast(MAX(popincities) as decimal)/cast(MIN(population) as decimal) as Ratio from urbanPop
		group by countrycode
select * from urbanRatioView
		
select countrycode from urbanRatioView
	where ratio = (select max(ratio) from urbanRatioView)
--SGP