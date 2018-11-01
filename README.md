### 1.下载DEM数据，下载地址：[www.gscloud.cn](http://www.gscloud.cn/)，使用高级检索，根据实际需求，下载不同精度的DEM数据
### 2.gdal_merge或gdalwarp合并栅格
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
    
-s_srs srs def:
source spatial reference set. The coordinate systems that can be passed are anything supported by the OGRSpatialReference.SetFromUserInput() call, which includes EPSG PCS and GCSes (ie. EPSG:4296), PROJ.4 declarations (as above), or the name of a .prf file containing well known text.
-t_srs srs_def:
target spatial reference set. The coordinate systems that can be passed are anything supported by the OGRSpatialReference.SetFromUserInput() call, which includes EPSG PCS and GCSes (ie. EPSG:4296), PROJ.4 declarations (as above), or the name of a .prf file containing well known text.
-to NAME=VALUE:
set a transformer option suitable to pass to GDALCreateGenImgProjTransformer2().
-order n:
order of polynomial used for warping (1 to 3). The default is to select a polynomial order based on the number of GCPs.
-tps:
Force use of thin plate spline transformer based on available GCPs.
-rpc:
Force use of RPCs.
-geoloc:
Force use of Geolocation Arrays.
-et err_threshold:
error threshold for transformation approximation (in pixel units - defaults to 0.125).
-refine_gcps tolerance minimum_gcps:
(GDAL >= 1.9.0) refines the GCPs by automatically eliminating outliers. Outliers will be eliminated until minimum_gcps are left or when no outliers can be detected. The tolerance is passed to adjust when a GCP will be eliminated. Not that GCP refinement only works with polynomial interpolation. The tolerance is in pixel units if no projection is available, otherwise it is in SRS units. If minimum_gcps is not provided, the minimum GCPs according to the polynomial model is used.
-te xmin ymin xmax ymax:
set georeferenced extents of output file to be created (in target SRS).
-tr xres yres:
set output file resolution (in target georeferenced units)
-tap:
(GDAL >= 1.8.0) (target aligned pixels) align the coordinates of the extent of the output file to the values of the -tr, such that the aligned extent includes the minimum extent.
-ts width height:
set output file size in pixels and lines. If width or height is set to 0, the other dimension will be guessed from the computed resolution. Note that -ts cannot be used with -tr
-wo "NAME=VALUE":
Set a warp options. The GDALWarpOptions::papszWarpOptions docs show all options. Multiple -wo options may be listed.
-ot type:
For the output bands to be of the indicated data type.
-wt type:
Working pixel data type. The data type of pixels in the source image and destination image buffers.
-r resampling_method:
Resampling method to use. Available methods are:
near:
nearest neighbour resampling (default, fastest algorithm, worst interpolation quality).
bilinear:
bilinear resampling.
cubic:
cubic resampling.
cubicspline:
cubic spline resampling.
lanczos:
Lanczos windowed sinc resampling.
average:
average resampling, computes the average of all non-NODATA contributing pixels. (GDAL >= 1.10.0)
mode:
mode resampling, selects the value which appears most often of all the sampled points. (GDAL >= 1.10.0)
-srcnodata value [value...]:
Set nodata masking values for input bands (different values can be supplied for each band). If more than one value is supplied all values should be quoted to keep them together as a single operating system argument. Masked values will not be used in interpolation. Use a value of None to ignore intrinsic nodata settings on the source dataset.
-dstnodata value [value...]:
Set nodata values for output bands (different values can be supplied for each band). If more than one value is supplied all values should be quoted to keep them together as a single operating system argument. New files will be initialized to this value and if possible the nodata value will be recorded in the output file. Use a value of None to ensure that nodata is not defined (GDAL>=2.0). If this argument is not used then nodata values will be copied from the source dataset (GDAL>=2.0).
-dstalpha:
Create an output alpha band to identify nodata (unset/transparent) pixels.
-wm memory_in_mb:
Set the amount of memory (in megabytes) that the warp API is allowed to use for caching.
-multi:
Use multithreaded warping implementation. Multiple threads will be used to process chunks of image and perform input/output operation simultaneously.
-q:
Be quiet.
-of format:
Select the output format. The default is GeoTIFF (GTiff). Use the short format name.
-co "NAME=VALUE":
passes a creation option to the output format driver. Multiple -co options may be listed. See format specific documentation for legal creation options for each format.

-cutline datasource:
Enable use of a blend cutline from the name OGR support datasource.
-cl layername:
Select the named layer from the cutline datasource.
-cwhere expression:
Restrict desired cutline features based on attribute query.
-csql query:
Select cutline features using an SQL query instead of from a layer with -cl.
-cblend distance:
Set a blend distance to use to blend over cutlines (in pixels).
-crop_to_cutline:
(GDAL >= 1.8.0) Crop the extent of the target dataset to the extent of the cutline.
-overwrite:
(GDAL >= 1.8.0) Overwrite the target dataset if it already exists.
-nomd:
(GDAL >= 1.10.0) Do not copy metadata. Without this option, dataset and band metadata (as well as some band information) will be copied from the first source dataset. Items that differ between source datasets will be set to * (see -cvmd option).
-cvmd meta_conflict_value:
(GDAL >= 1.10.0) Value to set metadata items that conflict between source datasets (default is "*"). Use "" to remove conflicting items.
-setci:
(GDAL >= 1.10.0) Set the color interpretation of the bands of the target dataset from the source dataset.

srcfile:
The source file name(s).
dstfile:
The destination file name.    
```
### 3.gdal_fillnodata填充nodata
```
gdal_fillnodata -md 10 -b 1  -of GTiff ./ASTGTM2_N43E084_dem.tif ./OUTPUT.tif
```
### 4.[gdal2cesium.py](https://github.com/giohappy/gdal2cesium) -o G:/GIS/data/terrain/srtm G:/GIS/data/terrain/result/dem.tif
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
### 5.使用web服务器发布地形瓦片（设置好跨域）
