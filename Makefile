.PHONY: *

all: init 

build-base:
	docker build -t build-env -f Dockerfile.build .

init:
	chown -R www-data:www-data /project
	
reset:
	docker exec drupal wget https://github.com/drush-ops/drush/releases/download/8.1.16/drush.phar
	docker exec drupal php drush.phar core-status
	docker exec drupal chmod +x drush.phar
	docker exec drupal mv drush.phar drush
	docker exec drupal ./drush dl commerce_kickstart
	docker exec drupal sh -c "echo y | ./drush si commerce_kickstart --db-url='mysql://root:mariaSql@mariadb/drupal' --site-name=Drupal --account-name=admin --account-pass=drupal123"
	docker exec drupal chown -R www-data:www-data /var/www/html
	
up: 
	docker-compose up -d

down:
	docker-compose down
