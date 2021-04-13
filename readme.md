# Terraform infrastructure v1
## Note: not production ready

### Overview
This repository provisions the following resources:
1. Remote state defined by [tf_s3_dynamo_remote_state](https://github.com/smokentar/tf_s3_dynamo_remote_state)
2. MYSQL database and a basic web cluster fronted by ALB defined by [aws_tf_modules](https://github.com/smokentar/aws_tf_modules)
3. Production and Staging environment defined by `master` / `staging` branches in [aws_tf_modules](https://github.com/smokentar/aws_tf_modules)
