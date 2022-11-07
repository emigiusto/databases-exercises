-- a)

-- 4
select count(*)
from empires E
where E.Empire = 'Great Britain';

-- 3
select count(*)
from empires E
where E.Empire = 'Danish Empire';

-- b)

-- 4
select count(*)
from (
	select CC.CountryCode
	from countries_continents CC 
	group by CC.CountryCode
	having count(*) > 1
) X;

-- 2
select count(*)
from (
	select CC.CountryCode
	from countries_continents CC 
		join countries_continents C2 on CC.CountryCode = C2.CountryCode
	where C2.Continent = 'Europe'
	group by CC.CountryCode
	having count(*) > 1
) X;

-- 2
-- I like this the best :)
select count(*)
from countries_continents
where percentage < 100 and continent = 'Europe';

-- 2
select count(*)
from (
	select countrycode
	from countries_continents
	where continent = 'Europe'
	intersect
	select countrycode
	from countries_continents
	where continent <> 'Europe'
) X;

-- c)

-- 164688674

select sum(SpanishSpeaking)
from (
	select CO.Code, CO.Population * CL.Percentage / 100.0 as SpanishSpeaking
	from countries CO
		join countries_continents CC on CO.Code = CC.CountryCode
		join countries_languages CL on CO.Code = CL.CountryCode
	where CO.Population > 1000000
		and CC.Continent = 'North America'
		and CL.Language = 'Spanish'
) X;

-- 160575157 +/- 100

select sum(SpanishSpeaking)
from (
	select CO.Code, CO.Population * CL.Percentage / 100.0 as SpanishSpeaking
	from countries CO
		join countries_continents CC on CO.Code = CC.CountryCode
		join countries_languages CL on CO.Code = CL.CountryCode
	where CO.Population > 1000000
		and CC.Continent = 'South America'
		and CL.Language = 'Spanish'
) X;

-- d)

-- 1
select count(*)
from (
	select CL.language
	from empires E
		join countries_languages CL on E.CountryCode = CL.CountryCode
	where E.Empire = 'Danish Empire'
	group by CL.language
	having count(E.CountryCode) = (
		select count(*)
		from empires E
		where E.Empire = 'Danish Empire'
	)
) X;

-- 2
select count(*)
from (
	select CL.language
	from empires E
		join countries_languages CL on E.CountryCode = CL.CountryCode
	where E.Empire = 'Benelux'
	group by CL.language
	having count(E.CountryCode) = (
		select count(*)
		from empires E
		where E.Empire = 'Benelux'
	)
) X;

select distinct(L.language)
from countries_languages L
where not exists (
	select * 
	from empires E2
	where E2.empire = 'Benelux'
	  and not exists (
	  	select *
		from countries_languages CL
		where E2.countrycode = CL.countrycode
		  and CL.language = L.language
	)
)