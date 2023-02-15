FROM golang:1.14-buster AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM ubuntu:20.04

LABEL maintainer "BCADET"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tigervnc-standalone-server \
    supervisor \
    bspwm
    

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
EXPOSE 8080

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libglib2.0-0 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libgtk3-perl \
    libgbm1 \
    libasound2 \
    libfuse2
# COPY Logic-2.4.4-master.AppImage /Logic.AppImage
ADD https://logic2api.saleae.com/download?os=linux /Logic.AppImage
RUN chmod +x /Logic.AppImage

CMD ["supervisord" ]
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y pulseview