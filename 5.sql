-- 1. Создайте представление, в которое попадет информация о  пользователях (имя, фамилия, город и пол), 
-- которые не старше 20 лет.

CREATE
OR REPLACE VIEW users_below_20 AS
SELECT
    users.firstname,
    users.lastname,
    profiles.hometown,
    profiles.gender
FROM
    users
    JOIN profiles ON users.id = profiles.user_id
WHERE
    TIMESTAMPDIFF(YEAR, profiles.birthday, curdate()) <= 20;
-- 2. Найдите кол-во,  отправленных сообщений каждым пользователем и  выведите ранжированный список пользователей,
-- указав имя и фамилию пользователя, 
-- количество отправленных сообщений и место в рейтинге (первое место у пользователя с 
-- максимальным количеством сообщений) . (используйте DENSE_RANK)

SELECT
    users.firstname,
    users.lastname,
    COUNT(messages.from_user_id) as count_msg,
    DENSE_RANK() OVER (
        ORDER BY
            count_msg DESC
    )
FROM
    users
    JOIN messages ON users.id = messages.from_user_id
GROUP BY
    messages.from_user_id;
-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и 
-- найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)

SELECT
    *,
    UNIX_TIMESTAMP(
        LEAD(created_at, 1) OVER (
            ORDER BY
                created_at
        )
    ) - UNIX_TIMESTAMP(created_at)
FROM
    messages;