=begin
  Function to initialize the upload script.
  Need to input AWS access keys, local database name.
  File is uploaded with time stamp.
=end
require 'zip'
namespace :mongo do
  desc 'This task will tae mongo backup on local and store to AWS S3 bucket'
  task :backup => :environment do

	class Mongo_Backup

=begin
  Function to initialize the upload script.
  Need to input AWS access keys, local database name.
  File is uploaded with time stamp.
=end
	  def initialize
	    puts "Give AWS access Keys"
	    @access_key = STDIN.gets.chomp
	    puts "Give AWS access Secret"
	    @access_secret = STDIN.gets.chomp
	    puts "Give AWS bucket name"
	    @bucket_name = STDIN.gets.chomp
	    puts "Give target mongo database name on your local machine"
	    @mongo_database = STDIN.gets.chomp
	    @base_path = "#{Rails.root}/lib/tasks"
	    @directory = @base_path + @mongo_database 
	    @zipfile_name = Time.now.getutc.to_s + '.zip' 
	  end

=begin
  Function to create zip file.
  Zip file is created inside the tasks folder itself.
=end
	  def zip_dump
	    system("mongodump --host localhost --db #{@mongo_database} --out #{@base_path}")
	    Dir[@base_path + '*.zip'].select { |e| File.delete(e) }
	    Zip::File.open(@zipfile_name, Zip::File::CREATE) do |zipfile|
	      Dir[File.join(@directory, '**', '**')].each do |file|
		    zipfile.add(file.sub(@directory + '/', ''), file)
	      end
	    end
	  end

=begin
  Function to upload the zip file to AWS.
  Uses access keys received to upload the file.
=end
	  def upload
	    AWS.config(access_key_id: @access_key, secret_access_key: @access_secret)
	    s3 = AWS::S3.new 
	    key = File.basename(@zipfile_name)
	    s3.buckets[@bucket_name].objects[key].write(:file => @zipfile_name)
	    puts "Uploading file #{@zipfile_name} to bucket #{@bucket_name}."
	    FileUtils.rm_rf @zipfile_name
	  end

	end

=begin
  Execution starts here.
  Exceptions are caught and notified on the console.
=end
    begin
	  @mongo_backup = Mongo_Backup.new
	  @mongo_backup.zip_dump
	  @mongo_backup.upload
	rescue Exception => e
	  puts "Sorry got an exception!"
      puts e.message
	end

  end
end

