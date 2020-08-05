FROM geographica/gdal2:2.2.0

RUN apt-get update \
     && apt-get install -y \
	unzip \	
	build-essential \
	wget \
	swig
	
# openjdk
COPY --from=openjdk:8-jdk  /usr/local/openjdk-8/ /usr/lib/jvm/java-1.8-openjdk/
ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION=8u265
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server

# apache ant
ARG ANT_VERSION=1.10.8
RUN mkdir -p  /usr/local/ant  \
        && wget -q https://mirrors.tuna.tsinghua.edu.cn/apache//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz -O - \
        | tar xz -C /usr/local/ant --strip-components=1 \
	&& chmod +x /usr/local/ant/bin/ant
ENV ANT_HOME=/usr/local/ant
ENV PATH=$PATH:/usr/local/ant/bin

# Build GDAL
ARG GDAL_VERSION=2.2.0
RUN mkdir -p  /gdal/gdal \
    &&   cd /gdal \
    && wget -q http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz  -O - \
        | tar xz -C gdal --strip-components=1 \
    && cd /gdal/gdal \
    && ./configure --prefix=/usr --without-libtool \
     --with-spatialite --with-pg --with-netcdf --with-geos \
    --with-java=/usr/lib/jvm/java-1.8-openjdk --with-jvm-lib=/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server --with-mdb=yes \
    --with-jvm-lib-add-rpath=/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server \
    --with-hide-internal-symbols \
    --with-proj=/usr \
    --with-libtiff=internal --with-rename-internal-libtiff-symbols \
    --with-geotiff=internal --with-rename-internal-libgeotiff-symbols \  
    --with-python \
    && make \
    && make install  

ADD ./java.opt /gdal/gdal/swig/java/java.opt
RUN cd /gdal/gdal/swig/java  \
    && make \
    && make install  \
    && ls /usr/lib \
    && cp /gdal/gdal/swig/java/*.jar /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/ \
    && cd /  \
    && rm -rf gdal
  
# Jackcess for mdb
RUN wget -O /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/jackcess-1.2.8.jar  \
	https://repo1.maven.org/maven2/com/healthmarketscience/jackcess/jackcess/1.2.8/jackcess-1.2.8.jar
RUN wget -O /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/commons-lang-2.4.jar  \
    https://repo1.maven.org/maven2/commons-lang/commons-lang/2.4/commons-lang-2.4.jar
RUN wget -O /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/commons-logging-1.1.1.jar  \
    https://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar
    
# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
