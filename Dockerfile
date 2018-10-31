FROM python:2.7-slim

# 更换软件源
ENV APT_SRC "http://mirrors.aliyun.com/debian/"
RUN set -x \
    && mv /etc/apt/sources.list /etc/apt/sources.list.backup \
    && echo "deb ${APT_SRC} jessie main non-free contrib\r\ndeb ${APT_SRC} jessie-proposed-updates main non-free contrib\r\ndeb-src ${APT_SRC} jessie main non-free contrib\r\ndeb-src ${APT_SRC} jessie-proposed-updates main non-free contrib" > /etc/apt/sources.list \
    && apt-get update

# 设置UTF8编码 //zh_CN,en_US
RUN set -x \
    && apt-get install -y --no-install-recommends locales \
    && localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 \
    && apt-get purge -y locales
    
ENV LANG zh_CN.utf8
ENV LC_ALL zh_CN.utf8

# 安装gdal相关库
RUN   apt-get install -y  gdal-bin netcdf-bin   libnetcdf-dev python-gdal


CMD ["python2"]
