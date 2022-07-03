FROM crystallang/crystal:1-alpine as builder
WORKDIR /src
COPY dotenv.cr .
RUN crystal build --release --static dotenv.cr

FROM alpine:latest
COPY --from=builder /src/dotenv /usr/bin/
CMD ["/usr/bin/dotenv"]
