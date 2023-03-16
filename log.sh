
cd ./infrastructure
nohup pnpm start > infrastructure.log &
echo "Infrastructure log service started!"


cd ..
echo "" > frontend.log
nohup pnpm dev > frontend.log &
echo "Frontend log service started!"
tail -f frontend.log
