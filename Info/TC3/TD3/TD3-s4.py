# -*- coding: utf-8 -*-
"""
TD3-serveur1.py

@author: Ecole Centrale de Lyon, 2025
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
  static_dir = 'TD3/client'

  
  def __init__(self, *args, **kwargs):
    """Surcharge du constructeur pour imposer 'client' comme sous répertoire racine"""
    
    super().__init__(*args, directory=self.static_dir, **kwargs)

    
  def do_GET(self):
    """Traiter les requêtes GET (surcharge la méthode héritée)"""
    
    self.init_params()

    # prénom et nom dans le chemin d'accès
    if self.path_info[0] == "coucou":
        self.send_coucou()

    # prénom et nom dans la chaîne de requête
    elif self.path_info[0] == "toctoc":
        self.send_toctoc()

    # requête générique
    elif self.path_info[0] == "service":
        self.send_service()   

    # sinon : comportement par défaut
    else:
        super().do_GET()


  def do_POST(self):
    """Traiter les requêtes POST"""

    self.init_params()

    # prénom et nom dans le corps de la requête
    if self.path_info[0] == "toctoc":
        self.send_toctoc()
      
    # requête générique
    elif self.path_info[0] == "service":
        self.send_service()   

    else:
        self.send_error(405)


  def send_coucou(self):
    """Génèrer une réponse en HTML contenant le nom et prénom passés dans le chemin d'accès"""
    
    body = f'<!DOCTYPE html> <title>{self.path_info[0]}</title> <meta charset="utf-8">' \
         + f'<p>Bonjour {self.path_info[1]} {self.path_info[2]}</p>'
    headers = [('Content-Type','text/html;charset=utf-8')]
    self.send(body,headers)


  def send_toctoc(self):
    """Génèrer une réponse sous forme d'un objet JSON contenant le nom et prénom"""

    # on construit une chaîne de caractère json à partir d'un dict python
    # version RESTful utilisant le chemin de l'URL
    body = json.dumps({
      'given_name': self.path_info[1], \
      'family_name': self.path_info[2] \
      });
    
    # on envoie
    headers = [('Content-Type','application/json')];
    self.send(body,headers)
            

  def send_service(self):
    """Génèrer une réponse en HTML retournant les paramètres de la requâte à des fins de test"""

    headers = [('Content-Type','text/html;charset=utf-8')]
    body = f'<!DOCTYPE html> <title>{self.path_info[0]}</title> <meta charset="utf-8">' \
         + f'<p>Path info : <code>{'/'.join(self.path_info)}</code></p>' \
         + f'<p>Chaîne de requête : <code>{self.query_string}</code></p>' \
         + f'<p>Corps :</p><pre>{self.body}</pre>'
    self.send(body,headers)     


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
