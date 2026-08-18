create table personas(
  id_personas serial primary key 
  nombre_personas varchar(100) not null
  apellido varchar(100) not null
  edad int 
  id_comuna int
  constraint fk_curso
    foreign key (id_comuna)
    references comuna(id_comuna)
    On delete set null
    on update cascade

)

create table comuna(
  id_comuna serial primary key 
  nombre_comunas varchar(100) not null
)


update personas
set edad = edad+1
where nombre_personas is not null

insert into personas(nombre_personas,apellido,edad,id_comuna) values
('Conchito','Conchito',0,2)


delete from personas
where edad = 36

select avg(edad) from personas

select count(*) from personas
where edad < 18