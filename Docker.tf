#terraform script to install docker on Amazon linux, create a dockerfile for amazon linux, create 
#a docker image after that create a container from this created docker image.

provider "aws" {
  region = "us-west-2"
}
#ec2 creation
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "name of key-pair"
}

# Install Docker on the EC2 instance
resource "remote_exec" "install_docker" {
  inline = [
    "sudo yum update -y",
    "sudo amazon-linux-extras install docker -y",
    "sudo service docker start",
    "sudo usermod -aG docker ec2-user",
    "sudo chkconfig docker on"
  ]

  connection {
    type        = "ssh"
    host        = aws_instance.example.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/my-key-pair.pem")
  }
}
# Create a Dockerfile for Amazon Linux
resource "null_resource" "create_dockerfile" {
  provisioner "local-exec" {
    command = <<EOT
cat <<EOF > Dockerfile
FROM amazonlinux:latest
RUN yum update -y && \
    yum install -y python3 && \
    yum clean all
CMD [ "python3", "-m", "http.server", "80" ]
EXPOSE 80
EOF
EOT
  }
}

# Create a Docker image from the Dockerfile
resource "docker_image" "example" {
  name         = "my-docker-image"
  build {
    context    = "."
    dockerfile = "Dockerfile"
  }
}

# Create a container from the Docker image
resource "docker_container" "example" {
  name  = "my-docker-container"
  image = docker_image.example.latest
  ports {
    internal = 80
    external = 8080
  }
}
