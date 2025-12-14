# -*- coding: utf-8 -*-
"""
CORRIGE du TD2-s2.py

@author: Ecole Centrale de Lyon, 2025
"""

import http.server
import socketserver

# numéro du port TCP utilisé par le serveur
port_serveur = 8080

class RequestHandler(http.server.SimpleHTTPRequestHandler):
  """"Classe dérivée pour traiter les requêtes entrantes du serveur"""

  # sous-répertoire racine des documents statiques
  static_dir = 'TC3/TD2/client'
  
  def __init__(self, *args, **kwargs):
    """Surcharge du constructeur pour imposer 'client' comme sous répertoire racine"""
    super().__init__(*args, directory=self.static_dir, **kwargs)

# Programme principal
if __name__ == '__main__' :
    # instanciation et lancement du serveur
    httpd = socketserver.TCPServer(("", port_serveur), RequestHandler)
    httpd.serve_forever()

