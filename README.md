This Rails project contains a rake task to push local mongo database dump to AWS S3 

STEPS to Follow
=> Clone the respository and got to root path.
=> run 'bundle install'
=> Install MongoDB on your local machine
=> Setup an AWS account with an IAM user restricting access AWS S3 alone.
=> Create an AWS S3 bucket and set proper permissions for the bucket.
=> run 'rake mongo:backup --trace' 
=> Task will ask you enter
	=> AWS Access Key (Type in and hit ENTER key)
	=> AWS Access Secret (Type in and hit ENTER key)
	=> AWS Target bucket name (Type in and hit ENTER key)
	=> Name of local mongodb database name (Type in and hit ENTER key)
=> Hit ENTER and system will generate dump as zip and upload to the S3 bucket

** NOTE: You need to install MongoDB on your local machine **
** NOTE: For this POC Local MongoDB is set to have no authetication username and password **




