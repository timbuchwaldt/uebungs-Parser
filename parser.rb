require 'rubygems'
require 'mechanize'
require 'awesome_print'

MATNR= "307760" #Matrikelnummer hier eintrage
PASSWD= "" #Passwort hier eintragen

linalg =  Hash.new
linalg["la"]=true
linalg["sum"] = /insgesamt (\d*) \D* (\d*) Punkten/
linalg["table"] = /<tr><td align="center">(\d*)<\/td><td align="center">(\d*) \((\d*)\)<\/td><td align="center">(\S*) \((\d*)\)/
linalg["login"] = "http://www2.math.rwth-aachen.de:8057/resquery.html"
linalg["results"] ="http://www2.math.rwth-aachen.de:8057/QueryResults"

dua =  Hash.new
dua["la"]=false

dua["login"] = "https://aprove.informatik.rwth-aachen.de/dsal11/login"
dua["results"] = "https://aprove.informatik.rwth-aachen.de/dsal11/student"
dua["sum"]= /<tr><TD align=center>Total<\/TD><TD align=center>(\d*).\d<\/td><td align=center>(\d*).\d<\/TD><\/tr>/
dua["table"] = /<TR><TD align=center>(-\d+|\d+)<\/TD><TD align=center>(\d*).?\d?<\/TD><TD align=center>(\d*).?\d?<\/TD><\/TR>/

fosap =  Hash.new
fosap["la"]=false
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
  if lesson["la"]
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
  puts rate=((100/pos)*have).to_i
  puts (100-rate).to_i
  res =  page.body.scan lesson["table"]
  ap res
end