
import argparse
import boto3
from botocore.exceptions import ClientError

REGION = "us-east-1"
INSTANCE_ID = "i-082427e3a8446f68f"

def check_and_recover(apply=False):
    ec2 = boto3.Session(
        profile_name="chaoscloud-recovery",
        region_name=REGION
    ).client("ec2")

    response = ec2.describe_instance_status(
        InstanceIds=[INSTANCE_ID],
        IncludeAllInstances=True
    )

    if not response["InstanceStatuses"]:
        print("No EC2 status information available.")
        return

    status = response["InstanceStatuses"][0]
    state = status["InstanceState"]["Name"]
    system = status["SystemStatus"]["Status"]
    instance = status["InstanceStatus"]["Status"]

    print(f"Instance: {INSTANCE_ID}")
    print(f"State: {state}")
    print(f"System status: {system}")
    print(f"Instance status: {instance}")

    if state != "running":
        print("Instance is not running. No recovery action taken.")
        return

    if instance == "impaired":
        if apply:
            ec2.reboot_instances(InstanceIds=[INSTANCE_ID])
            print("Recovery action: EC2 reboot requested.")
        else:
            print("DRY RUN: Instance is impaired. Reboot would be requested.")
        return

    if system == "impaired":
        print("System impairment detected. Manual AWS investigation required.")
        return

    print("EC2 health checks are not impaired. No recovery needed.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Allow an EC2 reboot when instance status is impaired"
    )
    args = parser.parse_args()

    try:
        check_and_recover(apply=args.apply)
    except ClientError as error:
        print("AWS error:", error)
