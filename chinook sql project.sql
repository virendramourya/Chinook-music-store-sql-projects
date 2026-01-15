
1) Find the artist who has contributed with the maximum no of albums. Display the artist name and the no of albums.

select count(albumid) as count,Name from artist a1 join album a2 on a1.artistid = a2.artistid
group by name
order by count desc
limit 1
													 or
with temp as
    (select alb.artistid
    , count(1) as no_of_albums
    , rank() over(order by count(1) desc) as rnk
    from Album alb
    group by alb.artistid)
select art.name as artist_name, t.no_of_albums
from temp t
join artist art on art.artistid = t.artistid
where rnk = 1;

2) Display the name, email id, country of all listeners who love Jazz, Rock and Pop music.
select  (c.firstname||' '||c.lastname) as customer_name
, c.email, c.country, g.name as genre
from InvoiceLine il
join track t on t.trackid = il.trackid
join genre g on g.genreid = t.genreid
join Invoice i on i.invoiceid = il.invoiceid
join customer c on c.customerid = i.customerid
where g.name in ('Jazz', 'Rock', 'Pop');


3) Find the employee who has supported the most no of customers. Display the employee name and designation

select count(*) as count,(e.firstname || " " || e.lastname ) as employee_name,title as designation from customer c join employee e on e.employeeid = c.supportrepid
group by e.employeeid
order by designation desc 
limit 1 

4) Which city corresponds to the best customers?

select city from customer c join invoice i on c.customerid = i.customerid
group by city 
order by sum(total) desc 
limit 1
                                                  or
5) The highest number of invoices belongs to which country?
select billingcountry from invoice
group by billingcountry
order by count(*) desc
limit 1

select country
from (
    select billingcountry as country, count(1) as no_of_invoice
    , rank() over(order by count(1) desc) as rnk
    from Invoice
    group by billingcountry) x
where x.rnk=1;


6) Name the best customer (customer who spent the most money).

select c.customerid,sum(total) as cc, (firstname || " " || lastname)  as customer from customer c join invoice i on c.customerid = i.customerid
group by c.customerid
order by cc desc          
                                                or 
select (c.firstname||' '||c.lastname) as customer_name
from (
    select customerid, sum(total) total_purchase
    , rank() over(order by sum(total) desc) as rnk
    from Invoice
    group by customerid) x
join customer c on c.customerid = x.customerid
where rnk=1;
   select * from genre
7) Suppose you want to host a rock concert in a city and want to know which location should host it.

select  count(1) as dd,sum(total) as cc,I.billingcity,g.name from Track T
join Genre G on G.genreid = T.genreid
join InvoiceLine IL on IL.trackid = T.trackid
join Invoice I on I.invoiceid = IL.invoiceid
where g.name = "rock"
   group by I.billingcity
   order by 2 desc
   
 8) Identify all the albums who have less then 5 track under them.
    Display the album name, artist name and the no of tracks in the respective album.
   
   with temp as
    (select t.albumid, count(1) as no_of_tracks
    from Track t
    group by t.albumid                                           
    having count(1) < 5
    order by 2 desc)
select al.title as album_title, art.name as artist_name, t.no_of_tracks
from temp t
join album al on t.albumid = al.albumid
join artist art on art.artistid = al.artistid
order by t.no_of_tracks desc;
                                                                   or
                                                                   
 select count(TrackId)  as no_of_track,t.AlbumId,bm.name ,a.title from track t  join album a on t.AlbumId = a.AlbumId join artist bm on  a.ArtistId = bm.ArtistId
 group by albumid
 having count(TrackId) < 5
 order by cc desc
 
   
9) Display the track, album, artist and the genre for all tracks which are not purchased.

select t.name as track_name, al.title as album_title, art.name as artist_name, g.name as genre
from Track t
join album al on al.albumid=t.albumid
join artist art on art.artistid = al.artistid
join genre g on g.genreid = t.genreid
where not exists (select 1
                 from InvoiceLine il
                 where il.trackid = t.trackid);

10) Find artist who have performed in multiple genres. Diplay the aritst name and the genre.

with temp as
        (select distinct art.name as artist_name, g.name as genre
        from Track t
        join album al on al.albumid=t.albumid
        join artist art on art.artistid = al.artistid
        join genre g on g.genreid = t.genreid
        order by 1,2),
    final_artist as
        (select artist_name
        from temp t
        group by artist_name
        having count(1) > 1)
select t.*
from temp t
join final_artist fa on fa.artist_name = t.artist_name
order by 1,2;

11) Find the artist who has contributed with the maximum no of songs/tracks. Display the artist name and the no of songs.

select name from (
    select ar.name,count(1)
    ,rank() over(order by count(1) desc) as rnk
    from Track t
    join album a on a.albumid = t.albumid
    join artist ar on ar.artistid = a.artistid
    group by ar.name
    order by 2 desc) x
where rnk = 1;
                             or
                                                  
  select count(1) as no_of_track,a2.name from track t join album a on a.albumid = t.trackid    join artist a2 on a2.artistid =  a.artistid  
  group by a2.artistid
  order by count(1) desc
  limit 1

12) Are there any albums owned by multiple artist?
     
select albumid, count(1) 
from Album 
group by albumid 
having count(1) > 1;

13) Is there any invoice which is issued to a non existing customer?

select * from Invoice I
where not exists (select 1 from customer c 
                where c.customerid = Invoice.customerid);
                
14) Is there any invoice line for a non existing invoice?

select * from InvoiceLine IL
where not exists (select 1 from Invoice I where I.invoiceid = IL.invoiceid);

15) Are there albums without a title?

select count(*) from Album 
where title is null;

16) Are there invalid tracks in the playlist?

select * from PlaylistTrack pt 
where not exists (select 1 from Track t 
                 where t.trackid = pt.trackid)


17) Identify if there are tracks more expensive than others. If there are then
    display the track name along with the album title and artist name for these expensive tracks.
    
    select t.name as track_name, al.title as album_name, art.name as artist_name
from Track t
join album al on al.albumid = t.albumid
join artist art on art.artistid = al.artistid
where unitprice > (select min(unitprice) from Track)













