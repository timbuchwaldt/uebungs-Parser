require "rubygems"
require "bundler/setup"

require 'mechanize'
require 'awesome_print'
require 'highline/import'
require 'data_mapper'

require 'models'
DataMapper.finalize
#User-Settings
MATNR=  HighLine::ask("Enter your MatrikelNr:  " ) { |q| q.echo }
PASSWD= HighLine::ask("Enter your password:  " ) { |q| q.echo = "" }

#Automated Setup
#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/test.db")
DataMapper.auto_upgrade!


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
Total.all.destroy
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
  @total = Total.create(
    :lecture => lesson["name"],
    :result => res[0][0].to_i,
    :possible => res[0][1].to_i
  )
  res =  page.body.scan lesson["table"]
  #ap res
  res.each do |result|
    @res = Result.new(
      :lecture => lesson["name"],
      :nr => result[0],
      :hw_result => result[1].to_i,
      :hw_possible => result[2].to_i,
      :on_result => result[3],
      :on_possible => result[4]
    )
    have_with_0 = Result.first(:lecture => lesson["name"],:nr => result[0])
    if have_with_0.nil?
      puts "Saving result #{@res}"
      ap @res
      @res.save
    elsif !have_with_0.nil? && result[1] != '' && have_with_0.hw_result == 0
      puts "updating result #{have_with_0}"
      ap have_with_0
      have_with_0.update(:hw_result => result[1].to_i)
    else
      puts "already have result"
    end
  end
  #ap Result.all
end
