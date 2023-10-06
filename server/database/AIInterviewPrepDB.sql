USE master
GO

IF DB_ID('ai_interview_prep') IS NOT NULL
BEGIN
	ALTER DATABASE ai_interview_prep SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE ai_interview_prep;
END

CREATE DATABASE ai_interview_prep
GO

USE ai_interview_prep
GO

CREATE TABLE deck (
	deck_id INT IDENTITY(1, 1) NOT NULL,
	deck_name NVARCHAR(255),
	CONSTRAINT PK_deck PRIMARY KEY (deck_id)
);

CREATE TABLE question (
	question_id INT IDENTITY(1, 1) NOT NULL,
	question_text NVARCHAR(MAX) NOT NULL,
	deck_id INT NOT NULL,
	CONSTRAINT PK_question PRIMARY KEY (question_id),
	CONSTRAINT FK_question_deck FOREIGN KEY (deck_id) REFERENCES deck (deck_id)
);


INSERT INTO deck (deck_name) VALUES ('Interview Question of the Day');
INSERT INTO deck (deck_name) VALUES ('Top 25 Interview Questions');

DECLARE @iqotd_id INT;
SELECT @iqotd_id = deck_id FROM deck WHERE deck_name = 'Interview Question of the Day';

INSERT INTO question (question_text, deck_id) VALUES (N'What is git? Why do we use it?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is a variable? Can you give an example of an integer expression? A boolean expression?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What controls whether the “if” or the “else” portion of an if-else should execute?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Why should the code for each if or else be enclosed in a scope “{ }”?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What programming problem does a loop solve? Why would we use a loop?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How do we display information on the console? How do we take in information from the user in a console program?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is an object? What is a class?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How is an array like a List(C#) / ArrayList(Java)? How are they different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Tell me about a Dictionary(C#) / HashMap(Java).', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is encapsulation? Why is it important?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is inheritance? Why, as a programmer, would you choose to use inheritance?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is polymorphism? How is polymorphism like inheritance? How is it different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is an interface, and why would you use one?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How are abstract classes and interfaces alike? How are they different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is Unit Testing? What tools are used to do automated Unit Testing?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are the three principles of Object Oriented Programming? Give an example for each.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'When catching Exceptions, should the code catch a specific exception type (like ''Subscript out of bounds'') or the general ''Exception'' type? Why?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'When writing files, what does it mean to append? What does it mean to not append?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'For an application that has a console user interface, reads and writes information to a file, and provides the ability to do CRUD (Create, Read, Update, and Delete) functions on the data in memory while executing, how might you organize and structure the classes and methods in your code?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is pair programming? What are the basic rules? What are its advantages and disadvantages?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'For some project you have worked on, if you were starting over now, knowing what you know, how would you approach the project differently?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is an RDBMS? Can you name some commercial and open-source RDBMS''s?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'The major elements of a SQL SELECT are written in a certain order. What''s that Order? (Hint: The first two are SELECT and FROM.)', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are the special considerations for GROUP BY in SQL queries?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are the two forms of the INSERT statement in SQL? Which is preferred? Why?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Why would a developer want to develop and maintain a SQL script for a database under development or being changed?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is a DAO, and what OOP principal does in most clearly express?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Why is it important to use parameter substitution rather than string concatenation when building SQL strings inside of code? Extra credit: Who is Little Bobby Tables?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What software vulnerability is totally under the control of the programmer (even a junior developer)?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are some examples of Integration Testing?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Why would you want to use SQL to select the specific information you need inside your program? Why not just select all the information from a table and hold it in a collection inside your program?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What does the first forward-slash (''/'') in a URL represent? What does the question mark (''?'') in a URL represent?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In HTTP, how are the GET and POST verbs alike? How are they different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Assume four blocks of code: 1) Controller and 2) Model/DAOs for a server and 3) User Interface, and 4) API Service for a client. Describe the flow of a REST request and response. Describe the role/responsibility of each block of code.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How can we test that our client-server application is following the rules and protocols of REST?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is a JWT? How is it generated, and how is it used?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Describe MVC in the context of a Web Service running on a server.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Why do HTTP POST and PUT use a request body? Why not just put information in the path or query string of the URL?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What should HTTP status codes in the 200''s indicate? The 400''s? The 500''s? What specific HTTP status codes do you know, and what should they mean?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In JavaScript, should you use ''let'' or ''var'' to create variables? Why?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In a world of HTML, CSS, and JavaScript, what role do each provide in the browser?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What different ways do you know to define a function in JavaScript?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are some common selectors used with HTML and CSS and how are they specified in CSS?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In CSS, what does it mean when multiple selectors are used together with spaces between them? (div li) With no space between them? (div.hidden) With commas between them? (div, li) With > between them (div > li)', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In general, what part of a web page layout should be controlled by CSS Grid? What part should be controlled by CSS Flex?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In JavaScript, this symbol ( => ) is referred to by what name? What JavaScript keyword does it replace? Bonus: What are some other names the symbol is called?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How is the ''event-driven'' style of program execution different from the ''sequential'' style of execution we utilized in simple console programs during the first few weeks of the program?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Describe at least two ways we have used anonymous functions in Vanilla Javascript.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Describe some advantages and disadvantages of Vue.js over vanilla JavaScript.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is mustache notation in Vue.js, and how is it different from v-model binding? Where is v-model binding mostly seen in Vue.js?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Why do we use ''.prevent'' with some vue.js events? Bonus: What event on what element should be ''handled'' for an input element of type submit?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How are v-if and v-show alike? How are they different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are two ways that vue.js components can pass data from component to component? Which one is intended to be used between parent and child components? Which one can be used between any components in an application?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is the role of <router-view> in the default vue.js router?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is the role of the ''created'' function of a vue.js component?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In vue.js component script sections, what elements are peers (exist at the same level) as the data section?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What information does a promise return in JavaScript? What are the 3 possible states for a promise?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In vue.js, where must we use ''this.'' with variables and methods (functions in the methods section)? Where do we not need to use the ''this.'' keyword?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In vue.js, ''router-link'' and ''router.push'' are both used to navigate from the current view to another view using the router. When should you use each?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'You are developing a Vue.js application with a web service providing the data. The web service has been tested with Postman and is working correctly. You create a Vue.js component that should display information retrieved from the web service. Nothing is displayed on the web browser. What do you look at, and what do you do to determine where the problem exists?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How are a ''for'' loop (''for (int i = 0; i < size; i++)'') and a ''while'' loop alike? How are they different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is the difference between overloading and overriding? Does JavaScript support overloading?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In Java or C#, how are methods and constructors alike? How are they different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In Java or C#, what is the difference between value/primitive types and reference types? How are they represented in memory?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'You are retrieving data from a database for a server program. All other things being equal, should you retrieve all of the data from a table and filter it in the server application, OR should you use the RDBMS to select just the information that you want? Why? What factors might cause you to change your decision?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What purpose does the Vuex data store serve in Vue.js? What is a circumstance when you might NOT want to use Vuex?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What elements make us the signature of a method in Java or C#?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is a static class? How is it used differently than a non-static class?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is the difference between a stack and a queue?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is the difference between a primary key and a foreign key in a relational database?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'The first element of the signature of a method is the access modifier. What access modifiers do you know, and what do they mean?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How is JavaScript like C# or Java? How is it different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How would you explain APIs to a non-technical team member?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is REST?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is the purpose of computed properties in Vue.js? How are they different from methods?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is the purpose of semantic HTML?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Describe the CSS box model.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How does garbage collection work? What things are not garbage collected?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are serialization and deserialization? How are they used when communicating using the REST architecture?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Can you describe a Vue.js lifecycle hook that you’ve used and how you used it?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How is an ''if'' statement like a ''while'' statement? How are they different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How many constructors can a class have? How many constructors can be used when creating a single object?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What value/primitive data types can name for Java or C#? What kind of information would you use each one for?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'The keywords ''final'' in Java and ''const'' in C# mean approximately the same thing. What do they mean?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Explain the concept of a RESTful API.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is the difference between the HTTP and HTTPS protocols?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are the different data types in JavaScript?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are truthy and falsy values in JavaScript?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is the purpose of Vue Router and how is it used for routing in Vue.js applications?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Vue.js is a JavaScript framework. What is a JavaScript framework? What other JavaScript frameworks can you name?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are exceptions, and how would you write code to allow your program to keep running if an exception occurred in Java or C#?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What type of SQL JOINs do you know about? Which SQL JOIN is used most frequently?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is a LEFT OUTER JOIN in SQL? Can you give an example of when you might use a LEFT OUTER JOIN?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In SQL, what is an alias?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What SQL commands correspond to the CRUD functions?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In SQL, what is the purpose of the LIKE operator?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How do you count the number of rows in a SQL table?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What does it mean to have a NULL value in SQL?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How do you delete a table in SQL? What might prevent deleting a table?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'For Java or C#, describe the process of reading multiple rows of information from a SQL table and displaying it in a console program.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'IN SQL, you just inserted a row into a table with a surrogate key generated by the RDBMS (like IDENTITY). Describe how your SQL could get the generated value. Why might you want to retrieve such a value?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What do the different groups of SQL commands (DDL, DML, DCL) represent?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is ANSI SQL, and why is it important?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'HTTP is defined by an RFC. What is an RFC?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In developing a REST client-server application, what tool could you use to simulate the client to be able to test the server?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What are the 4 HTTP verbs we use most frequently as developers? What should they be used for? Which ones usually include a request body? Which one is unlikely to include an endpoint identifier (id) in the path portion of the URL?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Why can’t an exception thrown in a server application be caught in the associated client application? What would be the proper way of expressing an error condition in the server to the associated client?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'For a REST-based web-services Server application, what software could act as a client? (Hint: we worked with 3 different clients in the program).', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Why would you even want to use a client-server architecture? Why not just put all the code into one program and load it onto each individual computer?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What 6 values are falsey in JavaScript?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'JavaScript is described as a loosely-typed language. What does that mean?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is node.js, and why might you use it?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In a programming environment and language you are familiar with, describe how you might solve the problem of no apparent errors being reported but no output is produced. In other words, the program seems to be working but never displays a result.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Explain the concept of normalization in databases.', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is serialization and deserialization?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is loose coupling?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In Web page design, what does “The Holy Grail” refer to?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Can CSS Flexbox be used with CSS Grid? Can a page have more than one CSS Grid container?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In Vanilla JavaScript, what do event.stopPropagation and event.preventDefault provide? Which one is used more often?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'When an event happens on an HTML element, what other elements “see” that same event?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In vue.js, how does the v-for work?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In making use of vue.js data defined in the “data” section of the script element, when is it necessary to use the keyword “this? When should you not use the keyword “this”?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Can you describe how the array function “filter” works in JavaScript?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What is a template in Vue.js? How do you define templates in your Vue components?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'What role do Axios, fetch, and XHR play in JavaScript?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'How would you add Vuex or Router to an existing vue.js application? Bonus: what step(s) should you take to ensure nothing is lost while adding these additional features?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In Vue.js, how are router-link and router.push alike? How are they different?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'In the vue.js router, you’re asked to convert a static route to a dynamic one. What three changes do you need to make to accomplish this? Bonus: What value does a dynamic route in the vue.js router offer over a static route?', @iqotd_id);
INSERT INTO question (question_text, deck_id) VALUES (N'Using vue.js and your favorite server environment (Apachie and Java/Spring, or IIS and ASP.NET), describe the steps that your code might take to get and display a list of students.', @iqotd_id);


GO