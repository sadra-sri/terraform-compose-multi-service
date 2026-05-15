provider "aws" {
	region = "us-east-1"
}

resource "aws_security_group" "my_sg"{

	name = "my_security_group"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress {

		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {

		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

}

resource "aws_instance" "app_server" {

	ami = "ami-091138d0f0d41ff90"
	instance_type = "t3.micro"
	key_name="sadrasaririjavan"
	vpc_security_group_ids = [aws_security_group.my_sg.id]



	connection {

		type = "ssh"
		user = "ubuntu"
		private_key = file("/home/ubuntu/sadrasaririjavan.pem")
		host = self.public_ip
	}

	provisioner "file"{

		source = "docker-compose.yml"
		destination = "/home/ubuntu/docker-compose.yml"
	}

	provisioner "file"{

		source = "nginx.conf"
		destination = "/home/ubuntu/nginx.conf"
	}


	provisioner "remote-exec" {

		inline=[
		
			"sudo apt update",
			"sudo apt install docker.io -y",
			"sudo apt install docker-compose-v2",
			"cd /home/ubuntu",
			"sudo docker compose up -d",
		]	
	}


}


