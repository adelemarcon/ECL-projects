# -*- coding: utf-8 -*-
"""
TD3-lieux-insolites.py

Application exemple : affichage de mes lieux préférés à la Croix-Rousse

@author: Ecole Centrale de Lyon, 2023
"""

import http.server
import socketserver
from urllib.parse import urlparse, parse_qs, unquote
import json

# numéro du port TCP utilisé par le serveur
port_serveur = 8080

class RequestHandler(http.server.SimpleHTTPRequestHandler):
  """"Classe dérivée pour traiter les requêtes entrantes du serveur"""

  # sous-répertoire racine des documents statiques
  static_dir = 'client'
  
  def __init__(self, *args, **kwargs):
    """Surcharge du constructeur pour imposer 'client' comme sous répertoire racine"""

    super().__init__(*args, directory=self.static_dir, **kwargs)
    

  def do_GET(self):
    """Traiter les requêtes GET (surcharge la méthode héritée)"""
    self.init_params()

    # requete location - retourne la liste des lieux et leurs coordonnées géogrpahiques
    if self.path_info[0] == "location":
      self.send_location()    

    # requete description - retourne la description du lieu dont on passe l'id en paramètre dans l'URL
    elif self.path_info[0] == "description":
      self.send_description()    

    # sinon : comportement par défaut
    else:
      super().do_GET()


  def send_location(self):
    """Génèrer une réponse avec la liste des lieux et leurs coordonnées géogrpahiques"""
    
    # simple liste de tuples en guise de base de données
    data=[{'id':1,'lat':45.76843,'lon':4.82667,'name':"Rue Couverte"},
          {'id':2,'lat':45.77128,'lon':4.83251,'name':"Rue Caponi"},
          {'id':3,'lat':45.78061,'lon':4.83196,'name':"Jardin Rosa-Mir"}]
    
    # réponse au format JSON
    body = json.dumps(data);
        
    # envoi de la réponse
    headers = [('Content-Type','application/json')];
    self.send(body,headers)


  def send_description(self):
    """Génèrer une réponse avec la description du lieu dont on passe l'id en paramètre"""
    
    data=[{'id':1,'desc':"Il ne faut pas être <b>trop grand</b> pour marcher dans cette rue qui passe sous une maison"},
          {'id':2,'desc':"Cette rue est <b>si étroite</b> qu'on touche les 2 côtés en tendant les bras !"},
          {'id':3,'desc':"Ce jardin <b>méconnu</b> évoque le palais idéal du Facteur Cheval"}]
    for c in data:
      if c['id'] == int(self.path_info[1]):
        # réponse au format JSON
        body = json.dumps(c);
             
        # envoi de la réponse
        headers = [('Content-Type','application/json')];
        self.send(body,headers) 
          
        break


  def send(self, body, headers=[]):
    """Envoyer la réponse au client avec le corps et les en-têtes fournis
    
    Arguments:
    body: corps de la réponse
    headers: liste de tuples d'en-têtes Cf. HTTP (par défaut : liste vide)
    """
    # on encode la chaine de caractères à envoyer
    encoded = bytes(body, 'UTF-8')

    # on envoie la ligne de statut
    self.send_response(200)

    # on envoie les lignes d'entête et la ligne vide
    [self.send_header(*t) for t in headers]
    self.send_header('Content-Length', int(len(encoded)))
    self.end_headers()

    # on envoie le corps de la réponse
    self.wfile.write(encoded)


  def init_params(self):
    """Analyse la requête pour initialiser nos paramètres"""

    # analyse de l'adresse
    info = urlparse(self.path)
    self.path_info = [unquote(v) for v in info.path.split('/')[1:]]
    self.query_string = info.query
    
    # récupération des paramètres dans la query string
    self.params = parse_qs(info.query)

    # récupération du corps et des paramètres (2 encodages traités)
    length = self.headers.get('Content-Length')
    ctype = self.headers.get('Content-Type')
    if length:
      self.body = str(self.rfile.read(int(length)),'utf-8')
      if ctype == 'application/x-www-form-urlencoded' : 
        self.params = parse_qs(self.body)
      elif ctype == 'application/json' :
        self.params = json.loads(self.body)
    else:
      self.body = ''
   
    # traces
    print('info_path =',self.path_info)
    print('body =',length,ctype,self.body)
    print('params =', self.params)


# Programme principal
if __name__ == '__main__' :
    # instanciation et lancement du serveur
    httpd = socketserver.TCPServer(("", port_serveur), RequestHandler)
    httpd.serve_forever()

