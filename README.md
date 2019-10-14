# docker-teamengine

[TEAM Engine](https://github.com/opengeospatial/teamengine) means "Test, Evaluation, And Measurement Engine".
It's developed by Open Geospatial Consortium.

This repository is simple TEAM Engine Docker image.
If you want to see more example, please see bellow url.

https://github.com/opengeospatial/teamengine-docker

# usage

Please execute following command.

```bash
docker run -it --rm -p 8080:8080 kannkyo/docker-teamengine
```

Please open following url in browser.

- http://localhost:8080/teamengine/
   : Home page for selecting and running test suites using the web interface

- http://localhost:8080/teamengine/rest/suites
   : Presents a listing of available test suites that expose a RESTful API, with links to test suite documentation

# LICENSE

[Apache 2.0](LICENSE)
