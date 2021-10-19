FROM golang:1.17.2 as build

WORKDIR /app

COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY cmd cmd
COPY pkg pkg

RUN CGO_ENABLED=0 GOOS=linux go build -o /app/bin/debug -installsuffix cgo -ldflags '-w -s' ./cmd/debug

FROM alpine:3.14

RUN apk --no-cache add ca-certificates tzdata

COPY --from=build /app/cmd /app/cmd
COPY --from=build /app/pkg /app/pkg
COPY --from=build /app/bin /usr/local/bin

CMD ["debug"]
