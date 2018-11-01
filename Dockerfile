FROM debian:stretch-slim

#增加apt代理

#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng
RUN  apt-get update && apt-get install -y --no-install-recommends \
     gdal-bin \
	 libgdal-dev

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

RUN apt-get install -y --no-install-recommends \
     python-gdal \
	 python3-gdal \
	 python-shapely \
     && rm -rf /var/lib/apt/lists/*

ADD gdal2cesium/gdal2cesium.py /usr/bin/gdal2cesium.py
RUN chmod +x /usr/bin/gdal2cesium.py

#RUN gdal2cesium.py

CMD ["/usr/bin/gdal2cesium.py","--help"]

