# docker build -f Dockerfile -t antidotelabs/vqfx .

# docker run -p 2202:22 --privileged --rm --name vqfx -v /Users/mierdin/Code/GO/src/github.com/nre-learning/antidote/images/vqfx:/dockervolume antidotelabs/vqfx

# docker push antidotelabs/vqfx


docker build -f Dockerfile-snap1 -t antidotelabs/vqfx:snap1 .
docker build -f Dockerfile-snap2 -t antidotelabs/vqfx:snap2 .
docker build -f Dockerfile-snap3 -t antidotelabs/vqfx:snap3 .

docker push antidotelabs/vqfx
