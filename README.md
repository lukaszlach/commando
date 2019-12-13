# Commando

![Version](https://img.shields.io/badge/version-0.2.0-lightgrey.svg?style=flat)

**Commando** generates Docker images on-demand with all the commands you need and simply point them by name in the `docker run` command. **Commando** is SysOps and DevOps best friend.

![](https://user-images.githubusercontent.com/5011490/65174414-25080700-da51-11e9-8f88-d3a69728c0a6.gif)

## Features

When running a Docker image you will enter the Bash shell by default and have the requested commands available.

Commando is deployed under `cmd.cat` and publicly available, you can freely use it but do not depend on it's stability in your projects as it is hosted on my private server with limited resources.

The image is based on Alpine and the builder does its best to reuse the existing layers when using multiple commands. This way both `cmd.cat/envsubst/curl` and `cmd.cat/curl/envsubst` are the same images, also `cmd.cat/envsubst/tcpdump/curl` adds only one extra layer.

[![](http://www.brendangregg.com/Perf/linuxperftools.png)](http://www.brendangregg.com/blog/2014-11-22/linux-perf-tools-2014.html)

> Source: [Linux PerfTools](http://www.brendangregg.com/linuxperf.html)

```bash
# One command.
docker run -it cmd.cat/strace
docker run -it cmd.cat/ab

# Two...
docker run -it cmd.cat/curl/wget
docker run -it cmd.cat/htop/iostat

# ... or a lot of commands, how many you need.
docker run -it cmd.cat/ping/nmap/whois
docker run -it cmd.cat/ngrep/tcpdump/ip/ifconfig/netstat
```

Use the generated image with host/container pid/network modes to debug and monitor your containers or the host system.

![](https://user-images.githubusercontent.com/5011490/65175421-25090680-da53-11e9-80db-37c111d5a640.gif)

```bash
docker run -d --name nginx nginx

# Enter the shell with all network tools available
docker run -it --net container:nginx cmd.cat/curl/ab/ngrep
# Monitor all network interfaces of the nginx container
docker run -it --net container:nginx cmd.cat/ngrep ngrep -d any
```

```bash
docker run -d --name redis redis

# Monitor the processes running inside the redis container
docker run -it --pid container:redis cmd.cat/htop htop
```

```bash
# Monitor network and processes on the host system
docker run -it --net host --pid host cmd.cat/htop/ngrep
```

## Running

Run the project locally or deploy it internally inside your company with a single command that will pull all the required images and build the registry proxy:

```bash
git clone https://github.com/lukaszlach/commando.git
cd commando
docker-compose up -d
```

Run any command built locally the same way:

```bash
docker run -it localhost:5050/tcpdump
docker run -it localhost:5050/strace/php
```

> The first run needs to build the base image so it takes longer than all further calls.

## License

MIT License

Copyright (c) 2019 Łukasz Lach <llach@llach.pl>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

Google [Nixery](https://github.com/google/nixery) :heart:
