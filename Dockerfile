FROM golang:1.17-alpine as builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 go build -o /api-app


FROM alpine:latest

RUN \
  apk add --update bash supervisor inotify-tools && \
  rm -rf /var/cache/apk/*

COPY --from=builder /api-app /api-app

ENV PORT="80"

EXPOSE 9999

ENTRYPOINT ["/api-app"]