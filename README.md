# p4install
This reposirty contains one BASH script that install a full-fledged P4 environment on your UBUNTU 16.04

This does not necessarily claim that it will not work on other versions or even on a pure Debian, but during the installing phase, you should be careful about the versions and package names as they might differ.

## Usage

### Ubuntu 16.04
```
$ sudo ./install-ubuntu16.04.sh
```

### Ubuntu 14.04 
Note:
 - p4c compiler won't be installed because of an old cmake version officially available in 14.04, but everything else is working
 - to have p4c compiler, use the following docker image: https://hub.docker.com/r/cslev/p4c/
```
$ sudo ./install-ubuntu14.04.sh
```


