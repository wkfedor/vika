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
