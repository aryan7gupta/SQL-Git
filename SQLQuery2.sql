Select * from sharktank..data

-- total episodes

select max(epno) from sharktank..data
select count(distinct epno) from sharktank..data

-- pitches 

select count(distinct brand) from sharktank..data

-- labelling converted as 1 and not converted as 0
select amountinvestedlakhs , case when amountinvestedlakhs>0 then 1 else 0 end as converted_not_converted from sharktank..data 

--no of pitches converted

select cast(sum(a.converted_not_converted) as float) /cast(count(*) as float) from (
select amountinvestedlakhs , case when amountinvestedlakhs>0 then 1 else 0 end as converted_not_converted from sharktank..data) a

-- total male

select sum(male) from sharktank..data

-- total female

select sum(female) from sharktank..data

--gender ratio

select sum(female)/sum(male) from sharktank..data

-- total invested amount

select sum(amountinvestedlakhs) from sharktank..data

-- avg equity taken

select avg(a.equitytakenp) from
(select * from sharktank..data where equitytakenp>0) a

--highest deal taken

select max(amountinvestedlakhs) from sharktank..data 

--higheest equity taken

select max(equitytakenp) from sharktank..data

-- startups having at least 1 women

	select sum(a.female_count) from (
	select female,case when female>0 then 1 else 0 end as female_count from sharktank..data) a

-- pitches converted having atleast one women

select * from sharktank..data


select sum(b.female_count) from(

select case when a.female>0 then 1 else 0 end as female_count ,a.*from (
(select * from sharktank..data where deal!='No Deal')) a)b

-- avg team members

select avg(teammembers) from sharktank..data

-- amount invested per deal

select avg(a.amountinvestedlakhs) amount_invested_per_deal from
(select * from sharktank..data where deal!='No Deal') a

-- avg age group of contestants

select avgage,count(avgage) cnt from sharktank..data group by avgage order by cnt desc

-- location group of contestants

select location,count(location) cnt from sharktank..data group by location order by cnt desc

-- sector group of contestants

select sector,count(sector) cnt from sharktank..data group by sector order by cnt desc


--partner deals

select partners,count(partners) cnt from sharktank..data  where partners!='-' group by partners order by cnt desc


-- making the matrix


select * from sharktank..data

select 'Ashnner' as keyy,count(ashneeramountinvested) from sharktank..data where ashneeramountinvested is not null


select 'Ashnner' as keyy,count(ashneeramountinvested) from sharktank..data where ashneeramountinvested is not null AND ashneeramountinvested!=0

SELECT 'Ashneer' as keyy,SUM(C.ASHNEERAMOUNTINVESTED),AVG(C.ASHNEEREQUITYTAKENP) 
FROM (SELECT * FROM sharktank..DATA  WHERE ASHNEEREQUITYTAKENP!=0 AND ASHNEEREQUITYTAKENP IS NOT NULL) C


select m.keyy,m.total_deals_present,m.total_deals,n.total_amount_invested,n.avg_equity_taken from

(select a.keyy,a.total_deals_present,b.total_deals from(

select 'Ashneer' as keyy,count(ashneeramountinvested) total_deals_present from sharktank..data where ashneeramountinvested is not null) a

inner join (
select 'Ashneer' as keyy,count(ashneeramountinvested) total_deals from sharktank..data 
where ashneeramountinvested is not null AND ashneeramountinvested!=0) b 

on a.keyy=b.keyy) m

inner join 

(SELECT 'Ashneer' as keyy,SUM(C.ASHNEERAMOUNTINVESTED) total_amount_invested,
AVG(C.ASHNEEREQUITYTAKENP) avg_equity_taken
FROM (SELECT * FROM sharktank..DATA  WHERE ASHNEEREQUITYTAKENP!=0 AND ASHNEEREQUITYTAKENP IS NOT NULL) C) n

on m.keyy=n.keyy

-- which is the startup in which the highest amount has been invested in each domain/sector




select c.* from 
(select brand,sector,amountinvestedlakhs,rank() over(partition by sector order by amountinvestedlakhs desc) rnk 

from sharktank..data) c

where c.rnk=1