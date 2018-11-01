FROM soxueren/busybox-gdal:2.7-slim

#增加apt代理
#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng
# 安装gdal相关库gdal-bin libgdal-dev netcdf-bin libnetcdf-dev 
RUN  pip install numpy Pillow GDAL Shapely
   
ADD gdal2cesium/gdal2cesium.py /usr/bin/gdal2cesium.py
RUN chmod +x /usr/bin/gdal2cesium.py

CMD ["/usr/bin/gdal2cesium.py","--help"]

