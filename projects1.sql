select *
from Projects..hotels

--checking if 2020 data is available till december or not

select arrival_date_month
from Projects..['2020']
group by arrival_date_month


--Check if the hotel revenue growing per year

select *
from Projects..hotels

select arrival_date_year,hotel, round(sum((stays_in_weekend_nights+stays_in_week_nights)*adr),0) as revenue
from Projects..hotels
group by arrival_date_year,hotel
order by 1,2

--But we have to consider the discounts too
--lets join these three tables together

select *
from Projects..hotels
left join Projects..market_segment
on hotels.market_segment=market_segment.market_segment
left join Projects..meal_cost
on hotels.meal=meal_cost.meal


--Now calculate the revenue(excluding meal cost)

select arrival_date_year,hotel,round(sum((stays_in_weekend_nights+stays_in_week_nights)*adr*(1-Discount)),0) as revenue
from Projects..hotels
left join Projects..market_segment
on hotels.market_segment=market_segment.market_segment
left join Projects..meal_cost
on hotels.meal=meal_cost.meal
group by arrival_date_year,hotel
order by 1,2







