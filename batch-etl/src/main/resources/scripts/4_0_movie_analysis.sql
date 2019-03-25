
-- 1、一部电影或者好几部电影的平均评分是多少？
SELECT movie_id, ROUND(AVG(rating), 1) AS rating FROM user_rating_fact GROUP BY movie_id;

-- 2、本周的趋势是什么样的？也就是说从本周开始哪些电影的评分有增长
WITH currentWeekMovieRating as (
  SELECT movie_id, max(rating) as rating FROM user_rating
  WHERE year(dt_time) = year(current_date) AND weekofyear(dt_time) = weekofyear(current_date)
  GROUP BY movie_id),
previousWeekMovieRating as (
  SELECT movie_id, max(rating) as rating FROM user_rating_history
  WHERE year(dt_time) != year(current_date) AND weekofyear(dt_time) != weekofyear(current_date)
  GROUP BY movie_id
)
SELECT t1.movie_id FROM currentWeekMovieRating t1 LEFT JOIN previousWeekMovieRating t2 ON t1.movie_id = t2.movie_id
WHERE (t1.rating - COALESCE(t2.rating, 0)) > 0;


-- 3、给电影Dead Man Walking(1995)评分在3分或者3分以上的用户中，21岁到30岁的女性用户占多少比例
WITH t1 as (SELECT id FROM movie WHERE title = "Dead Man Walking (1995)"),
t2 as (
  SELECT users.gender as gender, users.age as age FROM user_rating_fact
  JOIN t1 ON user_rating_fact.movie_id = t1.id
  JOIN users ON user_rating_fact.user_id=users.id
  WHERE user_rating_fact.rating >= 3),
t3 as(SELECT COUNT(*) as cnt FROM t2),
t4 as (SELECT COUNT(*) as cnt FROM t2 WHERE t2.age BETWEEN 21 AND 30 AND t2.gender = 'F')
SELECT ROUND(t4.cnt / t3.cnt, 2) FROM t3, t4;

-- 4、在三个月内更新了同一部电影的评分的用户数的占比是多少？
set hive.strict.checks.cartesian.product=false;
WITH t1 as (
  select user_id, movie_id FROM user_rating
  WHERE dt_time BETWEEN ADD_MONTHS(CURRENT_DATE, -3)
  AND CURRENT_DATE GROUP BY user_id, movie_id HAVING count(*) > 1),
t2 as (SELECT COUNT(*) as allCnt FROM users),
t3 as (SELECT COUNT(DISTINCT(user_id)) as cnt FROM t1)
select t3.cnt / t2.allCnt FROM t2, t3;

