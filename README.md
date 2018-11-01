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
```
Usage: gdal2cesium.py [options] input_file(s)

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -s S_SRS, --s_srs=S_SRS
                        Define input raster CRS (eg EPSG:3003)
  -z ZOOM, --zoom=ZOOM  Zoom levels to render (format:'2-5' or '10').
  -r RESAMPLING, --resampling=RESAMPLING
                        Resampling method
                        (average,near,bilinear,cubic,cubicspline,lanczos) -
                        default 'average'
  -e, --resume          Resume mode. Generate only missing files.
  -v, --verbose         Print status messages to stdout
  -o OUTPUT, --o_dir=OUTPUT
                        Root output directory
  -i, --index           Create the shapefile of tiles index (True or False)
  -k, --keep            Keep temporary files reated by gdal2cesium
  ```
### 5.使用web服务器发布地形瓦片（设置好跨域）
