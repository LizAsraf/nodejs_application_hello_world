# Hello-world nodejs

This is a simple Node.js application that uses the Express framework to listen for incoming HTTP requests on port 8885. 
When a request is received at the root ('/') route, the server responds with the text "Hello World". 
The application is configured to use the Express package version 4.16.1 as a dependency. 
The package.json file is used to manage the application's dependencies, and the start script is used to start the application using the command "node app.js"

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You will need to have Node.js and npm installed on your machine.
You can download them from the official website:
- [Node.js](https://nodejs.org/en/)
- [npm](https://www.npmjs.com/)

### Installing

1. Clone the repository
'''
    $ git clone git@github.com:LizAsraf/nodejs_application_hello_world.git
'''

2. To install the dependencies, navigate to the project's root directory and run the following command:
'''
    $ npm install
'''

3. To start the app, run the following command:
'''
    $ npm start
'''

4. Set the following environment variables:
- `PORT`: the port number of that you wqnt to run the application


## Usage

Once the application is running, you can access the following routes:
http://0.0.0.0:8885 and also http://localhost:8885 in your web browser.

## Built With

* [Express](https://expressjs.com/) - The web framework used


## Deploying with Docker

This application can also be run using Docker. The repository includes a `Dockerfile` and a `docker-compose.yml` file that can be used to build and run the application in a container.

### Prerequisites

You will need to have Docker installed on your machine. You can download it from the official website:

- [Docker](https://www.docker.com/)

### Building the Image

To build the image, navigate to the project's root directory and run the following command:

'''bash
    $ docker build -t app_node:latest .
    $ docker-compose up
'''
This will start the app and also start an nginx container that acts as a reverse proxy. 
The app will now be running on http://0.0.0.0 can also be accessed by visiting http://localhost in your web browser.

### Built With

- [Docker](https://www.docker.com/) - Containerization platform
- [Nginx](https://www.nginx.com/) - Reverse proxy

## Authors

* **Liz Asraf** - *Initial work* - [Your Github](https://github.com/LizAsraf/)[liz.asraf1@gmail.com](mailto:liz.asraf1@gmail.com)