##
# osgeo/gdal:alpine-normal

# This file is available at the option of the licensee under:
# Public domain
# or licensed under X/MIT (LICENSE.TXT) Copyright 2019 Even Rouault <even.rouault@spatialys.com>

ARG ALPINE_VERSION=3.11
FROM alpine:${ALPINE_VERSION} as builder

# Derived from osgeo/proj by Howard Butler <howard@hobu.co>
LABEL maintainer="Even Rouault <even.rouault@spatialys.com>"

# Setup build env for PROJ
RUN apk add --no-cache wget curl unzip make libtool autoconf automake pkgconfig g++ sqlite sqlite-dev

ARG PROJ_DATUMGRID_LATEST_LAST_MODIFIED
RUN \
    mkdir -p /build_projgrids/usr/share/proj \
    && curl -LOs http://download.osgeo.org/proj/proj-datumgrid-latest.zip \
    && unzip -q -j -u -o proj-datumgrid-latest.zip  -d /build_projgrids/usr/share/proj \
    && rm -f *.zip
 
# For PROJ and GDAL
ARG POPPLER_DEV=poppler-dev
RUN apk add --no-cache \
    linux-headers \
    libstdc++ \
    curl-dev tiff-dev \
    zlib-dev zstd-dev \
    libjpeg-turbo-dev libpng-dev openjpeg-dev libwebp-dev expat-dev \
    py3-numpy-dev python3-dev py3-numpy \
    ${POPPLER_DEV} postgresql-dev \
    openexr-dev \
    # For spatialite (and GDAL)
    libxml2-dev \
    swig \ 
    && mkdir -p /build_thirdparty/usr/lib

# Build xerces-c
ARG XERCESC_VERSION=3.2.3
RUN if test "${XERCESC_VERSION}" != ""; then ( \
    wget -q https://www-eu.apache.org/dist//xerces/c/3/sources/xerces-c-${XERCESC_VERSION}.zip \
    && unzip -q xerces-c-${XERCESC_VERSION}.zip  \
    && rm -f xerces-c-${XERCESC_VERSION}.zip \
    && cd xerces-c-${XERCESC_VERSION} \
    && ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && cp -P /usr/lib/libxerces-c*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf xerces-c-${XERCESC_VERSION} \
    ); fi

# Build geos
ARG GEOS_VERSION=3.8.1
RUN if test "${GEOS_VERSION}" != ""; then ( \
    wget -q http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 \
    && tar xjf geos-${GEOS_VERSION}.tar.bz2  \
    && rm -f geos-${GEOS_VERSION}.tar.bz2 \
    && cd geos-${GEOS_VERSION} \
    && ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && cp -P /usr/lib/libgeos*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf geos-${GEOS_VERSION} \
    ); fi

# Build szip
ARG SZIP_VERSION=2.1.1
RUN if test "${SZIP_VERSION}" != ""; then ( \
    wget -q https://support.hdfgroup.org/ftp/lib-external/szip/${SZIP_VERSION}/src/szip-${SZIP_VERSION}.tar.gz \
    && tar xzf szip-${SZIP_VERSION}.tar.gz \
    && rm -f szip-${SZIP_VERSION}.tar.gz \
    && cd szip-${SZIP_VERSION} \
    && CFLAGS=-O2 ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && cp -P /usr/lib/libsz*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf szip-${SZIP_VERSION} \
    ); fi

# Build hdf5
ARG HDF5_VERSION=1.12.0
RUN if test "${HDF5_VERSION}" != ""; then ( \
    wget -q https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION%.*}/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz \
    && tar xzf hdf5-${HDF5_VERSION}.tar.gz \
    && rm -f hdf5-${HDF5_VERSION}.tar.gz \
    && cd hdf5-${HDF5_VERSION} \
    && CFLAGS=-O2 CXXFLAGS=-O2 ./configure --prefix=/usr --disable-static --with-szlib=/usr --enable-cxx \
    && make -j$(nproc) \
    && make install \
    && cp -P /usr/lib/libhdf5*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf hdf5-${HDF5_VERSION} \
    ); fi

# Build netCDF
ARG NETCDF_VERSION=4.7.4
RUN if test "${NETCDF_VERSION}" != ""; then ( \
    apk add --no-cache libexecinfo-dev \
    && wget -q https://github.com/Unidata/netcdf-c/archive/v${NETCDF_VERSION}.tar.gz \
    && tar xzf v${NETCDF_VERSION}.tar.gz \
    && rm -f v${NETCDF_VERSION}.tar.gz \
    && cd netcdf-c-${NETCDF_VERSION} \
    && CFLAGS=-O2 ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && cp -P /usr/lib/libnetcdf*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf netcdf-c-${NETCDF_VERSION} \
    && apk del libexecinfo-dev \
    ); fi

# Build hdf4
ARG HDF4_VERSION=4.2.15
RUN if test "${HDF4_VERSION}" != ""; then ( \
    apk add --no-cache byacc flex portablexdr-dev \
    && mkdir hdf4 \
    && wget -q https://support.hdfgroup.org/ftp/HDF/releases/HDF${HDF4_VERSION}/src/hdf-${HDF4_VERSION}.tar.gz -O - \
        | tar xz -C hdf4 --strip-components=1 \
    && cd hdf4 \
    && LDFLAGS=-lportablexdr ./configure --prefix=/usr --enable-shared --disable-static \
        --with-szlib=/usr --disable-fortran --disable-netcdf \
    && make -j$(nproc) \
    && make install \
    && cp -P /usr/lib/libdf*.so* /build_thirdparty/usr/lib \
    && cp -P /usr/lib/libmfhdf*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf hdf4 \
    && apk del byacc flex portablexdr-dev \
    ); fi

# Build freexl
ARG FREEXL_VERSION=1.0.5
RUN if test "${FREEXL_VERSION}" != ""; then ( \
    wget -q http://www.gaia-gis.it/gaia-sins/freexl-${FREEXL_VERSION}.tar.gz \
    && tar xzf freexl-${FREEXL_VERSION}.tar.gz \
    && rm -f freexl-${FREEXL_VERSION}.tar.gz \
    && cd freexl-${FREEXL_VERSION} \
    && ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && cp -P /usr/lib/libfreexl*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf freexl-${FREEXL_VERSION} \
    ); fi

# Build likbkea
ARG KEA_VERSION=1.4.13
RUN if test "${KEA_VERSION}" != ""; then ( \
    apk add --no-cache cmake \
    && wget -q https://github.com/ubarsc/kealib/archive/kealib-${KEA_VERSION}.zip \
    && unzip -q kealib-${KEA_VERSION}.zip \
    && rm -f kealib-${KEA_VERSION}.zip \
    && cd kealib-kealib-${KEA_VERSION} \
    && cmake . -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr -DHDF5_INCLUDE_DIR=/usr/include/hdf5 \
        -DHDF5_LIB_PATH=/usr/lib -DLIBKEA_WITH_GDAL=OFF \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf kealib-kealib-${KEA_VERSION} \
    && cp -P /usr/lib/libkea*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && apk del cmake \
    ); fi

# Build openjpeg
# ARG OPENJPEG_VERSION=2.3.1
RUN if test "${OPENJPEG_VERSION}" != ""; then ( \
    apk add --no-cache cmake \
    && wget -q https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}.tar.gz \
    && tar xzf v${OPENJPEG_VERSION}.tar.gz \
    && rm -f v${OPENJPEG_VERSION}.tar.gz \
    && cd openjpeg-${OPENJPEG_VERSION} \
    && cmake . -DBUILD_SHARED_LIBS=ON  -DBUILD_STATIC_LIBS=OFF -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
    && make -j$(nproc) \
    && make install \
    && rm -f /usr/lib/libopenjp2.so.2.3.0 \
    && cp -P /usr/lib/libopenjp2*.so* /build_thirdparty/usr/lib \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf openjpeg-${OPENJPEG_VERSION} \
    && apk del cmake \
    ); fi

RUN apk add --no-cache rsync ccache
ARG RSYNC_REMOTE

# Build PROJ
ARG PROJ_VERSION=4.9.2
RUN mkdir proj \
    && wget -q https://github.com/OSGeo/PROJ/archive/${PROJ_VERSION}.tar.gz -O - \
        | tar xz -C proj --strip-components=1 \
    && cd proj \
    && ./autogen.sh \
    && if test "${RSYNC_REMOTE}" != ""; then \
        echo "Downloading cache..."; \
        rsync -ra ${RSYNC_REMOTE}/proj/ $HOME/; \
        echo "Finished"; \
        export CC="ccache gcc"; \
        export CXX="ccache g++"; \
        export PROJ_DB_CACHE_DIR="$HOME/.ccache"; \
        ccache -M 100M; \
    fi \
    && ./configure --prefix=/usr --disable-static --enable-lto \
    && make -j$(nproc) \
    && make install \
    && make install DESTDIR="/build_proj" \
    && if test "${RSYNC_REMOTE}" != ""; then \
        ccache -s; \
        echo "Uploading cache..."; \
        rsync -ra --delete $HOME/.ccache ${RSYNC_REMOTE}/proj/; \
        echo "Finished"; \
        rm -rf $HOME/.ccache; \
        unset CC; \
        unset CXX; \
    fi \
    && cd .. \
    && rm -rf proj \
    && for i in /build_proj/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build_proj/usr/bin/*; do strip -s $i 2>/dev/null || /bin/true; done

# Build spatialite
ARG SPATIALITE_VERSION=4.2.0
RUN if test "${SPATIALITE_VERSION}" != ""; then ( \
    wget -q http://www.gaia-gis.it/gaia-sins/libspatialite-${SPATIALITE_VERSION}.tar.gz \
    && tar xzf libspatialite-${SPATIALITE_VERSION}.tar.gz \
    && rm -f libspatialite-${SPATIALITE_VERSION}.tar.gz \
    && cd libspatialite-${SPATIALITE_VERSION} \
    && if test "${RSYNC_REMOTE}" != ""; then \
        echo "Downloading cache..."; \
        rsync -ra ${RSYNC_REMOTE}/spatialite/ $HOME/; \
        echo "Finished"; \
        export CC="ccache gcc"; \
        export CXX="ccache g++"; \
        ccache -M 100M; \
    fi \
    && CFLAGS="-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H -O2" ./configure --prefix=/usr --disable-static \
    && make -j$(nproc) \
    && make install \
    && if test "${RSYNC_REMOTE}" != ""; then \
        ccache -s; \
        echo "Uploading cache..."; \
        rsync -ra --delete $HOME/.ccache ${RSYNC_REMOTE}/spatialite/; \
        echo "Finished"; \
        rm -rf $HOME/.ccache; \
        unset CC; \
        unset CXX; \
    fi \
    && mkdir -p /build_spatialite/usr/lib \
    && cp -P /usr/lib/libspatialite*.so* /build_spatialite/usr/lib \
    && for i in /build_spatialite/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf libspatialite-${SPATIALITE_VERSION} \
    ); else \
        mkdir -p /build_spatialite/usr/lib; \
    fi
    
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
	
# Build GDAL
# http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz
ARG GDAL_VERSION=2.2.0
ARG GDAL_BUILD_IS_RELEASE=yes
RUN if test "x${GDAL_BUILD_IS_RELEASE}" = "x"; then \
        export GDAL_SHA1SUM=${GDAL_VERSION}; \
    fi \
    && export GDAL_EXTRA_ARGS="" \
    && if test "${GEOS_VERSION}" != ""; then \
        export GDAL_EXTRA_ARGS="--with-geos ${GDAL_EXTRA_ARGS}"; \
    fi \
    && if test "${XERCESC_VERSION}" != ""; then \
        export GDAL_EXTRA_ARGS="--with-xerces ${GDAL_EXTRA_ARGS}"; \
    fi \
    && if test "${HDF4_VERSION}" != ""; then \
        apk add --no-cache portablexdr-dev \
        && export LDFLAGS="-lportablexdr ${LDFLAGS}" \
        && export GDAL_EXTRA_ARGS="--with-hdf4 ${GDAL_EXTRA_ARGS}"; \
    fi \
    && if test "${HDF5_VERSION}" != ""; then \
        export GDAL_EXTRA_ARGS="--with-hdf5 ${GDAL_EXTRA_ARGS}"; \
    fi \
    && if test "${NETCDF_VERSION}" != ""; then \
        export GDAL_EXTRA_ARGS="--with-netcdf ${GDAL_EXTRA_ARGS}"; \
    fi \
    && if test "${SPATIALITE_VERSION}" != ""; then \
        export GDAL_EXTRA_ARGS="--with-spatialite ${GDAL_EXTRA_ARGS}"; \
    fi \
    && if test "${POPPLER_DEV}" != ""; then \
        export GDAL_EXTRA_ARGS="--with-poppler ${GDAL_EXTRA_ARGS}"; \
    fi \
    && echo ${GDAL_EXTRA_ARGS} \
    && mkdir -p gdal/gdal  \
    && cd gdal \
    && wget -q http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz -O - \
        | tar xz -C gdal --strip-components=1 \
    && cd gdal \
    && if test "${RSYNC_REMOTE}" != ""; then \
        echo "Downloading cache..."; \
        rsync -ra ${RSYNC_REMOTE}/gdal/ $HOME/; \
        echo "Finished"; \
        # Little trick to avoid issues with Python bindings
        printf "#!/bin/sh\nccache gcc \$*" > ccache_gcc.sh; \
        chmod +x ccache_gcc.sh; \
        printf "#!/bin/sh\nccache g++ \$*" > ccache_g++.sh; \
        chmod +x ccache_g++.sh; \
        export CC=$PWD/ccache_gcc.sh; \
        export CXX=$PWD/ccache_g++.sh; \
        ccache -M 1G; \
    fi \
    && ./configure --prefix=/usr --without-libtool \
    --with-java=/usr/lib/jvm/java-1.8-openjdk --with-jvm-lib=/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server --with-mdb=yes \
    --with-jvm-lib-add-rpath=/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server \
    --with-hide-internal-symbols \
    --with-proj=/usr \
    --with-libtiff=internal --with-rename-internal-libtiff-symbols \
    --with-geotiff=internal --with-rename-internal-libgeotiff-symbols \
    # --enable-lto
    ${GDAL_EXTRA_ARGS} \
    --with-python \
    && make -j$(nproc) \
    && make install DESTDIR="/build" \
    && ls /build/usr/lib | grep gdal

# build swig java    
RUN echo -e 'JAVA_HOME = /usr/lib/jvm/java-1.8-openjdk' > /gdal/gdal/swig/java/java.opt \
    && echo -e 'JAVADOC=$(JAVA_HOME)/bin/javadoc' >> /gdal/gdal/swig/java/java.opt \
    && echo -e 'JAVAC=$(JAVA_HOME)/bin/javac' >> /gdal/gdal/swig/java/java.opt \
    && echo -e 'JAVA=$(JAVA_HOME)/bin/java' >> /gdal/gdal/swig/java/java.opt \
    && echo -e 'JAR=$(JAVA_HOME)/bin/jar' >> /gdal/gdal/swig/java/java.opt \
    && echo -e 'JAVA_INCLUDE=-I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux' >> /gdal/gdal/swig/java/java.opt \
    && cd /gdal/gdal/swig/java  \
    && make \
    && make install DESTDIR="/build" \
    && cp /gdal/gdal/swig/java/*.jar /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/ \
    && cd /gdal/gdal  \
    && ls /build/usr/lib | grep gdal \
    && if test "${RSYNC_REMOTE}" != ""; then \
        ccache -s; \
        echo "Uploading cache..."; \
        rsync -ra --delete $HOME/.ccache ${RSYNC_REMOTE}/gdal/; \
        echo "Finished"; \
        rm -rf $HOME/.ccache; \
        unset CC; \
        unset CXX; \
    fi \
    && cd /  \
    && rm -rf gdal 
    
RUN  mkdir -p /build_gdal_python/usr/lib \
    && mkdir -p /build_gdal_python/usr/bin \
    && mkdir -p /build_gdal_version_changing/usr/include \
    && mv /build/usr/lib/python3.8          /build_gdal_python/usr/lib \
    && mv /build/usr/lib                    /build_gdal_version_changing/usr \
    && mv /build/usr/include/gdal_version.h /build_gdal_version_changing/usr/include \
    && mv /build/usr/bin/*.py               /build_gdal_python/usr/bin \
    && mv /build/usr/bin                    /build_gdal_version_changing/usr \
    && for i in /build_gdal_version_changing/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build_gdal_python/usr/lib/python3.8/site-packages/osgeo/*.so; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build_gdal_version_changing/usr/bin/*; do strip -s $i 2>/dev/null || /bin/true; done \
    # Remove resource files of uncompiled drivers
    && (for i in \
            # unused
            /build/usr/share/gdal/*.svg \
            # unused
            /build/usr/share/gdal/*.png \
       ;do rm $i; done)

# Build final image
FROM alpine:${ALPINE_VERSION} as runner

RUN date

ARG POPPLER=poppler
RUN apk add --no-cache \
        libstdc++ \
        sqlite-libs \
        libcurl tiff \
        ttf-dejavu \
        zlib zstd-libs\
        libjpeg-turbo libpng libwebp expat \
        python3 py3-numpy ${POPPLER} pcre libpq libxml2 portablexdr openjpeg \
        openexr \
    # Remove /usr/lib/libopenjp2.so.2.3.0 since we are building v2.3.1 manually
    # && rm -f /usr/lib/libopenjp2.so.2.3.0 \
    # libturbojpeg.so is not used by GDAL. Only libjpeg.so*
    && rm -f /usr/lib/libturbojpeg.so* \
    # libpoppler-cpp.so is not used by GDAL. Only libpoppler.so*
    && rm -f /usr/lib/libpoppler-cpp.so* \
    # Only libwebp.so is used by GDAL
    && rm -f /usr/lib/libwebpmux.so* /usr/lib/libwebpdemux.so* /usr/lib/libwebpdecoder.so* \
    && ln -s /usr/bin/python3 /usr/bin/python

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
COPY --from=builder  /build_gdal_python/usr/ /usr/
COPY --from=builder  /build_gdal_version_changing/usr/ /usr/
