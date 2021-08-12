containerName = SimpleBank_DB
dbName = simple_bank

db_service:
	# 启动postgres容器
	docker run -d -p 5432:5432 --name $(containerName) -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret postgres:12-alpine

createdb:
	# 创建项目所属数据库 “$(dbName)”
	docker exec -it $(containerName) createdb --username=root --owner=root $(dbName)

dropdb:
	# 删除数据库
	docker exec -it $(containerName) dropdb $(dbName)

migratedbup:
	# 迁移数据
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/$(dbName)?sslmode=disable" -verbose up

migratedbdown:
	# 回退数据
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/$(dbName)?sslmode=disable" -verbose down

sqlc:
	# sqlc generate
	sqlc generate

.PHONY: db_service createdb dropdb migratedbup migratedbdown sqlc