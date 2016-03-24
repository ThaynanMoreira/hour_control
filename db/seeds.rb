# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

tasks = Task.create([{:name => 'Desenvolvimento'}, {:name => 'Reunião'}, {:name => 'Ausente'}])

client = Client.create({:name => 'Interno'}, {:description => 'Produtos internos'})

types = Type.create([{:name => 'Administrador'}, {:name => 'Programador'}, {:name => 'Designer'}, {:name => 'Assistente'}, {:name => 'Analista'}])

user = User.create({:name => 'Admin', :email => 'admin@email.com', :password => '12345678', :type_id => 0 })
