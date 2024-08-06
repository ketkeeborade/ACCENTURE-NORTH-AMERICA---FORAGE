create database social;
set SQL_SAFE_UPDATES = 0;
select * from reactions;
select * from rt;
select * from content;
select count(*) from reactions;
ALTER TABLE reactions RENAME COLUMN `Content ID` TO Contentid;
ALTER TABLE content RENAME COLUMN `Type` TO CType;
ALTER TABLE reactions RENAME COLUMN `Type` TO RType;

select r.Contentid, r.RType, `Datetime`, CType, Category, Score, Sentiment from content c
right join reactions r
on r.Contentid = c.Contentid
join rt
on r.RType = rt.RType;

create table final
(
select r.Contentid, r.RType, `Datetime`, CType, Category, Score, Sentiment from content c
right join reactions r
on r.Contentid = c.Contentid
join rt
on r.RType = rt.RType
);

select * from final;
select distinct RType from final;
select distinct RType from final;
select distinct CType from final;
select distinct Category from final;
update final
set Category = replace(category,'"','');
ALTER TABLE final  
MODIFY `Datetime` date;

#--------------------------IMPORTANT VALUES---------------------------------------------------------
select count(contentid) as Contents from final;
select count(distinct category) as Total_Category from final;
select distinct Sentiment as Sentiments from final;
select distinct rtype from final;
select distinct ctype from final;
select distinct year(`datetime`) `Year` from final;


#-------------------------------- TOP 5 CATEGORIES BY SCORE --------------------------------------
select Category, sum(score) as Score from final
group by Category
order by Score desc
limit 5;

#------------------------- TOP 5 CATEGORIES BY HIGEST PERCENT OF SCORE  -------------------
select sum(Category_sum) as sct5
from (
select Category, sum(score) as Category_sum
from final
group by Category
order by Category_sum desc
limit 5
)
as abc;

select Category,concat(round((Category_sum/q2)*100,2),"%") as percent
from
(select Category,sum(score) as Category_sum,
(select sum(Category_sum) from
(select sum(score) as Category_sum
from final
group by Category
order by Category_sum desc
limit 5) as q1) as q2
from final
group by Category
order by Category_sum desc
limit 5 )
as done;

#-----------------------------------POSTS BY SENTIMENTS-------------------------------------
select sentiment, count(contentid) as Posts from final
group by Sentiment
order by posts desc;

#-----------------------------------POSTS BY CONTENT TYPE-------------------------------------
select CType, count(contentid) as Posts from final
group by CType
order by posts desc;

#----------------------NUMBER OF POSTS BY MONTH----------------------------------------------
select monthname(`datetime`) as Months, count(contentid) as Posts
from final
group by Months
order by posts desc;

#----------------------NUMBER OF POSTS BY YEAR----------------------------------------------
select year(`datetime`) as `Year`, count(contentid) as Posts
from final
group by `Year`
order by posts desc;



















