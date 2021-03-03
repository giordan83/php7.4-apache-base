FROM php:7.4-apache
LABEL maintainer="gabrielegiuranno@gmail.com"

RUN touch /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_execution_time = 300;" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "upload_max_filesize = 40M;" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 40M;" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 1024M;" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_file_uploads = 50;" >> /usr/local/etc/php/conf.d/uploads.ini

RUN a2enmod rewrite

RUN mkdir -p /usr/share/man/man1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
	libpq-dev \
	wkhtmltopdf \
	xvfb \
	wget \
	git \
	curl \
	vim \
	htop \
	p7zip-full \
	libpng-dev \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	zlib1g-dev \
	libzip-dev \
	libxml2-dev \
    unzip && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_pgsql intl
RUN docker-php-ext-configure gd && docker-php-ext-install gd
RUN docker-php-ext-configure zip && docker-php-ext-install zip
RUN docker-php-ext-configure soap && docker-php-ext-install soap

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN rm -f /etc/apache2/sites-enabled/*.conf
