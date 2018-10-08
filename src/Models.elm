module Models exposing (Car, Mechanic, initialCars, initialMechanics, m1)


type alias Car =
    { regNr : String
    , car : String
    , workType : String
    , status : String
    , mechanicId : Int
    }


type alias Mechanic =
    { id : Int
    , name : String
    }


m1 =
    Mechanic 0 "Ole"


m2 =
    Mechanic 1 "Jesper"


initialMechanics =
    [ m1, m2 ]


initialCars =
    [ { regNr = "ZT47121"
      , car = "Hyundai I40"
      , workType = "EU-kontroll"
      , status = "Venter på mekaniker"
      , mechanicId = m1.id
      }
    , { regNr = "ZT52590"
      , car = "Skoda Octavia"
      , workType = "Dekkskifte"
      , status = "Arbeid startet 08:14"
      , mechanicId = m2.id
      }
    ]
