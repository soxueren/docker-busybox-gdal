### 1.下载DEM数据，下载地址：[www.gscloud.cn](http://www.gscloud.cn/)，使用高级检索，根据实际需求，下载不同精度的DEM数据
### 2.gdal_merge或gdalwarp合并栅格
```
#gdal_merge合并
gdal_merge.py -init 255 -o G:/GIS/data/terrain/result/dem.tif G:/GIS/data/terrain/tif/*.tif 
#gdalwarp合并有自动填充nodata选项和自动插值功能，可以省略第三步骤
gdalwarp -s_srs EPSG:4326 -t_srs EPSG:4326 -dstnodata 0.0 -r bilinear -ot Float32 -of GTi
ff G:/GIS/data/terrain/tif/*.tif  G:/GIS/data/terrain/result/dem.tif
```
### 3.gdal_fillnodata填充nodata
### 4.gdal2cesium.py -o G:/GIS/data/terrain/srtm G:/GIS/data/terrain/result/dem.tif
### 5.使用web服务器发布地形瓦片（设置好跨域）
