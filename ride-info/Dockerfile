FROM golang:alpine
WORKDIR /app

ENV APP=/go/src/github.com/sumlare/microservices/ride-info

ADD . $APP
RUN cd $APP && go build -o app && cp app /app/

EXPOSE 8000
ENTRYPOINT ["./app"]
