# -*- coding: utf-8 -*-
"""
CORRIGE TD3-s7.py

Remarque : une version plus complète et améliorée est donnée dans le TD4 !

@author: Ecole Centrale de Lyon, 2024
"""

import http.server
import socketserver
from urllib.parse import urlparse, parse_qs, unquote
import json

import os
import sqlite3

import datetime as dt
import matplotlib.pyplot as plt
import matplotlib.dates as pltd

# numéro du port TCP utilisé par le serveur
port_serveur = 8080
# nom de la base de données
BD_name = "ter.sqlite"

class RequestHandler(http.server.SimpleHTTPRequestHandler):
  """"Classe dérivée pour traiter les requêtes entrantes du serveur"""

  # sous-répertoire racine des documents statiques
  static_dir = 'TD3/client'
  
  def __init__(self, *args, **kwargs):
    """Surcharge du constructeur pour imposer 'client' comme sous répertoire racine"""

    super().__init__(*args, directory=self.static_dir, **kwargs)
    

  def do_GET(self):
    """Traiter les requêtes GET (surcharge la méthode héritée)"""

    # On récupère les étapes du chemin d'accès
    self.init_params()

    # le chemin d'accès commence par /time
    if self.path_info[0] == 'time':
      self.send_time()
   
     # le chemin d'accès commence par /regions
    elif self.path_info[0] == 'regions':
      self.send_regions()
      
    # le chemin d'accès commence par /ponctualite
    elif self.path_info[0] == 'ponctualite':
      self.send_ponctualite()
      
    # ou pas...
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
    """Génèrer une réponse avec la liste des régions (version TD3, §5.1)"""
 
    # création du curseur (la connexion a été créée par le programme principal)
    c = conn.cursor()
    
    # récupération de la liste des régions et coordonnées (import de regions.csv)
    c.execute("SELECT * FROM 'regions'")
    r = c.fetchall()
    body = json.dumps([{'nom':n, 'lat':lat, 'lon': lon} 
                       for (n,lat,lon) in r])    

    # envoi de la réponse
    headers = [('Content-Type','application/json')];
    self.send(body,headers)
   

  def send_ponctualite(self):
    """Générer un graphique de ponctualite (cf. TD1) et une réponse formatée en JSON"""

    # création du curseur (la connexion a été créée par le programme principal)
    c = conn.cursor()

    # si pas de paramètre => erreur pas de région
    if len(self.path_info) <= 1 or self.path_info[1] == '' :
        # Région non spécifiée -> erreur 400 Bad Request
        print ('Erreur pas de nom')
        self.send_error(400)
        return None
    else:
        # on récupère le nom de la région dans le 1er paramètre
        region = self.path_info[1]
        # On teste que la région demandée existe bien
        c.execute("SELECT DISTINCT Région FROM 'regularite-mensuelle-ter'")
        r = c.fetchall()
        
        # Remarque : r est une liste de tuples à 1 seul élement
        if (region,) not in r:
            # Région non trouvée -> erreur 404
            print ('Erreur nom')
            self.send_error(404)    
            return None
        
    # configuration du tracé
    plt.figure(figsize=(18,6))
    plt.ylim(75,100)
    plt.grid(which='major', color='#888888', linestyle='-')
    plt.grid(which='minor',axis='x', color='#888888', linestyle=':')
    
    ax = plt.subplot(111)
    ax.xaxis.set_major_locator(pltd.YearLocator())
    ax.xaxis.set_minor_locator(pltd.MonthLocator())
    ax.xaxis.set_major_formatter(pltd.DateFormatter('%B %Y'))
    ax.xaxis.set_tick_params(labelsize=10)
    
    # interrogation de la base de données pour les données de la région
    c.execute("SELECT Date,`Tauxderégularité` FROM 'regularite-mensuelle-ter' WHERE Région=? ORDER BY Date", (region,))
    r = c.fetchall()

    # axe des abscisses : recupération de la date et transformation en date au format python
    x = [dt.date(int(d[:4]),int(d[5:]),1) for (d,t) in r if not (t == '' or t == None)]
    # axe des ordonnées : récupération du taux de régularité
    y = [float(t) for (d,t) in r if not (t == '' or  t==None)]

    # tracé de la courbe
    plt.plot(x,y,linewidth=1, linestyle='-', color='blue', label=region)
    
    # légendes
    plt.legend(loc='lower right')
    plt.title(f'Régularité des TER (en %) pour la Région {region}',fontsize=16)
    plt.ylabel('% de régularité')
    plt.xlabel('Date')
    
    # génération de la courbe dans un fichier PNG paramétré par le nom de la région
    fichier = 'courbes/ponctualite_{}.png'.format(region)
    plt.savefig('client/{}'.format(fichier))

    # réponse au format JSON
    body = json.dumps({
            'title': 'Régularité TER {}'.format(region), \
            'img': '/{}'.format(fichier) \
             });
        
    # envoi de la réponse
    headers = [('Content-Type','application/json')];
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
    # Ouverture d'une connexion avec la base de données après vérification de sa présence
    if not os.path.exists(BD_name):
        raise FileNotFoundError(f"BD {BD_name} non trouvée !")
    conn = sqlite3.connect(BD_name)
    
    # Instanciation et lancement du serveur
    httpd = socketserver.TCPServer(("", port_serveur), RequestHandler)
    print("Serveur lancé sur port : ", port_serveur)
    httpd.serve_forever()
    
