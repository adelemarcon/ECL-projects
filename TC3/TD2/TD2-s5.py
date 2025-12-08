# -*- coding: utf-8 -*-
"""
CORRIGE du TD2-s5.py

@author: Ecole Centrale de Lyon, 2025
"""

import http.server
import socketserver
import os
import sqlite3
import matplotlib.pyplot as plt
import datetime as dt
import matplotlib.dates as pltd

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
    # le chemin d'accès commence par /regions
    elif self.path.startswith('/regions'):
      self.send_regions()
    # le chemin d'accès commence par /ponctualite
    elif self.path.startswith('/ponctualite'):
      self.send_ponctualite()
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


  def send_regions(self):
    """Génèrer une réponse avec la liste des régions (cf. TD1)"""
    c = conn.cursor()
    
    c.execute("SELECT DISTINCT Région FROM 'regularite-mensuelle-ter'")
    r = c.fetchall()
    txt = 'Liste des {} régions :\n'.format(len(r))
    for a in r:
       txt = txt + '{}\n'.format(a[0])
    
    headers = [('Content-Type','text/plain;charset=utf-8')]
    self.send(txt,headers)
    

  def send_ponctualite(self):
    """Générer un graphique de ponctualite (cf. TD1) et une réponse HTML avec balise IMG"""
    c = conn.cursor()

    # configuration du tracé
    plt.figure(figsize=(18,6))
    plt.ylim(80,100)
    plt.grid(which='major', color='#888888', linestyle='-')
    plt.grid(which='minor',axis='x', color='#888888', linestyle=':')
    
    ax = plt.subplot(111)
    ax.xaxis.set_major_locator(pltd.YearLocator())
    ax.xaxis.set_minor_locator(pltd.MonthLocator())
    ax.xaxis.set_major_formatter(pltd.DateFormatter('%B %Y'))
    ax.xaxis.set_tick_params(labelsize=10)
    
    # interrogation de la base de données pour les données de la région RA
    c.execute("SELECT Date,`Tauxderégularité` FROM 'regularite-mensuelle-ter' WHERE Région='Rhône Alpes' ORDER BY Date")
    r = c.fetchall()
    # recupération de la date (1ère colonne) et transformation dans le format date de Python
    x = [dt.date(int(a[0][:4]),int(a[0][5:]),1) for a in r if not (a[1] == '' or a[1] == None)]
    # récupération de la régularité (2e colonne)
    y = [float(a[1]) for a in r if not (a[1] == '' or a[1] == None)]    
    
    # tracé de la courbe
    plt.plot(x,y,linewidth=1, linestyle='-', color='blue', label='Rhône-Alpes')
        
    # légendes
    plt.legend(loc='lower right')
    plt.title('Régularité des TER (en %) pour la Région Rhône-Alpes',fontsize=16)
    plt.ylabel('% de régularité')
    plt.xlabel('Date')
    
    # génération de la courbe dans un fichier PNG
    fichier = 'courbe_ponctualite.png'
    plt.savefig('client/{}'.format(fichier))

    html = '<img src="/{}" alt="ponctualité Rhône Alpes" width="100%">'.format(fichier)

    # envoi de la réponse
    headers = [('Content-Type','text/html;charset=utf-8')]
    self.send(html,headers)

    
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
    # ouverture d'une connexion avec la base de données après vérification de sa présence
    if not os.path.exists('ter.sqlite'):
        raise FileNotFoundError("BD ter.sqlite non trouvée !")
    conn = sqlite3.connect('ter.sqlite')
        
    # instanciation et lancement du serveur
    httpd = socketserver.TCPServer(("", port_serveur), RequestHandler)
    httpd.serve_forever()
