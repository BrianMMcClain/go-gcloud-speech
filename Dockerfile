# This is poorly written =\

# docker run -e GOOGLE_APPLICATION_CREDENTIALS=/certs/key.json -v /PATH/TO/key.json:/certs -p 8080:8080  go-gcloud-speech

# curl -XPOST -H "Content-Type:audio/x-flac" localhost:8080 --data-binary '@recording.flac'

FROM golang:1.11.4-alpine3.8

RUN apk --update --no-cache add \
    ca-certificates \
    git \
    libc6-compat

WORKDIR /app

COPY . /app
RUN go get -u cloud.google.com/go/speech/apiv1 && \
    go get -u google.golang.org/genproto/googleapis/cloud/speech/v1 && \
    go build

EXPOSE 8080
ENTRYPOINT ["./app"]