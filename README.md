The installation instructions are as per macOS

1. Run the file “db_dump.sql” using MySql Workbench. This is the data dump.
     we have created a single file to pull all the data for the table expense_management_system.

-> It contains data for 1 admin with username “admin1” and two users with username “dhruv” and “mumuksha”.
-> you can create any number of users using the signup portal (web app ) 


2. Running the JAVA application: 
   
   a. We have created project using java 17. 

       Download link: “https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html”
      
      Also, java compiler - IntelliJ : “https://www.jetbrains.com/idea/download/download-thanks.html?platform=macM1&code=IIC”

    b. Unzip project java application : “Expense-Management.zip”

    c. Open the project in IntelliJ and run “ExpenseManagementApplication.java” file to run the application.

    d.  Make sure that the database properties for the project is configured correctly :

 	In project root path “src/main/resources” -> open applications.properties file to configure the database url, username and password. 
           For now the DB is configured with :
 	URL : ”localhost:3306”
	username: “root”
	password: “root”

   e. The application runs on “localhost:8080”, make sure the port is free to run the application. 

   f. Once the application runs successfully, you should be able to open our API documentation and consumer : “http://localhost:8080/swagger-ui.html”. 

3. Now once both the above mentioned steps are completed, Now we will run the react application to run the user interface:

 a. Make sure to download nodejs version 16  :  “https://nodejs.org/en/download”

 b. Now, we need to unzip : “LogIt_UI.zip”, once the unzip is done.

 c. Go to root folder “Logit/” in terminal.

 d. fetch all required modules using command “npm install” 

 e. now run it by typing: “npm start” on the terminal 

   On any browser open “http://localhost:3000/” to access the application. 


