### 1.下载DEM数据，下载地址：[www.gscloud.cn](http://www.gscloud.cn/)，使用高级检索，根据实际需求，下载不同精度的DEM数据
### 2.gdal_merge合并栅格
### 3.gdal_fillnodata填充nodata
### 4.gdal2cesium.py -o srtm /data/terrain/rasters/dest.tif
### 5.使用soxueren/tomcat:8.5-jre8-apline发布地形瓦片（已经设置好tomcat跨域）
