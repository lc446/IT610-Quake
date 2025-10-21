FROM ubuntu
RUN apt update -y
# Installing the latest packages
RUN apt install wget unzip file libcurl4 -y

# Getting the latest mvdsv linux release
RUN wget -qO /tmp/server "https://github.com/QW-Group/mvdsv/releases/latest/download/mvdsv_linux_amd64"

RUN mkdir -p /quake/id1/maps

# Getting the latest ktx linux release
WORKDIR /tmp
RUN wget -qO /tmp/qwprogs.zip "https://github.com/QW-Group/ktx/releases/latest/download/qwprogs-linux-amd64.zip"

RUN mv /tmp/qwprogs.zip /quake/id1
WORKDIR /quake
RUN unzip /quake/id1/qwprogs.zip

# I don't have the greatest idea why, but unzip moves qwprogs.so up a directory, so you need to pull from /quake instead of /quake/id1
RUN mv /quake/qwprogs.so /quake/id1/qwprogs.so

#LOWERCASE PAK NEEDED BECAUSE LINUX!!
COPY ./id1/pak* /quake/id1
COPY ./id1/server.cfg /quake/id1

# copies all maps over, be sure to change your server.cfg to specify the one you want loaded on start up
COPY ./id1/maps /quake/id1/maps

RUN mv /tmp/server /quake
RUN chmod +x /quake/server

EXPOSE 27500/UDP

CMD ["/quake/server"]
