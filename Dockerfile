FROM oraclelinux:7-slim

ARG RELEASE=19
ARG UPDATE=18
ARG TNS_ADMIN="/etc/oracle/instantclient/network/admin"
ARG WORK_DIR="/work"

ARG USER_NAME=node
ARG UID=501
ARG NLS_LANG_ARG="AMERICAN_CIS.UTF8"

ARG ORA2PG_VERSION=23.2

# oracle
RUN  yum -y install oracle-release-el7-1.0
RUN  yum -y install oracle-instantclient${RELEASE}.${UPDATE}-basic \
                    oracle-instantclient${RELEASE}.${UPDATE}-devel \
                    oracle-instantclient${RELEASE}.${UPDATE}-sqlplus
RUN  yum -y install oraclelinux-developer-release-el7-1.0
ENV NLS_LANG=${NLS_LANG_ARG}
ENV LD_LIBRARY_PATH=/usr/lib/oracle/${RELEASE}.${UPDATE}/client64/lib
ENV ORACLE_HOME=/usr/lib/oracle/${RELEASE}.${UPDATE}/client64
ENV PATH=$ORACLE_HOME:$PATH

# postgres
RUN  yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN  yum -y install libzstd-devel
RUN  yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN  yum -y install postgresql15-server
ENV  PGDATA=/var/lib/pgsql/15/data
ENV  PATH=/usr/pgsql-15/bin/:$PATH

# perl
RUN  yum -y install perl \
                    perl-CPAN \
                    perl-DBI \
                    perl-DBD-Pg \
                    perl-DBD-oracle
RUN  yum -y install perl-Time-HiRes \
                    perl-YAML \
                    perl-local-lib
RUN  yum -y install gzip
RUN  yum -y install unzip
RUN  yum -y install make
RUN  yum -y install gcc

# cpanminus
RUN  yum -y install perl-App-cpanminus
RUN  cpanm CPAN::Config
RUN  cpanm CPAN::FirstTime
#RUN  cpan  install DBD::Pg
#RUN  perl -MCPAN -e 'install DBD::Oracle'
#RUN  cpanm install DBD::Oracle
RUN cpan  install Test::NoWarnings
RUN cpan  install Bundle::Compress::Zlib
RUN cpanm install DBD::Oracle@1.82

# Install DBI module with Postgres, Oracle and Compress::Zlib module
#RUN cpan install Test::NoWarnings &&\
#    cpan install DBI &&\
#    cpan install DBD::Pg &&\
#    cpan install Bundle::Compress::Zlib &&\
#    cpanm install DBD::Oracle@1.82

RUN  rm -rf /var/cache/yum/*

# add user with $HOST_USER_NAME and root group - for correct patchset history
#RUN useradd --uid ${UID} --gid 0 --shell /bin/bash ${USER_NAME}

RUN mkdir -p $TNS_ADMIN
ENV TNS_ADMIN=$TNS_ADMIN

# Install ora2pg
RUN curl -L -o /tmp/ora2pg.zip https://github.com/darold/ora2pg/archive/v$ORA2PG_VERSION.zip &&\
    (cd /tmp && unzip ora2pg.zip && rm -f ora2pg.zip) &&\
    mv /tmp/ora2pg* /tmp/ora2pg &&\
    (cd /tmp/ora2pg && perl Makefile.PL && make && make install)

# config directory
RUN mkdir /config
RUN cp /etc/ora2pg/ora2pg.conf.dist /etc/ora2pg/ora2pg.conf.backup  &&\
    cp /etc/ora2pg/ora2pg.conf.dist /config/ora2pg.conf
VOLUME /config

ENV PG_VERSION=15

# output directory
RUN mkdir /data
VOLUME /data

#RUN mkdir -p $WORK_DIR
#WORKDIR $WORK_DIR

#USER ${USER_NAME}

ADD entrypoint.sh /usr/bin/entrypoint.sh

WORKDIR /

ENTRYPOINT ["entrypoint.sh"]

CMD ["ora2pg"]