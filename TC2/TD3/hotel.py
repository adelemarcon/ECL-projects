class Personne:
    def __init__(self,nom):
        self.nom = nom

class Directeur(Personne):
    def __init__(self,nom):
        Personne.__init__(self,nom)
        self.hotels = []

class Client(Personne):
    def __init__(self,nom):
        Personne.__init__(self,nom)

class Hotel:
    def __init__(self,nom):
        self.nom = nom
        self.clients = []

class Chambre:
    def __init__(self,nom,hotel):
        self.nom = nom
        self.hotel = hotel