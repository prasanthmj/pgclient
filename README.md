# pgclient
Docker image for minimalist Postgres client with command line tools . It also has rclone to take backup to cloud storage like s3


## Sample IAM permissions 
That works with rclone copy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::my-backup-bucket",
                "arn:aws:s3:::my-backup-bucket/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "arn:aws:s3:::*"
        }
    ]
}
```

