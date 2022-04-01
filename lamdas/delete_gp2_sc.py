import logging
import urllib3
from urllib3.exceptions import HTTPError
from http import HTTPStatus

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

logger = logging.getLogger()
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s: %(levelname)s: %(message)s')

def lambda_handler(event, context):
    url = event['url']
    token = event['token']

    http = urllib3.PoolManager(cert_reqs='CERT_NONE')

    gp2_storageclass_exists = True

    # Check if gp2 StorageClass exists
    endpoint = '%s/apis/storage.k8s.io/v1/storageclasses/gp2' % url
    headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer %s' % token
    }
    logger.info('Checking if gp2 StorageClass exists')
    try:
        response = http.request('GET', endpoint, headers=headers)
    except HTTPError:
        logger.error('Failed to check if gp2 StorageClass exists')
        raise
    if response.status == 200:
        logger.info('gp2 StorageClass exists')
        gp2_storageclass_exists = True
    elif response.status == 404:
        logger.info('gp2 StorageClass does not exists')
        gp2_storageclass_exists = False
    else:
        logger.error('Failed to check if gp2 StorageClass exists')
        raise Exception('Return code: %s (%s)' % (response.status, [ status.name for status in HTTPStatus if status.value == response.status ][0]))

    # Delete gp2 StorageClass if it exists
    if gp2_storageclass_exists:
        endpoint = '%s/apis/storage.k8s.io/v1/storageclasses/gp2' % url
        headers = {
            'Accept': 'application/json',
            'Authorization': 'Bearer %s' % token
        }
        logger.info('Deleting StorageClass gp2')
        try:
            response = http.request('DELETE', endpoint, headers=headers)
        except HTTPError:
            logger.error('Failed to delete StorageClass gp2')
            raise
        if response.status == 200:
            logger.info('Successfuly deleted StorageClass gp2')
            gp2_storageclass_exists = False
        else:
            logger.error('Failed to delete StorageClass gp2')
            raise Exception('Return code: %s (%s)' % (response.status, [ status.name for status in HTTPStatus if status.value == response.status ][0]))
