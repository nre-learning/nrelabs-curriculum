FROM gnmic/gnmic:0.9.0 as source

FROM antidotelabs/utility
COPY --from=source /app/gnmic /usr/bin
