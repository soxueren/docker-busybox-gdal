##
# osgeo/gdal:alpine-normal

# This file is available at the option of the licensee under:
# Public domain
# or licensed under X/MIT (LICENSE.TXT) Copyright 2019 Even Rouault <even.rouault@spatialys.com>
#osgeo/gdal:alpine-small-v2.5.0RC1
ARG ALPINE_VERSION=3.9
FROM alpine:${ALPINE_VERSION} as builder
# Setup build env for PROJ
RUN apk add --no-cache wget curl unzip -q make libtool autoconf automake pkgconfig g++ sqlite sqlite-dev

# For GDAL
RUN apk add --no-cache \
    linux-headers \
    curl-dev \
    zlib-dev zstd-dev \
    libjpeg-turbo-dev libpng-dev openjpeg-dev libwebp-dev expat-dev \
    py-numpy-dev python2-dev py2-numpy \
    poppler-dev postgresql-dev swig

# For spatialite (and GDAL)
RUN apk add --no-cache libxml2-dev 

ARG PROJ_VERSION=4.9.3
# Build PROJ
RUN mkdir proj \
    && wget -q https://github.com/OSGeo/PROJ/archive/${PROJ_VERSION}.tar.gz -O - \
        | tar xz -C proj --strip-components=1 \
    && cd proj \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-static --enable-lto \
    && make -j$(nproc) \
    && make install \
    && make install DESTDIR="/build_proj" \
    && cd .. \
    && rm -rf proj \
    && for i in /build_proj/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build_proj/usr/bin/*; do strip -s $i 2>/dev/null || /bin/true; done
    
# Build xerces-c
ENV XERCESC_VERSION=3.2.3
RUN wget -q http://mirror.ibcp.fr/pub/apache/xerces/c/3/sources/xerces-c-${XERCESC_VERSION}.zip  \
    && unzip -q xerces-c-${XERCESC_VERSION}.zip  \
    && rm -f xerces-c-${XERCESC_VERSION}.zip \
    && cd xerces-c-${XERCESC_VERSION} \
    && ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /build_thirdparty/usr/lib \
    && cp -P /usr/lib/libxerces-c*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf xerces-c-${XERCESC_VERSION}

# Build geos
ENV GEOS_VERSION=3.7.1
RUN wget -q http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 \
    && tar xjf geos-${GEOS_VERSION}.tar.bz2  \
    && rm -f geos-${GEOS_VERSION}.tar.bz2 \
    && cd geos-${GEOS_VERSION} \
    && ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /build_thirdparty/usr/lib \
    && cp -P /usr/lib/libgeos*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf geos-${GEOS_VERSION}

ENV SZIP_VERSION=2.1.1
# Build szip
RUN wget -q https://support.hdfgroup.org/ftp/lib-external/szip/${SZIP_VERSION}/src/szip-${SZIP_VERSION}.tar.gz \
    && tar xzf szip-${SZIP_VERSION}.tar.gz \
    && rm -f szip-${SZIP_VERSION}.tar.gz \
    && cd szip-${SZIP_VERSION} \
    && CFLAGS=-O2 ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /build_thirdparty/usr/lib \
    && cp -P /usr/lib/libsz*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf szip-${SZIP_VERSION}

ENV HDF5_VERSION=1.10.5
# Build hdf5
RUN wget -q https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION%.*}/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz \
    && tar xzf hdf5-${HDF5_VERSION}.tar.gz \
    && rm -f hdf5-${HDF5_VERSION}.tar.gz \
    && cd hdf5-${HDF5_VERSION} \
    && CFLAGS=-O2 ./configure --prefix=/usr --disable-static --with-szlib=/usr \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /build_thirdparty/usr/lib \
    && cp -P /usr/lib/libhdf5*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf hdf5-${HDF5_VERSION}

ENV NETCDF_VERSION=4.6.3
# Build netCDF
RUN wget -q https://github.com/Unidata/netcdf-c/archive/v${NETCDF_VERSION}.tar.gz \
    && tar xzf v${NETCDF_VERSION}.tar.gz \
    && rm -f v${NETCDF_VERSION}.tar.gz \
    && cd netcdf-c-${NETCDF_VERSION} \
    && CFLAGS=-O2 ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /build_thirdparty/usr/lib \
    && cp -P /usr/lib/libnetcdf*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf netcdf-c-${NETCDF_VERSION}

ENV FREEXL_VERSION=1.0.5
# Build freexl
RUN wget -q http://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-${FREEXL_VERSION}.tar.gz \
    && tar xzf freexl-${FREEXL_VERSION}.tar.gz \
    && rm -f freexl-${FREEXL_VERSION}.tar.gz \
    && cd freexl-${FREEXL_VERSION} \
    && ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /build_thirdparty/usr/lib \
    && cp -P /usr/lib/libfreexl*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf freexl-${FREEXL_VERSION}

ENV SPATIALITE_VERSION=4.3.0a
# Build spatialite
RUN wget -q http://www.gaia-gis.it/gaia-sins/libspatialite-${SPATIALITE_VERSION}.tar.gz \
    && tar xzf libspatialite-${SPATIALITE_VERSION}.tar.gz \
    && rm -f libspatialite-${SPATIALITE_VERSION}.tar.gz \
    && cd libspatialite-${SPATIALITE_VERSION} \
    && CFLAGS="-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H -O2" ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /build_spatialite/usr/lib \
    && cp -P /usr/lib/libspatialite*.so* /build_spatialite/usr/lib \
    && for i in /build_spatialite/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf libspatialite-${SPATIALITE_VERSION}
	
# openjdk
COPY --from=openjdk:8-alpine  /usr/lib/jvm/java-1.8-openjdk/ /usr/lib/jvm/java-1.8-openjdk/
ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION=8u212
ENV JAVA_ALPINE_VERSION=8.212.04-r0
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server

# apache ant
ARG ANT_VERSION=1.10.8
RUN mkdir -p  /usr/local/ant  \
        && wget -q https://mirrors.tuna.tsinghua.edu.cn/apache//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz -O - \
        | tar xz -C /usr/local/ant --strip-components=1 \
	&& chmod +x /usr/local/ant/bin/ant
ENV ANT_HOME=/usr/local/ant
ENV PATH=$PATH:/usr/local/ant/bin

# clean gdal 2.5
RUN cd /usr/lib && rm -f libgdal* libogr* libosr*    
    
# Build GDAL
ARG GDAL_VERSION=2.2.0
RUN mkdir /gdal && cd / \
    && wget -q https://github.com/OSGeo/gdal/archive/v${GDAL_VERSION}.tar.gz  -O - \
        | tar xz -C gdal --strip-components=1 \
    && cd /gdal/gdal \
    && ./configure --prefix=/usr --without-libtool \
    --with-hide-internal-symbols \
    --with-proj=/usr \
    --with-libtiff=internal --with-rename-internal-libtiff-symbols \
    --with-geotiff=internal --with-rename-internal-libgeotiff-symbols \    
    --with-java=/usr/lib/jvm/java-1.8-openjdk --with-jvm-lib=/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server --with-mdb=yes \
    --with-jvm-lib-add-rpath=/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server \
    --with-geos \
    --with-xerces \
    --with-netcdf \
    --with-hdf5 \
    --with-poppler \
    --with-spatialite \	
    --with-python \
    && make \
    && make install \
    && make install DESTDIR="/build"
	
RUN \
    mkdir -p /build_projgrids/usr/share/proj \
    && curl -LOs http://download.osgeo.org/proj/proj-datumgrid-latest.zip \
    && unzip -q -j -u -o proj-datumgrid-latest.zip  -d /build_projgrids/usr/share/proj \
    && rm -f *.zip

ADD ./java.opt /gdal/gdal/swig/java/java.opt
RUN cd /gdal/gdal/swig/java  \
    && make \
	&& make install \
    && make install DESTDIR="/build" \
    && ls /usr/lib \
    && cp /gdal/gdal/swig/java/*.jar /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/ 
	
RUN cd /  \
    && rm -rf gdal \
	&& for i in /build/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build/usr/bin/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build/usr/lib/python2.7/site-packages/osgeo/*.so; do strip -s $i 2>/dev/null || /bin/true; done \
    # Remove resource files of uncompiled drivers
    && (for i in \
            # unused
            /build/usr/share/gdal/*.svg \
            # unused
            /build/usr/share/gdal/*.png \
       ;do rm $i; done)

	   
ARG ALPINE_VERSION=3.9
FROM alpine:${ALPINE_VERSION} as runner

RUN date

RUN apk add --no-cache \
        libstdc++ \
        sqlite-libs \
        libcurl \
        zlib zstd-libs\
	ttf-dejavu \
        fontconfig \
        libjpeg-turbo libpng openjpeg libwebp expat \
        python2 py2-numpy poppler pcre libpq libxml2 \
    # libturbojpeg.so is not used by GDAL. Only libjpeg.so*
    && rm -f /usr/lib/libturbojpeg.so* \
    # libpoppler-cpp.so is not used by GDAL. Only libpoppler.so*
    && rm -f /usr/lib/libpoppler-cpp.so* \
    # Only libwebp.so is used by GDAL
    && rm -f /usr/lib/libwebpmux.so* /usr/lib/libwebpdemux.so* /usr/lib/libwebpdecoder.so* \
    # Remove .py files since we have already the .pyc
    && find /usr/lib/python2.7/site-packages -name "*.py" -exec rm {} \;

# openjdk
COPY --from=builder  /usr/lib/jvm/java-1.8-openjdk/ /usr/lib/jvm/java-1.8-openjdk/
ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION=8u212
ENV JAVA_ALPINE_VERSION=8.212.04-r0
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server

# Jackcess for mdb
RUN wget -O /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/jackcess-1.2.8.jar  \
	https://repo1.maven.org/maven2/com/healthmarketscience/jackcess/jackcess/1.2.8/jackcess-1.2.8.jar
RUN wget -O /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/commons-lang-2.4.jar  \
    https://repo1.maven.org/maven2/commons-lang/commons-lang/2.4/commons-lang-2.4.jar
RUN wget -O /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/commons-logging-1.1.1.jar  \
    https://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar


# Order layers starting with less frequently varying ones
COPY --from=builder  /build_thirdparty/usr/ /usr/

COPY --from=builder  /build_projgrids/usr/ /usr/

COPY --from=builder  /build_spatialite/usr/ /usr/

COPY --from=builder  /build_proj/usr/share/proj/ /usr/share/proj/
COPY --from=builder  /build_proj/usr/include/ /usr/include/
COPY --from=builder  /build_proj/usr/bin/ /usr/bin/
COPY --from=builder  /build_proj/usr/lib/ /usr/lib/

COPY --from=builder  /build/usr/share/gdal/ /usr/share/gdal/
COPY --from=builder  /build/usr/include/ /usr/include/
COPY --from=builder  /build/usr/bin/ /usr/bin/
COPY --from=builder  /build/usr/lib/ /usr/lib/

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
