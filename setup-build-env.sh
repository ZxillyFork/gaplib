#!/bin/bash

ensure_lxd() {
  if ! command -v lxc version &> /dev/null
  then
    echo "LXD could not be found. Please ensure LXD exists."
    exit
  fi
}

build_image_in_container() {
  lxc launch ubuntu:22.04 gha-builder
  lxc ls
  
  echo "Copy the build-image script into gha-builder"
  lxc file push build-image.sh gha-builder/home/ubuntu/
  
  echo "Setting executable permissions on build-image.sh"
  lxc exec gha-builder -- chmod +x /home/ubuntu/build-image.sh
  
  echo "Running build-image.sh"
  lxc exec gha-builder -- /home/ubuntu/build-image.sh
  
  echo "Image build complete, deleting container"
  lxc delete -f gha-builder

}

run() {
  ensure_lxd
  build_image_in_container
}

run "$@"