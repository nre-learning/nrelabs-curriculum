docker build -f Dockerfile-snap1 -t antidotelabs/vqfxspeedy:snap1 .
docker build -f Dockerfile-snap2 -t antidotelabs/vqfxspeedy:snap2 .
docker build -f Dockerfile-snap3 -t antidotelabs/vqfxspeedy:snap3 .

docker push antidotelabs/vqfxspeedy
