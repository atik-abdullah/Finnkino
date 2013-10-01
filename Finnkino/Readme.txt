Example XML Datasctructure snippet
----------------------------------
----------------------------------
<Events>
    <Event>
    <OriginalTitle>2 Guns</OriginalTitle>
    <ProductionYear>2013</ProductionYear>
    <LengthInMinutes>109</LengthInMinutes>
    <Rating>16</Rating>
    <Genres>Toiminta, Komedia, Jännitys</Genres>
    </Event>

    <Event>
    <OriginalTitle>2 Guns</OriginalTitle>
    <ProductionYear>2013</ProductionYear>
    <LengthInMinutes>109</LengthInMinutes>
    <Rating>16</Rating>
    <Genres>Toiminta, Komedia, Jännitys</Genres>
    </Event>
    ...
</Events>


Example JSON Data structure snippent
------------------------------------
------------------------------------

{
   "total":18,
   "movies":[]
}

"movies":[
      {
         "id":"771313374",
         "title":"Rush",
         "year":2013,
         "mpaa_rating":"R",
         "runtime":123,
         "critics_consensus":"A sleek, slick, well-oiled machine, Rush is",
         "release_dates":{
            "theater":"2013-09-27"
         },
         "ratings":{
            "critics_rating":"Certified Fresh",
            "critics_score":88,
            "audience_rating":"Upright",
            "audience_score":94
         },
         "posters":{
            "thumbnail":"http://content8.flixster.com/movie/11/17/25/11172534_mob.jpg",
            "profile":"http://content8.flixster.com/movie/11/17/25/11172534_pro.jpg",
         },
         "abridged_cast":[]
      },
      {
         "id":"771313374",
         "title":"Rush",
         "year":2013,
         "mpaa_rating":"R",
         "runtime":123,
         "critics_consensus":"A sleek, slick, well-oiled machine",
         "release_dates":{
            "theater":"2013-09-27"
         },
         "ratings":{
            "critics_rating":"Certified Fresh",
            "critics_score":88,
            "audience_rating":"Upright",
            "audience_score":94
         },
         "posters":{
            "thumbnail":"http://content8.flixster.com/movie/11/17/25/11172534_mob.jpg",
            "profile":"http://content8.flixster.com/movie/11/17/25/11172534_pro.jpg",
         },
         "abridged_cast":[]
      }
]



"abridged_cast":[
    {
        "name":"Tom Hanks",
        "id":"162655641",
        "characters":[
            "Captain Richard Phillips"
        ]
    },
    {
        "name":"Barkhad Abdi",
        "id":"771454315",
        "characters":[
        "Muse"
        ]
    }
]


