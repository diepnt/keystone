#
# MySQL Dockerfile
#
# https://github.com/dockerfile/mysql
#

# Pull base image.
FROM diepnt/ubuntu

# Install MySQL.
  RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y keystone supervisor && \
  sed -i '609iconnection = mysql://keystone:KEYSTONE_DBPASS@mysql/keystone'  /etc/keystone/keystone.conf && \
  sed -i '14iadmin_token = ADMIN_TOKEN' /etc/keystone/keystone.conf  && \
  sed -i '15ilog_dir = /var/log/keystone' /etc/keystone/keystone.conf  && \
  sed -i '17i[program:keystone]' /etc/supervisor/supervisord.conf && \
  sed -i '18icommand=/usr/bin/keystone-all' /etc/supervisor/supervisord.conf && \
  rm /var/lib/keystone/keystone.db && \
  service supervisor start && \
  supervisorctl restart keystone && \


# Define working directory.
WORKDIR /root

# Define default command.

# Expose ports.
EXPOSE 5000 35357
CMD ["/usr/bin/supervisord", "-n"]
