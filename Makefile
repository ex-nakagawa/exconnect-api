
# 1.dockerで使用するネットワークを作成（ネットワーク名：XEEX-EXC-Network）
docker-net:
	docker network create -d bridge XEEX-EXC-Network

# 2.DynamoDB-local用のコンテナ作成（コンテナ名：dynamodb）
docker-create:
	docker run --network XEEX-EXC-Network --name XEEX-EXC-Dynamodb -p 8000:8000 amazon/dynamodb-local -jar DynamoDBLocal.jar -sharedDb

# 3.dynamodbコンテナを実行（バックグラウンド実行）
docker-start:
	docker start XEEX-EXC-Dynamodb 

# 4.テーブル作成 （作成テーブル：例 XEEX-EXC-Data）
create:
	aws dynamodb create-table --cli-input-json file://./db/${table}.json --endpoint-url http://localhost:8000

# 5.ビルド
build:
	sam build

# 6.Lambda・APIゲートウェイ起動
start:
	sam local start-api --docker-network XEEX-EXC-Network

# テーブル削除（作成テーブル：例 XEEX-EXC-Data）
delete:
	aws dynamodb delete-table --table-name ${table} --endpoint-url http://localhost:8000

# XEEX-EXC-Dynamodbコンテナを削除
clean:
	docker stop XEEX-EXC-Dynamodb 
	docker rm XEEX-EXC-Dynamodb 
