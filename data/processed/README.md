# Data Cookbook


## Files
### repo_ano_hash

This file contains info about repos. Each row stands for a repo. There are 3 columns:

* number of commits
* lab: which lab this repo is for
* username_hash: hashed github username

username_hash serves as an external key.

### commit_ano_hash

This file contains all info about commit. Each row stands for a commit. There are 8 columns:

* timestamp: when commit happens
* comment: comment for the commit
* changes: number of lines being changed
* build state: success / fail / cancel
* tests passed: how many test cases have passed
* tests run: how many test cases have run
* lab: which lab this commit is for
* username_hash: hashed github username

Both username_hash and lab serve as external keys.

Two columns (tests passed, tests run) might be difficult to understand. There are only three labs you need to focus on:

* lab2: 3 test cases in total; Due Jan 27 at 11:59pm; 4 points in total; number of lines of skeleton 33
* lab3: 8 test cases in total; Due Feb 10 at 11:59pm; 8 points in total; number of lines of skeleton 112
* lab4: 8 test cases in total; Due Feb 24 at 11:59pm; 4 points in total; number of lines of skeleton 138

### feedback_hash

This files contains info about student feedback on auto feedback. There are 6 columns:

* id_hash: hashed student ID
* section: which section a student is in
* To what extent did you use the automated feedback on Travis when you work on your labs / projects?
* What do you do when you find that you have a failed test case on Travis? Describe your experience of utilizing the feedback from Travis.
* What do you like about the automated feedback from Travis?
* What do you dislike about the automated feedback from Travis? How do you want us to improve it?

id_hash serves as an external key.

There were three sections:

* 11713: most generic feedback - which failed which passed
* 11714: feedback - what is wrong
* 11715: feedback - what is wrong; how you are likely to fix the issues

### performance_hash

This file contains info about lab performance. All columns include:

* id_hash: hashed student ID
* section: which section a student is in
* lab2
* lab3
* project1
* lab4
* project2
* midterm
* final

id_hash serves as an external key.

There were three sections:

* 11713: most generic feedback - which failed which passed
* 11714: feedback - what is wrong
* 11715: feedback - what is wrong; how you are likely to fix the issues

### username_ano_hash

This file contains info about github username.

* section
* id_hash: hashed student ID
* username_hash: hashed github username

id_hash and username_hash are paired here.

There were three sections:

* 11713: most generic feedback - which failed which passed
* 11714: feedback - what is wrong
* 11715: feedback - what is wrong; how you are likely to fix the issues
