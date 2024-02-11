mysql> create database shop;
Query OK, 1 row affected (0.00 sec)

mysql> use shop;
Database changed

mysql> create table tovar(
    -> tovar_id INT PRIMARY KEY AUTO_INCREMENT,
    -> tovar_name VARCHAR(64),
    -> price DECIMAL(12, 2),
    -> bonus INT
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE TABLE user(
    -> user_id INT PRIMARY KEY AUTO_INCREMENT,
    -> user_name VARCHAR(64),
    -> user_surname VARCHAR(64),
    -> user_number VARCHAR(64),
    -> user_mail VARCHAR(64)
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE TABLE adres(
    -> adress_id INT PRIMARY KEY AUTO_INCREMENT,
    -> gorod VARCHAR(64),
    -> street VARCHAR(64),
    -> dom VARCHAR(64),
    -> kvartira VARCHAR(64)
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE TABLE user_adres(
    -> adress_id INT,
    -> user_id INT,
    -> FOREIGN KEY (adress_id) REFERENCES adres(adress_id),
    -> FOREIGN KEY (user_id) REFERENCES user(user_id)
    -> );
Query OK, 0 rows affected (0.17 sec)


mysql> INSERT INTO tovar(tovar_name, price, bonus) VALUES
    -> ("Омега 3 Апельсина", 680.00, 5),
    -> ("Липосомальный Витамин С", 1275.00, 8),
    -> ("Корал Лецитин", 1785.00, 15)
    -> ;
Query OK, 3 rows affected (0.00 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO user(user_name, user_surname, user_number, user_mail) VALUES
    -> ("Сидоров", "П.", "+79256667711", "sidorov@example.ru");
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO adres(gorod, street, dom, kvartira) values
    -> ("Москва", "Центральная", "8", "12");
Query OK, 1 row affected (0.00 sec)



mysql> CREATE TABLE zakaz(
    -> zakaz_id INT PRIMARY KEY,
    -> tovar_id INT,
    -> kolvo INT,
    -> user_id INT,
    -> FOREIGN KEY (tovar_id) REFERENCES tovar(tovar_id),
    -> FOREIGN KEY (user_id) REFERENCES user(user_id)
    -> );
Query OK, 0 rows affected (0.02 sec)
mysql> INSERT INTO zakaz (zakaz_id, tovar_id, kolvo, user_id)
    -> VALUES
    ->     (1, 3, 1, 1),
    ->     (2, 2, 1, 1);
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> SELECT user.user_name, user.user_surname, tovar.tovar_name, tovar.price, tovar.bonus, SUM(tovar.price) OVER () AS ОбщаяЦена, SUM(tovar.bonus) OVER () as Общийбонус
    -> FROM zakaz
    -> JOIN tovar ON zakaz.tovar_id = tovar.tovar_id
    -> JOIN user ON user.user_id = zakaz.user_id
    -> GROUP BY user.user_name, user.user_surname, tovar.tovar_name, tovar.price, tovar.bonus;
+-----------+--------------+-------------------------+---------+-------+-----------+------------+
| user_name | user_surname | tovar_name              | price   | bonus | ОбщаяЦена | Общийбонус |
+-----------+--------------+-------------------------+---------+-------+-----------+------------+
| Сидоров   | П.           | Липосомальный Витамин С | 1275.00 |     8 |   3060.00 |         23 |
| Сидоров   | П.           | Корал Лецитин           | 1785.00 |    15 |   3060.00 |         23 |
+-----------+--------------+-------------------------+---------+-------+-----------+------------+
2 rows in set (0.00 sec)
