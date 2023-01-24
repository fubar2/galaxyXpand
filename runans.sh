# first time run only to generate and encrypt some vault passwords that do not matter but should always be set
DEST=environments/tf/group_vars
ansible-galaxy install -p roles -r requirements.yml
# ansible-galaxy collection install community.general
# make an unencrypted secret - will be encrypted before save
openssl rand -base64 24 > .vault-password.txt
openssl rand -base64 24 > .vault-id-secret.txt
printf "vault_rabbitmq_password_vhost: 127.0.0.1\n" > $DEST/secret.yml
printf "vault_rabbitmq_admin_password: " >> $DEST/secret.yml
openssl rand -base64 24 >> $DEST/secret.yml
printf "vault_id_secret: " >> $DEST/secret.yml
cat < ./.vault-id-secret.txt >> $DEST/secret.yml
printf "\n" >> $DEST/secret.yml
ansible-vault encrypt --encrypt-vault-id default --vault-password-file .vault-password.txt $DEST/secret.yml
ansible-playbook -i  $DEST/hosts  --vault-password-file .vault-password.txt playbook.yml
