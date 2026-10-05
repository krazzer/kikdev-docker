This Dockerfile is used to set up a development environment for KikCMS, which isn't publicly available yet, stay tuned!

### Build a new docker file with a specific name:

`docker build ~/Projecten/DockerKikDev/Symfony -t kiksaus/kikdev-symfony`

### Build a new docker file with a specific name, from a specific file:

`docker build ~/Projecten/DockerKikDev/Symfony -t kiksaus/kikdev-symfony -f ~/Projecten/DockerKikDev/Symfony/DockerfilePcov`

`docker build ~/Projecten/DockerKikDev/Phalcon5 -t kiksaus/kikdev-phalcon-latest-php8.2 -f ~/Projecten/DockerKikDev/Phalcon5/Dockerfile`

`docker build ~/Projecten/DockerKikDev/Phalcon5-php8.4 -t kiksaus/kikdev-phalcon-latest-php8.4 -f ~/Projecten/DockerKikDev/Phalcon5-php8.4/Dockerfile`

`docker build ~/Projecten/DockerKikDev/Phalcon5-php8.4 -t kiksaus/kikdev-phalcon5.17-php8.4 -f ~/Projecten/DockerKikDev/Phalcon5-php8.4/Dockerfile`

`docker build ~/Projecten/DockerKikDev/Phalcon5-php8.4 -t kiksaus/kikdev-phalcon5.17-php8.4-pcov -f ~/Projecten/DockerKikDev/Phalcon5-php8.4/DockerfilePcov`

`docker build ~/Projecten/DockerKikDev/Phalcon5 -t kiksaus/kikdev-phalcon5.17-php8.2 -f ~/Projecten/DockerKikDev/Phalcon5/Dockerfile`

`docker build ~/Projecten/DockerKikDev/Phalcon6 -t kiksaus/kikdev-phalcon6 -f ~/Projecten/DockerKikDev/Phalcon6/Dockerfile`

### Push docker file:

`docker push kiksaus/kikdev-symfony:latest`


### Nieuwe Phalcon versie

- Ga naar https://github.com/phalcon/cphalcon/releases
- Ga naar https://github.com/phalcon/cphalcon/releases
- Download de nieuwste versie, bijv: `phalcon-php8.4-nts-ubuntu-gcc-x64.zip`