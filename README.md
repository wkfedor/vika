# README
создать 2 базы данных
sudo -i -u postgres
psql
CREATE DATABASE vika_development;
CREATE DATABASE vika_test;
\l
выполнить только 1
rails db:migrate VERSION=20230410123456
откатить только 1
rails db:migrate:down VERSION=20230410123456
выполнить миграции
bin/rails db:migrate RAILS_ENV=development

запустить миграцию данных rake data:migrate
откатить rake data:rollback VERSION=20241020150101
удалить и создать заново rails db:migrate:reset
-----------------------------------------------------------------------------------план работ #todo
1) из папки работа создай данные для работы
1.1) создай выгрузку для таблицы группы
1.2) создай проект с новыми методами
1.3) создай новые методы
1.4) добавит выгрузку в groups_in_out
1.5) проверить работу от получения разных сообщений которые есть в работе и которых нет что будут запускать нужные и не нужные
1.6) запуск вывода данных в зенопостер
2) как передавать между зенопостером и руби и между руби и зенопосетром фото?
