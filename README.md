# Docker API test

Simple prototype to test creating remote docker containers that students can SSH into and use as a security sandbox.

## Instructions

### Start the App and Manage Containers

* Build scenrio images

  ```docker build -t scenario .```

* Start Server

  ```bundle exec rackup```

* Open Browser to ```localhost:9292```

* Create a container

  ```GET /${username}/${scenario}```

* View containers

  ```GET /```

* Destroy a user's container

  ```GET /destroy/${username}```

### SSH into a User Container

* SSH into the newly build container

  ```ssh -p ${port} ${username}@${ip}```

* Currently the password is hardcoded to 'password'. Better is to create a random password and give that to the user with the IP and PORT info.
