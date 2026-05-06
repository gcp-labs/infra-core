1 - gcloud compute networks create infra-vpc --subnet-mode=custom
2 - gcloud compute networks subnets create subnet-backend \
    --network=infra-vpc \
    --range=10.0.1.0/24 \
    --region=us-central1

3 - gcloud compute firewall-rules create allow-ssh \
    --network=infra-vpc \
    --allow=tcp:22 \
    --source-ranges=0.0.0.0/0    