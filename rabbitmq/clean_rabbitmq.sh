mypath=$(cd `dirname $0`; pwd)
ansible all -m script -a 'rabbitmq/do_clean.sh'
