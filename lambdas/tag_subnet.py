import logging
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s: %(levelname)s: %(message)s')

def lambda_handler(event, context):
    cluster_name = event['cluster_name']
    subnet_ids = event['subnet_ids']
    
    logger.info('Getting EC2 resource')
    try:
        ec2 = boto3.resource('ec2')
    except ClientError:
        logger.exception('Error getting EC2 resource')
        raise
    logger.info('Got EC2 resource')
    
    logger.info('Tagging subnets')
    try:
        ec2.create_tags(Resources=subnet_ids, Tags=[
                {'Key': 'kubernetes.io/cluster/%s' % cluster_name, 'Value': 'shared'},
                {'Key': 'kubernetes.io/role/internal-elb', 'Value': '1'}
            ]
        )
    except ClientError:
        logger.exception('Error tagging subnets')
        raise
    logger.info('Tagged subnets')

    return {
        'statusCode': 200,
        'body': 'Successfully tagged subnets'
    }
