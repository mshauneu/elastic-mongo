# Elastic Mongo
**Docker setup to get Elasticsearch and MongoDB up and running**

### Install Docker and docker-compose
* https://docs.docker.com/installation
* https://docs.docker.com/compose/install/

```bash
git clone https://github.com/mshauneu/elastic-mongo
cd elastic-mongo
docker-compose up -d  
```

Now you have Elasticsearch and MongoDB configured with transporter

```bash
$ docker ps  # =>

CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS                  PORTS                                                NAMES
...                 ...                 ...                    ....                ...                     ...
```

### Log into a container
```
docker exec -i -t elasticmongo_mongo2_1  bash
```
  
