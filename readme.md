This is an example JBoss application that is ready to deploy on CloudBees.

This example shows how to setup an app that uses  persistence.xml with a CloudBees database.

Requirements
-----

* Install Maven 3.0.4+
* Sign up for an account at www.cloudBees.com
* Install the CloudBees SDK (for bees commands)


Instructions
------------

Get the source

    git clone git@github.com:swashbuck1r/jboss-db-example.git

Build the WAR file

    mvn package

Deploy the WAR file

    bees app:deploy -t jboss -a MYAPP_ID target/jboss-db-example.war

Create a database for the app

    bees db:create -u DB_USER -p DB_PASSWORD DBNAME

Bind the database to the app (using datasource alias "ExampleDS" defined in persistence.xml)

    bees app:bind -db DBNAME -a MYAPP_ID -as ExampleDS

Restart the app (to inject the new database binding)

    bees app:restart MYAPPID
