FROM crashvb/supervisord:202402150134@sha256:c05da5b946d637ee406a2372b8855e1b93ecccee84efd3226c5219430ef020ea
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:c05da5b946d637ee406a2372b8855e1b93ecccee84efd3226c5219430ef020ea" \
	org.opencontainers.image.base.name="crashvb/supervisord:202402150134" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing mariadb." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/mariadb-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/mariadb" \
	org.opencontainers.image.url="https://github.com/crashvb/mariadb-docker"

# Install packages, download files ...
ENV MARIADB_DATA=/var/lib/mysql
RUN APT_ALL_REPOS=1 docker-apt mariadb-server ssl-cert && \
	rm --force --recursive ${MARIADB_DATA:?}/*

# Configure: mariadb
COPY mysql-* /usr/local/bin/
RUN usermod --append --groups ssl-cert mysql && \
	install --directory --group=mysql --mode=0750 --owner=mysql /var/run/mysqld && \
	sed --expression="/^bind-address/s/127.0.0.1/0.0.0.0/" \
		--expression="/^#ssl-ca =/cssl-ca = /etc/ssl/certs/mariadbca.crt" \
		--expression="/^#ssl-cert =/cssl-cert = /etc/ssl/certs/mariadb.crt" \
		--expression="/^#ssl-key =/cssl-key = /etc/ssl/private/mariadb.key" \
		--expression="/^#require-secure-transport = /s/off/on/g" \
		--expression="/^#require-secure-transport = /s/#//g" \
		--expression="/^#log_bin /clog_bin = ${MARIADB_DATA}/mysql-bin.log" \
		--in-place=.dist /etc/mysql/mariadb.conf.d/50-server.cnf

# Configure: supervisor
COPY supervisord.mariadb.conf /etc/supervisor/conf.d/mariadb.conf

# Configure: entrypoint
COPY entrypoint.mariadb /etc/entrypoint.d/mariadb

# Configure: healthcheck
COPY healthcheck.mariadb /etc/healthcheck.d/mariadb

EXPOSE 3306/tcp

VOLUME ${MARIADB_DATA}
