
docker kill utility-vm
docker build -t antidotelabs/utility-vm .
docker run --name utility-vm --rm -d -p 5900:5900 -p 2022:22 antidotelabs/utility-vm
docker exec -it utility-vm /bin/bash


# docker push antidotelabs/utility-vm


