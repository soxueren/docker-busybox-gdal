FROM debian:stretch-slim

#增加apt代理
#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

# 安装gdal相关库gdal-bin libgdal-dev netcdf-bin libnetcdf-dev 
RUN  apt-get update && apt-get install -y --no-install-recommends \      
         gdal-bin \	
	 netcdf-bin \
	 libgdal-dev \
	 libnetcdf-dev \
	 && rm -rf /var/lib/apt/lists/*
 
CMD ["python2"]
