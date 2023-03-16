
cd ./infrastructure
nohup pnpm start > infrastructure.log &
echo "Start infrastructure complete!"


cd ..
echo "" > front.log
nohup pnpm dev > front.log &
echo "Start front complete!"
tail -f front.log
