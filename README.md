# mariadb-docker

[![version)](https://img.shields.io/docker/v/crashvb/mariadb/latest)](https://hub.docker.com/repository/docker/crashvb/mariadb)
[![image size](https://img.shields.io/docker/image-size/crashvb/mariadb/latest)](https://hub.docker.com/repository/docker/crashvb/mariadb)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/mariadb-docker.svg)](https://github.com/crashvb/mariadb-docker/blob/master/LICENSE.md)

## Overview

This docker image contains [mariadb](https://www.mariadb.org/).

## Quick Start

### Checking Replication Status

```mysql
> show master status;
```

### Retrieving Server Information

```mysql
> select version(), @@server_id;
```

## Entrypoint Scripts

### mariadb

The embedded entrypoint script is located at `/etc/entrypoint.d/mariadb` and performs the following actions:

1. A new mariadb configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | ---------| ------------- | ----------- |
 | MARIADB\_ALLOW\_INSECURE\_ROOT | | If defined, TLS will not be required for secure connection from root. |
 | MARIADB\_ALLOW\_INSECURE\_USER | | If defined, TLS will not be required for secure connection from _<user>_. |
 | MARIADB\_DATABASE | | If defined, a database with the given name will be created. |
 | MARIADB\_ROOT\_PASSWORD | _random_ | The mariadb `root` password. |
 | MARIADB\_SERVER\_ID | | If defined, the unique identifier of the server in a replication pool. |
 | MARIADB\_TLS\_CIPHERSUITES | TLS\_AES\_256\_GCM\_SHA384 | The TLS cipher(s) to use for secure connections. |
 | MARIADB\_TLS\_VERSION | TLSv1.3 | The TLS versions to use for secure connections. |
 | MARIADB\_USER | | If defined, a user with the given name will be created. |
 | MARIADB\_USER\_PASSWORD | _random_ | The mariadb _<user>_ password. |

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ entrypoint.d/
│  │  └─ mariadb
│  ├─ healthcheck.d/
│  │  └─ mariadb
│  ├─ mysql/
│  └─ supervisor/
│     └─ config.d/
│        └─ mariadb.conf
├─ run/
│  └─ secrets/
│     ├─ mariadb.crt
│     ├─ mariadb.key
│     ├─ mariadbca.crt
│     ├─ mariadb_root_password
│     └─ mariadb_user_password
├─ usr/
│  └─ local/
│     └─ bin/
│        ├─ mysql-backup
│        └─ mysql-restore
└─ var/
   └─ lib/
      └─ mysql/
```

### Exposed Ports

* `3306/tcp` - mariadb listening port.

### Volumes

* `/var/lib/mysql` - The mariadb data directory.

## Development

[Source Control](https://github.com/crashvb/mariadb-docker)

