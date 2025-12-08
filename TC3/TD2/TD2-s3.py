# -*- coding: utf-8 -*-
"""
CORRIGE du TD2-s3.py

@author: Ecole Centrale de Lyon, 2025
"""

import http.server
import socketserver

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
    # le chemin d'accès commence par /time
    if self.path.startswith('/time'):
      self.send_time()
    # sinon : comportement par défaut
    else:
      super().do_GET()


  def send_time(self):
    """Génèrer une réponse avec la date et l'heure du serveur"""
    # on récupère l'heure
    time = self.date_time_string()

    # on génère un document au format html
    body = '<!doctype html>' + \
           '<meta charset="utf-8">' + \
           '<title>l\'heure</title>' + \
           '<div>Voici l\'heure du serveur :</div>' + \
           '<pre>{}</pre>'.format(time)

    # pour prévenir qu'il s'agit d'une ressource au format html
    headers = [('Content-Type','text/html;charset=utf-8')]

    # on envoie
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

# Programme principal
if __name__ == '__main__' :    
    # instanciation et lancement du serveur
    httpd = socketserver.TCPServer(("", port_serveur), RequestHandler)
    httpd.serve_forever()
