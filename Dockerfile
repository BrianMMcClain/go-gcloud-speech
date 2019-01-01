# docker run -e GOOGLE_APPLICATION_CREDENTIALS=/certs/key.json -v /PATH/TO/key.json:/certs -p 8080:8080  brianmmcclain/go-gcloud-speech

# curl -XPOST -H "Content-Type:audio/x-flac" localhost:8080 --data-binary '@recording.flac'

FROM golang:1.11.4-alpine3.8 as builder

RUN apk --update --no-cache add \
    ca-certificates \
    git \
    libc6-compat

WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./... && \
    go build




FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /app
COPY --from=builder /go/src/app/app /app/app

EXPOSE 8080
ENTRYPOINT ["./app"]