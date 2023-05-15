# ora2pgdock
Dockerized ora2pg base on Oracle Linux 7.

First, execute `./build.sh` (or `make build`). You will need `dockerx` installed (included in Docker Desktop).
The Docker image should be built once. 
You also need to change several properties in `common.sh`:
- `LOCAL_TNS_ADMIN` - path to directory containing configuration files of Oracle InstantClient 
  on host: `/Users/me/apps/oracle/instantclient_19_8/network/admin`
- `NLS_LANG` - oracle encoding type property
- `ORA2PG_DOCK_HOME` - path to directory with this project: `/Users/<path-to-project>`
- `CONFIG_DIR` - path to config directory on host: `$ORA2PG_DOCK_HOME/ora2pgdock/config`
- `CONFIG_LOCATION` - path to your config file on docker: `/config/ora2pg.conf`
- `OUTPUT_LOCATION` - path to directory for results: `$ORA2PG_DOCK_HOME/ora2pgdock/data`
- `ORA_HOST` - oracle host
- `ORA_USER` - oracle user and schema name
- `ORA_PWD` - oracle password

# Use dockerized ora2pg
- `run.sh` - ora2pg migration tool with `ora2pg.conf` configuration. ^C for exit without result.
- `run-bash.sh` - bash in docker image with ora2pg. To exit the program use `exit` command.
- `show-report` - ora2pg SHOW_REPORT with estimate cost.