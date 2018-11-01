### 1.下载DEM数据
下载地址：[www.gscloud.cn](http://www.gscloud.cn/)，使用高级检索，根据实际需求，下载不同精度的DEM数据
### 2.[gdal_merge](https://www.gdal.org/1.11/gdal_merge.html)或[gdalwarp](https://www.gdal.org/1.11/gdalwarp.html)合并栅格
```
# gdal_merge合并
gdal_merge.bat -ot Float32 -of GTiff -o ./OUTPUT.tif in1.tif in2.tif in3*.tif
# gdalwarp合并有自动填充nodata选项和自动插值功能，可以省略第三步骤
gdalwarp -s_srs EPSG:4326 -t_srs EPSG:4326 -dstnodata 0.0 -r bilinear -ot Float32 -of GTiff G:/GIS/data/terrain/tif/*.tif  G:/GIS/data/terrain/result/dem.tif
```
```
gdalwarp [--help-general] [--formats]
    [-s_srs srs_def] [-t_srs srs_def] [-to "NAME=VALUE"]
    [-order n | -tps | -rpc | -geoloc] [-et err_threshold]
    [-refine_gcps tolerance [minimum_gcps]]
    [-te xmin ymin xmax ymax] [-tr xres yres] [-tap] [-ts width height]
    [-wo "NAME=VALUE"] [-ot Byte/Int16/...] [-wt Byte/Int16]
    [-srcnodata "value [value...]"] [-dstnodata "value [value...]"] -dstalpha
    [-r resampling_method] [-wm memory_in_mb] [-multi] [-q]
    [-cutline datasource] [-cl layer] [-cwhere expression]
    [-csql statement] [-cblend dist_in_pixels] [-crop_to_cutline]
    [-of format] [-co "NAME=VALUE"]* [-overwrite]
    [-nomd] [-cvmd meta_conflict_value] [-setci]
    srcfile* dstfile  
```
### 3.[gdal_fillnodata](https://www.gdal.org/1.11/gdal_fillnodata.html)填充nodata
```
gdal_fillnodata -md 10 -b 1  -of GTiff ./ASTGTM2_N43E084_dem.tif ./OUTPUT.tif
```
### 4.[gdal2cesium.py](https://github.com/giohappy/gdal2cesium) 切片
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
  ```
  # 直接用下载下来的栅格数据生成地形瓦片
  gdal2cesium.py -r bilinear  -o ./srtm G:/GIS/data/terrain/rasters/*.tif
  
  ```
### 5.使用[web服务器](https://github.com/soxueren/docker-busybox-gdal/blob/gdal2cesium/server.js)发布地形瓦片（设置跨域）
```
 var app = express();
	//设置跨域访问
	app.all('*', function(req, res, next) {
	res.header("Access-Control-Allow-Origin", "*");
	res.header("Access-Control-Allow-Headers", "X-Requested-With");
	res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
	res.header("X-Powered-By",' 3.2.1');
	res.header("Content-Type", "application/json;charset=utf-8");
	next();
	});
    app.use(compression());
    app.use(express.static(__dirname));
```
