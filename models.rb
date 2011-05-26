class Result
   include DataMapper::Resource
   property :id,        Serial                       # primary serial key
   property :lecture,     String,  :required => true   # Cannot be nil
   property :nr, Integer,  :required => true  # Default value for new records is false
   property :hw_possible,Integer
   property :hw_result, Integer, :default => 0
   property :on_possible, Integer, :default => 0
   property :on_result, Integer, :default => 0
 end