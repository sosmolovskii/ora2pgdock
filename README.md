# ora2pgdock
Dockerized ora2pg base on Oracle Linux 7.

First, execute `./build.sh` (or `make build`). You will need `dockerx` installed (included in Docker Desktop).
The Docker image should be built once. 
You should rename `common.sh.temp` to `common.sh` and change several properties:
- `LOCAL_TNS_ADMIN` - path to directory containing configuration files of Oracle InstantClient 
  on host: `/Users/me/apps/oracle/instantclient_19_8/network/admin`
- `NLS_LANG` - oracle encoding property
- `ORA2PG_DOCK_HOME` - path to directory with this project: `/Users/<path-to-project>`
- `CONFIG_DIR` - path to config directory on host: `$ORA2PG_DOCK_HOME/config`
- `CONFIG_LOCATION` - path to your config file on docker: `/config/ora2pg.conf`
- `OUTPUT_DIR` - path to directory for results on host: `$ORA2PG_DOCK_HOME/data`
- `OUTPUT_LOCATION` - path to directory for results on docker: `/data`
- `ORA_HOST` - oracle host
- `ORA_USER` - oracle user and schema name
- `ORA_PWD` - oracle password

# Use dockerized ora2pg
After filling properties you can use several commands. 
All commands use values from `ora2pg.conf`, with rewriting values from `<args>` (see ora2pg manual). 
  - `./run.sh` - ora2pg export
  - `./run.sh ora2pg <args?>` - ora2pg export with additional args
  - `./run.sh report <args?>` - ora2pg SHOW_REPORT with additional args
  - `./run.sh bash` - bash in docker image with ora2pg