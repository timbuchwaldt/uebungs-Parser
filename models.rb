class Result
   include DataMapper::Resource
   property :id,        Serial                       
   property :lecture,     String,  :required => true   
   property :nr, Integer,  :required => true  
   property :hw_possible,Integer
   property :hw_result, Integer, :default => 0
   property :on_possible, Integer, :default => 0
   property :on_result, Integer, :default => 0
 end
class Total
  include DataMapper::Resource
  property :id,        Serial
  property :lecture,     String,  :required => true  
  property :possible, Integer
  property :result, Integer, :default => 0
end