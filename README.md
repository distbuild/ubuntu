# ubuntu



## Introduction

*ubuntu* is the Dockerfile of [distbuild](https://github.com/distbuild) for building.



## Prerequisites

- docker >= 25.0.0



## Build

```bash
docker build -f Dockerfile -t craftslab/ubuntu:distbuild .
```



## Docker

```bash
docker run -it --rm craftslab/ubuntu:distbuild /bin/bash
```



## License

Project License can be found [here](LICENSE).
