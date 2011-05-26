require 'rubygems'
require 'mechanize'
require 'awesome_print'
require 'highline/import'
require 'data_mapper'

require 'models'

#User-Settings
MATNR= "307760" #Matrikelnummer hier eintragem
PASSWD= HighLine::ask("Enter your password:  " ) { |q| q.echo = "" }

#Automated Setup
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.auto_migrate!


linalg =  Hash.new
linalg["name"]= "Lineare Algebra"
linalg["sum"] = /insgesamt (\d*) \D* (\d*) Punkten/
linalg["table"] = /<tr><td align="center">(\d*)<\/td><td align="center">(\d*) \((\d*)\)<\/td><td align="center">(\S*) \((\d*)\)/
linalg["login"] = "http://www2.math.rwth-aachen.de:8057/resquery.html"
linalg["results"] ="http://www2.math.rwth-aachen.de:8057/QueryResults"

dua =  Hash.new
dua["name"]= "Datenstrukturen und Algorithmen"

dua["login"] = "https://aprove.informatik.rwth-aachen.de/dsal11/login"
dua["results"] = "https://aprove.informatik.rwth-aachen.de/dsal11/student"
dua["sum"]= /<tr><TD align=center>Total<\/TD><TD align=center>(\d*).\d<\/td><td align=center>(\d*).\d<\/TD><\/tr>/
dua["table"] = /<TR><TD align=center>(-\d+|\d+)<\/TD><TD align=center>(\d*).?\d?<\/TD><TD align=center>(\d*).?\d?<\/TD><\/TR>/

fosap =  Hash.new
fosap["name"]= "Formale Systeme"
fosap["table"] = /<TR><TD align=center>(-\d+|\d+)<\/TD><TD align=center>(\d*.*\d*)<\/TD><TD align=center>(\d*.*\d*)<\/TD><\/TR>/
fosap["sum"]= /<tr><TD align=center>Total<\/TD><TD align=center>(\d*).\d<\/td><td align=center>(\d*).\d<\/TD><\/tr>/
fosap["login"] = "https://aprove.informatik.rwth-aachen.de/fosap11/login"
fosap["results"] = "https://aprove.informatik.rwth-aachen.de/fosap11/student"


lessons = [linalg,dua,fosap]
#lessons = [linalg]
lessons.each do |lesson|
  agent = Mechanize.new
  page = agent.get lesson["login"]
  form = page.forms.first
  if lesson["name"] == "Lineare Algebra"
    form.id = MATNR
    form.passwd = PASSWD
    page = agent.submit(form, form.buttons.first)
  else
    form.loginname = MATNR
    form.password = PASSWD
    page = agent.submit(form, form.buttons.first)
    page =  agent.get lesson["results"]
  end
  #puts page.body
  res =  page.body.scan lesson["sum"]
  #ap res
  pos = res[0][1].to_f
  have = res[0][0].to_f
  #puts rate=((100/pos)*have).to_i
  #puts (100-rate).to_i
  res =  page.body.scan lesson["table"]
  #ap res
  res.each do |result|
    @res = Result.create(
      :lecture => lesson["name"],
      :nr => result[0],
      :hw_result => result[1].to_i,
      :hw_possible => result[2].to_i,
      :on_result => result[3],
      :on_possible => result[4]
    )
    @res.save
  end
  ap Result.all
end