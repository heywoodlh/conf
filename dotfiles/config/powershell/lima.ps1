function conf {
    docker pull heywoodlh/conf
    docker run --user 1000:999 -it --rm -v /run/user/1000/docker.sock:/var/run/docker.sock heywoodlh/conf    
}
