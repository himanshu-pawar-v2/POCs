resource "aws_instance" "web" {
    ami = "var.image_id"
    instance_type = "var.instance_type"
    #key_name = "aws_key_pair.key-tf.V2KeyP" 
}
#ami = "ami-0376ec8eacdf70aae"
 #   instance_type = "t2.micro"
    #key_name = "aws_key_pair.key-tf.V2KeyP" 